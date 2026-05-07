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
  val restrict : Restrict.t
  val outcomereads : bool
  val outputdir : PrettyConf.outputdir_mode
  val suffix : string
  val dumpes : bool
  val badexecs : bool
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

module TestResult : sig
  type 'stset stats =
    { states : 'stset;
      cfail : int ;
      cands : int ;
      pos : int ;
      neg : int ;
      count_prop : int;
      flagged : int list Flag.Map.t ;
      cutoff : string option;
    }

  val has_bad_execs : badflag:string option -> 'stset stats -> bool

  type ('conc, 'sets, 'rels) execution

  val concrete : ('conc, 's, 'r) execution -> 'conc
  val relations : ('c, 's, 'rels) execution -> 'rels
  val passes_check : ('c, 's, 'r) execution -> bool
  val is_bad : badflag:string option -> ('c, 's, 'r) execution -> bool
  val should_show : show:PrettyConf.show -> 'p ConstrGen.constr -> ('c, 's, 'r) execution -> bool
  val passes_speedcheck : 'p ConstrGen.constr -> ('c, 's, 'r) execution -> bool

  type ('exec, 'stats) exec_iter

  val fold_execs : ('exec -> 'b -> 'b * bool) -> 'b -> ('exec, 'stats) exec_iter -> 'b * 'stats

  type ('es, 'exec, 'stats) t = 'es list * ('exec, 'stats) exec_iter

  module Make (S : SemExtra.S) : sig
    type nonrec stats = S.A.StateSet.t stats
    type nonrec execution = (S.concrete, S.set_pp, S.rel_pp) execution
    type nonrec t = (S.event_structure, execution, stats) t
  end
end

module Make (O: Config)(M:XXXMem.S) : sig
  type test_results = TestResult.Make(M.S).t

  val run : M.S.test -> M.S.test * test_results
end

module type PrinterConfig = sig
  module PC : PrettyConf.S
  val candidates : bool
  val showkind : bool
  val shortlegend : bool
  val verbose_flags : bool
  val show : PrettyConf.show
  val speedcheck : Speed.t
  val badflag : string option
end

module Printer (O : PrinterConfig) (S : SemExtra.S) : sig
  type stats := TestResult.Make(S).stats
  type execution := TestResult.Make(S).execution

  val pp_stats : time:float -> S.test -> stats -> Format.formatter -> unit
  val dump_exec_graph : Model.t -> S.test -> execution -> out_channel -> unit
end
