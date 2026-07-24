type t

val equal : t -> t -> bool
val compare : t -> t -> int

val empty : t
val top : t
val singleton : int -> t
val at_least : int -> t
val at_most : int -> t
val is_empty : t -> bool

(** Whether the weight contains arbitrarily small integers. *)
val is_negative_unbounded : t -> bool
val union : t -> t -> t
val intersection : t -> t -> t
val diff : t -> t -> t
val inverse : t -> t
val plus : t -> t -> t

val pp : Format.formatter -> t -> unit
