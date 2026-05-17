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
  type t =
    | Ref of TxtLoc.t * def_id
    | Base of TxtLoc.t * string (* other builtins / primitives *)
    | Op1 of TxtLoc.t * AST.op1 * node_id
    | Op of TxtLoc.t * AST.op2 * node_id list
    | Try of TxtLoc.t * node_id * node_id
    | If of TxtLoc.t * node_id * node_id
    | Unsupported of TxtLoc.t

  val location : t -> TxtLoc.t
end

module Def : sig
  type t = { name : string; rhs : node_id }

  val pp : Format.formatter -> t -> unit
end

type node = Node.t
type def = Def.t
type t

val build : Cat.binding list -> t
val get_node_opt : t -> node_id -> node option
val get_def_opt : t -> def_id -> def option

val get_node : t -> node_id -> node
(** [get_node t nid] raises [Not_found] when [nid] is not an expression node ID.
    This includes IDs that are valid definition IDs and IDs that are not present
    in the graph at all. *)

val all_vars : t -> var list
val all_defs : t -> def_id list
val all_nodes : t -> node_id list
val depends_on : t -> var -> var list
val pp : Format.formatter -> t -> unit
