module Node = Graph.Node
module E = TxtLoc.Extract ()

let read_chan chan =
  let len = in_channel_length chan in
  really_input_string chan len

let marker_padding s len =
  String.map (function '\t' -> '\t' | _ -> ' ') (String.sub s 0 len)

let pp_loc fmt (loc : TxtLoc.t) =
  if loc.loc_ghost then Format.pp_print_string fmt "** ?? **"
  else if loc.loc_start.Lexing.pos_lnum <> loc.loc_end.Lexing.pos_lnum then
    Format.pp_print_string fmt (E.extract loc)
  else
    let open Lexing in
    let cts =
      try Misc.input_protect read_chan loc.loc_start.pos_fname
      with Sys_error msg ->
        Warn.fatal "Error %s, while attempting to read %s\n" msg
          loc.loc_start.pos_fname
    in
    let n1 = loc.loc_start.pos_bol in
    let n2 =
      try String.index_from cts n1 '\n' with Not_found -> String.length cts
    in
    try
      let line = String.sub cts n1 (n2 - n1) in
      let start_col = loc.loc_start.pos_cnum - loc.loc_start.pos_bol in
      let end_col = loc.loc_end.pos_cnum - loc.loc_start.pos_bol in
      let marker =
        marker_padding line start_col ^ String.make (end_col - start_col) '^'
      in
      Format.fprintf fmt "%s@.%s" line marker
    with Invalid_argument _ -> assert false

let run (bs : Cat.binding list) : unit =
  let module D = AbstractDomain.FromTyped (DRDomain) in
  let module A = Analysis.Make (D) in
  let A.{ graph = g; fw_map; bw_map } = A.solve_all bs in
  let combined_set v =
    match (fw_map v, bw_map v) with
    | D.Set (_, fw), D.Set (_, bw) -> Some (DRDomain.Set.meet fw bw)
    | _ -> None
  in
  let is_empty_set s = CatSet.equal s CatSet.empty in
  let should_report v =
    let parent = Graph.get_parent g v in
    match Graph.get_node g parent with
    | Node.Def _ -> true
    | Node.Expr _ -> (
        match combined_set parent with
        | None -> true
        | Some parent_combined -> not (is_empty_set parent_combined))
  in
  let selected_vars =
    Graph.all_vars g
    |> List.filter (fun n_id ->
        match Graph.get_node g n_id with
        | Node.Expr { expr = AST.Var (_, "emptyset"); children = [] } -> false
        | Node.Expr _ -> true
        | _ -> false)
  in
  selected_vars
  |> List.iter (fun v ->
      match combined_set v with
      | Some combined when is_empty_set combined && should_report v ->
          let node = Graph.get_node g v in
          let loc = Node.location node in
          Printf.printf "%a:\n" TxtLoc.pp loc;
          Format.printf "%a@." pp_loc loc;
          Printf.printf "  this set expression is always empty in its context\n"
      | _ -> ())
