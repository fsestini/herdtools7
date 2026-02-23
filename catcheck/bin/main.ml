type opts = { libdir : string; verbose : bool; debug : bool }

let parse_options () =
  let libdir = ref None in
  let verbose = ref false in
  let debug = ref false in

  let opts =
    [
      ("-v", Arg.Unit (fun () -> verbose := true), "be verbose.");
      ("--debug", Arg.Unit (fun () -> debug := true), "enable debug logging.");
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
      (fun _s -> ())
      (Format.sprintf "Usage: %s [OPTIONS] FILE" prog)
  in
  let libdir =
    match !libdir with
    | Some libdir -> libdir
    | None -> Filename.concat Version.libdir "herd"
  in
  { verbose = !verbose; debug = !debug; libdir }

open Catcheck
module E = TxtLoc.Extract ()

let pp_txtloc fmt (p : TxtLoc.t) =
  let open TxtLoc in
  Format.fprintf fmt "File %s, line %d" p.loc_start.Lexing.pos_fname
    p.loc_start.Lexing.pos_lnum

let () =
  let opts = parse_options () in
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
  let bs = P.read_bindings "aarch64.cat" in
  let () =
    bs
    |> List.iter (fun b ->
        Logs.app (fun m -> m "%a: %s" pp_txtloc b.Cat.location b.Cat.name))
  in
  let module G = Graph.Make (DRDomain) in
  let results = G.solve_all bs in
  results
  |> List.iter (fun (loc, res) ->
      let combined = DRDomain.meet res.G.forward res.G.backward in
      if
        (not DRDomain.(equal top res.G.forward))
        && not (DRDomain.equal combined res.G.forward)
      then (
        let expected =
          CatSet.inter combined.DRDomain.domain combined.DRDomain.range
        in
        Printf.printf "%a:\n" TxtLoc.pp loc;
        Format.printf "  expression `%s` could be simplified to `[%a]`@."
          (E.extract loc) CatSet.pp expected))
