module Log = (val Logs.src_log (Logs.Src.create "domain") : Logs.LOG)

module type Typed = sig
  type set
  type rel

  module Set : sig
    val bottom : set
    val top : set
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
    end

    module Backward : sig
      val union : parent:set -> children_fw:set list -> set list
      val inter : parent:set -> children_fw:set list -> set list
      val diff : parent:set -> lchild_fw:set -> rchild_fw:set -> set * set
      val comp : parent:set -> child_fw:set -> set
    end
  end

  module Rel : sig
    val bottom : rel
    val top : rel
    val join : rel -> rel -> rel
    val meet : rel -> rel -> rel
    val equal : rel -> rel -> bool

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
    end
  end
end

module type S = sig
  type t

  val top : t
  val bottom : t
  val join : t -> t -> t
  val meet : t -> t -> t
  val equal : t -> t -> bool

  val builtin :
    string -> t option (* meaning of primitive/builtin named relation *)

  (* Forward transfer *)
  val op1_f : AST.op1 -> t -> t
  val op2_f : AST.op2 -> t list -> t

  (* Backward/demand transfer:
     Given parent demand and forward facts of children, produce demands for children
     in the same order as the children list. *)
  val op1_b : AST.op1 -> parent:t -> child_f:t -> t
  val op2_b : AST.op2 -> parent:t -> children_f:t list -> t list
  val pp : Format.formatter -> t -> unit
end

