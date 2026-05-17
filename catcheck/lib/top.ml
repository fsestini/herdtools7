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
  let module V = Graph.Var in
  let module N = Graph.Node in
  let g = Graph.build bs in
  let vars = Graph.all_vars g in
  let fw_map = A.forward g in
  let roots =
    vars |> List.filter_map (function V.VDef v -> Some v | V.VNode _ -> None)
  in
  let bw_map = A.backward ~g ~fw_map roots in
  let selected_vars =
    vars
    |> List.concat_map (function
      | V.VDef _ -> []
      | V.VNode n_id -> (
          let node = Graph.get_node g n_id in
          match node with
          | N.Op1 (_, AST.ToId, c) -> [ c ]
          | N.Op (_, AST.Union, cs) -> cs
          | _ -> []))
  in
  selected_vars
  |> List.iter (fun n_id ->
      let node = Graph.get_node g n_id in
      let v = V.VNode n_id in
      let loc = Graph.Node.location node in
      let fw = fw_map v in
      let bw = bw_map v in
      match (fw, bw) with
      | D.Set (_, fw), D.Set (_, bw) ->
          let combined = DRDomain.Set.meet fw bw in
          if CatSet.equal combined CatSet.empty then (
            Printf.printf "%a:\n" TxtLoc.pp loc;
            Format.printf "%a@." pp_loc loc;
            Printf.printf
              "  this set expression is always empty in its context\n")
          (* else if (not tainted) && not (CatSet.equal combined fw) then ( *)
          (*   Printf.printf "%a:\n" TxtLoc.pp loc; *)
          (*   Format.printf "%a@." pp_loc loc; *)
          (*   Format.printf "  this expression may be strenghthened to `%a`@." *)
          (*     CatSet.pp combined) *)
      | _ -> ())
