[@@@warning "-40-42"]

module NonEmpty = struct
  type 'a t = Cons of 'a * 'a list [@@deriving show]

  let of_list : 'a list -> 'a t = function
    | [] -> failwith "cannot create non-empty list from an empty list"
    | x :: xs -> Cons (x, xs)

  let map (f : 'a -> 'b) : 'a t -> 'b t = function
    | Cons (x, xs) -> Cons (f x, List.map f xs)

  let cons (x : 'a) : 'a t -> 'a t = function Cons (y, ys) -> Cons (x, y :: ys)
  let to_list : 'a t -> 'a list = function Cons (x, xs) -> x :: xs
  let rev : 'a t -> 'a t = fun xs -> of_list (List.rev (to_list xs))
  let pure : 'a -> 'a t = fun x -> Cons (x, [])

  let join : 'a t t -> 'a t =
   fun xs -> of_list (List.concat_map to_list (to_list xs))

  let concat (xs : 'a t) (ys : 'a t) : 'a t =
    List.fold_right cons (to_list xs) ys

  let foldl1 (f : 'a -> 'a -> 'a) : 'a t -> 'a = function
    | Cons (x, xs) -> List.fold_left f x xs

  let bind (xs : 'a t) (f : 'a -> 'b t) : 'b t = join (map f xs)
end

exception NormalizationError of string

module CoreAST = struct
  type fn_name = Fencerel | Range | Domain [@@deriving show]

  type 'a t =
    | Union of 'a t NonEmpty.t
    | Inter of 'a t NonEmpty.t
    | Seq of 'a t NonEmpty.t
    | Inv of 'a t
    | Comp of 'a t
    | ToId of 'a t
    | App of fn_name * 'a t
    | Empty
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
    | Op (_, Cartesian, _) ->
        raise (NormalizationError "Cartesian not implemented yet")
    | Op1 (_, ToId, exp) -> ToId (go exp)
    | Op1 (_, Plus, exp) -> unrolled (go exp)
    | Op1 (_, Star, exp) ->
        CoreAST.union_of_list [ unrolled (go exp); Var "ignore" ]
    | Op1 (_, Opt, exp) -> CoreAST.union_of_list [ go exp; Var "ignore" ]
    | Op1 (_, Inv, exp) -> Inv (go exp)
    | Op1 (_, Comp, exp) -> Comp (go exp)
    | Konst (_, Empty _) -> Empty
    | App (_, fexp, exp) -> (
        match fexp with
        | Var (_, "domain") -> App (Domain, go exp)
        | Var (_, "range") -> App (Range, go exp)
        | Var (_, "fencerel") -> App (Fencerel, go exp)
        | Var (_, fn) ->
            let err = Format.sprintf "function not supported: %s" fn in
            raise (NormalizationError err)
        | _ -> raise (NormalizationError "unknown function"))
    (* | Var (_, "emptyset") -> failwith "emptyset" *)
    | Var (_, var) -> Var var
    | If (_, VariantCond a, exp, exp2) ->
        if eval_variant_cond a then go exp else go exp2
    | Try (_, e, _) ->
        (* TODO: add a CoreAST contructor *)
        go e
        (* let err = "try expression not supported" in *)
        (* raise (NormalizationError err) *)
    | MatchSet _ ->
        let err = "MatchSet expression not supported" in
        raise (NormalizationError err)
    | Match _ ->
        let err = "Match expression not supported" in
        raise (NormalizationError err)
    | ExplicitSet _ ->
        let err = "ExplicitSet expression not supported" in
        raise (NormalizationError err)
    | Fun _ ->
        let err = "Fun expression not supported" in
        raise (NormalizationError err)
    | Bind _ ->
        let err = "Bind expression not supported" in
        raise (NormalizationError err)
    | BindRec _ ->
        let err = "BindRec expression not supported" in
        raise (NormalizationError err)
    | _ ->
        let err = Format.sprintf "expression not supported" in
        raise (NormalizationError err)
  in
  go exp

module IR = struct
  type 'a inter = Inter of 'a NonEmpty.t
  type ('a, 'b) rel_inter = Rel of 'a | Set of 'b
  type 'a seq = Seq of 'a NonEmpty.t
  type 'a union = Union of 'a list
  type ('a, 'b) t = ('a inter, 'b inter) rel_inter seq union
  type 'a set = 'a inter union

  (* let pp_union ~(pp : 'a -> string) : 'a union -> string = function *)
  (*   | Union x -> _ *)
  let pp (_t : ('a, 'b) t) : string = "t"
  let pure_union : 'a -> 'a union = fun x -> Union [ x ]
  let un_union : 'a union -> 'a list = fun (Union x) -> x
  let pure_seq : 'a -> 'a seq = fun x -> Seq (NonEmpty.pure x)
  let pure_inter : 'a -> 'a inter = fun x -> Inter (NonEmpty.pure x)
  let pure_rel_inter : 'a -> ('a, 'b) rel_inter = fun x -> Rel x

  let map_union (f : 'a -> 'b) : 'a union -> 'b union = function
    | Union x -> Union (List.map f x)

  let seq (e1 : ('a, 'b) t) (e2 : ('a, 'b) t) : ('a, 'b) t =
    let aux =
      let ( let* ) = fun x f -> List.concat_map f x in
      let* (Seq x) = un_union e1 in
      let* (Seq y) = un_union e2 in
      [ Seq (NonEmpty.concat x y) ]
    in
    Union aux

  let inter (e1 : 'a inter) (e2 : 'a inter) : 'a inter =
    match (e1, e2) with Inter i1, Inter i2 -> Inter (NonEmpty.concat i1 i2)

  let inter_set (e1 : 'a set) (e2 : 'a set) : 'a set =
    let aux =
      let ( let* ) = fun x f -> List.concat_map f x in
      let* x = un_union e1 in
      let* y = un_union e2 in
      [ inter x y ]
    in
    Union aux

  let inter_t (e1 : ('a, 'b) t) (e2 : ('a, 'b) t) : ('a, 'b) t =
    let aux =
      let ( let* ) = fun x f -> List.concat_map f x in
      let* (Seq x) = un_union e1 in
      let* (Seq y) = un_union e2 in
      match (x, y) with
      | Cons (Rel x, []), Cons (Rel y, []) -> [ pure_seq (Rel (inter x y)) ]
      | Cons (Set x, []), Cons (Set y, []) -> [ pure_seq (Set (inter x y)) ]
      | _, _ -> raise (NormalizationError "impossible intersection")
    in
    Union aux

  let rec rev_seq : 'a seq -> 'a seq = function
    | Seq xs -> Seq (NonEmpty.rev xs)

  let pure (x : 'a) : ('a, 'b) t =
    pure_union (pure_seq (pure_rel_inter (pure_inter x)))

  let union : 'a union -> 'a union -> 'a union =
   fun (Union x) (Union y) -> Union (List.append x y)

  let as_pure_set : 'a set -> 'a option = function
    | Union [ Inter (Cons (x, [])) ] -> Some x
    | _ -> None
  (* let as_pure_set : ('a, 'b) t -> 'b option = function *)
  (*   | Union [ Seq (Cons (Set (Inter (Cons (x, []))), [])) ] -> Some x *)
  (*   | _ -> None *)
end

type builtin_rel =
  | ISB
  | DMB_SY
  | DMB_ISH
  | DMB_OSHST
  | DMB_ST
  | DMB_ISHST
  | DSB_ST
  | DSB_OSHST
  | DSB_ISHST

type builtin_set =
  | R
  | W
  | ISB
  | DMB_SY
  | DMB_ISH
  | DMB_OSHST
  | DMB_ISHST
  | DMB_ST
  | DSB_ST
  | DSB_OSHST
  | DSB_ISHST

let fencerel : builtin_set -> builtin_rel = function
  | ISB -> ISB
  | DMB_ISH -> DMB_ISH
  | DMB_SY -> DMB_SY
  | DMB_OSHST -> DMB_OSHST
  | DMB_ST -> DMB_ST
  | DMB_ISHST -> DMB_ISHST
  | DSB_ST -> DSB_ST
  | DSB_ISHST -> DSB_ISHST
  | DSB_OSHST -> DSB_OSHST
  | _ -> raise (NormalizationError "unsupported argument for fencerel")

let parse_builtin_set : string -> builtin_set option = function
  | "DMB.SY" -> Some DMB_SY
  | "DMB.ISH" -> Some DMB_ISH
  | "DMB.OSHST" -> Some DMB_OSHST
  | "DMB.ST" -> Some DMB_ST
  | "DMB.ISHST" -> Some DMB_ISHST
  | "DSB.ST" -> Some DSB_ST
  | "DSB.ISHST" -> Some DSB_ISHST
  | "DSB.OSHST" -> Some DSB_OSHST
  | "R" -> Some R
  | "W" -> Some W
  | _ -> None

let comp_set_inter : builtin_set IR.inter -> builtin_set IR.set =
 (* TODO: implement as in cat2config *)
 fun is ->
  IR.pure_union is

let to_set ~(env : (var * builtin_set IR.set) list) (t : var CoreAST.t) :
    builtin_set IR.set =
  let rec go : var CoreAST.t -> builtin_set IR.set = function
    | Union es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.union
    | Inter es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.inter_set
    | Comp e ->
        (* the complement of unions is the intersection of complements *)
        let (Union aux) = go e in
        let complemented = List.map comp_set_inter aux in
        List.fold_left IR.inter_set (Union []) complemented
    | Var v -> (
        match parse_builtin_set v with
        | Some s -> IR.pure_union (IR.pure_inter s)
        | None -> (
            match List.assoc_opt v env with
            | Some t -> t
            | None ->
                let err = Format.sprintf "unknown set variable: %s" v in
                raise (NormalizationError err)))
    | _ -> raise (NormalizationError "set expression not supported")
  in
  go t

type ir = (builtin_rel, builtin_set) IR.t

let comp_rel_inter : builtin_rel IR.inter -> ir =
 (* TODO: implement as in cat2config *)
 fun is ->
  IR.(pure_union (pure_seq (pure_rel_inter is)))

(* TODO: account for recursive definitions *)
let to_ir ~(env : (var * ir) list) ~(set_env : (var * builtin_set IR.set) list)
    (t : var CoreAST.t) : ir =
  let rec go : var CoreAST.t -> ir = function
    | Union es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.union
    | Seq es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.seq
    | Inter es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.inter_t
    | ToId e ->
        let aux = to_set ~env:set_env e in
        IR.map_union (fun is -> IR.(pure_seq (Set is))) aux
    | Inv e -> go e |> IR.map_union IR.rev_seq
    | Comp e ->
        let (Union aux) = go e in
        let complemented =
          List.map
            (function
              | IR.Seq (Cons (IR.Rel x, [])) -> comp_rel_inter x
              | _ -> raise (NormalizationError "unsupported complement"))
            aux
        in
        List.fold_left IR.inter_t (Union []) complemented
    | App (fn, e) -> (
        match fn with
        | Fencerel -> (
            let s = to_set ~env:set_env e in
            match IR.as_pure_set s with
            | Some x ->
                let r = fencerel x in
                IR.pure r
            | None -> raise (NormalizationError "fencerel failed"))
        | _ ->
            raise (NormalizationError "unsupported function")
            (* app_ir fn (go e) *))
    | Empty -> Union []
    | Var v -> (
        match List.assoc_opt v env with
        | Some t -> t
        | None ->
            let err = Format.sprintf "unsupported rel var: %s" v in
            raise (NormalizationError err))
  in
  go t

let parse_core ~(unroll : int) ~(conds : string list)
    (lets : (var * AST.exp) list) : (var * var CoreAST.t) list =
  lets
  |> List.filter_map (fun (v, e) ->
         try
           let core = to_core_ast ~unroll ~conds e in
           Some (v, core)
         with NormalizationError _err ->
           (* Format.eprintf "parse_core (%s): %s@." v err; *)
           None)

let normalize_core (core_bindings : (var * var CoreAST.t) list) :
    (var * ir) list =
  let rel_lets, _ =
    core_bindings
    |> List.fold_left
         (fun (env, set_env) (v, t) ->
           try
             let s = to_set ~env:set_env t in
             (env, (v, s) :: set_env)
           with NormalizationError err -> (
             Format.eprintf "normalize_core(set)(%s): %s@." v err;
             try
               let t = to_ir ~env ~set_env t in
               ((v, t) :: env, set_env)
             with NormalizationError err ->
               Format.eprintf "normalize_core(rel)(%s): %s@." v err;
               (env, set_env)))
         ([], [])
  in
  rel_lets
