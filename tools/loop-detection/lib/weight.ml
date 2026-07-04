exception Unsupported of string

module type S = sig
  type t

  val empty : t
  val top : t
  val singleton : int -> t
  val at_least : int -> t
  val at_most : int -> t
  val is_empty : t -> bool
  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
  val union : t -> t -> t
  val intersection : t -> t -> t
  val diff : t -> t -> t
  val inverse : t -> t
  val plus : t -> t -> t
  val widen : t -> t -> t
end
