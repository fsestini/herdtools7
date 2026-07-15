type 'ev lasso
type 'rel lazy_env = (string * 'rel Lazy.t) list

val lasso_events : 'ev lasso -> 'ev list

module Make (S : SemExtra.S) (WR : WeightedRel.S with type elt = S.E.event) : sig
  module E := S.E

  type lasso := E.event lasso

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
