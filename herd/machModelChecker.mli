(****************************************************************************)
(*                           the diy toolsuite                              *)
(*                                                                          *)
(* Jade Alglave, University College London, UK.                             *)
(* Luc Maranget, INRIA Paris-Rocquencourt, France.                          *)
(*                                                                          *)
(* Copyright 2026-present Institut National de Recherche en Informatique et *)
(* en Automatique, ARM Ltd and the authors. All rights reserved.            *)
(*                                                                          *)
(* This software is governed by the CeCILL-B license under French law and   *)
(* abiding by the rules of distribution of the source file. You should have *)
(* received a copy of the CeCILL-B license along with this program. If not, *)
(* see <http://www.cecill.info/>.                                            *)
(****************************************************************************)

(** Check an event structure against a machine model. *)

module type Config = sig
  val fname : string
  val m : AST.t
  val bell_model_info : (string * BellModel.info) option
  val wide_po : bool
  include Model.Config
end

module Make :
  functor (O : Config) (S : Sem.Semantics) -> sig
    (** [check_event_structure test conc kfail kont res] checks candidate
        [conc] for [test] against [O.m]. [kfail] receives a rejected
        candidate's accumulator. [kont] receives each accepted candidate,
        its final state, displayed sets/relations, optional weighted lasso
        result, flags, and accumulator. [res] is the initial accumulator. *)
    val check_event_structure :
      S.test -> S.concrete ->
      ('a -> 'a) ->
      (S.concrete -> S.A.state * S.A.FaultSet.t ->
       (S.set_pp Lazy.t * S.rel_pp Lazy.t) ->
       S.event Lasso.result option ->
       Flag.Set.t -> 'a -> 'a) ->
      'a -> 'a
  end
