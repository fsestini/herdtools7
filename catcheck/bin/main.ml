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
  let prims =
    match opts.primitives with
    | Some fname -> P.read_bindings fname
    | None -> []
  in
  let bs = P.read_bindings fname in
  let bs = prims @ bs in
  Top.run bs
