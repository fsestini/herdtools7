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

(** Common signature of PPCMem, X86Mem, ARMMem, for abstract usage *)

module type S = sig
  val model : Model.t
  module S : Sem.Semantics

  (** [check_event_structure test conc kfail kont res] checks candidate
      [conc] for [test]. [kfail] receives a rejected candidate's accumulator.
      [kont] receives each accepted candidate, its final state, displayed
      sets/relations, optional weighted lasso result, flags, and accumulator.
      [res] is the initial accumulator. *)
  val check_event_structure :
      S.test -> S.concrete ->
      ('a -> 'a) ->
      (S.concrete ->  S.A.state * S.A.FaultSet.t ->
       (S.set_pp Lazy.t * S.rel_pp Lazy.t) ->
       S.event Lasso.result option ->
       Flag.Set.t (* Flags set during that execution *) -> 'a -> 'a) ->
       'a -> 'a

end
