module Node = Graph.Node
module Id = Graph.Id
module E = TxtLoc.Extract ()

let parse_loc spec =
  let col_sep = String.rindex spec ':' in
  let line_sep = String.rindex_from spec (col_sep - 1) ':' in
  let range =
    String.sub spec (col_sep + 1) (String.length spec - col_sep - 1)
  in
  let range_sep = String.index range '-' in
  let file = String.sub spec 0 line_sep in
  let line = String.sub spec (line_sep + 1) (col_sep - line_sep - 1) in
  let start_col = String.sub range 0 range_sep in
  let end_col =
    String.sub range (range_sep + 1) (String.length range - range_sep - 1)
  in
  (file, int_of_string line, int_of_string start_col, int_of_string end_col)

let loc_matches (file, line, start_col, end_col) (loc : TxtLoc.t) =
  let open Lexing in
  String.equal loc.loc_start.pos_fname file
  && Int.equal loc.loc_start.pos_lnum line
  && Int.equal (loc.loc_start.pos_cnum - loc.loc_start.pos_bol) start_col
  && Int.equal (loc.loc_end.pos_cnum - loc.loc_start.pos_bol) end_col

let pp_source fmt loc = Format.pp_print_string fmt (E.extract loc)

let pp_txtloc fmt (loc : TxtLoc.t) =
  let open Lexing in
  let start_col = loc.loc_start.pos_cnum - loc.loc_start.pos_bol in
  let end_col = loc.loc_end.pos_cnum - loc.loc_start.pos_bol in
  Format.fprintf fmt "File %S, line %d, characters %d-%d"
    loc.loc_start.pos_fname loc.loc_start.pos_lnum start_col end_col

let pp_node_kind fmt = function
  | Node.Def { name; _ } -> Format.fprintf fmt "definition %S" name
  | Node.Expr _ -> Format.pp_print_string fmt "expression"

let pp_combined_set combined_set fmt v =
  match combined_set v with
  | Some combined -> Format.fprintf fmt "%a" CatSet.pp combined
  | None -> Format.pp_print_string fmt "<not a set>"

let trace_node ~graph:g ~fw_map ~bw_map ~pp_domain fmt v =
  let node = Graph.get_node g v in
  let loc = Node.location node in
  Format.fprintf fmt "node %a (%a) at %a:@." Graph.Id.pp v pp_node_kind node
    pp_txtloc loc;
  Format.fprintf fmt "  source: %a@." pp_source loc;
  Format.fprintf fmt "  fw:     %a@." pp_domain (fw_map v);
  Format.fprintf fmt "  bw:     %a@." pp_domain (bw_map v)

let trace_ancestor_chain ~graph:g ~fw_map ~bw_map ~pp_domain fmt start =
  let max_depth = 64 in
  let trace_node = trace_node ~graph:g ~fw_map ~bw_map ~pp_domain in
  let rec loop depth seen child =
    if depth > max_depth then
      Format.fprintf fmt
        "ancestor trace stopped after %d edges; graph may contain a cycle@."
        max_depth
    else if List.exists (Id.equal child) seen then
      Format.fprintf fmt
        "ancestor trace stopped at node %a; graph contains a cycle@."
        Graph.Id.pp child
    else
      let parent = Graph.get_parent g child in
      trace_node fmt parent;
      match Graph.get_node g parent with
      | Node.Def _ -> ()
      | Node.Expr _ -> loop (depth + 1) (child :: seen) parent
  in
  loop 0 [] start

let run_if_requested ~graph:g ~fw_map ~bw_map ~pp_domain =
  match Sys.getenv_opt "CATCHECK_TRACE_LOC" with
  | None -> ()
  | Some spec -> (
      match parse_loc spec with
      | exception (Invalid_argument _ | Not_found) ->
          Format.eprintf
            "CATCHECK_TRACE_LOC: expected path:line:start_col-end_col, got %S@."
            spec
      | target ->
          let trace_node = trace_node ~graph:g ~fw_map ~bw_map ~pp_domain in
          let trace_ancestor_chain =
            trace_ancestor_chain ~graph:g ~fw_map ~bw_map ~pp_domain
          in
          Graph.all_vars g
          |> List.iter (fun v ->
              match Graph.get_node g v with
              | Node.Def _ -> ()
              | Node.Expr _ as node ->
                  let loc = Node.location node in
                  if loc_matches target loc then (
                    Format.eprintf "@[<v>CATCHECK_TRACE_LOC %s@," spec;
                    trace_node Format.err_formatter v;
                    trace_ancestor_chain Format.err_formatter v;
                    Format.eprintf "@]@.")))
