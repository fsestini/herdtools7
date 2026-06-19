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
  let module P = Top.Parser in
  let parsed = P.parse_all text in
  parsed |> List.iter (fun x -> Format.printf "%a@." P.pp x)
