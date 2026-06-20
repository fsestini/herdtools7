open Catpart
module Partition = Partitioning.Partition
module PSet = Partitioning.PartitionSet

module Node = struct
  type kind =
    | Universe
    | Symbol of string
    | Inter of StringSet.t
    | Residue of string

  type t = { kind : kind; semantics : PSet.t }

  let equal n1 n2 = n1.kind = n2.kind
  let compare n1 n2 = Stdlib.compare n1.kind n2.kind
  let hash = Hashtbl.hash
  let make ~kind ~semantics = { kind; semantics }
  let semantics n = n.semantics

  let kind_label k =
    match k with
    | Universe -> "Universe"
    | Symbol s -> s
    | Inter l -> String.concat " & " (StringSet.elements l)
    | Residue l -> l

  let label n = kind_label n.kind
end

module G = Graph.Imperative.Digraph.Concrete (Node)
module Oper = Graph.Oper.I (G)

type t = G.t

module Dot = Dot.Make (struct
  include G

  let node_id n =
    match n.Node.kind with
    | Node.Universe -> "universe"
    | Node.Symbol s -> "set:" ^ s
    | Node.Inter l -> "intersection:" ^ String.concat "&" (StringSet.elements l)
    | Node.Residue _ -> (
        match PSet.elements (Node.semantics n) with
        | [ p ] -> "partition:" ^ string_of_int (Partition.index p)
        | _ -> "residue:" ^ Node.label n)

  let label = Node.label

  let node_fillcolor n =
    match n.Node.kind with
    | Node.Universe -> "gray95"
    | Node.Symbol _ -> "lightsteelblue1"
    | Node.Inter _ -> "lightyellow"
    | Node.Residue _ -> "white"

  let edge_color src dst =
    match (src.Node.kind, dst.Node.kind) with
    | Node.Symbol _, Node.Symbol _ -> None
    | _ -> Some "gray80"
end)

let subsets xs =
  List.fold_right
    (fun x acc -> acc @ List.map (fun subset -> x :: subset) acc)
    xs [ [] ]

let den_terms ~denotation tms =
  match StringSet.elements tms with
  | [] -> invalid_arg "empty set"
  | x :: xs -> List.fold_left PSet.inter (denotation x) (List.map denotation xs)

let construct_intersections (partitioning : Partitioning.t) :
    (StringSet.t * PSet.t) list =
  let module StringSetSet = Set.Make (StringSet) in
  let partitions = Partitioning.partitions partitioning in
  let denotation l = Partitioning.denotation partitioning l in
  let inters =
    partitions
    |> List.fold_left
         (fun (s : StringSetSet.t) p ->
           let p_lbls = Partitioning.labels_of_partition partitioning p in
           let subss = subsets p_lbls in
           subss
           |> List.fold_left
                (fun s subs ->
                  let subs = Partitioning.simplify_labels partitioning subs in
                  if List.length subs >= 2 then
                    StringSetSet.add (StringSet.of_list subs) s
                  else s)
                s)
         StringSetSet.empty
  in
  StringSetSet.fold
    (fun s acc ->
      let inter = den_terms ~denotation s in
      if
        (not (PSet.is_empty inter))
        && not (List.exists (fun (_, sem) -> PSet.equal sem inter) acc)
      then (s, inter) :: acc
      else acc)
    inters []

let iter_pairings l1 l2 f =
  l1 |> List.iter (fun x -> l2 |> List.iter (fun y -> f x y))

let strict_subset p q = PSet.subset p q && not (PSet.equal p q)

let min_region ~(nodes : Node.t list) p =
  let regions =
    nodes
    |> List.filter (fun r ->
        PSet.mem p (Node.semantics r)
        && not
             (List.exists
                (fun q ->
                  PSet.mem p (Node.semantics q)
                  && strict_subset (Node.semantics q) (Node.semantics r))
                nodes))
  in
  match regions with [ r ] -> r | _ -> failwith "expected exactly one region"

let max_subregions ~(nodes : Node.t list) r =
  nodes
  |> List.filter (fun q ->
      strict_subset (Node.semantics q) (Node.semantics r)
      && not
           (List.exists
              (fun t ->
                strict_subset (Node.semantics q) (Node.semantics t)
                && strict_subset (Node.semantics t) (Node.semantics r))
              nodes))

