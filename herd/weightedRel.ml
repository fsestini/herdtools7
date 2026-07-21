exception Unsupported of string

type kind = [ `Finite | `Infinite ]

module type S = sig
  type elt
  type weight = Weight.t
  type t

  val kind : elt -> kind

  val equal : t -> t -> bool
  val compare : t -> t -> int

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
  val transitive_closure : t -> t option

  val pp : (Format.formatter -> elt -> unit) -> Format.formatter -> t -> unit
end

module W = Weight

module MakeInnerRel
    (E : MySet.S)
    (WR : S with type elt = E.elt) = struct
  type elt0 = E.elt
  type elt1 = elt0
  type elt2 = elt0

  module Elts = E
  module Elts1 = Elts
  module Elts2 = Elts

  type t = WR.t

  let unsupported operation =
    raise (Unsupported (Printf.sprintf "weighted relation operation `%s`" operation))

  (* [MySet.S] exposes comparison on sets, rather than directly on elements.
     Singleton sets retain the underlying element ordering. *)
  let equal_elt x y = Elts.mem x (Elts.singleton y)

  module Ord = struct
    type t = E.elt

    let compare x y = Elts.compare (Elts.singleton x) (Elts.singleton y)
  end

  module PlainRel = InnerRel.Make (Ord)

  let zero = W.singleton 0

  let is_finite elt = match WR.kind elt with `Finite -> true | `Infinite -> false

  let plain_rel_of_finite_endpoints operation rel =
    WR.fold
      (fun (src, dst, _) plain_rel ->
        if is_finite src && is_finite dst then
          PlainRel.add (src, dst) plain_rel
        else
          unsupported
            (Printf.sprintf
               "%s requires every relation endpoint to be finite"
               operation))
      rel PlainRel.empty

  let has_zero weight =
    not (W.is_empty (W.intersection weight zero))

  let has_strict_sign weight =
    W.equal weight (W.intersection weight (W.at_least 1))
    || W.equal weight (W.intersection weight (W.at_most (-1)))

  let equal = WR.equal
  let compare = WR.compare
  let empty = WR.empty

  let is_empty rel = WR.fold (fun _ _ -> false) rel true

  let mem (_ : elt1 * elt2) (_ : t) : bool = unsupported "mem"
  let singleton (_ : elt1 * elt2) : t = unsupported "singleton"
  let of_list (_ : (elt1 * elt2) list) : t = unsupported "of_list"
  let add (_ : elt1 * elt2) (_ : t) : t = unsupported "add"
  let add_set (_ : elt1) (_ : Elts.t) (_ : t) : t = unsupported "add_set"
  let remove (_ : elt1 * elt2) (_ : t) : t = unsupported "remove"
  let choose (_ : t) : elt1 * elt2 = unsupported "choose"
  let cardinal (_ : t) : int = unsupported "cardinal"
  let iter (_ : (elt1 * elt2) -> unit) (_ : t) : unit = unsupported "iter"

  let fold _ _ _ = unsupported "fold"

  let exists (_ : (elt1 * elt2) -> bool) (_ : t) : bool = unsupported "exists"
  let for_all (_ : (elt1 * elt2) -> bool) (_ : t) : bool = unsupported "for_all"
  let to_seq (_ : t) : (elt1 * elt2) Seq.t = unsupported "to_seq"
  let split3 (_ : t) : t * (elt1 * elt2) * t = unsupported "split3"
  let exists_succ (_ : t) (_ : elt1) : bool = unsupported "exists_succ"
  let exists_pred (_ : t) (_ : elt2) : bool = unsupported "exists_pred"
  let succs (_ : t) (_ : elt1) : Elts.t = unsupported "succs"
  let preds (_ : t) (_ : elt2) : Elts.t = unsupported "preds"

  let cartesian xs ys = WR.cartesian (Elts.elements xs) (Elts.elements ys) W.top

  let of_pred (_ : Elts.t) (_ : Elts.t) (_ : elt1 -> elt2 -> bool) : t =
    unsupported "of_pred"

  let domain rel : Elts.t =
    if is_empty rel then Elts.empty else unsupported "domain"

  let codomain rel : Elts.t =
    if is_empty rel then Elts.empty else unsupported "codomain"

  (* Event predicates and sets are interpreted as copy-invariant: they keep
     every copy of a selected lasso event, or none. Therefore filtering an
     edge by its representative endpoints preserves its full weight. *)
  let restrict_domain pred = WR.filter (fun src _ _ -> pred src)
  let restrict_codomain pred = WR.filter (fun _ dst _ -> pred dst)

  let restrict_codomain_to_set events =
    WR.filter (fun _ dst _ -> Elts.mem dst events)

  let restrict_domains pred_src pred_dst =
    WR.filter (fun src dst _ -> pred_src src && pred_dst dst)

  let restrict_domains_to_sets srcs dsts =
    WR.filter (fun src dst _ -> Elts.mem src srcs && Elts.mem dst dsts)

  let restrict_rel (_ : elt1 -> elt2 -> bool) (_ : t) : t =
    unsupported "restrict_rel"

  let subrel (_ : t) (_ : t) : bool = unsupported "subrel"
  let subset (_ : t) (_ : t) : bool = unsupported "subset"
  let union = WR.union
  let union3 rel1 rel2 rel3 = union rel1 (union rel2 rel3)
  let union4 rel1 rel2 rel3 rel4 = union (union rel1 rel2) (union rel3 rel4)

  let union5 rel1 rel2 rel3 rel4 rel5 =
    union (union4 rel1 rel2 rel3 rel4) rel5

  let union6 rel1 rel2 rel3 rel4 rel5 rel6 =
    union (union3 rel1 rel2 rel3) (union3 rel4 rel5 rel6)

  let unions = function [] -> empty | rels -> List.fold_left union empty rels
  let inter = WR.intersection
  let diff = WR.diff

  let nodes (_ : t) : Elts.t = unsupported "nodes"
  let filter_nodes pred = restrict_domains pred pred
  let map_nodes (_ : elt0 -> elt0) (_ : t) : t = unsupported "map_nodes"

  let inverse = WR.inverse

  let set_to_rln set =
    Elts.fold
      (fun event rel -> WR.add (event, event, W.singleton 0) rel)
      set empty

  let transitive_closure rel =
    match WR.transitive_closure rel with
    | Some closure -> closure
    | None -> unsupported "transitive_closure"

  let restrict_domain_transitive_closure events rel =
    restrict_domain
      (fun event -> Elts.mem event events)
      (transitive_closure rel)

  let is_reflexive rel =
    WR.fold
      (fun (x, y, weight) found ->
        found || (equal_elt x y && has_zero weight))
      rel false

  let is_irreflexive rel = not (is_reflexive rel)

  let is_acyclic rel =
    match WR.transitive_closure rel with
    | Some closure -> not (is_reflexive closure)
    | None ->
        (* A non-convergent closure is not, by itself, a zero-offset cycle:
           a strictly positive or negative self-loop is the simple case.  Do
           not accept any broader graph without a weighted closure, because
           it might contain a zero-sum cycle. *)
        if
          WR.fold
            (fun (x, y, weight) safe ->
              safe && equal_elt x y && has_strict_sign weight)
            rel true
        then true
        else unsupported "is_acyclic: transitive closure did not converge"

  let is_cyclic rel = not (is_acyclic rel)

  let order_to_succ (_ : elt0 list) : t = unsupported "order_to_succ"
  let order_to_rel (_ : elt0 list) : t = unsupported "order_to_rel"
  let cycle_to_rel (_ : elt0 list) : t = unsupported "cycle_to_rel"
  let cycle_option_to_rel (_ : elt0 list option) : t =
    unsupported "cycle_option_to_rel"

  exception Cyclic

  let exists_path (_ : elt0 * elt0) (_ : t) : bool = unsupported "exists_path"
  let reachable (_ : elt0) (_ : t) : Elts.t = unsupported "reachable"

  let reachable_from_set (_ : Elts.t) (_ : t) : Elts.t =
    unsupported "reachable_from_set"

  let path (_ : elt0) (_ : elt0) (_ : t) : elt0 list = unsupported "path"
  let leaves (_ : t) : Elts.t = unsupported "leaves"
  let leaves_from (_ : elt0) (_ : t) : Elts.t = unsupported "leaves_from"
  let roots (_ : t) : Elts.t = unsupported "roots"
  let up (_ : elt0) (_ : t) : Elts.t = unsupported "up"
  let up_from_set (_ : Elts.t) (_ : t) : Elts.t = unsupported "up_from_set"
  let get_cycle (_ : t) : elt0 list option = unsupported "get_cycle"

  let topo_kont _ _ _ _ = unsupported "topo_kont"
  let topo _ _ = unsupported "topo"
  let pseudo_topo_kont _ _ _ _ = unsupported "pseudo_topo_kont"
  let all_topos_kont _ _ _ _ = unsupported "all_topos_kont"

  let all_topos_kont_rel events rel kfail kont init =
    let operation = "all_topos_kont_rel" in
    if not (Elts.for_all is_finite events) then
      unsupported
        (Printf.sprintf "%s requires every requested node to be finite" operation);
    let plain_rel = plain_rel_of_finite_endpoints operation rel in
    let plain_events = PlainRel.Elts.of_list (Elts.elements events) in
    let weighted_rel plain_rel =
      PlainRel.fold
        (fun (src, dst) weighted_rel -> WR.add (src, dst, zero) weighted_rel)
        plain_rel WR.empty
    in
    PlainRel.all_topos_kont_rel plain_events plain_rel
      (fun plain_rel -> kfail (weighted_rel plain_rel))
      (fun plain_rel acc -> kont (weighted_rel plain_rel) acc)
      init

  let all_topos (_ : bool) (_ : Elts.t) (_ : t) : elt0 list list =
    unsupported "all_topos"

  let scc_kont
      (_ : elt0 list -> 'a -> 'a)
      (_ : 'a)
      (_ : elt0 list)
      (_ : t) : 'a =
    unsupported "scc_kont"

  let is_hierarchy (_ : Elts.t) (_ : t) : bool = unsupported "is_hierarchy"
  let remove_transitive_edges (_ : t) : t = unsupported "remove_transitive_edges"
  let classes (_ : t) : Elts.t list = unsupported "classes"
  let strata (_ : Elts.t) (_ : t) : Elts.t list = unsupported "strata"
  let bisimulation (_ : t) (_ : t) : t = unsupported "bisimulation"

  let sequence = WR.sequence
  let transitive3 rel = sequence rel (sequence rel rel)

  let sequences = function
    | [] -> empty
    | rel :: rels -> List.fold_left sequence rel rels

  let pp _ _ _ _ = unsupported "pp"
  let pp_str _ _ _ = unsupported "pp_str"
end

module Make
    (Elt : sig
      include Set.OrderedType

      val kind : t -> kind
    end) :
  S with type elt = Elt.t = struct
  type elt = Elt.t
  type weight = W.t

  module EltMap = MyMap.Make (Elt)

  type t = weight EltMap.t EltMap.t

  let kind = Elt.kind

  let empty = EltMap.empty

  let normalize_weight src dst w =
    let allowed =
      match (Elt.kind src, Elt.kind dst) with
      | `Finite, `Finite -> W.singleton 0
      | `Finite, `Infinite -> W.at_least 1
      | `Infinite, `Finite -> W.at_most (-1)
      | `Infinite, `Infinite -> W.top
    in
    W.intersection w allowed

  let add (src, dst, w) rel =
    let w = normalize_weight src dst w in
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
      Misc.List.cartesian srcs dsts
      |> List.map (fun (src,dst) -> (src,dst,w))
      |> of_list

  let union rel1 rel2 = EltMap.union (EltMap.union W.union) rel1 rel2

  (* Relations are normalized sparse maps: absent bindings denote [W.empty].
     [f] must preserve endpoint restrictions and satisfy
     [f W.empty W.empty = W.empty]. Empty results are omitted. *)
  let pointwise f rel1 rel2 =
    EltMap.merge
      (fun _src dsts1 dsts2 ->
        let dsts1 = Option.value dsts1 ~default:EltMap.empty
        and dsts2 = Option.value dsts2 ~default:EltMap.empty in
        let dsts =
          EltMap.merge
            (fun _dst w1 w2 ->
              let w1 = Option.value w1 ~default:W.empty
              and w2 = Option.value w2 ~default:W.empty in
              let w = f w1 w2 in
              if W.is_empty w then None else Some w)
            dsts1 dsts2
        in
        if EltMap.is_empty dsts then None else Some dsts)
      rel1 rel2

  let intersection = pointwise W.intersection
  let diff = pointwise W.diff

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
  let compare rel1 rel2 = EltMap.compare (EltMap.compare W.compare) rel1 rel2

  let transitive_closure rel =
    let max_iterations = 10 in
    let rec loop iteration current =
      if iteration >= max_iterations then
        None
      else
      let candidate = union current (sequence current current) in
      if equal current candidate then Some current
      else loop (iteration + 1) candidate
    in
    loop 0 rel

  let filter p (t : t) =
    fold
      (fun (x, y, w) acc -> if p x y w then add (x, y, w) acc else acc)
      t empty

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
end
