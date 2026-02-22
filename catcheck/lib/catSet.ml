module Atom = struct
  type t = Pure_R | A | Pure_W | L | MMU_fault | Other_fault | Unknown

  let compare = Stdlib.compare

  let to_string = function
    | Pure_R -> "R\\A"
    | Pure_W -> "W\\L"
    | A -> "A"
    | L -> "L"
    | MMU_fault -> "MMU"
    | Other_fault -> "Fault\\MMU"
    | Unknown -> "U\\(...)"
end

module S = Set.Make (Atom)

type t = S.t

let universe : t =
  S.of_list Atom.[ Pure_R; Pure_W; A; L; MMU_fault; Other_fault; Unknown ]

(* let rec of_ident = function *)
let rec of_primitive_set = function
  | "R" -> S.of_list Atom.[ Pure_R; A ]
  | "W" -> S.of_list Atom.[ Pure_W; L ]
  | "A" -> S.of_list Atom.[ A ]
  | "L" -> S.of_list Atom.[ L ]
  | "M" -> S.union (of_primitive_set "R") (of_primitive_set "W")
  | "MMU" -> S.singleton Atom.MMU_fault
  | "Fault" -> S.of_list Atom.[ MMU_fault; Other_fault ]
  | "_" -> universe
  | s -> invalid_arg (Format.sprintf "unknown set identifier: %s" s)

let empty : t = S.empty
let union (s1 : t) (s2 : t) : t = S.union s1 s2
let inter (s1 : t) (s2 : t) : t = S.inter s1 s2
let is_subset s1 s2 = S.subset s1 s2
let equal s1 s2 = S.equal s1 s2

let rec of_set_expr (e : AST.exp) : t =
  let open AST in
  match e with
  | Var (_, s) -> of_primitive_set s
  | Op (_, Union, es) -> List.fold_left union empty (List.map of_set_expr es)
  | Op (_, Inter, es) -> List.fold_left inter universe (List.map of_set_expr es)
  | Op (_, Diff, [ x; y ]) -> S.diff (of_set_expr x) (of_set_expr y)
  | Op1 (_, Inv, e) -> S.diff universe (of_set_expr e)
  | _ -> failwith "invalid set exp"

(* module StringSet = Set.Make (String) *)
(**)
(* let to_string_set : t -> StringSet.t = *)
(*  fun t -> StringSet.of_list (List.map Atom.to_string (S.to_list t)) *)
(**)
(* let to_pretty_string_set t = *)
(*   if S.equal t universe then StringSet.singleton "Univ" *)
(*   else *)
(*     let str_s = to_string_set t in *)
(*     let r_set = of_ident "R" |> to_string_set in *)
(*     let str_s = *)
(*       if StringSet.subset r_set str_s then *)
(*         StringSet.add "R" (StringSet.diff str_s r_set) *)
(*       else str_s *)
(*     in *)
(*     let w_set = of_ident "W" |> to_string_set in *)
(*     let str_s = *)
(*       if StringSet.subset w_set str_s then *)
(*         StringSet.add "W" (StringSet.diff str_s w_set) *)
(*       else str_s *)
(*     in *)
(*     str_s *)

let pp fmt t =
  let l = t |> S.to_list |> List.map Atom.to_string in
  Format.fprintf fmt "%s" (String.concat " ⊔ " l)

(* let pp fmt t = *)
(*   let s = to_pretty_string_set t in *)
(*   Format.fprintf fmt "%s" (String.concat " ⊔ " (StringSet.to_list s)) *)
