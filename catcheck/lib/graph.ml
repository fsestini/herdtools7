module Log = (val Logs.src_log (Logs.Src.create "graph") : Logs.LOG)
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
    | Ref of TxtLoc.t * def_id
    | Base of TxtLoc.t * string (* other builtins / primitives *)
    | Op1 of TxtLoc.t * AST.op1 * node_id
    | Op of TxtLoc.t * AST.op2 * node_id list
    | Try of TxtLoc.t * node_id * node_id
    | If of TxtLoc.t * node_id * node_id
    | Unsupported of TxtLoc.t

  let location = function
    | Ref (loc, _) -> loc
    | Base (loc, _) -> loc
    | Op1 (loc, _, _) -> loc
    | Op (loc, _, _) -> loc
    | Try (loc, _, _) -> loc
    | If (loc, _, _) -> loc
    | Unsupported loc -> loc

  let pp_node fmt =
    let open Format in
    function
    | Unsupported loc -> fprintf fmt "Unsupported (%s)" (E.extract loc)
    | Ref (_, id) -> fprintf fmt "Ref %a" DefId.pp id
    | Base (_, s) -> fprintf fmt "Base %s" s
    | Op1 (loc, _op, n) ->
        fprintf fmt "Op1 (%s, %a)" (E.extract loc) NodeId.pp n
    | Op (loc, _op, n) ->
        fprintf fmt "Op (%s, %a)" (E.extract loc)
          (pp_print_list
             ~pp_sep:(fun fmt () -> pp_print_string fmt ", ")
             NodeId.pp)
          n
    | Try (loc, _, _) -> fprintf fmt "Try (%s)" (E.extract loc)
    | If (loc, _, _) -> fprintf fmt "If (%s)" (E.extract loc)
end

module Def = struct
  type t = { name : string; rhs : node_id (* root node id of RHS expression *) }

  let pp fmt t =
    let open Format in
    Format.fprintf fmt "{ name = %s; rhs = %a }" t.name NodeId.pp t.rhs
end

type node = Node.t
type def = Def.t

module NodeMap = Map.Make (NodeId)
module DefMap = Map.Make (DefId)

type node_map = node NodeMap.t
type def_map = def DefMap.t
type env = def_id StringMap.t

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
  | Var (loc, s) ->
      let ident_id = next in
      let node =
        match StringMap.find_opt s env with
        | Some x -> Node.Ref (loc, x)
        | None -> Node.Base (loc, s)
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
  | If (loc, _, a, b) ->
      let (next, nm), id_a = compile_exp ~env (next, nm) a in
      let (next, nm), id_b = compile_exp ~env (next, nm) b in
      let op_id = next in
      let node = Node.If (loc, id_a, id_b) in
      let nm = NodeMap.add op_id node nm in
      ((NodeId.succ next, nm), op_id)

let compile_binding
    ((next_did, dm, next_nid, nm, env) :
      def_id * def_map * node_id * node_map * env) :
    Cat.binding -> def_id * def_map * node_id * node_map * env = function
  | Cat.{ name; exp; is_recursive = false; location = _ } ->
      let def_id = next_did in
      let (next_nid, nm), n_id = compile_exp ~env (next_nid, nm) exp in
      let def = Def.{ name; rhs = n_id } in
      let dm = DefMap.add def_id def dm in
      let env = StringMap.add name def_id env in
      (DefId.succ next_did, dm, next_nid, nm, env)
  | Cat.{ name; exp; is_recursive = true; location = _ } ->
      let def_id = next_did in
      let env = StringMap.add name def_id env in
      let (next_nid, nm), n_id = compile_exp ~env (next_nid, nm) exp in
      let def = Def.{ name; rhs = n_id } in
      let dm = DefMap.add def_id def dm in
      (DefId.succ next_did, dm, next_nid, nm, env)

