exception Unsupported of string

type 'ev lasso
type 'rel lazy_env = (string * 'rel Lazy.t) list
type 'ev weighted_edge = 'ev * 'ev * Weight.t

(** Lossless weighted relations produced for a lasso execution. *)
type 'ev result = {
  lasso_events : 'ev list;
  (** Relations selected by Cat [show] directives and CLI [-doshow]. *)
  shown_rels : (string * 'ev weighted_edge list) list Lazy.t;
  (** All final named relation bindings. *)
  rels : (string * 'ev weighted_edge list) list Lazy.t;
}

type 'ev event = {
  event : 'ev;
  kind : WeightedRel.kind
}

val lasso_events : 'ev lasso -> 'ev list

module Builder (E : Event.S) : sig
  val find_lasso :
    E.event_structure ->
    [ `Finite | `Infinite of E.event lasso | `Unsupported of string ]

  val kind : E.event lasso -> E.event -> WeightedRel.kind
  (** Classify an event as finite or as a representative of infinitely many
      lasso iterations. *)

  val assign_kind : E.event lasso -> E.event -> E.event WeightedRel.weighted_elt
  val classify_events : E.event lasso -> E.event list -> E.event event list
end

module Weights
    (E : Event.S)
    (WR : WeightedRel.S with type elt = E.event WeightedRel.weighted_elt) : sig
  val compute_initial_weights :
    E.event lasso -> E.event_rel lazy_env -> WR.t lazy_env
end
