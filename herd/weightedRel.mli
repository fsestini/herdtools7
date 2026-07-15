module type S = sig
  type elt
  type weight = Weight.t
  type t

  val equal : t -> t -> bool

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

      (** Restrict the weights permitted on an edge between two elements. *)
      val restrict_weight : t -> t -> Weight.t -> Weight.t
    end) :
  S with type elt = Elt.t
