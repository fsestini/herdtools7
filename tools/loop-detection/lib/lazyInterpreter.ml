open Herdlib
module Extract = TxtLoc.Extract ()

module Make
    (Elts : MySet.S)
    (W : Weight.S)
    (WR : WeightedRel.S with type elt = Elts.elt and type weight = W.t) : sig
  type t

  val interpret :
    ?lasso_events:Elts.t ->
    events:Elts.t ->
    builtins:WR.t StringMap.t ->
    ?set_builtins:Elts.t StringMap.t ->
    ?with_overrides:WR.t StringMap.t ->
    AST.ins list ->
    t

  val force_rel : t -> string -> WR.t
  val force_rels : t -> string list -> WR.t StringMap.t
  val check_failures : t -> string list
end = struct
  type v = Set of Elts.t | Rel of WR.t | Clo of closure | Tup of v list
  and binding = v Lazy.t
  and env = binding StringMap.t
  and closure = { param : AST.pat; body : AST.exp; env : env }

  type universes = { events : Elts.t; lasso_events : Elts.t; rel : WR.t }
  type context = { universes : universes; builtins : env; with_overrides : env }
  type state = { env : env; check_failures : string list }
  type t = { ctx : context; env : env; check_failures : string list }
  type event_kind = Finite | Lasso

  let event_kind lasso_events ev =
    if Elts.mem ev lasso_events then Lasso else Finite

  let all_offsets lasso_events src dst =
    match (event_kind lasso_events src, event_kind lasso_events dst) with
    | Finite, Finite -> W.singleton 0
    | Finite, Lasso -> W.at_least 1
    | Lasso, Finite -> W.at_most (-1)
    | Lasso, Lasso -> W.top

  let cartesian_rel ~lasso_events srcs dsts =
    Elts.fold
      (fun src acc ->
        Elts.fold
          (fun dst acc ->
            WR.add (src, dst, all_offsets lasso_events src dst) acc)
          dsts acc)
      srcs WR.empty

  let identity_rel events =
    Elts.fold (fun ev -> WR.add (ev, ev, W.singleton 0)) events WR.empty

  let universes_of_events ~lasso_events events =
    if not (Elts.subset lasso_events events) then
      invalid_arg
        "universes_of_events: lasso events must be included in all events";
    let rel = cartesian_rel ~lasso_events events events in
    { events; lasso_events; rel }

  let add_env_binding name binding env = StringMap.add name binding env

  let env_of_builtins sets rels =
    let env = StringMap.map (fun s -> lazy (Set s)) sets in
    StringMap.fold
      (fun name rel -> add_env_binding name (lazy (Rel rel)))
      rels env

  let empty_state = { env = StringMap.empty; check_failures = [] }

  let union_v v1 v2 =
    match (v1, v2) with
    | Set s1, Set s2 -> Set (Elts.union s1 s2)
    | Rel r1, Rel r2 -> Rel (WR.union r1 r2)
    | _ -> failwith "union_v: type mismatch"

  let inter_v v1 v2 =
    match (v1, v2) with
    | Set s1, Set s2 -> Set (Elts.inter s1 s2)
    | Rel r1, Rel r2 -> Rel (WR.intersection r1 r2)
    | _ -> failwith "inter_v: type mismatch"

  let normalize_rel universes rel = WR.intersection rel universes.rel

  let sequence_rel universes r1 r2 =
    normalize_rel universes (WR.sequence r1 r2)

  let sequence_v universes v1 v2 =
    match (v1, v2) with
    | Rel r1, Rel r2 -> Rel (sequence_rel universes r1 r2)
    | _ -> failwith "sequence_v: type mismatch"

  let diff_v v1 v2 =
    match (v1, v2) with
    | Set s1, Set s2 -> Set (Elts.diff s1 s2)
    | Rel r1, Rel r2 -> Rel (WR.diff r1 r2)
    | _ -> failwith "diff_v: type mismatch"

  let cartesian_v universes v1 v2 =
    match (v1, v2) with
    | Set s1, Set s2 ->
        Rel (cartesian_rel ~lasso_events:universes.lasso_events s1 s2)
    | _ -> failwith "cartesian_v: type mismatch"

  let inverse_v = function
    | Rel r -> Rel (WR.inverse r)
    | _ -> failwith "inverse_v: type mismatch"

  let complement_v universes = function
    | Set s -> Set (Elts.diff universes.events s)
    | Rel r -> Rel (WR.diff universes.rel r)
    | Clo _ | Tup _ -> failwith "complement expects a set or relation"

  let max_fixpoint_iterations = 10

  let transitive_closure_exact universes rel =
    let rec loop iteration current =
      if iteration >= max_fixpoint_iterations then
        raise
          (WeightedRel.Unsupported
             "weighted relation transitive closure did not stabilize");
      let candidate =
        WR.union current (sequence_rel universes current current)
      in
      let next = normalize_rel universes candidate in
      if WR.equal current next then current else loop (iteration + 1) next
    in
    loop 0 (normalize_rel universes rel)

  let plus_v universes = function
    | Rel r -> Rel (transitive_closure_exact universes r)
    | _ -> failwith "plus expects a relation"

  let star_v universes = function
    | Rel r ->
        Rel
          (WR.union
             (identity_rel universes.events)
             (transitive_closure_exact universes r))
    | _ -> failwith "star expects a relation"

  let opt_v universes = function
    | Rel r -> Rel (WR.union (identity_rel universes.events) r)
    | _ -> failwith "optional expects a relation"

  let fold_nonempty op name = function
    | [] -> failwith (Format.sprintf "invalid %s" name)
    | v :: vs -> List.fold_left op v vs

  let rel_is_empty rel = WR.fold (fun _ _ -> false) rel true

  let elt_equal x y = Elts.equal (Elts.singleton x) (Elts.singleton y)

  let weight_contains_zero w =
    not (W.is_empty (W.intersection w (W.singleton 0)))

  let rel_has_zero_self_edge rel =
    WR.fold
      (fun (src, dst, w) found ->
        found || (elt_equal src dst && weight_contains_zero w))
      rel false

  let v_is_empty = function
    | Set s -> Elts.is_empty s
    | Rel r -> rel_is_empty r
    | Clo _ | Tup _ -> false

  let fold_exps_short op name go env = function
    | [] -> failwith (Format.sprintf "invalid %s" name)
    | exp :: exps ->
        let rec loop acc = function
          | [] -> acc
          | _ when v_is_empty acc -> acc
          | exp :: exps -> loop (op acc (go env exp)) exps
        in
        loop (go env exp) exps

  let unsupported_in_binding name f =
    try f ()
    with WeightedRel.Unsupported msg ->
      raise
        (WeightedRel.Unsupported
           (Format.sprintf "%s\nwhile evaluating cat binding %s" msg name))

  let bind_pat0 name v env =
    match name with None -> env | Some name -> StringMap.add name (lazy v) env

  let bind_pat (pat : AST.pat) v env =
    match (pat, v) with
    | AST.Pvar name, v -> bind_pat0 name v env
    | AST.Ptuple names, Tup vs ->
        List.fold_left2 (fun env name v -> bind_pat0 name v env) env names vs
    | AST.Ptuple _, _ -> failwith "function argument mismatch"

  let find_v ctx env var =
    match StringMap.find_opt var env with
    | Some v -> Lazy.force v
    | None -> (
        match StringMap.find_opt var ctx.builtins with
        | Some v -> Lazy.force v
        | None ->
            let msg = Format.sprintf "Identifier not in scope: %s" var in
            failwith msg)

  let rec eval_exp (ctx : context) (st : state) : AST.exp -> v =
    let rec go (env : env) : AST.exp -> v = function
      | Konst (_, AST.Empty kind) -> (
          match kind with AST.SET -> Set Elts.empty | AST.RLN -> Rel WR.empty)
      | Konst (_, AST.Universe kind) -> (
          match kind with
          | AST.SET -> Set ctx.universes.events
          | AST.RLN -> Rel ctx.universes.rel)
      | Fun (_, pat, body, _, _) -> Clo { param = pat; body; env }
      | Var (_, var) -> find_v ctx env var
      | Op (_, Union, exps) ->
          List.map (go env) exps |> fold_nonempty union_v "union"
      | Op (_, Inter, exps) ->
          fold_exps_short inter_v "intersection" go env exps
      | Op (_, Diff, [ x; y ]) -> diff_v (go env x) (go env y)
      | Op (_, Seq, exps) ->
          fold_exps_short (sequence_v ctx.universes) "sequence" go env exps
      | Op (_, Cartesian, [ x; y ]) ->
          cartesian_v ctx.universes (go env x) (go env y)
      | Op (_, Tuple, exps) -> Tup (List.map (go env) exps)
      | Op1 (_, Plus, exp) -> plus_v ctx.universes (go env exp)
      | Op1 (_, Star, exp) -> star_v ctx.universes (go env exp)
      | Op1 (_, Opt, exp) -> opt_v ctx.universes (go env exp)
      | Op1 (_, ToId, exp) -> (
          match go env exp with
          | Set s -> Rel (identity_rel s)
          | Rel _ | Clo _ | Tup _ -> failwith "set restriction expects a set")
      | Op1 (_, Inv, exp) -> inverse_v (go env exp)
      | Op1 (_, Comp, exp) -> (
          try complement_v ctx.universes (go env exp)
          with WeightedRel.Unsupported msg ->
            let loc = ASTUtils.exp2loc exp in
            let exp_str = Extract.extract loc in
            raise
              (WeightedRel.Unsupported
                 (Format.sprintf "%s\nwhile evaluating cat complement ~%s" msg
                    exp_str)))
      | App (_, Var (_, "range"), arg) -> (
          match go env arg with
          | Rel r ->
              let s =
                WR.fold (fun (_, dst, _) acc -> Elts.add dst acc) r Elts.empty
              in
              Set s
          | _ -> failwith "range expects a relation")
      | App (_, Var (_, "domain"), arg) -> (
          match go env arg with
          | Rel r ->
              let s =
                WR.fold (fun (src, _, _) acc -> Elts.add src acc) r Elts.empty
              in
              Set s
          | _ -> failwith "domain expects a relation")
      | App (_, f, arg) -> (
          match go env f with
          | Clo { param; body; env = closure_env } ->
              let env = bind_pat param (go env arg) closure_env in
              go env body
          | Set _ | Rel _ | Tup _ -> failwith "application expects a function")
      | Try (_, x, y) -> ( try go env x with _ -> go env y)
      | If (_, cond, x, y) -> if eval_cond cond then go env x else go env y
      | ExplicitSet (_, []) -> Set Elts.empty
      | Bind (_, [ (_, AST.Pvar (Some name), rhs) ], body) ->
          let env = eval_let_binding ctx { st with env } name rhs in
          go env body
      | BindRec (_, [ (_, AST.Pvar (Some name), rhs) ], body) ->
          let env = eval_rec_binding ctx { st with env } name rhs in
          go env body
      | exp ->
          let loc = ASTUtils.exp2loc exp in
          let exp_str = Extract.extract loc in
          let msg = Format.sprintf "expression not supported: %s" exp_str in
          failwith msg
    in
    go st.env

  and eval_cond : AST.cond -> bool = function
    | AST.VariantCond cond -> eval_variant_cond cond
    | AST.Eq _ | AST.Subset _ | AST.In _ -> failwith "condition not supported"

  and eval_variant_cond = function
    | AST.Variant _ -> false
    | OpNot cond -> not (eval_variant_cond cond)
    | OpAnd (c1, c2) -> eval_variant_cond c1 && eval_variant_cond c2
    | OpOr (c1, c2) -> eval_variant_cond c1 || eval_variant_cond c2

  and eval_irreflexive_check ctx st test exp =
    let check () =
      match eval_exp ctx st exp with
      | Rel r -> not (rel_has_zero_self_edge r)
      | Set _ | Clo _ | Tup _ -> failwith "irreflexive expects a relation"
    in
    match test with
    | AST.Yes AST.Irreflexive -> Some (check ())
    | AST.No AST.Irreflexive -> Some (not (check ()))
    | AST.Yes (AST.Acyclic | AST.TestEmpty)
    | AST.No (AST.Acyclic | AST.TestEmpty) ->
        None

  and eval_let_binding ctx (st : state) name rhs =
    StringMap.add name
      (lazy (unsupported_in_binding name (fun () -> eval_exp ctx st rhs)))
      st.env

  and eval_let_bindings ctx (st : state) bds =
    List.fold_left
      (fun env -> function
        | _, AST.Pvar (Some name), rhs ->
            StringMap.add name
              (lazy
                (unsupported_in_binding name (fun () -> eval_exp ctx st rhs)))
              env
        | _ -> failwith "let binding not supported")
      st.env bds

  and eval_rec_binding ctx (st : state) name rhs =
    let rec_binding =
      lazy
        (unsupported_in_binding name (fun () ->
             let rec fix iteration current =
               if iteration >= max_fixpoint_iterations then
                 raise
                   (WeightedRel.Unsupported
                      "recursive relation fixpoint did not stabilize");
               let rec_st =
                 { st with
                   env = StringMap.add name (lazy (Rel current)) st.env
                 }
               in
               let next =
                 match eval_exp ctx rec_st rhs with
                 | Rel r -> r
                 | _ -> failwith "recursive definitions must be relation-valued"
               in
               let widened = next in
               if WR.equal current widened then Rel current
               else fix (iteration + 1) widened
             in
             fix 0 WR.empty))
    in
    StringMap.add name rec_binding st.env

  let eval_with_binding ctx (st : state) name =
    let binding =
      match StringMap.find_opt name ctx.with_overrides with
      | Some v -> v
      | None -> (
          match StringMap.find_opt name ctx.builtins with
          | Some v -> v
          | None ->
              lazy
                (unsupported_in_binding name (fun () ->
                     failwith "with binding not supplied")))
    in
    StringMap.add name binding st.env

  let eval_ins (ctx : context) (st : state) : AST.ins -> state = function
    | Let (_, bds) -> { st with env = eval_let_bindings ctx st bds }
    | Rec (_, [ (_, AST.Pvar (Some name), rhs) ], None) ->
        { st with env = eval_rec_binding ctx st name rhs }
    | WithFrom (_, name, _) -> { st with env = eval_with_binding ctx st name }
    | Test ((_, _, test, exp, name), AST.Check) -> (
        match eval_irreflexive_check ctx st test exp with
        | None | Some true -> st
        | Some false ->
            let name = Option.value name ~default:"<unnamed>" in
            { st with check_failures = name :: st.check_failures })
    | Test _ | Show _ | ShowAs _ | UnShow _ | Include _ | Procedure _ | Call _
    | Debug _ | Forall _ | Enum _ | InsMatch _ | Events _ | IfVariant _ ->
        st
    | _ -> failwith "instruction not supported"

  let eval_ins_list ctx st ins = List.fold_left (eval_ins ctx) st ins

  let interpret ?(lasso_events = Elts.empty) ~events ~builtins
      ?(set_builtins = StringMap.empty) ?(with_overrides = StringMap.empty) inss
      =
    let universes = universes_of_events ~lasso_events events in
    let builtins = env_of_builtins set_builtins builtins in
    let with_overrides = env_of_builtins StringMap.empty with_overrides in
    let ctx = { universes; builtins; with_overrides } in
    let st = eval_ins_list ctx empty_state inss in
    { ctx; env = st.env; check_failures = List.rev st.check_failures }

  let force_rel t name =
    match find_v t.ctx t.env name with
    | Rel r -> r
    | Set _ | Clo _ | Tup _ -> failwith "relation expected"

  let force_rels t names =
    List.fold_left
      (fun env name -> StringMap.add name (force_rel t name) env)
      StringMap.empty names

  let check_failures t = t.check_failures
end
