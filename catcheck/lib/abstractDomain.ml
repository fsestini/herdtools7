module Log = (val Logs.src_log (Logs.Src.create "domain") : Logs.LOG)

module type Typed = sig
  type set
  type rel

  module Set : sig
    val bottom : set
    val top : set
    val universe : set
    val join : set -> set -> set
    val meet : set -> set -> set
    val equal : set -> set -> bool

    val builtin : string -> set option
    (** semantics of primitive/builtin set *)

    val pp : Format.formatter -> set -> unit

    module Forward : sig
      val union : set list -> set
      val inter : set list -> set
      val diff : set -> set -> set
      val comp : set -> set
      val try_ : set -> set -> set
      val if_ : set -> set -> set
    end

    module Backward : sig
      val union : parent:set -> children_fw:set list -> set list
      val inter : parent:set -> children_fw:set list -> set list
      val diff : parent:set -> lchild_fw:set -> rchild_fw:set -> set * set
      val comp : parent:set -> child_fw:set -> set
      val try_ : parent:set -> lchild_fw:set -> rchild_fw:set -> set * set
      val if_ : parent:set -> lchild_fw:set -> rchild_fw:set -> set * set
    end
  end

  module Rel : sig
    val bottom : rel
    val top : rel
    val universe : rel
    val join : rel -> rel -> rel
    val meet : rel -> rel -> rel
    val equal : rel -> rel -> bool
    val domain : rel -> set
    val range : rel -> set

    val builtin : string -> rel option
    (** semantics of primitive/builtin relation *)

    val pp : Format.formatter -> rel -> unit

    module Forward : sig
      val union : rel list -> rel
      val inter : rel list -> rel
      val diff : rel -> rel -> rel
      val seq : rel Util.NonEmpty.t -> rel
      val cartesian : set -> set -> rel
      val inv : rel -> rel
      val comp : rel -> rel
      val toid : set -> rel
      val plus : rel -> rel
      val star : rel -> rel
      val opt : rel -> rel
      val try_ : rel -> rel -> rel
      val if_ : rel -> rel -> rel
    end

    module Backward : sig
      val union : parent:rel -> children_fw:rel list -> rel list
      val inter : parent:rel -> children_fw:rel list -> rel list
      val diff : parent:rel -> lchild_fw:rel -> rchild_fw:rel -> rel * rel
      val seq : parent:rel -> children_fw:rel Util.NonEmpty.t -> rel list
      val cartesian : parent:rel -> lchild_fw:set -> rchild_fw:set -> set * set
      val inv : parent:rel -> child_fw:rel -> rel
      val comp : parent:rel -> child_fw:rel -> rel
      val to_id : parent:rel -> child_fw:set -> set
      val plus : parent:rel -> child_fw:rel -> rel
      val star : parent:rel -> child_fw:rel -> rel
      val opt : parent:rel -> child_fw:rel -> rel
      val try_ : parent:rel -> lchild_fw:rel -> rchild_fw:rel -> rel * rel
      val if_ : parent:rel -> lchild_fw:rel -> rchild_fw:rel -> rel * rel
    end
  end
end

module type Forward = sig
  type t

  val top : t
  val bottom : t
  val join : t -> t -> t
  val equal : t -> t -> bool

  val builtin :
    string -> t option (* meaning of primitive/builtin named relation *)

  val konst_f : AST.konst -> t
  val tag_f : AST.tag -> t

  (* Forward transfer *)
  val op1_f : AST.op1 -> t -> t
  val op2_f : AST.op2 -> t list -> t
  val app_f : func:string -> arg_t:t -> t
  val explicit_set_f : t list -> t
  val match_set_f : scrutinee:t -> empty_case:t -> nonempty_case:t -> t
  val try_f : t -> t -> t
  val if_f : t -> t -> t
  val pp : Format.formatter -> t -> unit
end

module type S = sig
  include Forward

  val meet : t -> t -> t

  (* Backward/demand transfer:
     Given parent demand and forward facts of children, produce demands for children
     in the same order as the children list. *)
  val op1_b : AST.op1 -> parent:t -> child_f:t -> t
  val op2_b : AST.op2 -> parent:t -> children_f:t list -> t list
  val try_b : parent:t -> lchild_fw:t -> rchild_fw:t -> t * t
  val if_b : parent:t -> lchild_fw:t -> rchild_fw:t -> t * t
end

