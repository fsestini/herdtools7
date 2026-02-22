type t

val of_primitive_set : string -> t
val union : t -> t -> t
val inter : t -> t -> t
val empty : t
val universe : t
val is_subset : t -> t -> bool
val equal : t -> t -> bool
val pp : Format.formatter -> t -> unit
val of_set_expr : AST.exp -> t
