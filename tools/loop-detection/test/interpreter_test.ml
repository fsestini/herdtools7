open Herdlib
module WeightedRel = Loop_detection.WeightedRel
module W = WeightedRel.SetWeights
module NodeSet = MySet.Make (Int)
module WR = WeightedRel.Make (W) (Int)
module I = Loop_detection.Interpreter.Make (NodeSet) (W) (WR)

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
let event_list = NodeSet.elements events
let r = rel [ (1, 2, zero); (2, 3, zero) ]
let s = rel [ (2, 3, one); (3, 4, one) ]
let id = rel (List.map (fun i -> (i, i, zero)) event_list)

let builtins =
  StringMap.empty |> StringMap.add "r" r |> StringMap.add "s" s
  |> StringMap.add "id" id

let env = I.interpret ~events ~builtins (parse_cat "toy.cat")
let pp_int = Format.pp_print_int

let print_binding name =
  match StringMap.find_opt name env with
  | None -> Format.printf "%s = <missing>@." name
  | Some rel -> Format.printf "%s = %a@." name (WR.pp pp_int) rel

let () =
  List.iter print_binding
    [
      "seq";
      "fun_seq";
      "unioned";
      "inv";
      "none";
      "ids";
      "all_pairs";
      "without_id";
      "empty_id";
      "tc";
    ]
