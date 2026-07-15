type 'ev lasso
type 'rel lazy_env = (string * 'rel Lazy.t) list

val lasso_events : 'ev lasso -> 'ev list

module Builder (E : Event.S) : sig
  val find_lasso :
    E.event_structure ->
    [ `Finite | `Infinite of E.event lasso | `Unsupported of string ]
end

module Weights
    (E : Event.S)
    (WR : WeightedRel.S with type elt = E.event) : sig
  val compute_initial_weights :
    E.event lasso -> E.event_rel lazy_env -> (WR.t lazy_env, string) result
end
