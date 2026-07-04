let () =
  let file_path = ref None in
  let usage = "Usage: litmus2desc [options] FILE" in

  let libdir = ref None in
  let unroll = ref None in
  let debug = ref false in
  let lenient = ref false in
  let graph_rels = ref [] in
  let showevents = ref Herdlib.PrettyConf.NonRegEvents in
  let invalid_doshow s =
    Printf.eprintf "Invalid --doshow value: %s\n%!" s;
    exit 2
  in
  let add_graph_rels s =
    let tokens =
      s |> String.split_on_char ',' |> List.map String.trim
      |> List.filter (fun s -> not (String.equal s ""))
    in
    let rec parse acc = function
      | [] -> List.rev acc
      | token :: tokens -> (
          match String.split_on_char ':' token with
          | [ name ] -> parse (Loop_detection.Top.graph_rel name :: acc) tokens
          | [ name; ev1 ] -> (
              match tokens with
              | ev2 :: tokens
                when (not (String.equal name ""))
                     && (not (String.equal ev1 ""))
                     && (not (String.contains ev2 ':')) ->
                  let spec =
                    Loop_detection.Top.graph_rel_between name ev1 ev2
                  in
                  parse (spec :: acc) tokens
              | _ -> invalid_doshow s)
          | _ -> invalid_doshow s)
    in
    graph_rels := !graph_rels @ parse [] tokens
  in
  let set_showevents s =
    match Herdlib.PrettyConf.parse_showevents s with
    | Some v -> showevents := v
    | None ->
        Printf.eprintf "Invalid showevents value: %s\n%!" s;
        exit 2
  in
  let options =
    [
      ( "-set-libdir",
        Arg.String (fun s -> libdir := Some s),
        "<path> set libdir" );
      ("--unroll", Arg.Int (fun i -> unroll := Some i), "set unrolling limit");
      ( "--doshow",
        Arg.String add_graph_rels,
        "<rel>|<rel>:<ev>,<ev> relation(s) to print in execution graphs" );
      ( "-doshow",
        Arg.String add_graph_rels,
        "<rel>|<rel>:<ev>,<ev> alias for --doshow" );
      ( "--showevents",
        Arg.String set_showevents,
        "<all|mem|noregs|memf|nobranches> select events shown in graphs" );
      ( "-showevents",
        Arg.String set_showevents,
        "<all|mem|noregs|memf|nobranches> alias for --showevents" );
      ( "--lenient",
        Arg.Unit (fun () -> lenient := true),
        "skip unsupported executions with a warning" );
      ("--debug", Arg.Unit (fun () -> debug := true), "enable debugging");
    ]
  in
  let process_arg arg =
    match !file_path with
    | None -> file_path := Some arg
    | Some _ ->
        prerr_endline "Only one FILE argument is allowed";
        Arg.usage options usage;
        exit 2
  in

  Arg.parse options process_arg usage;

  let file_path =
    match !file_path with
    | Some p -> p
    | None ->
        prerr_endline "Missing FILE argument.";
        Arg.usage options usage;
        exit 2
  in

  if !debug then begin
    Logs.set_reporter (Logs.format_reporter ());
    Logs.set_level (Some Logs.Debug)
  end;
  match !graph_rels with
  | [] ->
      Loop_detection.Top.top ~showevents:!showevents ~lenient:!lenient
        ~libdir:!libdir ~unroll:!unroll file_path
  | graph_rels ->
      Loop_detection.Top.top ~graph_rels ~showevents:!showevents
        ~lenient:!lenient ~libdir:!libdir ~unroll:!unroll file_path
