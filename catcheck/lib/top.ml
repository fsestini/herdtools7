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
  let module Fw = AbstractDomain.FromTyped (DRTaintDomain) in
  let module Bw = AbstractDomain.FromTyped (DRDomain) in
  let module A = Analysis.MakeSplit (Fw) (Bw) in
  let module S = DRTaintDomain.Set in
  let erase_taint = function
    | Fw.Top -> Bw.Top
    | Fw.Bottom -> Bw.Bottom
    | Fw.Set s -> Bw.Set (S.carrier s)
    | Fw.Rel r ->
        Bw.Rel
          {
            DRDomain.domain = S.carrier r.DRTaintDomain.domain;
            range = S.carrier r.DRTaintDomain.range;
          }
  in
  let A.{ graph = g; fw_map; bw_map } = A.solve_all ~fw_to_bw:erase_taint bs in
  Trace.run_if_requested ~graph:g ~fw_map ~bw_map ~pp_fw:Fw.pp ~pp_bw:Bw.pp;
  selected_vars g
  |> List.iter (fun v ->
      if not (is_under_negative_context g v) then
        let loc = Node.location (Graph.get_node g v) in
        match (fw_map v, bw_map v) with
        | Fw.Set fw, Bw.Set bw
          when not (CatSet.equal (S.carrier fw) CatSet.universe) ->
            let combined = CatSet.inter (S.carrier fw) bw in
            if CatSet.equal combined CatSet.empty then (
              Printf.printf "%a:\n" TxtLoc.pp loc;
              Format.printf "%a@." pp_loc loc;
              Printf.printf
                "  this set expression is always empty in its context\n")
            else if
              (not (S.is_tainted fw))
              && not (CatSet.equal combined (S.carrier fw))
            then (
              let expected = combined in
              Printf.printf "%a:\n" TxtLoc.pp loc;
              Format.printf "%a@." pp_loc loc;
              Format.printf "  this expression may be strenghthened to `%a`@."
                CatSet.pp expected)
        | _ -> ())
