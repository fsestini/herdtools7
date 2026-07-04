exception Unsupported = Weight.Unsupported

module type S = sig
  type elt
  type weight
  type t

  val empty : t
  val of_list : (elt * elt * weight) list -> t
  val add : elt * elt * weight -> t -> t
  val fold : (elt * elt * weight -> 'a -> 'a) -> t -> 'a -> 'a
  val cartesian : elt list -> elt list -> weight -> t
  val union : t -> t -> t
  val intersection : t -> t -> t
  val diff : t -> t -> t
  val inverse : t -> t
  val sequence : t -> t -> t
  val filter : (elt -> elt -> weight -> bool) -> t -> t

  val transitive_closure_widened : t -> t
  (** Positive transitive closure. The returned edge set is exact w.r.t.
      reachability in the input relation, but edge weights may be sound
      overapproximations. *)

  val transitive_closure_exact : t -> t

  val transitive_reduction : t -> t
  (** Transitive reduction, computed independently for each [W.equal] weight
      class. Edge redundancy is decided only from the same-weight topology;
      weights on kept edges are preserved. *)

  val equal : t -> t -> bool
  val pp : (Format.formatter -> elt -> unit) -> Format.formatter -> t -> unit
  val widen : t -> t -> t
end

module Make
    (W : Weight.S)
    (Elt : sig
      type t

      val compare : t -> t -> int
    end) : S with type elt = Elt.t and type weight = W.t = struct
  type elt = Elt.t
  type weight = W.t

  module EltMap = MyMap.Make (Elt)

  type t = weight EltMap.t EltMap.t

  let empty = EltMap.empty
  let elt_equal x y = Elt.compare x y = 0

  let add (src, dst, w) rel =
    if W.is_empty w then rel
    else
      EltMap.update src
        (function
          | None -> Some (EltMap.singleton dst w)
          | Some dsts ->
              Some
                (EltMap.update dst
                   (function None -> Some w | Some w' -> Some (W.union w w'))
                   dsts))
        rel

  let of_list edges =
    List.fold_left (fun rel edge -> add edge rel) EltMap.empty edges

  let fold f rel acc =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold (fun dst w acc -> f (src, dst, w) acc) dsts acc)
      rel acc

  let cartesian srcs dsts w =
    if W.is_empty w then EltMap.empty
    else
      List.fold_left
        (fun rel src ->
          List.fold_left (fun rel dst -> add (src, dst, w) rel) rel dsts)
        EltMap.empty srcs

  let union rel1 rel2 = EltMap.union (EltMap.union W.union) rel1 rel2

  let intersection rel1 rel2 =
    EltMap.fold
      (fun src dsts1 acc ->
        match EltMap.find_opt src rel2 with
        | None -> acc
        | Some dsts2 ->
            let dsts =
              EltMap.fold
                (fun dst w1 acc ->
                  match EltMap.find_opt dst dsts2 with
                  | None -> acc
                  | Some w2 ->
                      let w = W.intersection w1 w2 in
                      if W.is_empty w then acc else EltMap.add dst w acc)
                dsts1 EltMap.empty
            in
            if EltMap.is_empty dsts then acc else EltMap.add src dsts acc)
      rel1 EltMap.empty

  let diff rel1 rel2 =
    EltMap.fold
      (fun src dsts1 acc ->
        let dsts2 = EltMap.find_opt src rel2 in
        let dsts =
          EltMap.fold
            (fun dst w1 acc ->
              let w =
                match dsts2 with
                | None -> w1
                | Some dsts2 -> (
                    match EltMap.find_opt dst dsts2 with
                    | None -> w1
                    | Some w2 -> W.diff w1 w2)
              in
              if W.is_empty w then acc else EltMap.add dst w acc)
            dsts1 EltMap.empty
        in
        if EltMap.is_empty dsts then acc else EltMap.add src dsts acc)
      rel1 EltMap.empty

  let inverse rel =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold (fun dst w acc -> add (dst, src, W.inverse w) acc) dsts acc)
      rel EltMap.empty

  let sequence rel1 rel2 =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold
          (fun mid w1 acc ->
            match EltMap.find_opt mid rel2 with
            | None -> acc
            | Some succs ->
                EltMap.fold
                  (fun dst w2 acc -> add (src, dst, W.plus w1 w2) acc)
                  succs acc)
          dsts acc)
      rel1 EltMap.empty

  let equal rel1 rel2 = EltMap.equal (EltMap.equal W.equal) rel1 rel2
  let widen rel1 rel2 = EltMap.union (EltMap.union W.widen) rel1 rel2

  let transitive_closure_ ~widen rel =
    let max_iterations = 10 in
    let rec loop iteration current =
      if iteration >= max_iterations then
        raise
          (Unsupported "weighted relation transitive closure did not stabilize");
      let candidate = union current (sequence current current) in
      let next = widen current candidate in
      if equal current next then current else loop (iteration + 1) next
    in
    loop 0 rel

  let transitive_closure_widened rel =
    let widen rel1 rel2 = EltMap.union (EltMap.union W.widen) rel1 rel2 in
    transitive_closure_ ~widen rel

  let transitive_closure_exact rel =
    let widen _ rel2 = rel2 in
    transitive_closure_ ~widen rel

  let successors rel src =
    match EltMap.find_opt src rel with
    | None -> []
    | Some dsts -> List.map fst (EltMap.to_list dsts)

  let nodes rel =
    fold
      (fun (src, dst, _) nodes ->
        nodes |> EltMap.add src () |> EltMap.add dst ())
      rel EltMap.empty
    |> EltMap.to_list |> List.map fst

  let predecessors rel dst =
    fold
      (fun (src, dst', _) acc -> if elt_equal dst dst' then src :: acc else acc)
      rel []

  let reachable_nodes ~successors src =
    let rec loop visited = function
      | [] -> visited
      | node :: stack ->
          if EltMap.mem node visited then loop visited stack
          else
            let visited = EltMap.add node () visited in
            loop visited (successors node @ stack)
    in
    loop EltMap.empty [ src ]

  let scc_ids rel =
    let rec loop next_id ids = function
      | [] -> ids
      | node :: nodes ->
          if EltMap.mem node ids then loop next_id ids nodes
          else
            let forward = reachable_nodes ~successors:(successors rel) node in
            let backward =
              reachable_nodes ~successors:(predecessors rel) node
            in
            let component =
              EltMap.fold
                (fun node () acc ->
                  if EltMap.mem node backward then EltMap.add node next_id acc
                  else acc)
                forward EltMap.empty
            in
            let ids =
              EltMap.fold
                (fun node id ids -> EltMap.add node id ids)
                component ids
            in
            loop (next_id + 1) ids nodes
    in
    loop 0 EltMap.empty (nodes rel)

  let scc_pair_equal (src1, dst1) (src2, dst2) =
    Int.equal src1 src2 && Int.equal dst1 dst2

  let add_scc_node node nodes =
    if List.exists (Int.equal node) nodes then nodes else node :: nodes

  let add_scc_pair pair pairs =
    if List.exists (scc_pair_equal pair) pairs then pairs else pair :: pairs

  let scc_successors pairs src =
    List.fold_left
      (fun succs (src', dst) ->
        if Int.equal src src' then add_scc_node dst succs else succs)
      [] pairs

  let scc_reachable_without_pair pairs ~skip_src ~skip_dst src target =
    let rec loop visited = function
      | [] -> false
      | node :: stack ->
          if List.exists (Int.equal node) visited then loop visited stack
          else
            let visited = node :: visited in
            let succs =
              scc_successors pairs node
              |> List.filter (fun dst ->
                  not (Int.equal node skip_src && Int.equal dst skip_dst))
            in
            if List.exists (Int.equal target) succs then true
            else loop visited (succs @ stack)
    in
    loop [] [ src ]

  let reduce_scc_pairs pairs =
    List.filter
      (fun (src, dst) ->
        not
          (scc_reachable_without_pair pairs ~skip_src:src ~skip_dst:dst src dst))
      pairs

  (* Reduce one same-weight subrelation by preserving SCC-internal edges and
     transitively reducing only the acyclic SCC condensation graph. *)
  let transitive_reduction_same_weight rel =
    let ids = scc_ids rel in
    let edges = fold (fun edge edges -> edge :: edges) rel [] in
    let internal_edges, inter_edges, pairs =
      List.fold_left
        (fun (internal_edges, inter_edges, pairs) ((src, dst, _) as edge) ->
          let src_id = EltMap.find src ids in
          let dst_id = EltMap.find dst ids in
          if Int.equal src_id dst_id then
            (edge :: internal_edges, inter_edges, pairs)
          else
            ( internal_edges,
              (src_id, dst_id, edge) :: inter_edges,
              add_scc_pair (src_id, dst_id) pairs ))
        ([], [], []) edges
    in
    let kept_pairs = reduce_scc_pairs pairs in
    let keep_pair src_id dst_id =
      List.exists (scc_pair_equal (src_id, dst_id)) kept_pairs
    in
    let kept_edges =
      List.fold_left
        (fun acc (src_id, dst_id, edge) ->
          if keep_pair src_id dst_id then edge :: acc else acc)
        internal_edges inter_edges
    in
    List.fold_left (fun rel edge -> add edge rel) EltMap.empty kept_edges

  let rec add_to_weight_group ((_, _, w) as edge) = function
    | [] -> [ (w, add edge EltMap.empty) ]
    | (group_w, group) :: groups ->
        if W.equal w group_w then (group_w, add edge group) :: groups
        else (group_w, group) :: add_to_weight_group edge groups

  let weight_groups rel =
    fold (fun edge groups -> add_to_weight_group edge groups) rel []
    |> List.map snd

  let transitive_reduction rel =
    List.fold_left
      (fun acc group -> union acc (transitive_reduction_same_weight group))
      EltMap.empty (weight_groups rel)

  let pp pp_elt fmt rel =
    let pp_edge fmt (src, dst, w) =
      Format.fprintf fmt "(%a,%a,%a)" pp_elt src pp_elt dst W.pp w
    in
    let edges = fold (fun edge acc -> edge :: acc) rel [] |> List.rev in
    Format.fprintf fmt "{%a}"
      (Format.pp_print_list
         ~pp_sep:(fun fmt () -> Format.fprintf fmt "; ")
         pp_edge)
      edges

  let filter p (t : t) =
    fold
      (fun (x, y, w) acc -> if p x y w then add (x, y, w) acc else acc)
      t empty
end