module FromTyped (D : Typed) = struct
  type t = Top | Rel of D.rel | Set of D.set | Bottom

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
    | Top -> D.Set.top
    | Set s -> s
    | Rel _ -> invalid_arg "as_set: type mismatch"

  let as_rel = function
    | Bottom -> D.Rel.bottom
    | Top -> D.Rel.top
    | Rel r -> r
    | Set _ -> invalid_arg "as_rel: type mismatch"

  let top = Top
  let bottom = Bottom

  let join x y =
    match (x, y) with
    | _, Top -> Top
    | Top, _ -> Top
    | Bottom, y -> y
    | x, Bottom -> x
    | Rel x, Rel y -> Rel (D.Rel.join x y)
    | Set x, Set y -> Set (D.Set.join x y)
    | Set _, Rel _ | Rel _, Set _ ->
        Log.warn (fun m -> m "Type mismatch in domain join");
        Top

  let meet x y =
    match (x, y) with
    | x, Top -> x
    | Top, y -> y
    | Bottom, _ -> Bottom
    | _, Bottom -> Bottom
    | Rel x, Rel y -> Rel (D.Rel.meet x y)
    | Set x, Set y -> Set (D.Set.meet x y)
    | Set _, Rel _ | Rel _, Set _ ->
        Log.warn (fun m -> m "Type mismatch in domain meet");
        Bottom

  let equal x y =
    match (x, y) with
    | Top, Top -> true
    | Bottom, Bottom -> true
    | Rel x, Rel y -> D.Rel.equal x y
    | Set x, Set y -> D.Set.equal x y
    | _ -> false

  let builtin s =
    match D.Set.builtin s with
    | Some x -> Some (Set x)
    | None -> (
        match D.Rel.builtin s with Some x -> Some (Rel x) | None -> None)

  let op1_f (op : AST.op1) (x : t) : t =
    let open AST in
    match op with
    | Inv -> Rel (D.Rel.Forward.inv (as_rel x))
    | Comp -> (
        match x with
        | Set s -> Set (D.Set.Forward.comp s)
        | Rel r -> Rel (D.Rel.Forward.comp r)
        | Top | Bottom -> Top)
    | ToId -> Rel (D.Rel.Forward.toid (as_set x))
    | Plus -> Rel (D.Rel.Forward.plus (as_rel x))
    | Star -> Rel (D.Rel.Forward.star (as_rel x))
    | Opt -> Rel (D.Rel.Forward.opt (as_rel x))

  let as_sets : t list -> D.set list option =
    Util.List.traverse_option (function Set s -> Some s | _ -> None)

  let as_rels : t list -> D.rel list option =
    Util.List.traverse_option (function Rel r -> Some r | _ -> None)

  module SetFw = D.Set.Forward
  module RelFw = D.Rel.Forward

  let op2_f (op : AST.op2) (args : t list) : t =
    let open AST in
    match op with
    | Union -> (
        match as_sets args with
        | Some ss -> Set (SetFw.union ss)
        | None -> (
            match as_rels args with
            | Some rr -> Rel (RelFw.union rr)
            | None -> Top))
    | Inter -> (
        match as_sets args with
        | Some ss -> Set (SetFw.inter ss)
        | None -> (
            match as_rels args with
            | Some rr -> Rel (RelFw.inter rr)
            | None -> Top))
    | Diff -> (
        match args with
        | [ Set left; Set right ] -> Set (SetFw.diff left right)
        | [ Rel left; Rel right ] -> Rel (RelFw.diff left right)
        | [ _; _ ] -> Top
        | _ -> failwith "invalid diff")
    | Seq -> (
        match as_rels args with
        | Some (x :: xs) -> Rel (RelFw.seq (Util.NonEmpty.cons x xs))
        | _ -> Top)
    | Cartesian -> (
        match args with
        | [ Set left; Set right ] -> Rel (RelFw.cartesian left right)
        | _ -> Top)
    | Add -> Top (* failwith "op2_f: Add not supported" *)
    | Tuple -> Top
  (* failwith "op2_f: Tuple not supported" *)

  module SetBw = D.Set.Backward
  module RelBw = D.Rel.Backward

  let op1_b (op : AST.op1) ~(parent : t) ~(child_f : t) : t =
    let open AST in
    match op with
    | Inv -> Rel (RelBw.inv ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | Comp -> (
        match parent with
        | Rel parent -> Rel (RelBw.comp ~parent ~child_fw:(as_rel child_f))
        | Set parent -> Set (SetBw.comp ~parent ~child_fw:(as_set child_f))
        | Top -> Top
        | Bottom -> Bottom)
    | ToId ->
        Set (RelBw.to_id ~parent:(as_rel parent) ~child_fw:(as_set child_f))
    | Plus ->
        Rel (RelBw.plus ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | Star ->
        Rel (RelBw.star ~parent:(as_rel parent) ~child_fw:(as_rel child_f))
    | Opt -> Rel (RelBw.opt ~parent:(as_rel parent) ~child_fw:(as_rel child_f))

  let op2_b (op : AST.op2) ~(parent : t) ~(children_f : t list) : t list =
    let open AST in
    match (op, parent, children_f) with
    | Union, Rel parent, _ ->
        let children_fw = List.map as_rel children_f in
        List.map mk_rel (RelBw.union ~parent ~children_fw)
    | Union, Set parent, _ ->
        let children_fw = List.map as_set children_f in
        List.map mk_set (SetBw.union ~parent ~children_fw)
    | Inter, Rel parent, _ ->
        let children_fw = List.map as_rel children_f in
        List.map mk_rel (RelBw.inter ~parent ~children_fw)
    | Inter, Set parent, _ ->
        let children_fw = List.map as_set children_f in
        List.map mk_set (SetBw.inter ~parent ~children_fw)
    | Diff, Rel parent, [ lchild_fw; rchild_fw ] ->
        let lchild_fw = as_rel lchild_fw in
        let rchild_fw = as_rel rchild_fw in
        let l, r = RelBw.diff ~parent ~lchild_fw ~rchild_fw in
        [ Rel l; Rel r ]
    | Diff, Rel _, _ -> failwith "malformed Diff"
    | Diff, Set parent, [ lchild_fw; rchild_fw ] ->
        let lchild_fw = as_set lchild_fw in
        let rchild_fw = as_set rchild_fw in
        let l, r = SetBw.diff ~parent ~lchild_fw ~rchild_fw in
        [ Set l; Set r ]
    | Diff, Set _, _ -> failwith "malformed Diff"
    | Seq, Rel parent, x :: xs ->
        let x = as_rel x in
        let xs = List.map as_rel xs in
        let l = RelBw.seq ~parent ~children_fw:(Util.NonEmpty.cons x xs) in
        List.map (fun r -> Rel r) l
    | Seq, Rel _, _ | Seq, Set _, _ -> failwith "malformed Seq"
    | Cartesian, Rel parent, [ lchild_fw; rchild_fw ] ->
        let lchild_fw = as_set lchild_fw in
        let rchild_fw = as_set rchild_fw in
        let l, r = RelBw.cartesian ~parent ~lchild_fw ~rchild_fw in
        [ Set l; Set r ]
    | Cartesian, Rel _, _ | Cartesian, Set _, _ ->
        failwith "malformed Cartesian"
    | _, Top, _ -> List.map (fun _ -> Top) children_f
    | _, Bottom, _ -> List.map (fun _ -> Bottom) children_f
    | Add, _, _ -> failwith "op2_b: Add not supported"
    | Tuple, _, _ -> failwith "op2_b: Tuple not supported"
end
