(****************************************************************************)
(*                           the diy toolsuite                              *)
(*                                                                          *)
(* Jade Alglave, University College London, UK.                             *)
(* Luc Maranget, INRIA Paris-Rocquencourt, France.                          *)
(*                                                                          *)
(* Copyright 2021-present Institut National de Recherche en Informatique et *)
(* en Automatique and the authors. All rights reserved.                     *)
(*                                                                          *)
(* This software is governed by the CeCILL-B license under French law and   *)
(* abiding by the rules of distribution of free software. You can use,      *)
(* modify and/ or redistribute the software under the terms of the CeCILL-B *)
(* license as circulated by CEA, CNRS and INRIA at the following URL        *)
(* "http://www.cecill.info". We also give a copy in LICENSE.txt.            *)
(****************************************************************************)

(** Utilities shared by litmus test parsers. *)

val call_parser :
    string -> Lexing.lexbuf -> 'a -> ('a -> Lexing.lexbuf -> 'b) -> 'b
(** [call_parser name lexbuf lexer parser] invokes [parser lexer lexbuf].

    @raise [Misc.UserError] on lexer and parser errors. *)

val check_regs :
  Proc.t list -> MiscParser.state -> MiscParser.locations ->
  MiscParser.constr -> unit
(** [check_regs procs init locations condition] validates processor references
    in [init], [locations], and [condition].
    Here, "check" means verifying membership in [procs].

    @raise [Misc.Fatal] on unknown processor. *)

val get_visible_locs :
  MiscParser.locations -> MiscParser.constr -> MiscParser.RLocSet.t
(** [get_visible_locs locations condition] returns the union of the locations
    extracted from [locations] and [condition]. *)
