type binding = { name : string; exp : AST.exp; is_recursive : bool }

module MakeParser (O : sig
  val libdir : string
end) =
struct
  module ML = MyLib.Make (struct
    let includes = []
    let env = Some "HERDLIB"
    let debug = false
    let libdir = O.libdir
  end)

  module ParserConfig = struct
    let debug = false
    let libfind = ML.find
  end

  module Parser = ParseModel.Make (ParserConfig)

  let rec read_bindings_ =
    let of_bindings bs =
      bs
      |> List.concat_map (function
        | _, AST.Pvar (Some name), exp ->
            [ { name; exp; is_recursive = false } ]
        | _ -> [])
    in
    fun ~seen fname ->
      if StringSet.mem fname seen then []
      else
        let _, (_, _, ast) = Parser.find_parse fname in
        ast
        |> List.concat_map (function
          | AST.Include (_, fname) ->
              let seen = StringSet.add fname seen in
              read_bindings_ ~seen fname
          | AST.Let (_, bs) -> of_bindings bs
          | AST.Rec (_, bs, _) -> of_bindings bs
          | _ -> [])

  let read_bindings = read_bindings_ ~seen:StringSet.empty
end

(* let ident s = Ident s *)
(* let binop op exps = Binop (op, exps) *)
(* let unaop op exp = Unaop (op, exp) *)
(* let union exps = binop Union exps *)
(* let inter exps = binop Inter exps *)
(* let diff exps = binop Diff exps *)
(* let seq exps = binop Seq exps *)
(* let plus exp = unaop Plus exp *)
(* let star exp = unaop Star exp *)
(* let opt exp = unaop Opt exp *)
(* let comp exp = unaop Comp exp *)
(* let inv exp = unaop Inv exp *)
(* let to_id exp = To_id exp *)
(* let let_ name exp = Let (name, exp) *)
(* let let_rec name exp = Let_rec (name, exp) *)
(**)
(* let pp_exp = *)
(*   let open Format in *)
(*   let prec_of = function *)
(*     | Ident _ | To_id _ -> 6 *)
(*     | Unaop ((Plus | Star | Opt | Inv), _) -> 5 *)
(*     | Unaop (Comp, _) -> 4 *)
(*     | Binop (Diff, _) -> 4 *)
(*     | Binop (Seq, _) -> 3 *)
(*     | Binop (Inter, _) -> 2 *)
(*     | Binop (Union, _) -> 1 *)
(*   in *)
(**)
(*   let rec pp_with_prec parent_prec fmt exp = *)
(*     let curr_prec = prec_of exp in *)
(*     let needs_parens = curr_prec < parent_prec in *)
(**)
(*     if needs_parens then fprintf fmt "("; *)
(**)
(*     begin match exp with *)
(*     | Ident n -> fprintf fmt "%s" n *)
(*     | To_id exp -> *)
(*         fprintf fmt "["; *)
(*         pp_with_prec 0 fmt exp; *)
(*         fprintf fmt "]" *)
(*     | Binop (Union, []) -> fprintf fmt "empty" *)
(*     | Binop (Union, exps) -> *)
(*         pp_print_list *)
(*           ~pp_sep:(fun fmt () -> fprintf fmt " | ") *)
(*           (pp_with_prec curr_prec) fmt exps *)
(*     | Binop (Diff, []) -> fprintf fmt "empty" *)
(*     | Binop (Diff, [ exp ]) -> pp_with_prec curr_prec fmt exp *)
(*     | Binop (Diff, exps) -> *)
(*         pp_print_list *)
(*           ~pp_sep:(fun fmt () -> fprintf fmt " \\ ") *)
(*           (pp_with_prec curr_prec) fmt exps *)
(*     | Binop (Seq, exps) -> *)
(*         pp_print_list *)
(*           ~pp_sep:(fun fmt () -> fprintf fmt "; ") *)
(*           (pp_with_prec curr_prec) fmt exps *)
(*     | Binop (Inter, []) -> fprintf fmt "_" *)
(*     | Binop (Inter, exps) -> *)
(*         pp_print_list *)
(*           ~pp_sep:(fun fmt () -> fprintf fmt " & ") *)
(*           (pp_with_prec curr_prec) fmt exps *)
(*     | Unaop (Plus, exp) -> fprintf fmt "%a+" (pp_with_prec curr_prec) exp *)
(*     | Unaop (Star, exp) -> fprintf fmt "%a*" (pp_with_prec curr_prec) exp *)
(*     | Unaop (Opt, exp) -> fprintf fmt "%a?" (pp_with_prec curr_prec) exp *)
(*     | Unaop (Inv, exp) -> fprintf fmt "%a^-1" (pp_with_prec curr_prec) exp *)
(*     | Unaop (Comp, exp) -> fprintf fmt "~%a" (pp_with_prec curr_prec) exp *)
(*     end; *)
(**)
(*     if needs_parens then fprintf fmt ")" *)
(*   in *)
(**)
(*   pp_with_prec 0 *)
