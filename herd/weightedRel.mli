exception Unsupported of string

type kind = [ `Finite | `Infinite ]

module type S = sig
  type elt
  type weight = Weight.t
  type t

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

module WeightedElt : sig
  type 'elt t = { elt : 'elt; kind : kind }
  val elt : 'elt t -> 'elt
  val kind : 'elt t -> kind
  val make : 'elt -> kind -> 'elt t
  val make_finite : 'elt -> 'elt t
  val make_infinite : 'elt -> 'elt t
  val is_finite : 'elt t -> bool
end

type 'elt weighted_elt = 'elt WeightedElt.t

(** View a weighted relation as an [InnerRel.S] relation, so that it can be used
    in contexts that expect [InnerRel.S] structures (such as [Interpreter]).
    Not all [InnerRel.S] operations are supported, and some of them are not even
    well-defined in a weighted context. Unsupported operations raise [Unsupported]. *)
module MakeInnerRel
    (O : MySet.OrderedType)
    (WR : S with type elt = O.t weighted_elt) :
  InnerRel.S with type elt0 = WR.elt and type t = WR.t
