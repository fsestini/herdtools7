type loop_boundaries = { proc : int; start_spoi : int; end_spoi : int }
type 'rel lasso_rels = { rf : 'rel; po : 'rel; co : 'rel; rf_reg : 'rel }
type 'ev iteration = { events : 'ev list; branch_event : 'ev }

type ('ev, 'rel) lasso = {
  iteration : 'ev iteration;
  initial_weights : 'rel lasso_rels;
}

type 'a weighted_lasso =
  Lasso : (module WeightedRel.S with type t = 'rel and type elt = 'a)
        * ('a, 'rel) lasso
       -> 'ev weighted_lasso

module Make (S : SemExtra.S) (WR : WeightedRel.S with type elt = S.E.event) : sig
  module E := S.E

  type nonrec iteration = E.event iteration
  type nonrec lasso = (E.event, WR.t) lasso

  val find_static_loop_boundaries :
    cutoff:E.event -> E.event_structure -> loop_boundaries

  val iterations_of_loop : loop_boundaries -> E.EventSet.t -> iteration list

  val compute_lasso_weights :
    lasso_candidate:iteration ->
    predecessor:iteration ->
    E.event_rel lasso_rels ->
    WR.t lasso_rels

  val find_lasso :
    S.concrete ->
    rf_reg:E.event_rel ->
    rf:E.event_rel ->
    co:E.event_rel ->
    [ `Finite | `Infinite of lasso | `Unsupported of string ]
end
