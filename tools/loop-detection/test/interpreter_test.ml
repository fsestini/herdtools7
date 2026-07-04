open Herdlib
module WeightedRel = Loop_detection.WeightedRel
module W = Loop_detection.IntervalWeights
module NodeSet = MySet.Make (Int)
module WR = WeightedRel.Make (W) (Int)
module I = Loop_detection.Interpreter.Make (NodeSet) (W) (WR)

module Parser = ParseModel.Make (struct
  let debug = false
  let libfind file = file
end)

let finite xs =
  List.fold_left (fun acc x -> W.union acc (W.singleton x)) W.empty xs

let nodes xs = List.fold_left (fun acc x -> NodeSet.add x acc) NodeSet.empty xs
let rel edges = WR.of_list edges
let zero = finite [ 0 ]

let parse_cat file =
  let _, _, ins = Parser.parse file in
  ins

let events = nodes [ 1; 2; 3; 4 ]
let event_list = NodeSet.elements events
let r = rel [ (1, 2, zero); (2, 3, zero) ]
let s = rel [ (2, 3, zero); (3, 4, zero) ]
let id = rel (List.map (fun i -> (i, i, zero)) event_list)
let fl = rel [ (1, 2, W.at_least 1) ]
let lf = rel [ (2, 3, W.at_most (-1)) ]
let ll = rel [ (2, 2, W.top) ]

let builtins =
  StringMap.empty |> StringMap.add "r" r |> StringMap.add "s" s
  |> StringMap.add "id" id

let lasso_builtins =
  StringMap.empty |> StringMap.add "fl" fl |> StringMap.add "lf" lf
  |> StringMap.add "ll" ll

let pp_int = Format.pp_print_int

let print_binding ?(prefix = "") env name =
  match StringMap.find_opt name env with
  | None -> Format.printf "%s%s = <missing>@." prefix name
  | Some rel -> Format.printf "%s%s = %a@." prefix name (WR.pp pp_int) rel

let print_env_bindings ?prefix env names =
  List.iter (print_binding ?prefix env) names

let finite_env = I.interpret ~events ~builtins (parse_cat "toy.cat")

let lasso_env =
  I.interpret ~events
    ~lasso_events:(nodes [ 3; 4 ])
    ~builtins:StringMap.empty
    (parse_cat "lasso_cartesian.cat")

let lasso_sequence_env =
  I.interpret ~events
    ~lasso_events:(nodes [ 2 ])
    ~builtins:lasso_builtins
    (parse_cat "lasso_sequence.cat")

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
let () =
  print_env_bindings ~prefix:"lasso_sequence." lasso_sequence_env
    [ "finite_to_finite"; "lasso_to_finite" ]
