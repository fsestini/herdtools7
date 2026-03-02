module Log = (val Logs.src_log (Logs.Src.create "analysis") : Logs.LOG)
module Var = Graph.Var
module Node = Graph.Node
module NodeId = Graph.NodeId

type var = Graph.var
type def_id = Graph.def_id

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
    match v with
    | Var.VDef did -> sol (Var.VNode (Graph.get_def_root g did))
    | Var.VNode nid -> (
        let node = Graph.get_node g nid in
        match node with
        | Node.Base (_, s) -> begin
            match D.builtin s with Some x -> x | None -> D.top
          end
        | Node.Unsupported _ -> D.top
        | Node.Ref (_, did) -> sol (Var.VDef did)
        | Node.Try (_, c1, c2) ->
            D.try_f (sol (Var.VNode c1)) (sol (Var.VNode c2))
        | Node.Op1 (_loc, op, c) ->
            (* Format.printf "doing op1_f of %s@." (E.extract loc); *)
            D.op1_f op (sol (Var.VNode c))
        | Node.Op (_loc, op, cs) ->
            (* Format.printf "doing op2_f of %s@." (E.extract loc); *)
            let args = List.map (fun c -> sol (Var.VNode c)) cs in
            D.op2_f op args)

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
    let open Var in
    match v with
    | VDef did ->
        let root = Graph.get_def_root g did in
        [ (VNode root, c (VDef did)) ]
    | VNode nid -> (
        match Graph.get_node g nid with
        | Node.(Base _ | Unsupported _) -> []
        | Node.Ref (_, did) -> [ (VDef did, c (VNode nid)) ]
        | Node.Try (_, c1, c2) ->
            let parent = c (VNode nid) in
            let lchild_fw = fw_map (VNode c1) in
            let rchild_fw = fw_map (VNode c2) in
            let l_bw, r_bw = D.try_b ~parent ~lchild_fw ~rchild_fw in
            [ (VNode c1, l_bw); (VNode c2, r_bw) ]
        | Node.Op1 (_, op, child) ->
            let parent_d = c (VNode nid) in
            let child_f = fw_map (VNode child) in
            [ (VNode child, D.op1_b op ~parent:parent_d ~child_f) ]
        | Node.Op (_, op, children) ->
            let parent_d = c (VNode nid) in
            let children_f = List.map (fun ch -> fw_map (VNode ch)) children in
            let ds = D.op2_b op ~parent:parent_d ~children_f in
            List.map2 (fun ch d -> (VNode ch, d)) children ds)

  (* Backward roots: definitions that should be treated as "publicly exported". *)
  let backward ~(g : Graph.t) ~(fw_map : var -> D.t) (roots : def_id list) :
      var -> D.t =
    let vars = Graph.all_vars g in
    (* let env = { dm; nm; v } in *)
    let seeds =
      List.map
        (fun did ->
          let vd = fw_map (Var.VDef did) in
          (Var.VDef did, vd))
        roots
    in
    Bw.solve ~vars ~step:(bw_step ~g ~fw_map) ~seeds

  type analysis_result = { forward : D.t; backward : D.t }

  (* let debug_analysis ~name ~vars ~(g : Graph.t) f = *)
  (*   Log.debug (fun m -> *)
  (*       m "%s:@.%a" name *)
  (*         Format.( *)
  (*           pp_print_list *)
  (*             ~pp_sep:(fun fmt () -> pp_print_string fmt "@.") *)
  (*             (fun fmt v -> *)
  (*               let var_str = *)
  (*                 match v with *)
  (*                 | Var.VDef did -> *)
  (*                     let nid = DefMap.find did dm in *)
  (*                     let node = NodeMap.find nid nm in *)
  (*                     Format.asprintf "def %a" Node.pp_node node *)
  (*                 | Var.VNode nid -> *)
  (*                     let node = NodeMap.find nid nm in *)
  (*                     Format.asprintf "%a" Node.pp_node node *)
  (*               in *)
  (*               let value = f v in *)
  (*               fprintf fmt "%a (%s) -> %a@." Var.pp v var_str D.pp value)) *)
  (*         vars) *)

  let solve_all (stmts : Cat.binding list) : (TxtLoc.t * analysis_result) list =
    Log.debug (fun m -> m "solve_all");

    let g = Graph.build stmts in
    (* Log.debug (fun m -> m "%a" pp_graph (dm, nm)); *)
    let vars = Graph.all_vars g in
    let fw_map = forward g in

    (* debug_analysis ~name:"Forward analysis" ~vars ~dm ~nm fw_map; *)
    let roots =
      (* Treat all definitions as "publicly exported" *)
      vars
      |> List.filter_map Var.(function VDef v -> Some v | VNode _ -> None)
    in
    let bw_map = backward ~g ~fw_map roots in

    (* debug_analysis ~name:"Backward analysis" ~vars ~dm ~nm bw_map; *)
    (* debug_analysis ~name:"Full analysis" ~vars ~dm ~nm (fun v -> *)
    (*     D.meet (fw_map v) (bw_map v)); *)
    vars
    |> List.filter_map (function
      | Var.VNode nid -> (
          match Graph.get_node g nid with
          | Node.Op1 (loc, AST.ToId, ch) -> Some (Var.VNode ch, loc)
          | _ -> None)
      | _ -> None)
    |> List.map (fun (v, loc) ->
        let fw = fw_map v in
        let bw = bw_map v in
        (loc, { forward = fw; backward = bw }))
end
