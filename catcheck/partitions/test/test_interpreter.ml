open Partitions

let pp_string = Format.pp_print_string

let run fname =
  Format.printf "== %s ==@." fname;
  let ins = ModelParser.parse ~libdir:(Some "../libdir") fname in
  let constraints = Interpreter.constraints_of_cat ins in
  List.iter (Format.printf "%a@." (Logic.pp pp_string)) constraints

let () =
  run "cats/simple_cover.cat";
  run "cats/subseteq.cat";
  run "cats/disjoint.cat"