let compile_bindings (l : Cat.binding list) : def_map * node_map =
  let _, dm, _, nm, _ =
    List.fold_left compile_binding
      (DefId.zero, DefMap.empty, NodeId.zero, NodeMap.empty, StringMap.empty)
      l
  in
  (dm, nm)

module Var = struct
  type t = VNode of node_id | VDef of def_id

  let compare = Stdlib.compare

  let pp fmt =
    let open Format in
    function
    | VNode id -> fprintf fmt "VNode(%a)" NodeId.pp id
    | VDef id -> fprintf fmt "VDef(%a)" DefId.pp id
end

type var = Var.t
type t = { def_map : def_map; node_map : node_map; deps_map : var -> var list }

(* let missing_node nid = *)
(*   failwith (Format.asprintf "Missing node: %a" NodeId.pp nid) *)

(* let missing_def did = failwith (Format.asprintf "Missing node: %a" DefId.pp did) *)

let get_node (t : t) (nid : node_id) : node =
  match NodeMap.find_opt nid t.node_map with
  | Some n -> n
  | None -> raise Not_found

let get_def_root (g : t) (did : def_id) : node_id =
  match DefMap.find_opt did g.def_map with
  | Some r -> r.Def.rhs
  | None -> raise Not_found

module VarMap = Map.Make (Var)

let build_revdeps ~(dm : def_map) ~(nm : node_map) : var -> var list =
  let add_edge m ~from_ ~to_ =
    let old = Option.value ~default:[] (VarMap.find_opt from_ m) in
    VarMap.add from_ (to_ :: old) m
  in
  let rev_map =
    NodeMap.fold
      (fun n_id n acc ->
        let node_v = Var.VNode n_id in
        match n with
        | Node.Unsupported _ -> acc
        | Node.Base _ -> acc
        | Node.Ref (_, d) -> add_edge acc ~from_:(Var.VDef d) ~to_:node_v
        | Node.Try (_, c1, c2) ->
            List.fold_left
              (fun acc c -> add_edge acc ~from_:(Var.VNode c) ~to_:node_v)
              acc [ c1; c2 ]
        | Node.If (_, c1, c2) ->
            List.fold_left
              (fun acc c -> add_edge acc ~from_:(Var.VNode c) ~to_:node_v)
              acc [ c1; c2 ]
        | Node.Op1 (_, _, c) -> add_edge acc ~from_:(Var.VNode c) ~to_:node_v
        | Node.Op (_, _, cs) ->
            List.fold_left
              (fun acc c -> add_edge acc ~from_:(Var.VNode c) ~to_:node_v)
              acc cs)
      nm VarMap.empty
  in
  let rev_map =
    DefMap.fold
      (fun did def acc ->
        add_edge acc ~from_:(Var.VNode def.Def.rhs) ~to_:(Var.VDef did))
      dm rev_map
  in
  fun v -> Option.value ~default:[] (VarMap.find_opt v rev_map)

let build (l : Cat.binding list) : t =
  let def_map, node_map = compile_bindings l in
  let deps_map = build_revdeps ~dm:def_map ~nm:node_map in
  { def_map; node_map; deps_map }

let all_vars (t : t) : var list =
  let defs = DefMap.bindings t.def_map |> List.map (fun (d, _) -> Var.VDef d) in
  let nodes =
    NodeMap.bindings t.node_map |> List.map (fun (n, _) -> Var.VNode n)
  in
  defs @ nodes

let depends_on t = t.deps_map

let pp fmt (t : t) =
  let open Format in
  fprintf fmt "@[<v>defs:@,";
  DefMap.iter
    (fun did def -> fprintf fmt "  %a -> %a@," DefId.pp did Def.pp def)
    t.def_map;
  fprintf fmt "nodes:@,";
  NodeMap.iter
    (fun nid node -> fprintf fmt "  %a: %a@," NodeId.pp nid Node.pp_node node)
    t.node_map;
  fprintf fmt "@]"

(* let pp fmt t =  *)
