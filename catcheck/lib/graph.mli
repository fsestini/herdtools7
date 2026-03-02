module DefId : sig
  type t

  val pp : Format.formatter -> t -> unit
end

module NodeId : sig
  type t

  val pp : Format.formatter -> t -> unit
end

type def_id = DefId.t
type node_id = NodeId.t

module Var : sig
  type t = VNode of node_id | VDef of def_id

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

type node = Node.t
type var = Var.t
type t

val build : Cat.binding list -> t
val get_node : t -> node_id -> node
val get_def_root : t -> def_id -> node_id
val all_vars : t -> var list
val depends_on : t -> var -> var list
val pp : Format.formatter -> t -> unit
