type opts = {
  libdir : string;
  verbose : bool;
  debug : bool;
  primitives : string option;
}

let parse_options () =
  let libdir = ref None in
  let verbose = ref false in
  let debug = ref false in
  let primitives = ref None in
  let args = ref [] in

  let opts =
    [
      ("-v", Arg.Unit (fun () -> verbose := true), "be verbose.");
      ("--debug", Arg.Unit (fun () -> debug := true), "enable debug logging.");
      ( "--primitives",
        Arg.String (fun s -> primitives := Some s),
        "enable debug logging." );
      ( "--set-libdir",
        Arg.String (fun s -> libdir := Some s),
        "<path>  Set location of libdir to <path>." );
    ]
  in
  let prog =
    if Array.length Sys.argv > 0 then Filename.basename Sys.argv.(0)
    else "cat2config7"
  in
  let () =
    Arg.parse opts
      (fun s -> args := s :: !args)
      (Format.sprintf "Usage: %s [OPTIONS] FILE" prog)
  in
  let libdir =
    match !libdir with
    | Some libdir -> libdir
    | None -> Filename.concat Version.libdir "herd"
  in
  let arg =
    match !args with [ x ] -> x | _ -> failwith "need exactly one arg"
  in
  ({ verbose = !verbose; debug = !debug; libdir; primitives = !primitives }, arg)

open Catcheck
module E = TxtLoc.Extract ()

(* let pp_txtloc fmt (p : TxtLoc.t) = *)
(*   let open TxtLoc in *)
(*   Format.fprintf fmt "File %s, line %d" p.loc_start.Lexing.pos_fname *)
(*     p.loc_start.Lexing.pos_lnum *)

let () =
  let opts, fname = parse_options () in
  let log_level =
    if opts.debug then Logs.Debug
    else if opts.verbose then Logs.Info
    else Logs.Warning
  in
  Logs.set_reporter (Logs.format_reporter ());
  Logs.Src.list ()
  |> List.iter (fun src -> Logs.Src.set_level src (Some log_level));

  let module P = Cat.MakeParser (struct
    let libdir = opts.libdir
  end) in
  print_endline "Catcheck";
  let prims =
    match opts.primitives with
    | Some fname -> P.read_bindings fname
    | None -> []
  in
  let bs = P.read_bindings fname in
  let bs = prims @ bs in
  (* let () = *)
  (*   bs *)
  (*   |> List.iter (fun b -> *)
  (*       Logs.app (fun m -> m "%a: %s" pp_txtloc b.Cat.location b.Cat.name)) *)
  (* in *)
  let module D = AbstractDomain.FromTyped (DRDomain) in
  let module A = Analysis.Make (D) in
  let results = A.solve_all bs in
  results
  |> List.iter (fun (loc, res) ->
      let fw = res.A.forward in
      let bw = res.A.backward in
      match (fw, bw) with
      | D.Set ((_b as tnt), fw), D.Set (_, bw)
        when not DRDomain.Set.(equal fw top) ->
          let combined = DRDomain.Set.meet fw bw in
          if not (DRDomain.Set.equal combined fw) then (
            let expected = combined in
            Printf.printf "%a:\n" TxtLoc.pp loc;
            Format.printf
              "  expression `%s` (fw: %b %a) could be simplified to `[%a]`@."
              (E.extract loc) tnt DRDomain.Set.pp fw CatSet.pp expected)
      | _ -> ())
(* results *)
(* |> List.iter (fun (loc, res) -> *)
(*     let combined = D.meet res.A.forward res.A.backward in *)
(*     if *)
(*       (not D.(equal top res.A.forward)) *)
(*       && not (D.equal combined res.A.forward) *)
(*     then ( *)
(*       let expected = *)
(*         CatSet.inter combined.DRDomain.domain combined.DRDomain.range *)
(*       in *)
(*       Printf.printf "%a:\n" TxtLoc.pp loc; *)
(*       Format.printf "  expression `%s` could be simplified to `[%a]`@." *)
(*         (E.extract loc) CatSet.pp expected)) *)