let residual_label ~denotation ~nodes r =
  let sem_r = Node.semantics r in
  let qs = max_subregions ~nodes r in
  let simplified_qs =
    qs
    |> List.map (fun q ->
        match q.Node.kind with
        | Node.Symbol s -> Node.Symbol s
        | Node.Inter tms ->
            let sem_q = Node.semantics q in
            tms
            |> StringSet.filter (fun l ->
                let tms_sans_l = StringSet.remove l tms in
                let should_remove =
                  PSet.(
                    equal (inter sem_r (den_terms ~denotation tms_sans_l)) sem_q)
                in
                not should_remove)
            |> fun tms -> Node.Inter tms
        | Node.Universe -> Node.Universe
        | Node.Residue _ -> failwith "unexpected Residue node")
  in

  let subtractands =
    String.concat " | " (List.map Node.kind_label simplified_qs)
  in
  if List.length simplified_qs > 1 then
    Printf.sprintf "%s \\ (%s)" (Node.label r) subtractands
  else Printf.sprintf "%s \\ %s" (Node.label r) subtractands

let build_graph (partitioning : Partitioning.t) : G.t =
  let denotation = Partitioning.denotation partitioning in
  let partitions = Partitioning.partitions partitioning in
  let universe_node =
    Node.make ~kind:Node.Universe ~semantics:(PSet.of_list partitions)
  in

  let g = G.create () in
  G.add_vertex g universe_node;

  (* Create primitive symbol nodes *)
  let symbol_nodes =
    Partitioning.labels partitioning
    |> List.filter_map (fun l ->
        if not (PSet.is_empty (denotation l)) then
          Some (Node.make ~kind:(Node.Symbol l) ~semantics:(denotation l))
        else None)
  in
  symbol_nodes |> List.iter (G.add_vertex g);

  (* Create intersection nodes *)
  let inter_nodes =
    construct_intersections partitioning
    |> List.map (fun (syms, semantics) ->
        Node.make ~kind:(Node.Inter syms) ~semantics)
  in
  inter_nodes |> List.iter (G.add_vertex g);

  let sym_inter_nodes = (universe_node :: symbol_nodes) @ inter_nodes in
  iter_pairings sym_inter_nodes sym_inter_nodes (fun n n' ->
      let ps = Node.semantics n in
      let ps' = Node.semantics n' in
      if (not (PSet.equal ps ps')) && PSet.subset ps ps' then G.add_edge g n' n);

  (* Create residual leaves *)
  partitions
  |> List.iter (fun p ->
      let semantics = PSet.of_list [ p ] in
      if
        not
          (List.exists
             (fun n -> PSet.equal semantics (Node.semantics n))
             sym_inter_nodes)
      then
        let r = min_region ~nodes:sym_inter_nodes p in
        let lbl = residual_label ~denotation ~nodes:sym_inter_nodes r in
        let n = Node.make ~kind:(Node.Residue lbl) ~semantics in
        G.add_edge g r n);

  let _ = Oper.replace_by_transitive_reduction g in
  g

let filter_subtree ~(root_label : string) g =
  let roots = ref [] in
  G.iter_vertex
    (fun node ->
      if String.equal (Node.label node) root_label then roots := node :: !roots)
    g;
  let root =
    match !roots with
    | [ root ] -> root
    | [] -> invalid_arg (Printf.sprintf "no DAG node with label %S" root_label)
    | _ ->
        invalid_arg
          (Printf.sprintf "multiple DAG nodes with label %S" root_label)
  in
  let module NodeSet = Set.Make (Node) in
  let rec collect seen node =
    if NodeSet.mem node seen then seen
    else
      let seen = NodeSet.add node seen in
      G.fold_succ (fun succ seen -> collect seen succ) g node seen
  in
  let kept = collect NodeSet.empty root in
  let subtree = G.create () in
  NodeSet.iter (G.add_vertex subtree) kept;
  G.iter_edges_e
    (fun edge ->
      let src = G.E.src edge in
      let dst = G.E.dst edge in
      if NodeSet.mem src kept && NodeSet.mem dst kept then
        G.add_edge subtree src dst)
    g;
  subtree
