open Herdlib
module Extract = TxtLoc.Extract ()

module Make
    (Elts : MySet.S)
    (W : WeightedRel.Weight)
    (WR : WeightedRel.S with type elt = Elts.elt and type weight = W.t) : sig
  type env := WR.t StringMap.t

  val interpret : events:Elts.t -> builtins:env -> AST.ins list -> env
end = struct
  type v = Set of Elts.t | Rel of WR.t | Clo of closure
  and closure = { param : string; body : AST.exp; env : v StringMap.t }

  type env = v StringMap.t
  type universes = { events : Elts.t; rel : WR.t }
  type context = { universes : universes; builtins : env }
  type state = { env : env }

  let universes_of_events _events =
    (* TODO: this needs to take lasso events into consideration *)
    failwith "NIY"
  (* let event_list = Elts.elements events in *)
  (* { events; rel = WR.cartesian event_list event_list W.top } *)

  let context universes builtins = { universes; builtins }
  let empty_state = { env = StringMap.empty }

  let union_v v1 v2 =
    match (v1, v2) with
    | Set s1, Set s2 -> Set (Elts.union s1 s2)
    | Rel r1, Rel r2 -> Rel (WR.union r1 r2)
    | Set _, Rel _ | Rel _, Set _ ->
        failwith "mixing sets and relations in union"
    | Clo _, _ | _, Clo _ -> failwith "union expects sets or relations"

  let inter_v v1 v2 =
    match (v1, v2) with
    | Set s1, Set s2 -> Set (Elts.inter s1 s2)
    | Rel r1, Rel r2 -> Rel (WR.intersection r1 r2)
    | Set _, Rel _ | Rel _, Set _ ->
        failwith "mixing sets and relations in intersection"
    | Clo _, _ | _, Clo _ -> failwith "intersection expects sets or relations"

  let sequence_v v1 v2 =
    match (v1, v2) with
    | Rel r1, Rel r2 -> Rel (WR.sequence r1 r2)
    | Set _, Set _ | Set _, Rel _ | Rel _, Set _ ->
        failwith "sequence expects relations"
    | Clo _, _ | _, Clo _ -> failwith "sequence expects relations"

  let diff_v v1 v2 =
    match (v1, v2) with
    | Set s1, Set s2 -> Set (Elts.diff s1 s2)
    | Rel r1, Rel r2 -> Rel (WR.diff r1 r2)
    | Set _, Rel _ | Rel _, Set _ ->
        failwith "mixing sets and relations in difference"
    | Clo _, _ | _, Clo _ -> failwith "difference expects sets or relations"

  let cartesian_v v1 v2 =
    match (v1, v2) with
    | Set _s1, Set _s2 ->
        (* TODO: this needs to take lasso events into consideration *)
        failwith "NIY"
        (* Rel (WR.cartesian (Elts.elements s1) (Elts.elements s2) W.top) *)
    | Rel _, Rel _ | Set _, Rel _ | Rel _, Set _ ->
        failwith "cartesian product expects sets"
    | Clo _, _ | _, Clo _ -> failwith "cartesian product expects sets"

  let inverse_v v =
    match v with
    | Rel r -> Rel (WR.inverse r)
    | Set _ -> failwith "inverse expects a relation"
    | Clo _ -> failwith "inverse expects a relation"

  let complement_v universes = function
    | Set s -> Set (Elts.diff universes.events s)
    | Rel r -> Rel (WR.diff universes.rel r)
    | Clo _ -> failwith "complement expects a set or relation"

  let fold_nonempty op name = function
    | [] -> failwith (Format.sprintf "invalid %s" name)
    | v :: vs -> List.fold_left op v vs

  let max_fixpoint_iterations = 1000

  let function_param : AST.pat -> string = function
    | Pvar (Some name) -> name
    | Pvar None -> failwith "function parameters must be named variables"
    | Ptuple _ ->
        failwith "only single-variable function parameters are supported"

  let rec recursive_rhs_allowed : AST.exp -> bool = function
    | App _ | Fun _ | Bind _ | BindRec _ -> false
    | Op (_, Diff, _) | Op1 (_, Comp, _) -> false
    | Op (_, _, exps) | ExplicitSet (_, exps) ->
        List.for_all recursive_rhs_allowed exps
    | Op1 (_, _, exp) -> recursive_rhs_allowed exp
    | Match (_, exp, clauses, default) -> (
        recursive_rhs_allowed exp
        && List.for_all (fun (_, exp) -> recursive_rhs_allowed exp) clauses
        &&
        match default with
        | None -> true
        | Some exp -> recursive_rhs_allowed exp)
    | MatchSet (_, exp1, exp2, clause) ->
        let clause_exp =
          match clause with
          | EltRem (_, _, exp) | PreEltPost (_, _, _, exp) -> exp
        in
        recursive_rhs_allowed exp1 && recursive_rhs_allowed exp2
        && recursive_rhs_allowed clause_exp
    | Try (_, exp1, exp2) ->
        recursive_rhs_allowed exp1 && recursive_rhs_allowed exp2
    | If (_, cond, exp1, exp2) ->
        recursive_cond_allowed cond
        && recursive_rhs_allowed exp1 && recursive_rhs_allowed exp2
    | Konst _ | Tag _ | Var _ -> true

  and recursive_cond_allowed = function
    | Eq (exp1, exp2) | Subset (exp1, exp2) | In (exp1, exp2) ->
        recursive_rhs_allowed exp1 && recursive_rhs_allowed exp2
    | VariantCond _ -> true

  (* let lmrs = [W]; ((po & same-loc) & ~(intervening(W,(po & same-loc)))); [R] *)
  (* let intervening(S,r) = r; [S]; r *)

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
      | Op (_, Diff, exps) -> (
          match exps with
          | [ x; y ] -> diff_v (go env x) (go env y)
          | _ -> failwith "invalid difference")
      | Op (_, Seq, exps) -> (
          match exps with
          | [ x; y ] -> sequence_v (go env x) (go env y)
          | _ -> failwith "invalid sequence")
      | Op (_, Cartesian, exps) -> (
          match exps with
          | [ x; y ] -> cartesian_v (go env x) (go env y)
          | _ -> failwith "Invalid cartesian product")
      | Op1 (_, ToId, exp) ->
          let v = go env exp in
          inter_v (cartesian_v v v) (StringMap.find "id" ctx.builtins)
      | Op1 (_, Inv, exp) -> inverse_v (go env exp)
      | Op1 (_, Comp, exp) -> complement_v ctx.universes (go env exp)
      | App (_, f, arg) -> (
          match go env f with
          | Clo { param; body; env = closure_env } ->
              let arg = go env arg in
              go (StringMap.add param arg closure_env) body
          | Set _ | Rel _ -> failwith "application expects a function")
      | Bind (_, [ ((_, Pvar (Some _), _) as binding) ], body) ->
          let env = eval_let_binding ctx { env } binding in
          go env body
      | BindRec (_, [ ((_, Pvar (Some _), _) as binding) ], body) ->
          let env = eval_rec_binding ctx { env } binding in
          go env body
      | exp ->
          let loc = ASTUtils.exp2loc exp in
          let exp_str = Extract.extract loc in
          let msg = Format.sprintf "expression not supported: %s" exp_str in
          failwith msg
    in
    go st.env

  and eval_let_binding ctx st (_, pat, rhs) =
    let name =
      match pat with
      | Pvar (Some name) -> name
      | Pvar None | Ptuple _ -> invalid_arg "unsupported let binding"
    in
    let v = eval_exp ctx st rhs in
    StringMap.add name v st.env

  and eval_rec_binding ctx st (_, pat, rhs) =
    let name =
      match pat with
      | Pvar (Some name) -> name
      | Pvar None | Ptuple _ -> invalid_arg "unsupported let rec binding"
    in
    if not (recursive_rhs_allowed rhs) then
      failwith "recursive definitions must be monotone relation expressions";
    let rec fix iteration current =
      if iteration >= max_fixpoint_iterations then
        failwith "recursive relation fixpoint did not stabilize";
      let rec_st = { env = StringMap.add name (Rel current) st.env } in
      let next =
        match eval_exp ctx rec_st rhs with
        | Rel r -> r
        | Set _ -> failwith "recursive definitions must be relation-valued"
        | Clo _ -> failwith "recursive functions are not supported"
      in
      let widened = WR.widen current next in
      if WR.equal current widened then StringMap.add name (Rel current) st.env
      else fix (iteration + 1) widened
    in
    fix 0 WR.empty

  let unsupported_ins ins =
    let loc = ASTUtils.ins2loc ins in
    let ins_str = Extract.extract loc in
    let msg = Format.sprintf "instruction not supported: %s" ins_str in
    failwith msg

  let eval_ins (ctx : context) (st : state) : AST.ins -> state = function
    | Let (_, [ ((_, Pvar (Some _), _) as binding) ]) ->
        { env = eval_let_binding ctx st binding }
    | Rec (_, [ ((_, Pvar (Some _), _) as binding) ], None) ->
        { env = eval_rec_binding ctx st binding }
    | ins -> unsupported_ins ins

  let eval_ins_list ctx st ins = List.fold_left (eval_ins ctx) st ins

  let interpret ~events ~builtins inss =
    let universes = universes_of_events events in
    let builtins = builtins |> StringMap.map (fun r -> Rel r) in
    let ctx = context universes builtins in
    let st = eval_ins_list ctx empty_state inss in
    st.env
    |> StringMap.filter_map (fun _ x ->
        match x with Rel r -> Some r | _ -> None)
end
