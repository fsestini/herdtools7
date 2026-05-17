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
    | Def of { name : string; location : TxtLoc.t; rhs : node_id }
    | Expr of { expr : AST.exp; children : Id.t list }

  let children = function
    | Def { rhs; _ } -> [ rhs ]
    | Expr { children; _ } -> children

  let location = function
    | Def { location; _ } -> location
    | Expr { expr; _ } -> ASTUtils.exp2loc expr

  let pp_node fmt =
    let open Format in
    function
    | Def { name; rhs; _ } ->
        fprintf fmt "Def { name = %s; rhs = %a }" name Id.pp rhs
    | Expr { children; _ } ->
        fprintf fmt "Expr (%a)"
          (pp_print_list ~pp_sep:(fun fmt () -> pp_print_string fmt ", ") Id.pp)
          children
end

type node = Node.t

module NodeMap = Map.Make (Id)

type node_map = node NodeMap.t
type env = def_id StringMap.t

module Build : sig
  type state
  type 'a t = env -> state -> state * 'a

  val return : 'a -> 'a t
  val ( let* ) : 'a t -> ('a -> 'b t) -> 'b t
  val run : 'a t -> state * 'a
  val nodes : state -> node_map
  val ask : env t
  val local : (env -> env) -> 'a t -> 'a t
  val fresh_id : Id.t t

  val emit_def :
    def_id -> name:string -> location:TxtLoc.t -> rhs:node_id -> unit t

  val emit_expr : AST.exp -> Id.t list -> node_id t
  val traverse : ('a -> 'b t) -> 'a list -> 'b list t
end = struct
  type state = { next : Id.t; nodes : node_map }
  type 'a t = env -> state -> state * 'a

  let return x _env st = (st, x)

  let bind m f env st =
    let st, x = m env st in
    f x env st

  let ( let* ) = bind
  let init = { next = Id.zero; nodes = NodeMap.empty }
  let run m = m StringMap.empty init
  let nodes st = st.nodes
  let ask env st = (st, env)
  let local f m env st = m (f env) st

  let fresh_id _env st =
    let id = st.next in
    ({ st with next = Id.succ id }, id)

  let add_node node_id node _env st =
    ({ st with nodes = NodeMap.add node_id node st.nodes }, ())

  let emit_def def_id ~name ~location ~rhs =
    add_node def_id (Node.Def { name; location; rhs })

  let emit_expr expr children =
    let* node_id = fresh_id in
    let* () = add_node node_id (Node.Expr { expr; children }) in
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
  let unsupported exp =
    (* Log.warn (fun m -> m "compile_exp: unsupported expression@."); *)
    emit_expr exp []
  in
  match exp with
  | Op (_, _, exps) ->
      let* ids = traverse compile_exp exps in
      emit_expr exp ids
  | Op1 (_, _, child) ->
      let* n_id = compile_exp child in
      emit_expr exp [ n_id ]
  | Var (loc, s) ->
      let* env = ask in
      let children =
        match StringMap.find_opt s env with Some x -> [ x ] | None -> []
      in
      emit_expr (Var (loc, s)) children
  | Konst _ -> unsupported exp
  | Tag _ | App _ | Bind _ | BindRec _ | Fun _ | ExplicitSet _ | Match _
  | MatchSet _ ->
      unsupported exp
  | Try (_, a, b) ->
      let* id_a = compile_exp a in
      let* id_b = compile_exp b in
      emit_expr exp [ id_a; id_b ]
  | If (_, _, a, b) ->
      let* id_a = compile_exp a in
      let* id_b = compile_exp b in
      emit_expr exp [ id_a; id_b ]

let compile_binding Cat.{ name; exp; is_recursive; location } =
  let open Build in
  let* def_id = fresh_id in
  let extend = StringMap.add name def_id in
  let* rhs =
    if is_recursive then local extend (compile_exp exp) else compile_exp exp
  in
  let* () = emit_def def_id ~name ~location ~rhs in
  return extend

let compile_bindings (l : Cat.binding list) : node_map =
  let rec compile_all = function
    | [] -> Build.return ()
    | binding :: rest ->
        let open Build in
        let* extend = compile_binding binding in
        local extend (compile_all rest)
  in
  let st, () = Build.run (compile_all l) in
  Build.nodes st

module Var = struct
  type t = var

  let compare = Id.compare
  let pp = Id.pp
end

type t = { node_map : node_map; dependents_map : var -> var list }

(* let missing_node nid = *)
(*   failwith (Format.asprintf "Missing node: %a" Id.pp nid) *)

(* let missing_def did = failwith (Format.asprintf "Missing node: %a" Id.pp did) *)

let get_node_opt (t : t) (nid : node_id) : node option =
  NodeMap.find_opt nid t.node_map

(* [get_node] raises [Not_found] when [nid] is not present in the graph. *)
let get_node (t : t) (nid : node_id) : node =
  match get_node_opt t nid with Some n -> n | None -> raise Not_found

module VarMap = Map.Make (Var)

let build_dependents ~(nm : node_map) : var -> var list =
  let add_edge m ~from_ ~to_ =
    let old = Option.value ~default:[] (VarMap.find_opt from_ m) in
    VarMap.add from_ (to_ :: old) m
  in
  let rev_map =
    NodeMap.fold
      (fun n_id n acc ->
        Node.children n
        |> List.fold_left (fun acc c -> add_edge acc ~from_:c ~to_:n_id) acc)
      nm VarMap.empty
  in
  fun v -> Option.value ~default:[] (VarMap.find_opt v rev_map)

let build (l : Cat.binding list) : t =
  let node_map = compile_bindings l in
  let dependents_map = build_dependents ~nm:node_map in
  { node_map; dependents_map }

let all_toplevel_defs (t : t) : def_id list =
  NodeMap.bindings t.node_map
  |> List.filter_map (function
    | id, Node.Def _ -> Some id
    | _, Node.Expr { expr = _; children = _ } -> None)

let all_vars (t : t) : var list = NodeMap.bindings t.node_map |> List.map fst
let dependents t = t.dependents_map

let pp fmt (t : t) =
  let open Format in
  fprintf fmt "@[<v>nodes:@,";
  NodeMap.iter
    (fun nid node -> fprintf fmt "  %a: %a@," Id.pp nid Node.pp_node node)
    t.node_map;
  fprintf fmt "@]"
