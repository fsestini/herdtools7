module Log = (val Logs.src_log (Logs.Src.create "graph") : Logs.LOG)
module E = TxtLoc.Extract ()

module Id : sig
  type t

  val zero : t
  val succ : t -> t
  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
end = struct
  include Int

  let pp = Format.pp_print_int
end

type def_id = Id.t
type node_id = Id.t

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
    | Ref (_, id) -> fprintf fmt "Ref %a" Id.pp id
    | Base (_, s) -> fprintf fmt "Base %s" s
    | Op1 (loc, _op, n) -> fprintf fmt "Op1 (%s, %a)" (E.extract loc) Id.pp n
    | Op (loc, _op, n) ->
        fprintf fmt "Op (%s, %a)" (E.extract loc)
          (pp_print_list ~pp_sep:(fun fmt () -> pp_print_string fmt ", ") Id.pp)
          n
    | Try (loc, _, _) -> fprintf fmt "Try (%s)" (E.extract loc)
    | If (loc, _, _) -> fprintf fmt "If (%s)" (E.extract loc)
end

module Def = struct
  type t = { name : string; rhs : node_id (* root node id of RHS expression *) }

  let pp fmt t =
    let open Format in
    Format.fprintf fmt "{ name = %s; rhs = %a }" t.name Id.pp t.rhs
end

type node = Node.t
type def = Def.t

module NodeMap = Map.Make (Id)
module DefMap = Map.Make (Id)

type node_map = node NodeMap.t
type def_map = def DefMap.t
type env = def_id StringMap.t

module Build : sig
  type state
  type 'a t = state -> state * 'a

  val return : 'a -> 'a t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
  val run : 'a t -> state * 'a
  val defs : state -> def_map
  val nodes : state -> node_map
  val get_env : env t
  val add_env : string -> def_id -> unit t
  val fresh_def : def_id t
  val add_def : def_id -> def -> unit t
  val emit_node : node -> node_id t
  val traverse : ('a -> 'b t) -> 'a list -> 'b list t
end = struct
  type state = {
    next_def : def_id;
    next_node : node_id;
    defs : def_map;
    nodes : node_map;
    env : env;
  }

  type 'a t = state -> state * 'a

  let return x st = (st, x)

  let bind m f st =
    let st, x = m st in
    f x st

  let ( let* ) = bind

  let init =
    {
      next_def = Id.zero;
      next_node = Id.zero;
      defs = DefMap.empty;
      nodes = NodeMap.empty;
      env = StringMap.empty;
    }

  let run m = m init
  let defs st = st.defs
  let nodes st = st.nodes
  let get_env st = (st, st.env)

  let add_env name def_id st =
    ({ st with env = StringMap.add name def_id st.env }, ())

  let fresh_def st =
    let def_id = st.next_def in
    ({ st with next_def = Id.succ def_id }, def_id)

  let add_def def_id def st =
    ({ st with defs = DefMap.add def_id def st.defs }, ())

  let fresh_node st =
    let node_id = st.next_node in
    ({ st with next_node = Id.succ node_id }, node_id)

  let add_node node_id node st =
    ({ st with nodes = NodeMap.add node_id node st.nodes }, ())

  let emit_node node =
    let* node_id = fresh_node in
    let* () = add_node node_id node in
    return node_id

  let rec traverse f = function
    | [] -> return []
    | x :: xs ->
        let* y = f x in
        let* ys = traverse f xs in
        return (y :: ys)
end

let rec compile_exp : AST.exp -> node_id Build.t =
 fun exp ->
  let open Build in
  let open AST in
  let unsupported loc =
    (* Log.warn (fun m -> m "compile_exp: unsupported expression@."); *)
    emit_node (Node.Unsupported loc)
  in
  match exp with
  | Op (loc, op, exps) ->
      let* ids = traverse compile_exp exps in
      emit_node (Node.Op (loc, op, ids))
  | Op1 (loc, op, exp) ->
      let* n_id = compile_exp exp in
      emit_node (Node.Op1 (loc, op, n_id))
  | Var (loc, s) ->
      let* env = get_env in
      let node =
        match StringMap.find_opt s env with
        | Some x -> Node.Ref (loc, x)
        | None -> Node.Base (loc, s)
      in
      emit_node node
  | Konst (loc, _) -> unsupported loc
  | Tag (loc, _) -> unsupported loc
  | App (loc, _, _) -> unsupported loc
  | Bind (loc, _, _) -> unsupported loc
  | BindRec (loc, _, _) -> unsupported loc
  | Fun (loc, _, _, _, _) -> unsupported loc
  | ExplicitSet (loc, _) -> unsupported loc
  | Match (loc, _, _, _) -> unsupported loc
  | MatchSet (loc, _, _, _) -> unsupported loc
  | Try (loc, a, b) ->
      let* id_a = compile_exp a in
      let* id_b = compile_exp b in
      emit_node (Node.Try (loc, id_a, id_b))
  | If (loc, _, a, b) ->
      let* id_a = compile_exp a in
      let* id_b = compile_exp b in
      emit_node (Node.If (loc, id_a, id_b))

let compile_binding Cat.{ name; exp; is_recursive; location = _ } =
  let open Build in
  let* def_id = fresh_def in
  let* () = if is_recursive then add_env name def_id else return () in
  let* rhs = compile_exp exp in
  let* () = add_def def_id Def.{ name; rhs } in
  let* () = if is_recursive then return () else add_env name def_id in
  return ()

let compile_bindings (l : Cat.binding list) : def_map * node_map =
  let st, _ = Build.run (Build.traverse compile_binding l) in
  (Build.defs st, Build.nodes st)

module Var = struct
  type t = VNode of node_id | VDef of def_id

  let compare = Stdlib.compare

  let pp fmt =
    let open Format in
    function
    | VNode id -> fprintf fmt "VNode(%a)" Id.pp id
    | VDef id -> fprintf fmt "VDef(%a)" Id.pp id
end

type var = Var.t
type t = { def_map : def_map; node_map : node_map; deps_map : var -> var list }

(* let missing_node nid = *)
(*   failwith (Format.asprintf "Missing node: %a" Id.pp nid) *)

(* let missing_def did = failwith (Format.asprintf "Missing node: %a" Id.pp did) *)

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
    (fun did def -> fprintf fmt "  %a -> %a@," Id.pp did Def.pp def)
    t.def_map;
  fprintf fmt "nodes:@,";
  NodeMap.iter
    (fun nid node -> fprintf fmt "  %a: %a@," Id.pp nid Node.pp_node node)
    t.node_map;
  fprintf fmt "@]"

(* let pp fmt t =  *)
