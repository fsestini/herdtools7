type t = bool * CatSet.t

let known set = (false, set)
let unknown_within set = (true, set)
let is_tainted (tainted, _) = tainted
let carrier (_, set) = set
let bottom = known CatSet.empty
let universe = known CatSet.universe
let top = unknown_within CatSet.universe
let equal = Misc.pair_eq Bool.equal CatSet.equal
let pp fmt t = CatSet.pp fmt (carrier t)

let lift2 f x y =
  let tainted_x, set_x = x in
  let tainted_y, set_y = y in
  (tainted_x || tainted_y, f set_x set_y)

let union = lift2 CatSet.union
let inter = lift2 CatSet.inter

let diff (t_x, set_x) (t_y, set_y) =
  let t = t_x || t_y in
  if t_y then (t, set_x) else (t, CatSet.diff set_x set_y)

let comp (t, x) = if t then top else (false, CatSet.diff CatSet.universe x)
let taint x = unknown_within (carrier x)
