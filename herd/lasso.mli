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

val lasso_events : 'ev lasso -> 'ev list

module Builder (E : Event.S) : sig
  val find_lasso :
    E.event_structure ->
    [ `Finite | `Infinite of E.event lasso | `Unsupported of string ]

  (** Restrict an edge's offsets to those allowed by its lasso endpoints. *)
  val restrict_weight :
    E.event lasso -> E.event -> E.event -> Weight.t -> Weight.t
end

module Weights
    (E : Event.S)
    (WR : WeightedRel.S with type elt = E.event) : sig
  val compute_initial_weights :
    E.event lasso -> E.event_rel lazy_env -> WR.t lazy_env
end
