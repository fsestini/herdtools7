module Node = Graph.Node
module Var = Graph.Id
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

let infer_types (bs : Cat.binding list) =
  let module A = Analysis.MakeForward (TypeDomain) in
  let g = Graph.build bs in
  let ty_map = A.forward g in
  Graph.nodes g
  |> List.iter (function
    | v, Node.Def { name; location; _ } ->
        let ty = ty_map v in
        let ty_str = Format.asprintf "%a" TypeDomain.pp ty in
        Printf.printf "%a: %s : %s\n" TxtLoc.pp location name ty_str
    | _, Node.Expr _ -> ())

let selected_vars g =
  Graph.all_vars g
  |> List.concat_map (fun n_id ->
      match Graph.get_node g n_id with
      | Node.Expr
          {
            expr = AST.Op1 (_, AST.ToId, _) | AST.Op (_, AST.Union, _);
            children;
          } ->
          children
          |> List.filter (fun child ->
              match Graph.get_node g child with
              | Node.Expr { expr = AST.Var (_, "emptyset"); children = [] } ->
                  false
              | _ -> true)
      | _ -> [])

let exp_constructor = function
  | AST.Konst _ -> "Konst"
  | AST.Tag _ -> "Tag"
  | AST.Var _ -> "Var"
  | AST.Op1 _ -> "Op1"
  | AST.Op _ -> "Op"
  | AST.App _ -> "App"
  | AST.Bind _ -> "Bind"
  | AST.BindRec _ -> "BindRec"
  | AST.Fun _ -> "Fun"
  | AST.ExplicitSet _ -> "ExplicitSet"
  | AST.Match _ -> "Match"
  | AST.MatchSet _ -> "MatchSet"
  | AST.Try _ -> "Try"
  | AST.If _ -> "If"

let report_any_types (bs : Cat.binding list) =
  let module A = Analysis.MakeForward (TypeDomain) in
  let g = Graph.build bs in
  let ty_map = A.forward g in
  let report id node =
    match ty_map id with
    | TypeDomain.Any ->
        let loc = Node.location node in
        let kind =
          match node with
          | Node.Def { name; _ } -> "definition " ^ name
          | Node.Expr { expr; _ } -> "expression " ^ exp_constructor expr
        in
        Printf.printf "%a: %s: %s\n" TxtLoc.pp loc kind (E.extract loc)
    | TypeDomain.Bottom | TypeDomain.Set | TypeDomain.Rel -> ()
  in
  Graph.nodes g
  |> List.iter (function
    | _, Node.Def { rhs; _ }
      when match Graph.get_node g rhs with
           | Node.Expr { expr = AST.Fun _; _ } -> true
           | _ -> false ->
        ()
    | id, (Node.Def _ as node) -> report id node
    | _ -> ());
  selected_vars g |> List.iter (fun id -> report id (Graph.get_node g id))

let rec is_under_negative_context g v =
  let parent = Graph.get_parent g v in
  match Graph.get_node g parent with
  | Node.Def _ -> false
  | Node.Expr _ ->
      Graph.Util.is_negative_edge g ~parent ~child:v
      || is_under_negative_context g parent

let run (bs : Cat.binding list) : unit =
  let module D = AbstractDomain.FromTyped (DRDomain) in
  let module A = Analysis.Make (D) in
  let module S = DRDomain.Set in
  let A.{ graph = g; fw_map; bw_map } = A.solve_all bs in
  Trace.run_if_requested ~graph:g ~fw_map ~bw_map ~pp_domain:D.pp;
  selected_vars g
  |> List.iter (fun v ->
      if not (is_under_negative_context g v) then
        let loc = Node.location (Graph.get_node g v) in
        match (fw_map v, bw_map v) with
        | D.Set fw, D.Set bw when not (S.equal fw S.top) ->
            let combined = DRDomain.Set.meet fw bw in
            if CatSet.equal combined CatSet.empty then (
              Printf.printf "%a:\n" TxtLoc.pp loc;
              Format.printf "%a@." pp_loc loc;
              Printf.printf
                "  this set expression is always empty in its context\n")
            else if not (S.equal combined fw) then (
              let expected = combined in
              Printf.printf "%a:\n" TxtLoc.pp loc;
              Format.printf "%a@." pp_loc loc;
              Format.printf "  this expression may be strenghthened to `%a`@."
                S.pp expected)
        | _ -> ())
