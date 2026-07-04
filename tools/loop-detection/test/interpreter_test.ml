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

let pp_int = Format.pp_print_int

let print_binding ?(prefix = "") env name =
  match StringMap.find_opt name env with
  | None -> Format.printf "%s%s = <missing>@." prefix name
  | Some rel -> Format.printf "%s%s = %a@." prefix name (WR.pp pp_int) rel

let print_env_bindings ?prefix env names =
  List.iter (print_binding ?prefix env) names

let finite_env = I.interpret ~events ~builtins (parse_cat "toy.cat")

let lasso_env =
  I.interpret ~events ~lasso_events:(nodes [ 3; 4 ]) ~builtins:StringMap.empty
    (parse_cat "lasso_cartesian.cat")

let () =
  print_env_bindings finite_env
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
      "rplus";
      "rstar";
      "ropt";
      "tc";
    ];
  print_env_bindings ~prefix:"lasso." lasso_env [ "ids"; "all_pairs" ]
