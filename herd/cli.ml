module TR = Top_herd.TestResult

module Make (O : sig
  include RunTest.Config
  include Top_herd.PrinterConfig
  val nshow : int option
  val timeout : float option
end) = struct
  module PC = O.PC

(* Open a dot outfile or not *)
  let open_dot test =
    match O.outputdir with
    | PrettyConf.NoOutputdir ->
       begin
         match O.PC.view with
         | Some _ ->
          begin try
            let f,chan = Filename.open_temp_file "herd" ".dot" in
            Some (chan,f)
          with  Sys_error msg ->
            Warn.warn_always "Cannot create temporary file: %s" msg ;
            None
          end
         | None -> None
       end
    | PrettyConf.StdoutOutput ->
       let fname = Test_herd.basename test in
       Printf.fprintf stdout "\nDOTBEGIN %s\n" fname;
       Printf.fprintf stdout "DOTCOM %s\n"
         (let module G = Show.Generator(PC) in
         G.generator) ;
       Some (stdout, fname)
    | PrettyConf.Outputdir d ->
        let base = Test_herd.basename test in
        let base = base ^ O.suffix in
        let f = Filename.concat d base ^ ".dot" in
        try Some (open_out f,f) with
        | Sys_error msg ->
            Warn.warn_always "Cannot create %s: %s" f msg ;
            None

  let close_dot = function
    | None -> ()
    | Some (chan,fname) ->
       match O.outputdir with
       | PrettyConf.NoOutputdir | PrettyConf.Outputdir _ ->
          if O.PC.debug then Printf.eprintf "close %s\n" fname ;
          close_out chan
       | PrettyConf.StdoutOutput ->
          Printf.fprintf stdout "\nDOTEND %s\n" fname

  let my_remove name =
    try Sys.remove name
    with e ->
      Warn.warn_always "remove failed: %s" (Printexc.to_string e)

  let erase_dot = match O.PC.debug, O.outputdir with
  | false,PrettyConf.NoOutputdir -> (* Erase temp file *)
      (function Some (_,f) -> my_remove f | None -> ())
  | (_,PrettyConf.Outputdir _)|(_,PrettyConf.StdoutOutput)|(true,PrettyConf.NoOutputdir) -> (function _ -> ())

  let dump_results ~start_time (module R : RunTest.Outcome) =
    let open R in
    let module S = M.S in
    let module A = S.A in
    let module T = Test_herd.Make (S.A) in
    let module PP = Top_herd.Printer (O) (S) in
    let open ConstrGen in
    let cstr = T.find_our_constraint test in
    let event_structures, i = result in

(* Open *)
    let ochan = open_dot test in
(* So small a race condition... *)
    Handler.push (fun () -> erase_dot ochan) ;
(* Dump event structures ... *)
    if O.dumpes then begin
      match ochan with
      | None -> ()
      | Some (chan, fname) ->
          let module PP = Pretty.Make(S) in
          List.iter
            (fun es -> PP.dump_es chan test es)
            event_structures ;
          close_dot ochan ;
          if Misc.is_some S.O.PC.view then begin
            let module SH = Show.Make(S.O.PC) in
            SH.show_file fname
          end ;
          erase_dot ochan ;
          Handler.pop ()
    end else
    let dump_graph =
      match ochan with
        | Some (chan, _) -> fun exec -> PP.dump_exec_graph M.model test exec chan
        | None -> fun _ -> ()
    in
    let shown, c =
      try PP.iter_showable cstr dump_graph i
      with e -> close_dot ochan; raise e
    in
(* Close *)
    close_dot ochan ;
    let do_show () =
(* Show if something to show *)
      begin match ochan with
      | Some (_,fname) when shown > 0 ->
          let module SH = Show.Make(S.O.PC) in
          if O.PC.debug then Printf.eprintf "show %s file\n" fname ;
          SH.show_file fname
      | Some _|None -> ()
      end ;
(* Erase *)
      erase_dot ochan ;
      Handler.pop ()
    in
    let finals = c.TR.states in
    let nfinals = A.StateSet.cardinal finals in
    match O.restrict with
    | Restrict.Observed when c.TR.cands = 0 -> do_show ()
    | Restrict.NonAmbiguous when c.TR.cands <> nfinals -> do_show ()
    | Restrict.CondOne when c.TR.pos <> c.TR.count_prop -> do_show ()
    | _ ->
(* Header *)
      if not O.badexecs && TR.has_bad_execs ~badflag:O.badflag c then ()
      else
(* Stop interval timer *)
        Itimer.stop O.timeout ;
(* Now output *)
        let time = Sys.time () -. start_time in
        Format.printf "%a\n" (fun fmt () -> PP.pp_stats ~time test c fmt) ();
        do_show ();
        begin
          match c.TR.cutoff with
          | Some msg ->
              Warn.warn_always
                "%a: unrolling limit exceeded at %s, legal outcomes may be missing."
                Pos.pp_pos0   test.Test_herd.name.Name.file
                msg
          | None -> ()
        end

  let from_file f env =
    let module T = ParseTest.Top (O) in
(* Interval timer will be stopped just before output, see dump_results *)
    Itimer.start f O.timeout ;
    let start_time = Sys.time () in
    let env, result = T.from_file f env in
    begin match result with
      | Some result -> dump_results ~start_time result
      | None -> ()
    end;
    env
end
