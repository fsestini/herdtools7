open Herdlib
module SW = WeightedRel.SetWeights

module Make
    (S : SemExtra.S)
    (WR : WeightedRel.S with type elt = S.E.event and type weight = SW.t) =
struct
  module E = S.E
  module I = LazyInterpreter.Make (S.E.EventSet) (SW) (WR)

  let check (conc : S.concrete) (lasso_events : E.event list)
      (builtins : (string * WR.t) list) (model : AST.ins list) : string -> WR.t
      =
    let events = conc.S.str.events in
    let lasso_events = E.EventSet.of_list lasso_events in
    let builtins = StringMap.of_list builtins in
    let with_overrides = StringMap.empty in
    let interpreted =
      I.interpret ~lasso_events ~events ~builtins ~with_overrides model
    in
    fun sym -> I.force_rel interpreted sym
end
