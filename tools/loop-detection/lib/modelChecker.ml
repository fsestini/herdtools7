open Herdlib

module Make (S : SemExtra.S) = struct
  let check : S.concrete -> unit = fun _conc -> ()
end
