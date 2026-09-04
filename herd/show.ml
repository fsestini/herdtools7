(****************************************************************************)
(*                           the diy toolsuite                              *)
(*                                                                          *)
(* Jade Alglave, University College London, UK.                             *)
(* Luc Maranget, INRIA Paris-Rocquencourt, France.                          *)
(*                                                                          *)
(* Copyright 2010-present Institut National de Recherche en Informatique et *)
(* en Automatique and the authors. All rights reserved.                     *)
(*                                                                          *)
(* This software is governed by the CeCILL-B license under French law and   *)
(* abiding by the rules of distribution of free software. You can use,      *)
(* modify and/ or redistribute the software under the terms of the CeCILL-B *)
(* license as circulated by CEA, CNRS and INRIA at the following URL        *)
(* "http://www.cecill.info". We also give a copy in LICENSE.txt.            *)
(****************************************************************************)

(************************************************************)
(* Show feature, for debug, pops up a window to show graphs *)
(************************************************************)

let src = (Logs.Src.create "herdtools7.herd.show")
module Log = (val Logs.src_log src)

let should_debug () =
  match Logs.Src.level src with Some Logs.Debug -> true | _ -> false

open Printf

(* let generator dotcom = match dotcom with *)
(*   | None -> *)
(*       begin match O.graph with *)
(*       | Graph.Columns -> "neato" *)
(*       | Graph.Free|Graph.Cluster -> "dot" *)
(*       end *)
(*   | Some com -> PrettyConf.pp_dotcom com *)

let my_remove name =
  try Sys.remove name
  with Sys_error msg -> Log.warn (fun k -> k "remove failed: %s" msg)

let extfile name_dot ext = (Filename.remove_extension name_dot) ^ "." ^ ext

(* module G = Generator(O) *)
(* let generator = G.generator *)

let with_temp_file ?(keep = should_debug ()) name f =
  if keep then (
    Log.debug (fun k -> k "The file %s will not be removed." name);
    f ())
  else (
    Log.debug (fun k -> k "Using tempfile %s" name);
    Handler.push (fun () -> my_remove name);
    f ();
    my_remove name;
    Handler.pop ())

let suppress_stderr cmd =
  if should_debug () then cmd else sprintf "(%s) 2>/dev/null" cmd

let run_cmd cmd =
  let r = Sys.command (suppress_stderr cmd) in
  Log.debug (fun k -> k "Command: [%s] -> %i" cmd r)

let run_cmds cmds =
  (* In debug mode, break lines so that command is easier to read *)
  let and_ = if should_debug () then " \\\n  && " else " && " in
  String.concat and_ cmds |> run_cmd

let do_show_file ?(keep_tmp_pdf = should_debug ()) generator name_dot prog ext : unit =
  let generator = PrettyConf.pp_dotcom generator in
  let name_ps = extfile name_dot ext in
  with_temp_file ~keep:keep_tmp_pdf name_ps @@ fun () ->
  run_cmds
    [
      sprintf "%s -T%s %s > %s" generator ext name_dot name_ps;
      sprintf "%s %s" prog name_ps;
    ]

let macos_join_pdf =
  {|/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/MacOS/join|}

let do_show_file_preview generator name_dot =
  let generator = PrettyConf.pp_dotcom generator in
  let dirname, name_dot = Filename.(dirname name_dot, basename name_dot) in
  run_cmds
    [
      (* cd in temp dir, just so that command is easier to read in debug mode *)
      sprintf "cd %s" dirname;
      (* Generate the pdfs *)
      sprintf "%s -Tpdf %s -O" generator name_dot;
      (* Merge the pdfs into one big pdf *)
      sprintf "%s -o %s.all %s*.pdf" macos_join_pdf name_dot name_dot;
      (* Remove the individual pdfs *)
      sprintf "rm %s*.pdf" name_dot;
      (* Move the big pdf into a .pdf file *)
      sprintf "mv %s.all %s.pdf" name_dot name_dot;
      (* Open the big pdf *)
      sprintf "open -a Preview %s.pdf" name_dot;
    ]

let show_file_with_view generator view name_dot : unit =
  let open View in
  match view with
  | GV -> do_show_file generator name_dot "gv" "ps"
  | Evince -> do_show_file generator name_dot "evince" "pdf"
  | Preview -> do_show_file_preview generator name_dot

let show_file generator view name_dot =
  show_file_with_view generator view name_dot

let show generator view ouput_dot =
  let name_dot = Filename.temp_file "herd" ".dot" in
  with_temp_file name_dot @@ fun () ->
  Misc.output_protect ouput_dot name_dot;
  show_file_with_view generator view name_dot
