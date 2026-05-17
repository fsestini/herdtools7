module Log = (val Logs.src_log (Logs.Src.create "analysis") : Logs.LOG)
module Var = Graph.Var
module Node = Graph.Node

type var = Graph.var
type def_id = Graph.def_id

let find_id (g : Graph.t) (v : Graph.var) :
    (Graph.node_id, Graph.node * AST.exp) Either.t =
  match Graph.get_node_opt g v with
  | Some (Graph.Node.Def { rhs; _ }) -> Either.Left rhs
  | Some (Graph.Node.Expr { expr; _ } as node) -> Either.Right (node, expr)
  | None -> raise Not_found

let invalid_graph_node () = invalid_arg "malformed graph expression node"

module Make (D : AbstractDomain.S) = struct
  module Lat = struct
    type t = D.t

    let bottom = D.bottom
    let join = D.join
    let equal = D.equal
    let pp = D.pp
  end

  module Fw = Fixpoint.MakeForward (Var) (Lat)
  module Bw = Fixpoint.MakeBackward (Var) (Lat)

  (* type fw_env = { dm : def_map; nm : node_map; deps : var -> var list } *)

  (* let fw_rhs (env : fw_env) (sol : var -> D.t) (v : var) : D.t = *)
  let fw_rhs (g : Graph.t) (sol : Graph.var -> D.t) (v : Graph.var) : D.t =
    match find_id g v with
    | Either.Left rhs -> sol rhs
    | Either.Right (node, expr) -> (
        let open AST in
        match (expr, Node.children node) with
        | Var (_, s), [] -> begin
            match D.builtin s with Some x -> x | None -> D.top
          end
        | Var _, [ did ] -> sol did
        | Try _, [ c1; c2 ] -> D.try_f (sol c1) (sol c2)
        | If _, [ c1; c2 ] -> D.if_f (sol c1) (sol c2)
        | Op1 (_loc, op, _), [ c ] -> D.op1_f op (sol c)
        | Op (_loc, op, _), cs -> D.op2_f op (List.map sol cs)
        | ( ( Konst _ | Tag _ | App _ | Bind _ | BindRec _ | Fun _
            | ExplicitSet _ | Match _ | MatchSet _ ),
            _ ) ->
            D.top
        | _ -> invalid_arg "malformed graph expression node")

  let forward (g : Graph.t) : Graph.var -> D.t =
    let vars = Graph.all_vars g in
    let deps = Graph.depends_on g in
    Fw.solve ~vars ~deps ~rhs:(fw_rhs g) ~init:(fun _ -> D.bottom)

  (* ---------------- Backward (demand) analysis ---------------- *)

  (* type bw_env = { *)
  (*   dm : def_map; *)
  (*   nm : node_map; *)
  (*   v : var -> D.t; (* results of forward analysis *) *)
  (* } *)

  (* Propagate demand "downward" (from parent to children) in the syntax tree. *)
  let bw_step ~(g : Graph.t) ~(fw_map : var -> D.t) (c : var -> D.t) (v : var) :
      (var * D.t) list =
    match find_id g v with
    | Either.Left rhs -> [ (rhs, c v) ]
    | Either.Right (node, expr) -> (
        let open AST in
        match (expr, Node.children node) with
        | Var _, [] -> []
        | Var _, [ did ] -> [ (did, c v) ]
        | Try _, [ c1; c2 ] ->
            let parent = c v in
            let lchild_fw = fw_map c1 in
            let rchild_fw = fw_map c2 in
            let l_bw, r_bw = D.try_b ~parent ~lchild_fw ~rchild_fw in
            [ (c1, l_bw); (c2, r_bw) ]
        | If _, [ c1; c2 ] ->
            let parent = c v in
            let lchild_fw = fw_map c1 in
            let rchild_fw = fw_map c2 in
            let l_bw, r_bw = D.if_b ~parent ~lchild_fw ~rchild_fw in
            [ (c1, l_bw); (c2, r_bw) ]
        | Op1 (_, op, _), [ child ] ->
            let parent_d = c v in
            let child_f = fw_map child in
            [ (child, D.op1_b op ~parent:parent_d ~child_f) ]
        | Op (_, op, _), children ->
            let parent_d = c v in
            let children_f = List.map fw_map children in
            let ds = D.op2_b op ~parent:parent_d ~children_f in
            List.map2 (fun ch d -> (ch, d)) children ds
        | ( ( Konst _ | Tag _ | App _ | Bind _ | BindRec _ | Fun _
            | ExplicitSet _ | Match _ | MatchSet _ ),
            _ ) ->
            []
        | _ -> invalid_arg "malformed graph expression node")

  (* Backward roots: definitions that should be treated as "publicly exported". *)
  let backward ~(g : Graph.t) ~(fw_map : var -> D.t) (roots : def_id list) :
      var -> D.t =
    let vars = Graph.all_vars g in
    (* let env = { dm; nm; v } in *)
    let seeds =
      List.map
        (fun did ->
          let vd = fw_map did in
          (did, vd))
        roots
    in
    Bw.solve ~vars ~step:(bw_step ~g ~fw_map) ~seeds

  type analysis_result = { forward : D.t; backward : D.t }

  let solve_all (stmts : Cat.binding list) : (TxtLoc.t * analysis_result) list =
    Log.debug (fun m -> m "solve_all");

    let g = Graph.build stmts in
    (* Log.debug (fun m -> m "%a" pp_graph (dm, nm)); *)
    let fw_map = forward g in

    (* debug_analysis ~name:"Forward analysis" ~vars ~dm ~nm fw_map; *)
    let roots = Graph.all_defs g in
    let bw_map = backward ~g ~fw_map roots in

    (* debug_analysis ~name:"Backward analysis" ~vars ~dm ~nm bw_map; *)
    (* debug_analysis ~name:"Full analysis" ~vars ~dm ~nm (fun v -> *)
    (*     D.meet (fw_map v) (bw_map v)); *)
    Graph.all_expr_nodes g
    |> List.map (fun nid ->
        let loc = Graph.get_expr_location g nid in
        (nid, loc))
    |> List.map (fun (v, loc) ->
        let fw = fw_map v in
        let bw = bw_map v in
        (loc, { forward = fw; backward = bw }))
end
