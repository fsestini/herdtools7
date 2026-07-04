let () =
  let file_path = ref None in
  let usage = "Usage: litmus2desc [options] FILE" in

  let libdir = ref None in
  let unroll = ref None in
  let debug = ref false in
  let graph_rels = ref [] in
  let add_graph_rels s =
    let rels =
      s |> String.split_on_char ',' |> List.map String.trim
      |> List.filter (fun s -> not (String.equal s ""))
    in
    graph_rels := !graph_rels @ rels
  in
  let options =
    [
      ( "-set-libdir",
        Arg.String (fun s -> libdir := Some s),
        "<path> set libdir" );
      ("--unroll", Arg.Int (fun i -> unroll := Some i), "set unrolling limit");
      ( "--doshow",
        Arg.String add_graph_rels,
        "<rel>[,<rel>...] relation(s) to print in execution graphs" );
      ( "-doshow",
        Arg.String add_graph_rels,
        "<rel>[,<rel>...] alias for --doshow" );
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
  | [] -> Loop_detection.Top.top ~libdir:!libdir ~unroll:!unroll file_path
  | graph_rels ->
      Loop_detection.Top.top ~graph_rels ~libdir:!libdir ~unroll:!unroll
        file_path
