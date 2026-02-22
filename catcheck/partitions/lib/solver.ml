module Parser = struct
  type parsed =
    | Subseteq of string list * string list
    | Disjoint of string list
    | Cover of string list

  let name_set : parsed -> StringSet.t = function
    | Subseteq (l1, l2) -> StringSet.(union (of_list l1) (of_list l2))
    | Disjoint l -> StringSet.of_list l
    | Cover l -> StringSet.of_list l

  let pp fmt =
    let open Format in
    let pp_list fmt l = fprintf fmt "%s" (String.concat "," l) in
    function
    | Subseteq (l1, l2) -> fprintf fmt "subseteq %a %a" pp_list l1 pp_list l2
    | Disjoint l -> fprintf fmt "disjoint %a" pp_list l
    | Cover l -> fprintf fmt "cover %a" pp_list l

  include (
    struct
      module A = Angstrom

      let ( let* ) = A.( let* )
      let ( <* ) = A.( <* )
      let ( *> ) = A.( *> )
      let is_whitespace = function ' ' | '\n' | '\t' -> true | _ -> false
      let whitespace = A.skip_while is_whitespace
      let whitespace1 = A.skip is_whitespace *> whitespace
      let token p = p <* whitespace

      let symbol =
        A.take_while1 (function
          | 'A' .. 'Z' | 'a' .. 'z' | '-' | '_' | '.' -> true
          | _ -> false)

      let symbol_list = A.sep_by1 (A.char ',') symbol

      let subseteq =
        let* _ = token (A.string "subseteq") in
        let* l1 = symbol_list in
        let* _ = A.char ' ' in
        let* l2 = symbol_list in
        A.return (Subseteq (l1, l2))

      let disjoint =
        let* _ = token (A.string "disjoint") in
        let* l = symbol_list in
        A.return (Disjoint l)

      let cover =
        let* _ = token (A.string "cover") in
        let* l = symbol_list in
        A.return (Cover l)

      let constr = A.choice [ subseteq; disjoint; cover ]

      let parser : parsed list A.t =
        whitespace *> A.sep_by whitespace1 constr <* whitespace

      let parse_all s =
        match A.parse_string ~consume:A.Consume.Prefix parser s with
        | Ok l -> l
        | Error msg -> failwith msg
    end :
      sig
        val parse_all : string -> parsed list
      end)
end

module Lit = Minisat.Lit

type solution = bool StringMap.t

let pp_solution fmt sol =
  let open Format in
  sol |> StringMap.to_list
  |> pp_print_list
       ~pp_sep:(fun fmt () -> pp_print_string fmt " & ")
       (fun fmt (l, b) ->
         let pfx = if b then "" else "~" in
         fprintf fmt "%s%s" pfx l)
       fmt

module Solver : sig
  type t
  type lit

  val create : unit -> t
  val add_constraints : t -> Parser.parsed list -> unit

  val solve : t -> solution
  (** Solve current constraints.
      @raise Minisat.Unsat if UNSAT. *)

  val exclude : t -> solution -> unit
