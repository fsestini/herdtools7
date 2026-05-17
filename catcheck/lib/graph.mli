module Id : sig
  type t

  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
end

type def_id = Id.t
type node_id = Id.t
type var = Id.t

module Var : sig
  type t = var

  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
end

module Node : sig
  type t = Def of { name : string; rhs : node_id } | Expr of Id.t list

  val children : t -> Id.t list
end

type node = Node.t
type t

val build : Cat.binding list -> t
val get_node_opt : t -> Id.t -> node option
val get_def_node_opt : t -> def_id -> node option
val get_expr_node_opt : t -> node_id -> node option
val get_def_rhs : t -> def_id -> node_id
val get_expr_opt : t -> node_id -> AST.exp option

val get_node : t -> Id.t -> node
(** [get_node t id] raises [Not_found] when [id] is not present in the graph. *)

val get_expr_node : t -> node_id -> node
(** [get_expr_node t nid] raises [Not_found] when [nid] is not an expression
    node ID. This includes IDs that are valid definition IDs and IDs that are
    not present in the graph at all. *)

val get_expr : t -> node_id -> AST.exp
(** [get_expr t nid] raises [Not_found] when [nid] is not an expression node ID.
    This includes IDs that are valid definition IDs and IDs that are not present
    in the graph at all. *)

val get_node_expr : t -> node_id -> node * AST.exp
(** [get_node_expr t nid] raises [Not_found] when [nid] is not an expression
    node ID, or when graph storage is inconsistent and only the topology or
    expression entry is present. *)

val get_expr_location : t -> node_id -> TxtLoc.t
val all_vars : t -> var list
val all_defs : t -> def_id list
val all_expr_nodes : t -> node_id list
val depends_on : t -> var -> var list
val pp : Format.formatter -> t -> unit
