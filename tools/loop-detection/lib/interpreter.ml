open Herdlib
module Extract = TxtLoc.Extract ()

module Make
    (Elts : MySet.S)
    (W : Weight.S)
    (WR : WeightedRel.S with type elt = Elts.elt and type weight = W.t) : sig
  type env := WR.t StringMap.t

  val interpret :
    ?lasso_events:Elts.t -> events:Elts.t -> builtins:env -> AST.ins list -> env
end = struct
  type v = Set of Elts.t | Rel of WR.t | Clo of closure
  and closure = { param : string; body : AST.exp; env : v StringMap.t }

  type env = v StringMap.t
  type universes = { events : Elts.t; lasso_events : Elts.t; rel : WR.t }
  type context = { universes : universes; builtins : env }
  type state = { env : env }
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

  let context universes builtins = { universes; builtins }
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

  let inverse_v v =
    match v with
    | Rel r -> Rel (WR.inverse r)
    | _ -> failwith "inverse_v: type mismatch"

  let complement_v universes = function
    | Set s -> Set (Elts.diff universes.events s)
    | Rel r -> Rel (WR.diff universes.rel r)
    | Clo _ -> failwith "complement expects a set or relation"

  let max_fixpoint_iterations = 1000

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

  let function_param : AST.pat -> string = function
    | Pvar (Some name) -> name
    | Pvar None -> failwith "function parameters must be named variables"
    | Ptuple _ ->
        failwith "only single-variable function parameters are supported"

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
      | Var (_, var) -> (
          match StringMap.find_opt var env with
          | Some v -> v
          | None -> (
              match StringMap.find_opt var ctx.builtins with
              | Some v -> v
              | None ->
                  let msg = Format.sprintf "Identifier not in scope: %s" var in
                  failwith msg))
      | Op (_, Union, exps) ->
          List.map (go env) exps |> fold_nonempty union_v "union"
      | Op (_, Inter, exps) ->
          List.map (go env) exps |> fold_nonempty inter_v "intersection"
      | Op (_, Diff, [ x; y ]) -> diff_v (go env x) (go env y)
      | Op (_, Seq, [ x; y ]) -> sequence_v ctx.universes (go env x) (go env y)
      | Op (_, Cartesian, [ x; y ]) ->
          cartesian_v ctx.universes (go env x) (go env y)
      | Op1 (_, Plus, exp) -> plus_v ctx.universes (go env exp)
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
              let arg = go env arg in
              go (StringMap.add param arg closure_env) body
          | Set _ | Rel _ -> failwith "application expects a function")
      | Bind (_, [ (_, Pvar (Some name), _) ], body) ->
          let env = eval_let_binding ctx { env } name body in
          go env body
      | BindRec (_, [ (_, Pvar (Some name), _) ], body) ->
          let env = eval_rec_binding ctx { env } name body in
          go env body
      | exp ->
          let loc = ASTUtils.exp2loc exp in
          let exp_str = Extract.extract loc in
          let msg = Format.sprintf "expression not supported: %s" exp_str in
          failwith msg
    in
    go st.env

  and eval_let_binding ctx st name rhs =
    let v = eval_exp ctx st rhs in
    StringMap.add name v st.env

  and eval_rec_binding ctx st name rhs =
    let rec fix iteration current =
      if iteration >= max_fixpoint_iterations then
        raise
          (WeightedRel.Unsupported
             "recursive relation fixpoint did not stabilize");
      let rec_st = { env = StringMap.add name (Rel current) st.env } in
      let next =
        match eval_exp ctx rec_st rhs with
        | Rel r -> r
        | _ -> failwith "recursive definitions must be relation-valued"
      in
      if WR.equal current next then StringMap.add name (Rel current) st.env
      else fix (iteration + 1) next
    in
    fix 0 WR.empty

  let unsupported_ins ins =
    let loc = ASTUtils.ins2loc ins in
    let ins_str = Extract.extract loc in
    let msg = Format.sprintf "instruction not supported: %s" ins_str in
    failwith msg

  let eval_ins (ctx : context) (st : state) : AST.ins -> state = function
    | Let (_, [ (_, Pvar (Some name), rhs) ]) ->
        { env = eval_let_binding ctx st name rhs }
    | Rec (_, [ (_, Pvar (Some name), rhs) ], None) ->
        { env = eval_rec_binding ctx st name rhs }
    | ins -> unsupported_ins ins

  let eval_ins_list ctx st ins = List.fold_left (eval_ins ctx) st ins

  let interpret ?(lasso_events = Elts.empty) ~events ~builtins inss =
    let universes = universes_of_events ~lasso_events events in
    let builtins = builtins |> StringMap.map (fun r -> Rel r) in
    let ctx = context universes builtins in
    let st = eval_ins_list ctx empty_state inss in
    st.env
    |> StringMap.filter_map (fun _ x ->
        match x with Rel r -> Some r | _ -> None)
end
