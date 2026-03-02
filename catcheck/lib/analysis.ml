module Log = (val Logs.src_log (Logs.Src.create "analysis") : Logs.LOG)
module E = TxtLoc.Extract ()

module DefId : sig
  type t

  val zero : t
  val succ : t -> t
  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
end = struct
  include Int

  let pp = Format.pp_print_int
end

module NodeId : sig
  type t

  val is_int : int -> t -> bool
  val zero : t
  val succ : t -> t
  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
end = struct
  include Int

  let is_int n x = Int.equal n x
  let pp = Format.pp_print_int
end

type def_id = DefId.t
type node_id = NodeId.t

module Node = struct
  type t =
    | Ref of def_id
    | Base of string (* other builtins / primitives *)
    | Op1 of TxtLoc.t * AST.op1 * node_id
    | Op of TxtLoc.t * AST.op2 * node_id list
    | Try of TxtLoc.t * node_id * node_id
    | Unsupported of TxtLoc.t

  let pp_node fmt =
    let open Format in
    function
    | Unsupported loc -> fprintf fmt "Unsupported (%s)" (E.extract loc)
    | Ref id -> fprintf fmt "Ref %a" DefId.pp id
    | Base s -> fprintf fmt "Base %s" s
    | Op1 (loc, _op, n) ->
        fprintf fmt "Op1 (%s, %a)" (E.extract loc) NodeId.pp n
    | Op (loc, _op, n) ->
        fprintf fmt "Op (%s, %a)" (E.extract loc)
          (pp_print_list
             ~pp_sep:(fun fmt () -> pp_print_string fmt ", ")
             NodeId.pp)
          n
    | Try (loc, _, _) -> fprintf fmt "Try (%s)" (E.extract loc)
end

type node = Node.t
type def = { name : string; rhs : node_id (* root node id of RHS expression *) }

module NodeMap = Map.Make (NodeId)
module DefMap = Map.Make (DefId)

type node_map = node NodeMap.t
type def_map = node_id DefMap.t
type env = def_id StringMap.t

let pp_graph fmt ((dm, nm) : def_map * node_map) =
  let open Format in
  fprintf fmt "@[<v>defs:@,";
  DefMap.iter
    (fun did root -> fprintf fmt "  %a -> %a@," DefId.pp did NodeId.pp root)
    dm;
  fprintf fmt "nodes:@,";
  NodeMap.iter
    (fun nid node -> fprintf fmt "  %a: %a@," NodeId.pp nid Node.pp_node node)
    nm;
  fprintf fmt "@]"

let rec compile_exp ~(env : def_id StringMap.t)
    ((next, nm) : node_id * node_map) :
    AST.exp -> (node_id * node_map) * node_id =
  let open AST in
  let of_unsupported loc =
    (* Log.warn (fun m -> m "compile_exp: unsupported expression@."); *)
    let ident_id = next in
    let node = Node.Unsupported loc in
    let nm = NodeMap.add next node nm in
    ((NodeId.succ next, nm), ident_id)
  in
  function
  | Op (loc, op, exps) ->
      let (next, nm), ids =
        List.fold_left_map (compile_exp ~env) (next, nm) exps
      in
      let op_id = next in
      let node = Node.Op (loc, op, ids) in
      let nm = NodeMap.add op_id node nm in
      ((NodeId.succ next, nm), op_id)
  | Op1 (loc, op, exp) ->
      let (next, nm), n_id = compile_exp ~env (next, nm) exp in
      let op_id = next in
      let node = Node.Op1 (loc, op, n_id) in
      let nm = NodeMap.add op_id node nm in
      ((NodeId.succ next, nm), op_id)
  | Var (_, s) ->
      let ident_id = next in
      let node =
        match StringMap.find_opt s env with
        | Some x -> Node.Ref x
        | None -> Node.Base s
      in
      let nm = NodeMap.add next node nm in
      ((NodeId.succ next, nm), ident_id)
  | Konst (loc, _) -> of_unsupported loc
  | Tag (loc, _) -> of_unsupported loc
  | App (loc, _, _) -> of_unsupported loc
  | Bind (loc, _, _) -> of_unsupported loc
  | BindRec (loc, _, _) -> of_unsupported loc
  | Fun (loc, _, _, _, _) -> of_unsupported loc
  | ExplicitSet (loc, _) -> of_unsupported loc
  | Match (loc, _, _, _) -> of_unsupported loc
  | MatchSet (loc, _, _, _) -> of_unsupported loc
  | Try (loc, a, b) ->
      let (next, nm), id_a = compile_exp ~env (next, nm) a in
      let (next, nm), id_b = compile_exp ~env (next, nm) b in
      let op_id = next in
      let node = Node.Try (loc, id_a, id_b) in
      let nm = NodeMap.add op_id node nm in
      ((NodeId.succ next, nm), op_id)
  | If (loc, _, _, _) -> of_unsupported loc