module FromTyped (D : Typed) = struct
  type ('r, 's) ty_lat = Top | Rel of 'r | Set of 's | Bottom
  type t = (D.rel, D.set) ty_lat

  let is_bottom = function Bottom -> true | _ -> false
  let is_rel = function Rel _ -> true | _ -> false
  let is_set = function Set _ -> true | _ -> false
  let is_set_or_bottom = function Set _ -> true | Bottom -> true | _ -> false
  let is_rel_or_bottom = function Rel _ -> true | Bottom -> true | _ -> false

  let pp fmt =
    let open Format in
    function
    | Top -> fprintf fmt "Top"
    | Bottom -> fprintf fmt "Bottom"
    | Rel r -> fprintf fmt "Rel (%a)" D.Rel.pp r
    | Set r -> fprintf fmt "Set (%a)" D.Set.pp r

  let mk_rel r = Rel r
  let mk_set s = Set s

  let as_set = function
    | Bottom -> D.Set.bottom
    | Top -> invalid_arg "as_set: Top not allowed"
    | Set s -> s
    | Rel _ -> invalid_arg "as_set: type mismatch"

  let as_rel = function
    | Bottom -> D.Rel.bottom
    | Top -> invalid_arg "as_rel: Top not allowed"
    | Rel r -> r
    | Set _ -> invalid_arg "as_rel: type mismatch"

  let top = Top
  let bottom = Bottom

  let join x y =
    match (x, y) with
    | _, Top | Top, _ -> Top
    | Bottom, y -> y
    | x, Bottom -> x
    | Rel x, Rel y -> Rel (D.Rel.join x y)
    | Set x, Set y -> Set (D.Set.join x y)
    | Set _, Rel _ | Rel _, Set _ -> Top

  let meet x y =
    match (x, y) with
    | x, Top -> x
    | Top, y -> y
    | Bottom, _ | _, Bottom -> Bottom
    | Rel x, Rel y -> Rel (D.Rel.meet x y)
    | Set x, Set y -> Set (D.Set.meet x y)
    | Set _, Rel _ | Rel _, Set _ -> invalid_arg "ill-typed meet"

  let has_set xs = List.exists is_set xs
  let has_rel xs = List.exists is_rel xs

  let infer_list (args : t list) : (D.rel list, D.set list) ty_lat =
    if List.for_all is_bottom args then Bottom
    else if List.for_all is_set_or_bottom args then Set (List.map as_set args)
    else if List.for_all is_rel_or_bottom args then Rel (List.map as_rel args)
    else Top

  let infer_pair a b : (D.rel * D.rel, D.set * D.set) ty_lat =
    if is_bottom a && is_bottom b then Bottom
    else if is_set_or_bottom a && is_set_or_bottom b then
      Set (as_set a, as_set b)
    else if is_rel_or_bottom a && is_rel_or_bottom b then
      Rel (as_rel a, as_rel b)
    else Top

  let equal x y =
    match (x, y) with
    | Top, Top | Bottom, Bottom -> true
    | Rel x, Rel y -> D.Rel.equal x y
    | Set x, Set y -> D.Set.equal x y
    | _ -> false

  let builtin s =
    match D.Set.builtin s with
    | Some x -> Some (Set x)
    | None -> (
        match D.Rel.builtin s with
        | Some x -> Some (Rel x)
        | None ->
            Log.warn (fun m -> m "Unknown builtin symbol: %s" s);
            None)

  let konst_f = function
    | AST.Empty AST.SET -> Set D.Set.bottom
    | AST.Universe AST.SET -> Set D.Set.universe
    | AST.Empty AST.RLN -> Rel D.Rel.bottom
    | AST.Universe AST.RLN -> Rel D.Rel.universe

  let tag_f _ = Top

  let op1_f (op : AST.op1) (x : t) : t =
    let open AST in
    match (op, x) with
    | _, Bottom -> Bottom
    | Inv, Rel r -> Rel (D.Rel.Forward.inv r)
    | Comp, Set s -> Set (D.Set.Forward.comp s)
    | Comp, Rel r -> Rel (D.Rel.Forward.comp r)
    | ToId, Set s -> Rel (D.Rel.Forward.toid s)
    | Plus, Rel r -> Rel (D.Rel.Forward.plus r)
    | Star, Rel r -> Rel (D.Rel.Forward.star r)
    | Opt, Rel r -> Rel (D.Rel.Forward.opt r)
    | _, _ -> Top

  module SetFw = D.Set.Forward
  module RelFw = D.Rel.Forward

  let op2_f (op : AST.op2) (args : t list) : t =
    let open AST in
    match op with
    | Union -> (
        match infer_list args with
        | Bottom -> Bottom
        | Set args -> Set (SetFw.union args)
        | Rel args -> Rel (RelFw.union args)
        | Top -> Top)
    | Inter -> (
        match infer_list args with
        | Bottom -> Bottom
        | Set args -> Set (SetFw.inter args)
        | Rel args -> Rel (RelFw.inter args)
        | Top -> Top)
    | Diff -> (
        match infer_list args with
        | Set [ a; b ] -> Set (SetFw.diff a b)
        | Rel [ a; b ] -> Rel (RelFw.diff a b)
        | Bottom -> Bottom
        | Top -> Top
        | _ -> failwith "malformed Diff")
    | Seq -> (
        match args with
        | [] -> failwith "malformed seq"
        | x :: xs when List.for_all is_rel_or_bottom args ->
            let rr = Util.NonEmpty.cons (as_rel x) (List.map as_rel xs) in
            Rel (RelFw.seq rr)
        | _ -> Top)
    | Cartesian -> (
        match args with
        | [ a; b ] when is_set_or_bottom a && is_set_or_bottom b ->
            Rel (RelFw.cartesian (as_set a) (as_set b))
        | [ _; _ ] -> Top
        | _ -> failwith "malformed cartesian product")
    | Add -> Top (* failwith "op2_f: Add not supported" *)
    | Tuple -> Top
  (* failwith "op2_f: Tuple not supported" *)

  let app_f ~func ~arg_t =
    match func with
    | "domain" -> (
        match arg_t with
        | Rel rel -> Set (D.Rel.domain rel)
        | Bottom -> Set (D.Rel.domain D.Rel.bottom)
        | Top | Set _ -> Top)
    | "range" -> (
        match arg_t with
        | Rel rel -> Set (D.Rel.range rel)
        | Bottom -> Set (D.Rel.range D.Rel.bottom)
        | Top | Set _ -> Top)
    | "intervening" | "fencerel" | "same-oa" -> Rel D.Rel.top
    | "oa-changes" | "at-least-one-writable" -> Set D.Set.top
    | _ -> Top

  let explicit_set_f = function [] -> Bottom | _ :: _ -> Top

  let match_set_f ~scrutinee:_ ~empty_case ~nonempty_case =
    match infer_pair empty_case nonempty_case with
    | Bottom -> Bottom
    | Set (empty_case, nonempty_case) ->
        Set (SetFw.union [ empty_case; nonempty_case ])
    | Rel (empty_case, nonempty_case) ->
        Rel (RelFw.union [ empty_case; nonempty_case ])
    | Top -> Top

  let try_f a b =
    match infer_pair a b with
    | Bottom -> Bottom
    | Set (a, b) -> Set (SetFw.try_ a b)
    | Rel (a, b) -> Rel (RelFw.try_ a b)
    | Top -> Top

  let if_f a b =
    match infer_pair a b with
    | Bottom -> Bottom
    | Set (a, b) -> Set (SetFw.if_ a b)
    | Rel (a, b) -> Rel (RelFw.if_ a b)
    | Top -> Top

  module SetBw = D.Set.Backward
  module RelBw = D.Rel.Backward

  let op1_b (op : AST.op1) ~(parent : t) ~(child_f : t) : t =
    let open AST in
    match (op, parent, child_f) with
    | Inv, (Rel _ | Bottom), (Rel _ | Bottom) ->
        Rel (RelBw.inv ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | Comp, Bottom, Bottom -> Bottom
    | Comp, (Rel _ | Bottom), (Rel _ | Bottom) ->
        Rel (RelBw.comp ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | Comp, (Set _ | Bottom), (Set _ | Bottom) ->
        Set (SetBw.comp ~parent:(as_set parent) ~child_fw:(as_set child_f))
    | ToId, (Rel _ | Bottom), (Set _ | Bottom) ->
        Set (RelBw.to_id ~parent:(as_rel parent) ~child_fw:(as_set child_f))
    | Plus, (Rel _ | Bottom), (Rel _ | Bottom) ->
        Rel (RelBw.plus ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | Star, (Rel _ | Bottom), (Rel _ | Bottom) ->
        Rel (RelBw.star ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | Opt, (Rel _ | Bottom), (Rel _ | Bottom) ->
        Rel (RelBw.opt ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | _ -> Top

  let op2_b (op : AST.op2) ~(parent : t) ~(children_f : t list) : t list =
    let open AST in
    let bottoms = List.map (fun _ -> Bottom) children_f in
    let all_bottom = List.for_all is_bottom (parent :: children_f) in
    let all_rels = List.for_all is_rel_or_bottom (parent :: children_f) in
    let all_sets = List.for_all is_set_or_bottom (parent :: children_f) in
    match (op, children_f) with
    | Union, _ when all_bottom -> bottoms
    | Union, _ when all_rels ->
        let parent = as_rel parent in
        let children_fw = List.map as_rel children_f in
        List.map mk_rel (RelBw.union ~parent ~children_fw)
    | Union, _ when all_sets ->
        let parent = as_set parent in
        let children_fw = List.map as_set children_f in
        List.map mk_set (SetBw.union ~parent ~children_fw)
    | Inter, _ when all_bottom -> bottoms
    | Inter, _ when all_rels ->
        let parent = as_rel parent in
        let children_fw = List.map as_rel children_f in
        List.map mk_rel (RelBw.inter ~parent ~children_fw)
    | Inter, _ when all_sets ->
        let parent = as_set parent in
        let children_fw = List.map as_set children_f in
        List.map mk_set (SetBw.inter ~parent ~children_fw)
    | Diff, _ when all_bottom -> bottoms
    | Diff, [ lchild_fw; rchild_fw ] when all_rels ->
        let parent = as_rel parent in
        let lchild_fw = as_rel lchild_fw in
        let rchild_fw = as_rel rchild_fw in
        let l, r = RelBw.diff ~parent ~lchild_fw ~rchild_fw in
        [ Rel l; Rel r ]
    | Diff, [ lchild_fw; rchild_fw ] when all_sets ->
        let parent = as_set parent in
        let lchild_fw = as_set lchild_fw in
        let rchild_fw = as_set rchild_fw in
        let l, r = SetBw.diff ~parent ~lchild_fw ~rchild_fw in
        [ Set l; Set r ]
    | Seq, x :: xs when all_rels ->
        let parent = as_rel parent in
        let x = as_rel x in
        let xs = List.map as_rel xs in
        let l = RelBw.seq ~parent ~children_fw:(Util.NonEmpty.cons x xs) in
        List.map (fun r -> Rel r) l
    | Cartesian, [ lchild_fw; rchild_fw ]
      when is_rel_or_bottom parent && is_set_or_bottom lchild_fw
           && is_set_or_bottom rchild_fw ->
        let parent = as_rel parent in
        let lchild_fw = as_set lchild_fw in
        let rchild_fw = as_set rchild_fw in
        let l, r = RelBw.cartesian ~parent ~lchild_fw ~rchild_fw in
        [ Set l; Set r ]
    | _ -> List.map (fun _ -> Top) children_f

  let try_b ~parent ~lchild_fw ~rchild_fw : t * t =
    let values = [ parent; lchild_fw; rchild_fw ] in
    if List.for_all is_bottom values then (Bottom, Bottom)
    else if List.for_all is_rel_or_bottom values then
      let l, r =
        RelBw.try_ ~parent:(as_rel parent) ~lchild_fw:(as_rel lchild_fw)
          ~rchild_fw:(as_rel rchild_fw)
      in
      (Rel l, Rel r)
    else if List.for_all is_set_or_bottom values then
      let l, r =
        SetBw.try_ ~parent:(as_set parent) ~lchild_fw:(as_set lchild_fw)
          ~rchild_fw:(as_set rchild_fw)
      in
      (Set l, Set r)
    else (Top, Top)

  let if_b ~parent ~lchild_fw ~rchild_fw : t * t =
    let values = [ parent; lchild_fw; rchild_fw ] in
    if List.for_all is_bottom values then (Bottom, Bottom)
    else if List.for_all is_rel_or_bottom values then
      let l, r =
        RelBw.if_ ~parent:(as_rel parent) ~lchild_fw:(as_rel lchild_fw)
          ~rchild_fw:(as_rel rchild_fw)
      in
      (Rel l, Rel r)
    else if List.for_all is_set_or_bottom values then
      let l, r =
        SetBw.if_ ~parent:(as_set parent) ~lchild_fw:(as_set lchild_fw)
          ~rchild_fw:(as_set rchild_fw)
      in
      (Set l, Set r)
    else (Top, Top)
end
