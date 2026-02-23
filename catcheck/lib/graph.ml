module Log = (val Logs.src_log (Logs.Src.create "fixpoint") : Logs.LOG)

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

  val zero : t
  val succ : t -> t
  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
end = struct
  include Int

  let pp = Format.pp_print_int
end

type def_id = DefId.t
type node_id = NodeId.t

module Node = struct
  type t =
    | To_id of TxtLoc.t * AST.exp
    | Cartesian of AST.exp * AST.exp
    | Ref of def_id
    | Base of string (* other builtins / primitives *)
    | Op1 of AST.op1 * node_id
    | Op of AST.op2 * node_id list

  let pp_node fmt =
    let open Format in
    function
    | To_id (_, _exp) -> fprintf fmt "To_id _"
    | Cartesian _ -> fprintf fmt "Cartesian _"
    | Ref id -> fprintf fmt "Ref %a" DefId.pp id
    | Base s -> fprintf fmt "Base %s" s
    | Op1 (_op, n) -> fprintf fmt "Op1 (_, %a)" NodeId.pp n
    | Op (_op, n) ->
        fprintf fmt "Op (_, %a)"
          (pp_print_list
             ~pp_sep:(fun fmt () -> pp_print_string fmt ", ")
             NodeId.pp)
          n
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
  function
  | Op (_, Cartesian, [ a; b ]) ->
      let node = Node.Cartesian (a, b) in
      let nm = NodeMap.add next node nm in
      ((NodeId.succ next, nm), next)
  | Op (_, op, exps) ->
      let (next, nm), ids =
        List.fold_left_map (compile_exp ~env) (next, nm) exps
      in
      let op_id = next in
      let node = Node.Op (op, ids) in
      let nm = NodeMap.add op_id node nm in
      ((NodeId.succ next, nm), op_id)
  | Op1 (loc, ToId, exp) ->
      let node = Node.To_id (loc, exp) in
      let nm = NodeMap.add next node nm in
      ((NodeId.succ next, nm), next)
  | Op1 (_, op, exp) ->
      let (next, nm), n_id = compile_exp ~env (next, nm) exp in
      let op_id = next in
      let node = Node.Op1 (op, n_id) in
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
  | _ ->
      Format.eprintf "compile_exp: unsupported expression@.";
      let s = "<unsupported>" in
      let ident_id = next in
      let node =
        match StringMap.find_opt s env with
        | Some x -> Node.Ref x
        | None -> Node.Base s
      in
      let nm = NodeMap.add next node nm in
      ((NodeId.succ next, nm), ident_id)

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
end

module Make (D : Domain.S) = struct
  module Lat = struct
    type t = D.t

    let bottom = D.bottom
    let join = D.join
    let equal = D.equal
  end

  module Fw = Analysis.MakeForward (Var) (Lat)
  module Bw = Analysis.MakeBackward (Var) (Lat)

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
          | Node.(Base _ | To_id _ | Cartesian _) -> acc
          | Node.Ref d -> add_edge acc ~from_:(VDef d) ~to_:node_v
          | Node.Op1 (_, c) -> add_edge acc ~from_:(VNode c) ~to_:node_v
          | Node.Op (_, cs) ->
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
        match get_node env.nm nid with
        | Node.Base s -> begin
            match D.builtin s with Some x -> x | None -> D.bottom
          end
        | Node.To_id (_, e) -> D.to_id e
        | Node.Cartesian (left, right) -> D.cartesian left right
        | Node.Ref did -> sol (VDef did)
        | Node.Op1 (op, c) -> D.op1_f op (sol (VNode c))
        | Node.Op (op, cs) ->
            let args = List.map (fun c -> sol (VNode c)) cs in
            D.op2_f op args)

  let fw_init (_ : var) : D.t = D.bottom

  (* Enumerate all vars (defs + nodes) once; used by both solvers. *)
  let all_vars ~(dm : def_map) ~(nm : node_map) : var list =
    let defs = DefMap.bindings dm |> List.map (fun (d, _) -> VDef d) in
    let nodes = NodeMap.bindings nm |> List.map (fun (n, _) -> VNode n) in
    defs @ nodes

  let forward ~(dm : def_map) ~(nm : node_map) : var -> D.t =
    let deps = build_revdeps ~dm ~nm in
    let env = { dm; nm; deps } in
    let vars = all_vars ~dm ~nm in
    Fw.solve ~vars ~deps ~rhs:(fw_rhs env) ~init:fw_init

  (* let forward_all (stmts : Cat.binding list) : unit = *)
  (*   let dm, nm = compile_bindings stmts in *)
  (*   Format.printf "%a@." pp_graph (dm, nm); *)
  (*   let vars = all_vars ~dm ~nm in *)
  (*   let fw_map = forward ~dm ~nm in *)
  (*   vars *)
  (*   |> List.iter (fun v -> *)
  (*       let value = fw_map v in *)
  (*       Format.printf "%a -> %a@." Var.pp v D.pp value) *)

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
        | Node.(Base _ | To_id _ | Cartesian _) -> []
        | Node.Ref did -> [ (VDef did, c (VNode nid)) ]
        | Node.Op1 (op, child) ->
            let parent_d = c (VNode nid) in
            let child_f = env.v (VNode child) in
            [ (VNode child, D.op1_b op ~parent:parent_d ~child_f) ]
        | Node.Op (op, children) ->
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

  let debug_analysis ~name ~vars f =
    Log.debug (fun m ->
        m "%s:@.%a" name
          Format.(
            pp_print_list
              ~pp_sep:(fun fmt () -> pp_print_string fmt "@.")
              (fun fmt v ->
                let value = f v in
                fprintf fmt "%a -> %a@." Var.pp v D.pp value))
          vars)

  let solve_all (stmts : Cat.binding list) : (TxtLoc.t * analysis_result) list =
    let dm, nm = compile_bindings stmts in
    Format.printf "%a@." pp_graph (dm, nm);
    let vars = all_vars ~dm ~nm in
    let fw_map = forward ~dm ~nm in

    debug_analysis ~name:"Forward analysis" ~vars fw_map;

    let roots =
      (* Treat all definitions as "publicly exported" *)
      vars |> List.filter_map (function VDef v -> Some v | VNode _ -> None)
    in
    let bw_map = backward ~dm ~nm ~v:fw_map ~roots in

    debug_analysis ~name:"Backward analysis" ~vars bw_map;
    debug_analysis ~name:"Full analysis" ~vars (fun v ->
        D.meet (fw_map v) (bw_map v));

    vars
    |> List.filter_map (function
      | VNode nid as v -> (
          match get_node nm nid with
          | Node.To_id (loc, _) -> Some (v, loc)
          | _ -> None)
      | _ -> None)
    |> List.map (fun (v, loc) ->
        let fw = fw_map v in
        let bw = bw_map v in
        (loc, { forward = fw; backward = bw }))
end
