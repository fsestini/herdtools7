module Log = (val Logs.src_log (Logs.Src.create "analysis") : Logs.LOG)
module Var = Graph.Id
module Node = Graph.Node

type var = Graph.var
type def_id = Graph.def_id

module MakeForward (D : AbstractDomain.Forward) = struct
  module Lat = struct
    type t = D.t

    let bottom = D.bottom
    let join = D.join
    let equal = D.equal
    let pp = D.pp
  end

  module Fw = Fixpoint.MakeForward (Var) (Lat)

  let fw_rhs (g : Graph.t) (sol : Graph.var -> D.t) (v : Graph.var) : D.t =
    match Graph.get_node g v with
    | Node.Def { rhs; _ } -> sol rhs
    | Node.Expr { expr; children } -> (
        let open AST in
        match (expr, children) with
        | Var (_, s), [] -> begin
            match D.builtin s with Some x -> x | None -> D.top
          end
        | Var _, [ did ] -> sol did
        | Try _, [ c1; c2 ] -> D.try_f (sol c1) (sol c2)
        | If _, [ c1; c2 ] -> D.if_f (sol c1) (sol c2)
        | Op1 (_loc, op, _), [ c ] -> D.op1_f op (sol c)
        | Op (_loc, op, _), cs -> D.op2_f op (List.map sol cs)
        | Konst (_, k), [] -> D.konst_f k
        | Tag (_, tag), [] -> D.tag_f tag
        | App (_, Var (_, func), _), [ _func_id; arg_id ] ->
            D.app_f ~func ~arg_t:(sol arg_id)
        | App _, [ _func_id; _arg_id ] -> D.top
        | ExplicitSet _, cs -> D.explicit_set_f (List.map sol cs)
        (* The cat models currently exercised by catcheck use MatchSet, not
           normal tag Match expressions, so keeping this unsupported for now. *)
        | Match _, _ -> D.top
        | MatchSet _, [ scrutinee; empty_case; nonempty_case ] ->
            D.match_set_f ~scrutinee:(sol scrutinee)
              ~empty_case:(sol empty_case) ~nonempty_case:(sol nonempty_case)
        | (Bind _ | BindRec _ | Fun _), _ -> D.top
        | _ -> invalid_arg "malformed graph expression node")

  let forward (g : Graph.t) : Graph.var -> D.t =
    let vars = Graph.all_vars g in
    let deps v = Graph.dependents g v in
    Fw.solve ~vars ~deps ~rhs:(fw_rhs g) ~init:(fun _ -> D.bottom)
end

module MakeSplit (FwD : AbstractDomain.Forward) (BwD : AbstractDomain.Backward) =
struct
  module FwAnalysis = MakeForward (FwD)

  let forward = FwAnalysis.forward

  module BwLat = struct
    type t = BwD.t

    let bottom = BwD.bottom
    let join = BwD.join
    let equal = BwD.equal
    let pp = BwD.pp
  end

  module Bw = Fixpoint.MakeBackward (Var) (BwLat)

  (* ---------------- Backward (demand) analysis ---------------- *)

  (* Propagate demand "downward" (from parent to children) in the syntax tree. *)
  let bw_step ~(g : Graph.t) ~(fw_to_bw : FwD.t -> BwD.t)
      ~(fw_map : var -> FwD.t) (c : var -> BwD.t) (v : var) : (var * BwD.t) list
      =
    let fw_map child = fw_to_bw (fw_map child) in
    match Graph.get_node g v with
    | Node.Def { rhs; _ } -> [ (rhs, c v) ]
    | Node.Expr { expr; children } -> (
        let open AST in
        match (expr, children) with
        | Var _, [] -> []
        | Var _, [ did ] -> [ (did, c v) ]
        | Try _, [ c1; c2 ] ->
            let parent = c v in
            let lchild_fw = fw_map c1 in
            let rchild_fw = fw_map c2 in
            let l_bw, r_bw = BwD.try_b ~parent ~lchild_fw ~rchild_fw in
            [ (c1, l_bw); (c2, r_bw) ]
        | If _, [ c1; c2 ] ->
            let parent = c v in
            let lchild_fw = fw_map c1 in
            let rchild_fw = fw_map c2 in
            let l_bw, r_bw = BwD.if_b ~parent ~lchild_fw ~rchild_fw in
            [ (c1, l_bw); (c2, r_bw) ]
        | Op1 (_, op, _), [ child ] ->
            let parent_d = c v in
            let child_f = fw_map child in
            [ (child, BwD.op1_b op ~parent:parent_d ~child_f) ]
        | Op (_, op, _), children ->
            let parent_d = c v in
            let children_f = List.map fw_map children in
            let ds = BwD.op2_b op ~parent:parent_d ~children_f in
            List.map2 (fun ch d -> (ch, d)) children ds
        (* TODO: shouldn't implement backward rules for these constructors? *)
        | ( ( Konst _ | Tag _ | App _ | Bind _ | BindRec _ | Fun _
            | ExplicitSet _ | Match _ | MatchSet _ ),
            _ ) ->
            []
        | _ -> invalid_arg "malformed graph expression node")

  (* Backward roots: definitions that should be treated as "publicly exported". *)
  let backward ~(g : Graph.t) ~(fw_to_bw : FwD.t -> BwD.t)
      ~(fw_map : var -> FwD.t) (roots : def_id list) : var -> BwD.t =
    let vars = Graph.all_vars g in
    let seeds =
      List.map
        (fun did ->
          let vd = fw_to_bw (fw_map did) in
          (did, vd))
        roots
    in
    Bw.solve ~vars ~step:(bw_step ~g ~fw_to_bw ~fw_map) ~seeds

  type analysis_result = {
    graph : Graph.t;
    fw_map : var -> FwD.t;
    bw_map : var -> BwD.t;
  }

  let solve_all ~(fw_to_bw : FwD.t -> BwD.t) (stmts : Cat.binding list) :
      analysis_result =
    Log.debug (fun m -> m "solve_all");

    let g = Graph.build stmts in
    (* Log.debug (fun m -> m "%a" pp_graph (dm, nm)); *)
    let fw_map = forward g in

    (* debug_analysis ~name:"Forward analysis" ~vars ~dm ~nm fw_map; *)
    let roots = Graph.all_toplevel_defs g in
    let bw_map = backward ~g ~fw_to_bw ~fw_map roots in

    (* debug_analysis ~name:"Backward analysis" ~vars ~dm ~nm bw_map; *)
    (* debug_analysis ~name:"Full analysis" ~vars ~dm ~nm (fun v -> *)
    (*     D.meet (fw_map v) (bw_map v)); *)
    { graph = g; fw_map; bw_map }
end
