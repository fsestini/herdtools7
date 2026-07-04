open Herdlib
module WeightedRel = Loop_detection.WeightedRel
module W = WeightedRel.SetWeights
module NodeSet = MySet.Make (Int)
module WR = WeightedRel.Make (W) (Int)
module I = Loop_detection.LazyInterpreter.Make (NodeSet) (W) (WR)

module Parser = ParseModel.Make (struct
  let debug = false
  let libfind file = file
end)

let int_set xs = List.fold_left (fun acc x -> IntSet.add x acc) IntSet.empty xs
let finite xs = W.Int_set (int_set xs)
let nodes xs = List.fold_left (fun acc x -> NodeSet.add x acc) NodeSet.empty xs
let rel edges = WR.of_list edges
let zero = finite [ 0 ]
let one = finite [ 1 ]

let parse_cat file =
  let _, _, ins = Parser.parse file in
  ins

let events = nodes [ 1; 2; 3; 4 ]
let r = rel [ (1, 2, zero); (2, 3, zero) ]
let s = rel [ (2, 3, one); (3, 4, one) ]
let fr = rel [ (2, 1, zero) ]
let co = rel [ (4, 1, one) ]

let builtins =
  StringMap.empty |> StringMap.add "r" r |> StringMap.add "s" s
  |> StringMap.add "fr" fr

let with_overrides = StringMap.empty |> StringMap.add "co" co
let pp_int = Format.pp_print_int

let print_rel env name =
  let rel = I.force_rel env name in
  Format.printf "%s = %a@." name (WR.pp pp_int) rel

let print_force_failure env name =
  try
    let _ = I.force_rel env name in
    Format.printf "%s = <unexpected success>@." name
  with _ -> Format.printf "%s = <failed>@." name

let env = I.interpret ~events ~builtins ~with_overrides (parse_cat "lazy.cat")

let () =
  print_rel env "good";
  print_rel env "ca";
  print_force_failure env "demanded_tlbi"
