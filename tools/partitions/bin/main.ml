open Catpart
module P = Partitioning.Partition

let run_json ~libdir ~partition_format fname =
  let model = ModelParser.parse ~libdir fname in
  let partitioned = Partitioning.compute_partitions model in
  let render_partition =
    match partition_format with
    | `Int -> fun p -> `Int (P.index p)
    | `String -> fun p -> `String (Format.asprintf "%a" P.pp p)
  in
  let json =
    `Assoc
      (List.map
         (fun (s, ps) -> (s, `List (List.map render_partition ps)))
         (Partitioning.to_assoc partitioned))
  in
  Yojson.Safe.pretty_to_channel stdout json;
  output_char stdout '\n'

let run_dot ~libdir ?subtree fname =
  let model = ModelParser.parse ~libdir fname in
  let partitioned = Partitioning.compute_partitions model in
  let graph = Dag.build_graph partitioned in
  let graph =
    match subtree with
    | None -> graph
    | Some root_label -> (
        try Dag.filter_subtree ~root_label graph
        with Invalid_argument message ->
          prerr_endline (Printf.sprintf "catpart: %s" message);
          exit 1)
  in
  Dag.Dot.output_graph Out_channel.stdout graph

let () =
  let libdir = ref None in
  let mode = ref `Json in
  let partition_format = ref None in
  let subtree = ref None in
  let input_files = ref [] in
  let parse_partition_format = function
    | "int" -> `Int
    | "string" -> `String
    | s -> invalid_arg (Printf.sprintf "invalid partition format: %s" s)
  in
  let parse_mode = function
    | "json" -> `Json
    | "dot" -> `Dot
    | s -> invalid_arg (Printf.sprintf "invalid mode: %s" s)
  in
  let set_libdir s = libdir := Some s in
  let options =
    [
      ("-set-libdir", Arg.String set_libdir, "<path>: alias of --set-libdir");
      ( "--set-libdir",
        Arg.String set_libdir,
        "<path>: set installation directory to <path>." );
      ( "--mode",
        Arg.String (fun s -> mode := parse_mode s),
        "<json|dot>: determine printing mode" );
      ( "--partition-format",
        Arg.String
          (fun s -> partition_format := Some (parse_partition_format s)),
        "" );
      ( "--subtree",
        Arg.String (fun s -> subtree := Some s),
        "<label>: print DOT subtree rooted at node label" );
    ]
  in
  let usage_msg = "catpart [options] <file>" in
  let get_input filename = input_files := filename :: !input_files in
  Arg.parse options get_input usage_msg;
  let () =
    match (!mode, !partition_format) with
    | `Dot, Some _ ->
        print_endline "--partition-format is only valid in json mode"
    | _ -> ()
  in
  let () =
    match (!mode, !subtree) with
    | `Json, Some _ ->
        prerr_endline "--subtree is only valid in dot mode";
        exit 1
    | _ -> ()
  in
  match !input_files with
  | [ file ] -> (
      match !mode with
      | `Json ->
          let partition_format =
            Option.value ~default:`String !partition_format
          in
          run_json ~libdir:!libdir ~partition_format file
      | `Dot -> run_dot ~libdir:!libdir ?subtree:!subtree file)
  | _ ->
      print_endline "Expected exactly one input file";
      exit 1
