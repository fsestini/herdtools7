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
    | Def of { name : string; location : TxtLoc.t; rhs : node_id }
    | Expr of { expr : AST.exp; children : Id.t list }

  val children : t -> Id.t list
  val location : t -> TxtLoc.t
end

type node = Node.t
type t

val build : Cat.binding list -> t

val get_node : t -> Id.t -> node
(** [get_node t id] raises [Not_found] when [id] is not present in the graph. *)

val get_parent : t -> node_id -> node_id
(** [get_parent t id] returns the unique parent of expression node [id]. The
    parent may be either another expression node or a definition node whose RHS
    is [id].

    @raise Not_found when [id] is absent.
    @raise Invalid_argument when [id] is a definition node
    @raise Failure
      when the graph invariant that expression nodes have exactly one parent is
      violated. *)

val all_vars : t -> var list
val all_toplevel_defs : t -> def_id list

val dependents : t -> var -> var list
(** [dependents t v] returns the immediate reverse dependencies of [v]: graph
    nodes whose [Node.children] contain [v]. *)

val pp : Format.formatter -> t -> unit