let compile_binding
    ((next_did, dm, next_nid, nm, env) :
      def_id * def_map * node_id * node_map * env) :
    Cat.binding -> def_id * def_map * node_id * node_map * env = function
  | Cat.{ name; exp; is_recursive = false; location = _ } ->
      let def_id = next_did in
      let (next_nid, nm), n_id = compile_exp ~env (next_nid, nm) exp in
      let dm = DefMap.add def_id n_id dm in
      let env = StringMap.add name def_id env in
      (DefId.succ next_did, dm, next_nid, nm, env)
  | Cat.{ name; exp; is_recursive = true; location = _ } ->
      let def_id = next_did in
      let env = StringMap.add name def_id env in
      let (next_nid, nm), n_id = compile_exp ~env (next_nid, nm) exp in
      let dm = DefMap.add def_id n_id dm in
      (DefId.succ next_did, dm, next_nid, nm, env)

let compile_bindings (l : Cat.binding list) : def_map * node_map =
  let _, dm, _, nm, _ =
    List.fold_left compile_binding
      (DefId.zero, DefMap.empty, NodeId.zero, NodeMap.empty, StringMap.empty)
      l
  in
  (dm, nm)

type var = VNode of node_id | VDef of def_id

module Var = struct
  type t = var

  let compare = Stdlib.compare

  let pp fmt =
    let open Format in
    function
    | VNode id -> fprintf fmt "VNode(%a)" NodeId.pp id
    | VDef id -> fprintf fmt "VDef(%a)" DefId.pp id

  let should_report = function VNode nid -> NodeId.is_int 39 nid | _ -> false
