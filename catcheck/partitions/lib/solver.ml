module Lit = Minisat.Lit

type lit = Lit.t

type t = {
  solver : Minisat.t;
  lit_counter : int ref;
      (* symbols : StringSet.t ref; *)
      (* symbol_map : (string, Lit.t) Hashtbl.t; *)
}

type solution = bool StringMap.t

let create () =
  {
    solver = Minisat.create ();
    lit_counter = ref 1;
    (* symbols = ref StringSet.empty; *)
    (* symbol_map = Hashtbl.create 20; *)
  }

let fresh_lit t _name : lit =
  let n = !(t.lit_counter) in
  t.lit_counter := n + 1;
  let lit = Lit.make n in
  (* Hashtbl.add t.symbol_map name lit; *)
  (* t.symbols := StringSet.add name !(t.symbols); *)
  (* { lit; name } *)
  lit

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

let solve t =
  (* let syms = !(t.symbols) in *)
  Minisat.solve t.solver
(* let lst = *)
(*   StringSet.fold *)
(*     (fun s acc -> *)
(*       let l = Hashtbl.find t.symbol_map s in *)
(*       let value = Minisat.value t.solver l in *)
(*       let b = *)
(*         match value with *)
(*         | Minisat.V_true -> true *)
(*         | Minisat.V_false -> false *)
(*         | Minisat.V_undef -> failwith "Undefined value" *)
(*       in *)
(*       (s, b) :: acc) *)
(*     syms [] *)
(* in *)
(* StringMap.of_list lst *)

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

(* let exclude t sol = *)
(*   let clause = *)
(*     sol |> StringMap.to_list *)
(*     |> List.map (fun (s, b) -> *)
(*         let l = Hashtbl.find t.symbol_map s in *)
(*         if b then Lit.apply_sign false l else l) *)
(*   in *)
(*   Minisat.add_clause_l t.solver clause *)
