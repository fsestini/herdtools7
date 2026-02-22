open Partitions

let text : string =
  {|
  subseteq R,W M
  subseteq IW W
  disjoint R,W
  disjoint Exp,Imp
  |}

let () =
  Format.printf "Parsed:@.";
  let module P = Solver.Parser in
  let parsed = P.parse_all text in
  parsed |> List.iter (fun x -> Format.printf "%a@." P.pp x)