end

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

  type fw_env = { dm : def_map; nm : node_map; deps : var -> var list }

  let missing_node nid =
    failwith (Format.asprintf "Missing node: %a" NodeId.pp nid)

  let missing_def did =
    failwith (Format.asprintf "Missing node: %a" DefId.pp did)

  let get_node (nm : node_map) (nid : node_id) : node =
    match NodeMap.find_opt nid nm with Some n -> n | None -> missing_node nid

  let get_def_root (dm : def_map) (did : def_id) : node_id =
    match DefMap.find_opt did dm with Some r -> r | None -> missing_def did

  module VarMap = Map.Make (Var)

  let build_revdeps ~(dm : def_map) ~(nm : node_map) : var -> var list =
    let add_edge m ~from_ ~to_ =
      let old = Option.value ~default:[] (VarMap.find_opt from_ m) in
      VarMap.add from_ (to_ :: old) m
    in
    let rev_map =
      NodeMap.fold
        (fun n_id n acc ->
          let node_v = VNode n_id in
          match n with
          | Node.Unsupported _ -> acc
          | Node.Base _ -> acc
          | Node.Ref d -> add_edge acc ~from_:(VDef d) ~to_:node_v
          | Node.Try (_, c1, c2) ->
              List.fold_left
                (fun acc c -> add_edge acc ~from_:(VNode c) ~to_:node_v)
                acc [ c1; c2 ]
          | Node.Op1 (_, _, c) -> add_edge acc ~from_:(VNode c) ~to_:node_v
          | Node.Op (_, _, cs) ->
              List.fold_left
                (fun acc c -> add_edge acc ~from_:(VNode c) ~to_:node_v)
                acc cs)
        nm VarMap.empty
    in
    let rev_map =
      DefMap.fold
        (fun did root acc -> add_edge acc ~from_:(VNode root) ~to_:(VDef did))
        dm rev_map
    in
    fun v -> match VarMap.find_opt v rev_map with Some xs -> xs | None -> []

  let fw_rhs (env : fw_env) (sol : var -> D.t) (v : var) : D.t =
    match v with
    | VDef did -> sol (VNode (get_def_root env.dm did))
    | VNode nid -> (
        let node = get_node env.nm nid in
        if NodeId.is_int 39 nid then
          Log.debug (fun m -> m "Node 39: %a" Node.pp_node node);
        match node with
        | Node.Base s -> begin
            match D.builtin s with Some x -> x | None -> D.top
          end
        | Node.Unsupported _ -> D.top
        | Node.Ref did -> sol (VDef did)
        | Node.Try (_, c1, c2) -> D.try_f (sol (VNode c1)) (sol (VNode c2))
        | Node.Op1 (_loc, op, c) ->
            (* Format.printf "doing op1_f of %s@." (E.extract loc); *)
            D.op1_f op (sol (VNode c))
        | Node.Op (_loc, op, cs) ->
            (* Format.printf "doing op2_f of %s@." (E.extract loc); *)
            let args = List.map (fun c -> sol (VNode c)) cs in
            D.op2_f op args)

  (* Enumerate all vars (defs + nodes) once; used by both solvers. *)
  let all_vars ~(dm : def_map) ~(nm : node_map) : var list =
    let defs = DefMap.bindings dm |> List.map (fun (d, _) -> VDef d) in
    let nodes = NodeMap.bindings nm |> List.map (fun (n, _) -> VNode n) in
    defs @ nodes

  let forward ~(dm : def_map) ~(nm : node_map) : var -> D.t =
    let deps = build_revdeps ~dm ~nm in
    let env = { dm; nm; deps } in
    let vars = all_vars ~dm ~nm in
    Fw.solve ~vars ~deps ~rhs:(fw_rhs env) ~init:(fun _ -> D.bottom)

  (* ---------------- Backward (demand) analysis ---------------- *)

  type bw_env = {
    dm : def_map;
    nm : node_map;
    v : var -> D.t; (* results of forward analysis *)
  }

  (* Propagate demand "downward" (from parent to children) in the syntax tree. *)
  let bw_step (env : bw_env) (c : var -> D.t) (v : var) : (var * D.t) list =
    match v with
    | VDef did ->
        let root = get_def_root env.dm did in
        [ (VNode root, c (VDef did)) ]
    | VNode nid -> (
        match get_node env.nm nid with
        | Node.(Base _ | Unsupported _) -> []
        | Node.Ref did -> [ (VDef did, c (VNode nid)) ]
        | Node.Try (_, c1, c2) ->
            let parent = c (VNode nid) in
            let lchild_fw = env.v (VNode c1) in
            let rchild_fw = env.v (VNode c2) in
            let l_bw, r_bw = D.try_b ~parent ~lchild_fw ~rchild_fw in
            [ (VNode c1, l_bw); (VNode c2, r_bw) ]
        | Node.Op1 (_, op, child) ->
            let parent_d = c (VNode nid) in
            let child_f = env.v (VNode child) in
            [ (VNode child, D.op1_b op ~parent:parent_d ~child_f) ]
        | Node.Op (_, op, children) ->
            let parent_d = c (VNode nid) in
            let children_f = List.map (fun ch -> env.v (VNode ch)) children in
            let ds = D.op2_b op ~parent:parent_d ~children_f in
            List.map2 (fun ch d -> (VNode ch, d)) children ds)

  (* Backward roots: definitions that should be treated as "publicly exported". *)
  let backward ~(dm : def_map) ~(nm : node_map) ~(v : var -> D.t)
      ~(roots : def_id list) : var -> D.t =
    let vars = all_vars ~dm ~nm in
    let env = { dm; nm; v } in
    let seeds =
      List.map
        (fun did ->
          let vd = v (VDef did) in
          (VDef did, vd))
        roots
    in
    Bw.solve ~vars ~step:(bw_step env) ~seeds

  type analysis_result = { forward : D.t; backward : D.t }

  let debug_analysis ~name ~vars ~(dm : def_map) ~(nm : node_map) f =
    Log.debug (fun m ->
        m "%s:@.%a" name
          Format.(
            pp_print_list
              ~pp_sep:(fun fmt () -> pp_print_string fmt "@.")
              (fun fmt v ->
                let var_str =
                  match v with
                  | VDef did ->
                      let nid = DefMap.find did dm in
                      let node = NodeMap.find nid nm in
                      Format.asprintf "def %a" Node.pp_node node
                  | VNode nid ->
                      let node = NodeMap.find nid nm in
                      Format.asprintf "%a" Node.pp_node node
                in
                let value = f v in
                fprintf fmt "%a (%s) -> %a@." Var.pp v var_str D.pp value))
          vars)

  let solve_all (stmts : Cat.binding list) : (TxtLoc.t * analysis_result) list =
    Log.debug (fun m -> m "solve_all");

    let dm, nm = compile_bindings stmts in
    Log.debug (fun m -> m "%a" pp_graph (dm, nm));
    let vars = all_vars ~dm ~nm in
    let fw_map = forward ~dm ~nm in

    debug_analysis ~name:"Forward analysis" ~vars ~dm ~nm fw_map;
    let roots =
      (* Treat all definitions as "publicly exported" *)
      vars |> List.filter_map (function VDef v -> Some v | VNode _ -> None)
    in
    let bw_map = backward ~dm ~nm ~v:fw_map ~roots in

    debug_analysis ~name:"Backward analysis" ~vars ~dm ~nm bw_map;
    debug_analysis ~name:"Full analysis" ~vars ~dm ~nm (fun v ->
        D.meet (fw_map v) (bw_map v));
    vars
    |> List.filter_map (function
      | VNode nid -> (
          match get_node nm nid with
          | Node.Op1 (loc, AST.ToId, ch) -> Some (VNode ch, loc)
          | _ -> None)
      | _ -> None)
    |> List.map (fun (v, loc) ->
        let fw = fw_map v in
        let bw = bw_map v in
        (loc, { forward = fw; backward = bw }))
end
