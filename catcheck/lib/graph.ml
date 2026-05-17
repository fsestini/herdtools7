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
type var = Id.t

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
  type 'a t = env -> state -> state * 'a

  val return : 'a -> 'a t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
  val run : 'a t -> state * 'a
  val defs : state -> def_map
  val nodes : state -> node_map
  val ask : env t
  val local : (env -> env) -> 'a t -> 'a t
  val fresh_def : def_id t
  val add_def : def_id -> def -> unit t
  val emit_node : node -> node_id t
  val traverse : ('a -> 'b t) -> 'a list -> 'b list t
end = struct
  type state = { next : Id.t; defs : def_map; nodes : node_map }
  type 'a t = env -> state -> state * 'a

  let return x _env st = (st, x)

  let bind m f env st =
    let st, x = m env st in
    f x env st

  let ( let* ) = bind
  let init = { next = Id.zero; defs = DefMap.empty; nodes = NodeMap.empty }
  let run m = m StringMap.empty init
  let defs st = st.defs
  let nodes st = st.nodes
  let ask env st = (st, env)
  let local f m env st = m (f env) st

  let fresh_id _env st =
    let id = st.next in
    ({ st with next = Id.succ id }, id)

  let fresh_def = fresh_id

  let add_def def_id def _env st =
    ({ st with defs = DefMap.add def_id def st.defs }, ())

  let add_node node_id node _env st =
    ({ st with nodes = NodeMap.add node_id node st.nodes }, ())

  let emit_node node =
    let* node_id = fresh_id in
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
      let* env = ask in
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
  let extend = StringMap.add name def_id in
  let* rhs =
    if is_recursive then local extend (compile_exp exp) else compile_exp exp
  in
  let* () = add_def def_id Def.{ name; rhs } in
  return extend

let compile_bindings (l : Cat.binding list) : def_map * node_map =
  let rec compile_all = function
    | [] -> Build.return ()
    | binding :: rest ->
        let open Build in
        let* extend = compile_binding binding in
        local extend (compile_all rest)
  in
  let st, () = Build.run (compile_all l) in
  (Build.defs st, Build.nodes st)

module Var = struct
  type t = var

  let compare = Id.compare
  let pp = Id.pp
end

type t = { def_map : def_map; node_map : node_map; deps_map : var -> var list }

(* let missing_node nid = *)
(*   failwith (Format.asprintf "Missing node: %a" Id.pp nid) *)

(* let missing_def did = failwith (Format.asprintf "Missing node: %a" Id.pp did) *)

let get_node_opt (t : t) (nid : node_id) : node option =
  NodeMap.find_opt nid t.node_map

let get_def_opt (t : t) (did : def_id) : def option =
  DefMap.find_opt did t.def_map

(* [get_node] raises [Not_found] when [nid] is not an expression node ID.
   This includes IDs that are valid definition IDs and IDs that are not present
   in the graph at all. *)
let get_node (t : t) (nid : node_id) : node =
  match get_node_opt t nid with Some n -> n | None -> raise Not_found

module VarMap = Map.Make (Var)

let build_revdeps ~(dm : def_map) ~(nm : node_map) : var -> var list =
  let add_edge m ~from_ ~to_ =
    let old = Option.value ~default:[] (VarMap.find_opt from_ m) in
    VarMap.add from_ (to_ :: old) m
  in
  let rev_map =
    NodeMap.fold
      (fun n_id n acc ->
        match n with
        | Node.Unsupported _ -> acc
        | Node.Base _ -> acc
        | Node.Ref (_, d) -> add_edge acc ~from_:d ~to_:n_id
        | Node.Try (_, c1, c2) ->
            List.fold_left
              (fun acc c -> add_edge acc ~from_:c ~to_:n_id)
              acc [ c1; c2 ]
        | Node.If (_, c1, c2) ->
            List.fold_left
              (fun acc c -> add_edge acc ~from_:c ~to_:n_id)
              acc [ c1; c2 ]
        | Node.Op1 (_, _, c) -> add_edge acc ~from_:c ~to_:n_id
        | Node.Op (_, _, cs) ->
            List.fold_left (fun acc c -> add_edge acc ~from_:c ~to_:n_id) acc cs)
      nm VarMap.empty
  in
  let rev_map =
    DefMap.fold
      (fun did def acc -> add_edge acc ~from_:def.Def.rhs ~to_:did)
      dm rev_map
  in
  fun v -> Option.value ~default:[] (VarMap.find_opt v rev_map)

let build (l : Cat.binding list) : t =
  let def_map, node_map = compile_bindings l in
  let deps_map = build_revdeps ~dm:def_map ~nm:node_map in
  { def_map; node_map; deps_map }

let all_defs (t : t) : def_id list = DefMap.bindings t.def_map |> List.map fst

let all_nodes (t : t) : node_id list =
  NodeMap.bindings t.node_map |> List.map fst

let all_vars (t : t) : var list = all_defs t @ all_nodes t
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