end = struct
  type t = {
    solver : Minisat.t;
    lit_counter : int ref;
    symbols : StringSet.t ref;
    symbol_map : (string, Lit.t) Hashtbl.t;
  }

  type lit = Lit.t * string

  let get_lit : lit -> Lit.t = fst

  let create () =
    {
      solver = Minisat.create ();
      lit_counter = ref 1;
      symbols = ref StringSet.empty;
      symbol_map = Hashtbl.create 20;
    }

  let fresh t s : lit =
    let n = !(t.lit_counter) in
    t.lit_counter := n + 1;
    let l = Lit.make n in
    Hashtbl.add t.symbol_map s l;
    t.symbols := StringSet.add s !(t.symbols);
    (l, s)

  let get_or_create_lit : t -> string -> lit =
   fun t s ->
    match Hashtbl.find_opt t.symbol_map s with
    | Some l -> (l, s)
    | None -> fresh t s

  type constr =
    | Subseteq of lit list * lit list
    | Disjoint of lit list
    | Cover of lit list

  let from_parsed t : Parser.parsed -> constr = function
    | Parser.Subseteq (l1, l2) ->
        let l1 = List.map (get_or_create_lit t) l1 in
        let l2 = List.map (get_or_create_lit t) l2 in
        Subseteq (l1, l2)
    | Parser.Disjoint l ->
        let l = List.map (get_or_create_lit t) l in
        Disjoint l
    | Parser.Cover l ->
        let l = List.map (get_or_create_lit t) l in
        Cover l

  let to_formula : constr -> lit Logic.t = function
    | Subseteq (xs, ys) ->
        let xs = List.map Logic.var xs in
        let ys = List.map Logic.var ys in
        Logic.impl (Logic.disj xs) (Logic.disj ys)
    | Disjoint xs ->
        let xs = List.map Logic.var xs in
        let rec pairwise acc = function
          | [] -> acc
          | x :: rest ->
              let acc =
                List.fold_left
                  (fun acc y -> Logic.disj [ Logic.neg x; Logic.neg y ] :: acc)
                  acc rest
              in
              pairwise acc rest
        in
        let at_most_one = pairwise [] xs in
        Logic.conj at_most_one
    | Cover xs ->
        let xs = List.map Logic.var xs in
        Logic.disj xs

  (* | Exclude l -> *)
  (*     l *)
  (*     |> List.map (fun (v, b) -> *)
  (*         let literal = Logic.var v in *)
  (*         if b then Logic.neg literal else literal) *)
  (*     |> Logic.disj *)

  let to_clauses (t : constr) : Lit.t list list =
    (* let pp_lit = fun fmt (_, s) -> Format.pp_print_string fmt s in *)
    let f = to_formula t in
    (* Format.printf "Formula: %a@." (Logic.pp pp_lit) f; *)
    let cnf = Logic.to_cnf f in
    (* Format.printf "CNF: %a@." (Logic.pp_cnf pp_lit) cnf; *)
    cnf
    |> List.map
         (List.map (function
           | Logic.Var v -> get_lit v
           | Logic.Neg v -> Lit.apply_sign false (get_lit v)))

  let exclude t sol =
    let clause =
      sol |> StringMap.to_list
      |> List.map (fun (s, b) ->
          let l = Hashtbl.find t.symbol_map s in
          if b then Lit.apply_sign false l else l)
    in
    Minisat.add_clause_l t.solver clause

  let add_constraints t l =
    l
    |> List.iter (fun c ->
        let c = from_parsed t c in
        let cs = to_clauses c in
        cs |> List.iter (Minisat.add_clause_l t.solver))

  let solve t =
    let syms = !(t.symbols) in
    Minisat.solve t.solver;
    let lst =
      StringSet.fold
        (fun s acc ->
          let l = Hashtbl.find t.symbol_map s in
          let value = Minisat.value t.solver l in
          let b =
            match value with
            | Minisat.V_true -> true
            | Minisat.V_false -> false
            | Minisat.V_undef -> failwith "undef"
          in
          (s, b) :: acc)
        syms []
    in
    StringMap.of_list lst
end

let run text =
  (* Format.printf "Text: %s@." text; *)
  let parsed = Parser.parse_all text in
  (* Format.printf "Parsed:@."; *)
  (* parsed |> List.iter (fun x -> Format.printf "%a@." Parser.pp x); *)
  let solver = Solver.create () in
  Solver.add_constraints solver parsed;
  let rec loop acc () =
    try
      let solution = Solver.solve solver in
      (* Format.printf "%a@." (pp_solution solver) solution; *)
      Solver.exclude solver solution;
      loop (solution :: acc) ()
    with Minisat.Unsat ->
      Format.printf "unsat.@.";
      acc
  in
  loop [] ()
