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
  val add : elt * elt * weight -> t -> t
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

(** View a weighted relation as an [InnerRel.S] relation.

    Every relation satisfying [S] contains only non-empty weights permitted by
    its endpoint kinds: finite-to-finite edges have weight [{0}], edges from a
    finite to an infinite endpoint have a strictly positive weight, edges in
    the reverse direction have a strictly negative weight, and
    infinite-to-infinite edges may have any weight.

    Only weighted algebra, Cartesian construction, orbit-saturated endpoint
    restrictions, zero-offset identity and zero-offset cycle checks are
    defined. Comparison is structural and works for all weighted relations;
    [all_topos_kont_rel] is available when all requested nodes and all relation
    endpoints are finite, by delegating to [InnerRel]. Legacy pair-set
    operations, such as membership, traversal and projection to event sets,
    raise [Unsupported] until their lasso semantics is defined. *)
module MakeInnerRel
    (Elts : MySet.S)
    (WR : S with type elt = Elts.elt) :
  InnerRel.S with
    type elt0 = Elts.elt
    and module Elts = Elts
    and type t = WR.t
