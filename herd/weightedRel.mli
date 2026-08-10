exception Unsupported of string

type kind = [ `Finite | `Infinite ]

module type S = sig
  type elt
  type weight = Weight.t
  type t

  (** The copy semantics of an endpoint. *)
  val kind : elt -> kind

  val equal : t -> t -> bool
  val compare : t -> t -> int

  val empty : t
  val of_list : (elt * elt * weight) list -> t
  val to_list : t -> (elt * elt * weight) list
  val add : elt * elt * weight -> t -> t
  val succs : t -> elt -> (elt * weight) list
  val fold : (elt * elt * weight -> 'a -> 'a) -> t -> 'a -> 'a
  val cartesian : elt list -> elt list -> weight -> t
  val union : t -> t -> t
  val intersection : t -> t -> t
  val diff : t -> t -> t
  val inverse : t -> t
  val sequence : t -> t -> t
  val filter : (elt -> elt -> weight -> bool) -> t -> t
  val transitive_closure : t -> t option

  val pp : (Format.formatter -> elt -> unit) -> Format.formatter -> t -> unit
end

module Make
    (Elt : sig
      include Set.OrderedType

      (** Classify an element as a single event or an infinite family of
          copies. The classification must be stable. *)
      val kind : t -> kind
    end) :
  S with type elt = Elt.t

(** View a weighted relation as an [InnerRel.S] relation, so that it can be used
    in contexts that expect [InnerRel.S] structures (such as [Interpreter]).
    Not all [InnerRel.S] operations are supported, and some of them are not even
    well-defined in a weighted context.

    @raise [Unsupported] on unsupported operations. *)
module MakeInnerRel
    (Elts : MySet.S)
    (WR : S with type elt = Elts.elt) :
  InnerRel.S with
    type elt0 = Elts.elt
    and module Elts = Elts
    and type t = WR.t
