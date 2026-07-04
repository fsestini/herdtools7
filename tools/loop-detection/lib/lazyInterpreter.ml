open Herdlib

module Make
    (Elts : MySet.S)
    (W : WeightedRel.Weight)
    (WR : WeightedRel.S with type elt = Elts.elt and type weight = W.t) : sig
  type t

  val interpret :
    ?lasso_events:Elts.t ->
    events:Elts.t ->
    builtins:WR.t StringMap.t ->
    ?with_overrides:WR.t StringMap.t ->
    AST.ins list ->
    t

  val force_rel : t -> string -> WR.t
  val force_rels : t -> string list -> WR.t StringMap.t
end = struct
  type v = Set of Elts.t | Rel of WR.t | Clo of closure
  and binding = v Lazy.t
  and env = binding StringMap.t
  and closure = { param : string; body : AST.exp; env : env }

  type universes = { events : Elts.t; lasso_events : Elts.t; rel : WR.t }
  type context = { universes : universes; builtins : env; with_overrides : env }
  type state = { env : env }
  type t = { ctx : context; env : env }
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

  let env_of_rels rels = StringMap.map (fun r -> lazy (Rel r)) rels
  let empty_state = { env = StringMap.empty }

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

  let sequence_v v1 v2 =
    match (v1, v2) with
    | Rel r1, Rel r2 -> Rel (WR.sequence r1 r2)
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
    | Clo _ -> failwith "complement expects a set or relation"

  let plus_v = function
    | Rel r -> Rel (WR.transitive_closure_exact r)
    | _ -> failwith "plus expects a relation"

  let star_v universes = function
    | Rel r ->
        Rel
          (WR.union
             (identity_rel universes.events)
             (WR.transitive_closure_exact r))
    | _ -> failwith "star expects a relation"

  let opt_v universes = function
    | Rel r -> Rel (WR.union (identity_rel universes.events) r)
    | _ -> failwith "optional expects a relation"

  let fold_nonempty op name = function
    | [] -> failwith (Format.sprintf "invalid %s" name)
    | v :: vs -> List.fold_left op v vs

  let max_fixpoint_iterations = 1000

  let function_param : AST.pat -> string = function
    | Pvar (Some name) -> name
    | Pvar None -> failwith "function parameters must be named variables"
    | Ptuple _ ->
        failwith "only single-variable function parameters are supported"

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
      | Fun (_, pat, body, _, _) ->
          let param = function_param pat in
          Clo { param; body; env }
      | Var (_, var) -> find_v ctx env var
      | Op (_, Union, exps) ->
          List.map (go env) exps |> fold_nonempty union_v "union"
      | Op (_, Inter, exps) ->
          List.map (go env) exps |> fold_nonempty inter_v "intersection"
      | Op (_, Diff, [ x; y ]) -> diff_v (go env x) (go env y)
      | Op (_, Seq, [ x; y ]) -> sequence_v (go env x) (go env y)
      | Op (_, Cartesian, [ x; y ]) ->
          cartesian_v ctx.universes (go env x) (go env y)
      | Op1 (_, Plus, exp) -> plus_v (go env exp)
      | Op1 (_, Star, exp) -> star_v ctx.universes (go env exp)
      | Op1 (_, Opt, exp) -> opt_v ctx.universes (go env exp)
      | Op1 (_, ToId, exp) -> (
          match go env exp with
          | Set s -> Rel (identity_rel s)
          | Rel _ | Clo _ -> failwith "set restriction expects a set")
      | Op1 (_, Inv, exp) -> inverse_v (go env exp)
      | Op1 (_, Comp, exp) -> complement_v ctx.universes (go env exp)
      | App (_, f, arg) -> (
          match go env f with
          | Clo { param; body; env = closure_env } ->
              let arg = lazy (go env arg) in
              go (StringMap.add param arg closure_env) body
          | Set _ | Rel _ -> failwith "application expects a function")
      | Bind (_, [ (_, Pvar (Some name), rhs) ], body) ->
          let env = eval_let_binding ctx { env } name rhs in
          go env body
      | BindRec (_, [ (_, Pvar (Some name), rhs) ], body) ->
          let env = eval_rec_binding ctx { env } name rhs in
          go env body
      | _ -> failwith "expression not supported"
    in
    go st.env

  and eval_let_binding ctx (st : state) name rhs =
    StringMap.add name (lazy (eval_exp ctx st rhs)) st.env

  and eval_rec_binding ctx (st : state) name rhs =
    let rec_binding =
      lazy
        (let rec fix iteration current =
           if iteration >= max_fixpoint_iterations then
             raise
               (WeightedRel.Unsupported
                  "recursive relation fixpoint did not stabilize");
           let rec_st =
             { env = StringMap.add name (lazy (Rel current)) st.env }
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
         fix 0 WR.empty)
    in
    StringMap.add name rec_binding st.env

  let eval_with_binding ctx (st : state) name =
    let binding =
      match StringMap.find_opt name ctx.with_overrides with
      | Some v -> v
      | None -> (
          match StringMap.find_opt name ctx.builtins with
          | Some v -> v
          | None -> lazy (failwith "with binding not supplied"))
    in
    StringMap.add name binding st.env

  let eval_ins (ctx : context) (st : state) : AST.ins -> state = function
    | Let (_, [ (_, Pvar (Some name), rhs) ]) ->
        { env = eval_let_binding ctx st name rhs }
    | Rec (_, [ (_, Pvar (Some name), rhs) ], None) ->
        { env = eval_rec_binding ctx st name rhs }
    | WithFrom (_, name, _) -> { env = eval_with_binding ctx st name }
    | Test _ | Show _ | ShowAs _ | UnShow _ | Include _ -> st
    | _ -> failwith "instruction not supported"

  let eval_ins_list ctx st ins = List.fold_left (eval_ins ctx) st ins

  let interpret ?(lasso_events = Elts.empty) ~events ~builtins
      ?(with_overrides = StringMap.empty) inss =
    let universes = universes_of_events ~lasso_events events in
    let builtins = env_of_rels builtins in
    let with_overrides = env_of_rels with_overrides in
    let ctx = { universes; builtins; with_overrides } in
    let st = eval_ins_list ctx empty_state inss in
    { ctx; env = st.env }

  let force_rel t name =
    match find_v t.ctx t.env name with
    | Rel r -> r
    | Set _ | Clo _ -> failwith "relation expected"

  let force_rels t names =
    List.fold_left
      (fun env name -> StringMap.add name (force_rel t name) env)
      StringMap.empty names
end
