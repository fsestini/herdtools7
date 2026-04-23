(****************************************************************************)
(*                           the diy toolsuite                              *)
(*                                                                          *)
(* Jade Alglave, University College London, UK.                             *)
(* Luc aranget, INRIA Paris-Rocquencourt, France.                          *)
(*                                                                          *)
(* Copyright 2012-present Institut National de Recherche en Informatique et *)
(* en Automatique and the authors. All rights reserved.                     *)
(*                                                                          *)
(* This software is governed by the CeCILL-B license under French law and   *)
(* abiding by the rules of distribution of free software. You can use,      *)
(* modify and/ or redistribute the software under the terms of the CeCILL-B *)
(* license as circulated by CEA, CNRS and INRIA at the following URL        *)
(* "http://www.cecill.info". We also give a copy in LICENSE.txt.            *)
(****************************************************************************)

module type CommonConfig = sig
  val timeout : float option
  val candidates : bool
  val show : PrettyConf.show
  val nshow : int option
  val restrict : Restrict.t
  val showkind : bool
  val shortlegend : bool
  val outcomereads : bool
  val outputdir : PrettyConf.outputdir_mode
  val suffix : string
  val dumpes : bool
  val badexecs : bool
  val badflag : string option
  val throughflag : string option
  include Mem.CommonConfig
  val statelessrc11 : bool
  val skipchecks : StringSet.t
  val dumpallfaults : bool
end

module type Config = sig
  include CommonConfig
  val byte : MachSize.sz
  val dirty : DirtyBit.t option
end

module Make (O: Config)(M:XXXMem.S) : sig

  type stats = M.S.A.StateSet.t TestResult.stats
  type execution = (M.S.concrete, M.S.set_pp Lazy.t, M.S.rel_pp Lazy.t) TestResult.execution
  type test_results = (execution, M.S.event_structure, stats) TestResult.t

  val run_pure : M.S.test -> test_results
  val dump_results : start_time:float -> M.S.test -> test_results -> unit
end
