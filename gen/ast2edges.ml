[@@@warning "-40-42"]

module StringMap = Map.Make (String)

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
        CoreAST.union_of_list [ unrolled (go exp); Empty ]
        (* CoreAST.union_of_list [ unrolled (go exp); Var "ignore" ] *)
    | Op1 (_, Opt, exp) -> CoreAST.union_of_list [ go exp; Empty ]
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

  let pure_set (x : 'a) : 'a set = pure_union (pure_inter x)

  let union : 'a union -> 'a union -> 'a union =
   fun (Union x) (Union y) -> Union (List.append x y)

  let as_pure_set : 'a set -> 'a option = function
    | Union [ Inter (Cons (x, [])) ] -> Some x
    | _ -> None
  (* let as_pure_set : ('a, 'b) t -> 'b option = function *)
  (*   | Union [ Seq (Cons (Set (Inter (Cons (x, []))), [])) ] -> Some x *)
  (*   | _ -> None *)
end

type builtin_fence =
  | ISB
  | DMB_SY
  | DSB_LD
  | DSB_SY
  | DMB_LD
  | DMB_ISH
  | DSB_ISH
  | DMB_OSH
  | DSB_OSH
  | DMB_OSHST
  | DMB_ISHST
  | DMB_ISHLD
  | DSB_ISHLD
  | DMB_ST
  | DSB_ST
  | DSB_OSHST
  | DSB_ISHST
  | DMB_OSHLD
  | DSB_OSHLD

type builtin_rel = Co | Fr | Rf | Ext | Po | Fencerel of builtin_fence

let builtin_rels : (var * builtin_rel) list =
  [ ("co", Co); ("fr", Fr); ("rf", Rf); ("ext", Ext); ("po", Po) ]

type builtin_set =
  | Exp
  | M
  | R
  | W
  | A
  | L
  | Q
  | FAULT
  | NoRet
  | IC
  | Fence of builtin_fence

let fencerel : builtin_set -> builtin_rel = function
  | Fence f -> Fencerel f
  | _ -> raise (NormalizationError "unsupported argument for fencerel")

let builtin_sets : (var * builtin_set) list =
  [
    ("DSB.LD", Fence DSB_LD);
    ("DMB.SY", Fence DMB_SY);
    ("DSB.SY", Fence DSB_SY);
    ("DMB.LD", Fence DMB_LD);
    ("DMB.ISH", Fence DMB_ISH);
    ("DMB.OSHST", Fence DMB_OSHST);
    ("DMB.ST", Fence DMB_ST);
    ("DMB.ISHST", Fence DMB_ISHST);
    ("DSB.ST", Fence DSB_ST);
    ("DSB.ISHST", Fence DSB_ISHST);
    ("DSB.OSHST", Fence DSB_OSHST);
    ("DMB.ISHLD", Fence DMB_ISHLD);
    ("DSB.ISH", Fence DSB_ISH);
    ("DSB.ISHLD", Fence DSB_ISHLD);
    ("DMB.OSH", Fence DMB_OSH);
    ("DSB.OSH", Fence DSB_OSH);
    ("DMB.OSHLD", Fence DMB_OSHLD);
    ("DSB.OSHLD", Fence DSB_OSHLD);
    ("ISB", Fence ISB);
    ("R", R);
    ("W", W);
    ("M", M);
    ("A", A);
    ("L", L);
    ("Q", Q);
    ("Exp", Exp);
    ("FAULT", FAULT);
    ("NoRet", NoRet);
    ("IC", IC);
  ]

let comp_set_inter : builtin_set IR.inter -> builtin_set IR.set =
 (* TODO: implement as in cat2config *)
 fun is ->
  IR.pure_union is

type ir_set = builtin_set IR.set
type ir = (builtin_rel, builtin_set) IR.t
type env = (ir, ir_set) Either.t StringMap.t

let comp_rel_inter : builtin_rel IR.inter -> ir =
 (* TODO: implement as in cat2config *)
 fun is ->
  IR.(pure_union (pure_seq (pure_rel_inter is)))

let domain : ir -> ir_set = _
let range : ir -> ir_set = _

let rec to_set ~(env : env) (t : var CoreAST.t) : ir_set =
  let rec go : var CoreAST.t -> builtin_set IR.set = function
    | Union es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.union
    | Inter es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.inter_set
    | Comp e ->
        (* the complement of unions is the intersection of complements *)
        let (Union aux) = go e in
        let complemented = List.map comp_set_inter aux in
        List.fold_left IR.inter_set (Union []) complemented
    | Var v -> (
        match StringMap.find_opt v env with
        | Some (Right t) -> t
        | _ ->
            let err = Format.sprintf "unknown set variable: %s" v in
            raise (NormalizationError err))
    | App (fn, e) -> (
        match fn with
        | Domain -> domain (to_ir ~env e)
        | Range -> range (to_ir ~env e)
        | Fencerel ->
            let err = "Function `fencerel` does not produce a set" in
            raise (NormalizationError err))
    | e ->
        let err =
          Format.sprintf "invalid or unsupported set expression: %s"
            (CoreAST.show Format.pp_print_string e)
        in
        raise (NormalizationError err)
  in
  go t

(* TODO: account for recursive definitions *)
and to_ir ~(env : env) (t : var CoreAST.t) : ir =
  let rec go : var CoreAST.t -> ir = function
    | Union es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.union
    | Seq es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.seq
    | Inter es -> es |> NonEmpty.map go |> NonEmpty.foldl1 IR.inter_t
    | ToId e ->
        let aux = to_set ~env e in
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
            let s = to_set ~env e in
            match IR.as_pure_set s with
            | Some x ->
                let r = fencerel x in
                IR.pure r
            | None -> raise (NormalizationError "fencerel failed"))
        | Domain ->
            let err = "Function `domain` does not produce a relation" in
            raise (NormalizationError err)
        | Range ->
            let err = "Function `range` does not produce a relation" in
            raise (NormalizationError err))
    | Empty -> Union []
    | Var v -> (
        match StringMap.find_opt v env with
        | Some (Left t) -> t
        | _ ->
            let err = Format.sprintf "unsupported rel var: %s" v in
            raise (NormalizationError err))
  in
  go t

