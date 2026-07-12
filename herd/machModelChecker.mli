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
  type lasso := S.E.event Lasso.weighted_lasso

    (**
        [check_event_structure test conc kfail kont res] checks [conc] against
        the model [O.m] for [test]. [kfail] handles a failed candidate;
        [kont] handles each successful candidate, including its optional lasso.
        [res] is the caller's accumulator threaded through both continuations.
    *)
    val check_event_structure :
      S.test -> S.concrete ->
      ('a -> 'a) ->
      (S.concrete -> S.A.state * S.A.FaultSet.t ->
       (S.set_pp Lazy.t * S.rel_pp Lazy.t) ->
       lasso option ->
       Flag.Set.t -> 'a -> 'a) ->
      'a -> 'a
  end
