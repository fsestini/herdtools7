[@@@warning "-40-42"]

module NonEmpty = struct
  type 'a t = Cons of 'a * 'a list [@@deriving show]

  let of_list : 'a list -> 'a t = function
    | [] -> failwith "cannot create non-empty list from an empty list"
    | x :: xs -> Cons (x, xs)
end

module CoreAST = struct
  type 'a t =
    | Union of 'a t NonEmpty.t
    | Inter of 'a t NonEmpty.t
    | Seq of 'a t NonEmpty.t
    | Inv of 'a t
    | Comp of 'a t
    | ToId of 'a t
    | Var of 'a
  [@@deriving show]

  let union_of_list : 'a t list -> 'a t = fun xs -> Union (NonEmpty.of_list xs)
  let inter_of_list : 'a t list -> 'a t = fun xs -> Inter (NonEmpty.of_list xs)
  let seq_of_list : 'a t list -> 'a t = fun xs -> Seq (NonEmpty.of_list xs)
end

type var = string

let to_core_ast ~(unroll : int) ~(conds : string list) (exp : AST.exp) :
    var CoreAST.t =
  let unrolled (e : var CoreAST.t) : var CoreAST.t =
    CoreAST.union_of_list
      (List.init unroll (fun i ->
           CoreAST.seq_of_list (List.init (unroll - i) (fun _ -> e))))
  in
  let rec eval_variant_cond : AST.variant_cond -> bool = function
    | Variant v -> List.mem v conds
    | OpNot v -> not (eval_variant_cond v)
    | OpAnd (v1, v2) -> eval_variant_cond v1 && eval_variant_cond v2
    | OpOr (v1, v2) -> eval_variant_cond v1 || eval_variant_cond v2
  in
  let rec go (exp : AST.exp) : var CoreAST.t =
    let open AST in
    match exp with
    | Op (_, Union, expl) -> CoreAST.union_of_list (List.map go expl)
    | Op (_, Inter, expl) -> CoreAST.inter_of_list (List.map go expl)
    | Op (_, Seq, expl) -> CoreAST.seq_of_list (List.map go expl)
    | Op (_, Diff, expl) -> go (List.hd expl)
    | Op (_, Cartesian, _) -> failwith "Cartesian not implemented yet"
    | Op1 (_, ToId, exp) -> ToId (go exp)
    | Op1 (_, Plus, exp) -> unrolled (go exp)
    | Op1 (_, Star, exp) ->
        CoreAST.union_of_list [ unrolled (go exp); Var "ignore" ]
    | Op1 (_, Opt, exp) -> CoreAST.union_of_list [ go exp; Var "ignore" ]
    | Op1 (_, Inv, exp) -> Inv (go exp)
    | Op1 (_, Comp, exp) -> Comp (go exp)
    | Konst (_, Empty _) -> failwith "Empty exp"
    | App (_, fexp, exp) -> (
        match fexp with
        | Var (_, ("range" | "domain")) -> go exp
        | _ -> failwith "function not supported")
    | Var (_, "emptyset") -> failwith "emptyset"
    | Var (_, var) -> Var var
    | If (_, VariantCond a, exp, exp2) ->
        if eval_variant_cond a then go exp else go exp2
    | _ -> failwith "expression not supported"
  in
  go exp

let rec foldr1 (f : 'a -> 'a -> 'a) : 'a list -> 'a = function
  | [] -> failwith "called foldr1 on empty list"
  | [ x ] -> x
  | x :: xs -> f x (foldr1 f xs)

module IR = struct
  type 'a inter = Inter of 'a inter * 'a inter | Pure of 'a
  type 'a intersection = Event of 'a | Pure of 'a
  type 'a sequence = Seq of 'a sequence * 'a sequence | Pure of 'a
  type 'a union = Union of 'a union * 'a union | Pure of 'a
  type 'a t = 'a inter intersection sequence union

  let rec map_union (f : 'a -> 'b) : 'a union -> 'b union = function
    | Pure x -> Pure (f x)
    | Union (e1, e2) -> Union (map_union f e1, map_union f e2)

  let rec concat_map_union (f : 'a -> 'b union) : 'a union -> 'b union =
    function
    | Pure x -> f x
    | Union (e1, e2) -> Union (concat_map_union f e1, concat_map_union f e2)

  let rec seq (e1 : 'a t) (e2 : 'a t) : 'a t =
    match e1 with
    | Pure s -> map_union (fun s2 -> Seq (s, s2)) e2
    | Union (e1_l, e1_r) -> seq e1_l (seq e1_r e2)

  let inter_intersection (e1 : 'a intersection) (e2 : 'a intersection) :
      'a intersection =
    match (e1, e2) with
    | Pure i1, Pure i2 -> Pure (Inter (i1, i2))
    | Event ev1, Event ev2 -> Event (Inter (ev1, ev2))
    | _, _ -> failwith "cannot mix event and relation"

  let inter_seq (e1 : 'a intersection sequence) (e2 : 'a intersection sequence)
      : 'a intersection sequence =
    match (e1, e2) with
    | Pure x, Pure y -> Pure (inter_intersection x y)
    | _ -> failwith "impossible intersection"

  let rec inter (e1 : 'a t) (e2 : 'a t) : 'a t =
    match e1 with
    | Pure s -> map_union (fun s2 -> inter_seq s s2) e2
    | Union (e1_l, e1_r) -> inter e1_l (inter e1_r e2)

  let rec rev_seq : 'a sequence -> 'a sequence = function
    | Seq (e1, e2) -> Seq (rev_seq e2, rev_seq e1)
    | Pure x -> Pure x

  let pure (x : 'a) : 'a t = Pure (Pure (Pure (Pure x)))
  let union : 'a t -> 'a t -> 'a t = fun x y -> Union (x, y)
  let pure_inter : 'a inter -> 'a t = fun inter -> Pure (Pure (Pure inter))
end

type builtin = DMB_SY | DMB_ISH (* etc... *)

let parse_builtin : string -> builtin option = function
  | "DMB_SY" -> Some DMB_SY
  | "DMB_ISH" -> Some DMB_ISH
  | _ -> None

let to_ir ~(env : (var * var IR.t) list) (t : var CoreAST.t) : var IR.t =
  let of_complement : var IR.inter -> var IR.t = function
    | Inter (Pure "NExp", Pure "M") -> _
  in
  let rec go : var CoreAST.t -> var IR.t = function
    | Union (e1, e2) -> IR.Union (go e1, go e2)
    | Seq (e1, e2) -> IR.seq (go e1) (go e2)
    | Inter (e1, e2) -> IR.inter (go e1) (go e2)
    | ToId e -> (
        match go e with
        | Pure (Pure (Pure i)) -> Pure (Pure (Event i))
        | Pure (Pure (Event i)) -> Pure (Pure (Event i))
        | _ -> failwith "cannot create event out of non-intersection relation")
    | Inv e -> go e |> IR.map_union IR.rev_seq
    | Comp e -> (
        match go e with
        | Pure (Pure (Pure x)) -> of_complement x
        | _ -> failwith "complement of non-intersection not supported")
    | Pure v -> (
        match List.assoc_opt v env with Some t -> t | None -> IR.pure v)
  in
  go t
