open Catcheck

let m_set = CatSet.of_primitive_set "M" |> Option.get
let exp_set = CatSet.of_primitive_set "Exp" |> Option.get
let tagcheck_set = CatSet.of_primitive_set "TagCheck" |> Option.get
let fault_set = CatSet.of_primitive_set "FAULT" |> Option.get
let r_set = CatSet.of_primitive_set "R" |> Option.get
let w_set = CatSet.of_primitive_set "W" |> Option.get
let dc_set = CatSet.of_primitive_set "DC" |> Option.get
let l_set = CatSet.of_primitive_set "L" |> Option.get
let t_set = CatSet.of_primitive_set "T" |> Option.get

(* ( Exp & M | TagCheck & FAULT ) & ~(Exp & R) *)

let test_cases =
  [
    ("M", m_set);
    ("R", CatSet.inter m_set r_set);
    ("M & DC", CatSet.inter m_set dc_set);
    ("L & T", CatSet.inter l_set t_set);
    ("Exp & W & L", CatSet.(inter (inter exp_set l_set) w_set));
    ( "( Exp & M | TagCheck & FAULT ) & ~(Exp & R)",
      CatSet.(
        inter
          (union (inter exp_set m_set) (inter tagcheck_set fault_set))
          (diff universe (inter exp_set r_set))) );
  ]

let () =
  test_cases
  |> List.iter (fun (lbl, s) -> Format.printf "%s  -->  %a@." lbl CatSet.pp s)
