(* exception Unsupported of string *)

(* type loop_boundaries = { proc : int; start_spoi : int; end_spoi : int } *)
(* type 'rel lasso_rels = { rf : 'rel; po : 'rel; co : 'rel; rf_reg : 'rel } *)
(* type 'ev iteration = { events : 'ev list; branch_event : 'ev } *)

type 'ev lasso

val lasso_events : 'ev lasso -> 'ev list

type 'rel lazy_env = (string * 'rel Lazy.t) list

(* type 'a weighted_lasso = *)
(*   Lasso : (module WeightedRel.S with type t = 'rel and type elt = 'a) *)
(*         * ('a, 'rel) lasso *)
(*        -> 'ev weighted_lasso *)

module Make (S : SemExtra.S) (WR : WeightedRel.S with type elt = S.E.event) : sig
  module E := S.E

  type lasso := E.event lasso

  (* val find_static_loop_boundaries : *)
  (*   cutoff:E.event -> E.event_structure -> loop_boundaries *)

  (* val iterations_of_loop : loop_boundaries -> E.EventSet.t -> iteration list *)

  val find_lasso :
    E.event_structure -> [ `Finite | `Infinite of lasso | `Unsupported of string ]

  val compute_initial_weights :
    lasso -> E.event_rel lazy_env -> (WR.t lazy_env, string) result

  (* val compute_lasso_weights : *)
  (*   lasso_candidate:iteration -> *)
  (*   predecessor:iteration -> *)
  (*   E.event_rel lasso_rels -> *)
  (*   WR.t lasso_rels *)

  (* val find_lasso : *)
  (*   S.concrete -> *)
  (*   rf_reg:E.event_rel -> *)
  (*   rf:E.event_rel -> *)
  (*   co:E.event_rel -> *)
  (*   [ `Finite | `Infinite of lasso | `Unsupported of string ] *)
end