module DList = struct
  type 'a t = DList of ('a list -> 'a list)

  let of_list xs = DList (fun ys -> List.append xs ys)
  let empty = of_list []
  let to_list (DList l) = l []
  let append (DList l1) (DList l2) = DList (fun xs -> l1 (l2 xs))
end

let extract_let_bindings (ins : AST.ins list) : (var * AST.exp) list =
  let aux =
    ins
    |> List.fold_left
         (fun l e ->
           let open AST in
           let l' =
             match e with
             | Let (_, xs) ->
                 xs
                 |> List.filter_map (function
                      | _, Pvar (Some v), expr -> Some (v, expr)
                      | _ -> None)
                 |> DList.of_list
             | Rec (_, (_, Pvar (Some v), expr) :: rest, _) ->
                 if List.length rest > 0 then
                   Format.eprintf "Skipping %d Rec bindings@."
                     (List.length rest);
                 DList.of_list [ (v, expr) ]
             | _ ->
                 (* Format.eprintf "Skipping instruction@."; *)
                 DList.empty
           in
           DList.append l l')
         DList.empty
  in
  DList.to_list aux

let parse_core ~(unroll : int) ~(conds : string list)
    (lets : (var * AST.exp) list) : (var * var CoreAST.t) list =
  lets
  |> List.filter_map (fun (v, e) ->
         try
           (* let () = Format.eprintf "Parsing core for %s@." v in *)
           let core = to_core_ast ~unroll ~conds e in
           (* let () = Format.eprintf "Setting core for %s@." v in *)
           Some (v, core)
         with NormalizationError _err ->
           (* Format.eprintf "parse_core (%s): %s@." v err; *)
           None)

let normalize_core (core_bindings : (var * var CoreAST.t) list) :
    (var * ir) list =
  let env : env = StringMap.empty in
  let env =
    builtin_sets
    |> List.fold_left
         (fun env (v, t) -> StringMap.add v (Either.Right (IR.pure_set t)) env)
         env
  in
  let env =
    builtin_rels
    |> List.fold_left
         (fun env (v, t) -> StringMap.add v (Either.Left (IR.pure t)) env)
         env
  in
  let env =
    core_bindings
    |> List.fold_left
         (fun env (v, t) ->
           try
             let s = to_set ~env t in
             (* let () = Format.eprintf "setting %s (set)@." v in *)
             let env = StringMap.add v (Either.Right s) env in
             env
           with NormalizationError err -> (
             (* Format.eprintf "normalize_core(set)(%s): %s@." v err; *)
             try
               let t = to_ir ~env t in
               (* let () = Format.eprintf "setting %s (rel)@." v in *)
               let env = StringMap.add v (Either.Left t) env in
               env
             with NormalizationError err ->
               Format.eprintf "normalize_core(rel)(%s): %s@." v err;
               env))
         env
  in
  env |> StringMap.to_list
  |> List.filter_map (function v, Either.Left t -> Some (v, t) | _ -> None)
