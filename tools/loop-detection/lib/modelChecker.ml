open Herdlib
module SW = WeightedRel.SetWeights

module Make
    (S : SemExtra.S)
    (WR : WeightedRel.S with type elt = S.E.event and type weight = SW.t) =
struct
  let check : S.concrete -> (string * WR.t) list -> (string * WR.t) list =
   fun _conc _rels -> failwith "NIY"
end
