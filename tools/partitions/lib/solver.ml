module Lit = Minisat.Lit

type lit = Lit.t
type t = { solver : Minisat.t; lit_counter : int ref }
type solution = bool StringMap.t

let create () = { solver = Minisat.create (); lit_counter = ref 1 }

let fresh_lit t : lit =
  let n = !(t.lit_counter) in
  t.lit_counter := n + 1;
  Lit.make n

let add_clause t f =
  let cnf = Logic.to_cnf f in
  let clauses =
    cnf
    |> List.map
         (List.map (function
           | Logic.Var v -> v
           | Logic.Neg v -> Lit.apply_sign false v))
  in
  clauses |> List.iter (Minisat.add_clause_l t.solver)

let solve t = Minisat.solve t.solver

let value t l =
  let b = Minisat.value t.solver l in
  match b with
  | Minisat.V_true -> true
  | Minisat.V_false -> false
  | Minisat.V_undef -> failwith "Undefined value"

let exclude t sol =
  let clause =
    sol |> List.map (fun (l, b) -> if b then Lit.apply_sign false l else l)
  in
  Minisat.add_clause_l t.solver clause
