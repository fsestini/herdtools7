open Herdlib

module SP = Splitter.Make (struct
  let debug = false
  let check_rename = fun s -> Some s
end)

module DefaultConfig = struct
  include GenParser.DefaultConfig

  let model = None
  let archcheck = false
  let through = Model.ThroughNone
  let strictskip = false
  let cycles = StringSet.empty
  let bell_model_info = None
  let debuglexer = false
  let check_kind = fun _ -> None
  let check_cond = fun _ -> None
  let restrict = Restrict.No
  let outcomereads = false
  let show = PrettyConf.ShowAll
  let nshow = None
  let badflag = None
  let badexecs = true
  let throughflag = None
  let verbose = 0
  let optace = OptAce.Iico
  let speedcheck = Speed.False
  let debug = Debug_herd.none
  let observed_finals_only = not ModelOption.(default.co)
  let initwrites = ModelOption.default.init
  let check_filter = true
  let maxphantom = None
  let variant = function Variant.CutOff -> true | _ -> false
  let fault_handling = Fault.Handling.default
  let mte_precision = Precision.default
  let mte_store_only = false
  let skipchecks = StringSet.empty
  let statelessrc11 = false
  let dumpallfaults = false
  let endian = None
  let byte = MachSize.Tag.Auto
  let sve_vector_length = 128
  let sme_vector_length = 128
  let macros = None
  let check_name = fun _ -> true
  let check_rename = fun s -> Some s
  let hexa = false

  module PC = struct
    module PP = Opts.PP

    let showkind = false
    let shortlegend = false
    let debug = debug.Debug_herd.pretty
    let verbose = verbose
    let dotmode = !PP.dotmode
    let dotcom = !PP.dotcom
    let view = !PP.view
    let showevents = PrettyConf.AllEvents
    let texmacros = !PP.texmacros
    let tikz = !PP.tikz
    let hexa = !PP.hexa
    let mono = !PP.mono
    let fontname = !PP.fontname
    let fontsize = !PP.fontsize
    let edgedelta = !PP.edgedelta
    let penwidth = !PP.penwidth
    let arrowsize = !PP.arrowsize
    let splines = !PP.splines
    let overlap = !PP.overlap
    let sep = !PP.sep
    let margin = !PP.margin
    let pad = !PP.pad
    let scale = !PP.scale
    let xscale = !PP.xscale
    let yscale = !PP.yscale
    let dsiy = !PP.dsiy
    let siwidth = !PP.siwidth
    let boxscale = !PP.boxscale
    let ptscale = !PP.ptscale
    let squished = !PP.squished
    let graph = !PP.graph
    let showpo = !PP.showpo
    let relabel = !PP.relabel
    let withbox = !PP.withbox
    let labelbox = !PP.labelbox
    let showthread = !PP.showthread
    let showlegend = !PP.showlegend
    let showfinalrf = !PP.showfinalrf
    let showinitrf = !PP.showinitrf
    let finaldotpos = !PP.finaldotpos
    let initdotpos = !PP.initdotpos
    let oneinit = !PP.oneinit
    let initpos = !PP.initpos
    let threadposy = !PP.threadposy
    let showinitwrites = !PP.showinitwrites
    let brackets = !PP.brackets
    let showobserved = !PP.showobserved
    let movelabel = !PP.movelabel
    let fixedsize = !PP.fixedsize
    let extrachars = !PP.extrachars
    let edgeattrs = PP.get_edgeattrs ()
    let doshow = StringSet.of_list [ "co" ]
    let unshow = StringSet.of_list [ "ctrl"; "ca" ]
    let noid = !PP.noid
    let symetric = !PP.symetric
    let classes = !PP.classes
    let showraw = StringSet.of_list [ "co" ]
    let dotheader = None
    let shift = !PP.shift
    let edgemerge = !PP.edgemerge
    let labelinit = !PP.labelinit
    let variant = variant
  end
end

(* module Converter (S : SemExtra.S) = struct *)
(*   module A = S.A *)
(*   module E = S.E *)
(*   module TR = Top_herd.TestResult.Make (S) *)
(**)
(*   type test_results = TR.t *)
(**)
(*   let convert_location (l : A.location) : Execution.location = *)
(*     match l with *)
(*     | A.Location_reg (proc, r) -> *)
(*         Execution.(Reg { proc; reg_pretty = A.pp_reg r }) *)
(*     | A.Location_global a -> Execution.Global (A.pp_global a) *)
(**)
(*   let convert_value (v : A.V.v) : Execution.value = *)
(*     let hexa = false in *)
(*     match v with *)
(*     | A.V.Var var -> Execution.Var var *)
(*     | A.V.Val cst -> ( *)
(*         match cst with *)
(*         | Constant.Concrete scalar -> *)
(*             let scalar_pretty = A.V.Cst.Scalar.pp hexa scalar in *)
(*             Execution.(Val (Concrete { scalar_pretty })) *)
(*         | Constant.Symbolic sym -> *)
(*             let symbol_pretty = Constant.pp_symbol sym in *)
(*             Execution.(Val (Symbolic { symbol_pretty })) *)
(*         | Constant.PteVal pteval -> *)
(*             let pteval_pretty = A.V.Cst.PteVal.pp hexa pteval in *)
(*             let as_physical = A.V.Cst.PteVal.as_physical pteval in *)
(*             Execution.(Val (Pteval { pteval_pretty; as_physical })) *)
(*         | _ -> Execution.Val_pretty (A.V.Cst.pp hexa cst)) *)
(**)
(*   let convert_action (a : E.Act.action) = *)
(*     if E.Act.is_load a || E.Act.is_store a then *)
(*       let dir = if E.Act.is_load a then Execution.R else Execution.W in *)
(*       let loc = *)
(*         match E.Act.location_of a with *)
(*         | Some loc -> convert_location loc *)
(*         | None -> invalid_arg "register or memory action without location" *)
(*       in *)
(*       let value = *)
(*         match E.Act.value_of a with *)
(*         | Some v -> convert_value v *)
(*         | None -> invalid_arg "register or memory action without value" *)
(*       in *)
(*       if E.Act.is_reg_any a then Execution.(Register { dir; loc; value }) *)
(*       else *)
(*         let is_atomic = E.Act.is_atomic a in *)
(*         let is_implicit = not (E.Act.is_explicit a) in *)
(*         Execution.(Memory { dir; loc; value; is_implicit; is_atomic }) *)
(*     else if E.Act.is_barrier a then *)
(*       let barrier_pretty = *)
(*         match E.Act.barrier_of a with *)
(*         | Some b -> A.pp_barrier_short b *)
(*         | None -> invalid_arg "invalid barrier" *)
(*       in *)
(*       Execution.Barrier { barrier_pretty } *)
(*     else if E.Act.is_commit a then *)
(*       let commit = *)
(*         if E.Act.is_bcc a then "bcc" *)
(*         else if E.Act.is_pred a then "pred" *)
(*         else invalid_arg "invalid commit action" *)
(*       in *)
(*       Execution.Commit { commit } *)
(*     else if E.Act.is_fault a then Execution.Fault *)
(*     else failwith "Unrecognized action type" *)
(**)
(*   let convert_event (e : E.event) : Execution.event = *)
(*     let iiid = *)
(*       match e.E.iiid with *)
(*       | E.IdInit -> Execution.Init *)
(*       | E.IdSpurious -> Execution.Spurious *)
(*       | E.IdSome ii -> *)
(*           let inst_pretty = A.pp_instruction PPMode.Ascii ii.A.inst in *)
(*           let proc = ii.A.proc in *)
(*           let poi = ii.A.static_poi in *)
(*           Execution.Index { proc; poi; inst_pretty } *)
(*     in *)
(*     let act = convert_action e.E.action in *)
(*     let eiid = e.E.eiid in *)
(*     { act; eiid; iiid } *)
(**)
(*   let convert_rel (r : E.event_rel) : Execution.rel_edge list = *)
(*     let mk_eiid_obj n = Execution.{ eiid = n } in *)
(*     let l = *)
(*       E.EventRel.fold *)
(*         (fun (e, e') acc -> *)
(*           Execution.{ src = mk_eiid_obj e.E.eiid; tgt = mk_eiid_obj e'.E.eiid } *)
(*           :: acc) *)
(*         r [] *)
(*     in *)
(*     List.rev l *)
(**)
(*   module PU = PrettyUtils.Make (S) *)
(**)
(*   (* Non deps mode *) *)
(*   let rec min_max_to_succ = function *)
(*     | [] | [ _ ] -> E.EventRel.empty *)
(*     | (_xmin, xmax) :: ((ymin, _ymax) :: _ as rem) -> *)
(*         E.EventRel.union (E.EventRel.cartesian xmax ymin) (min_max_to_succ rem) *)
(**)
(*   let make_visible_po_nodeps es by_proc_and_poi = *)
(*     let intra = E.EventRel.transitive_closure (E.iico es) in *)
(*     let min_max_list = *)
(*       List.map *)
(*         (List.map (fun es -> *)
(*              let mins = *)
(*                E.EventSet.filter *)
(*                  (fun e -> not (E.EventRel.exists_pred intra e)) *)
(*                  es *)
(*              and maxs = *)
(*                E.EventSet.filter *)
(*                  (fun e -> not (E.EventRel.exists_succ intra e)) *)
(*                  es *)
(*              in *)
(*              (mins, maxs))) *)
(*         by_proc_and_poi *)
(*     in *)
(*     E.EventRel.unions (List.map min_max_to_succ min_max_list) *)
(**)
(*   let convert_es (es : E.event_structure) (rfmap : S.read_from S.RFMap.t) *)
(*       (vbss : (string * E.event_rel) list) : Execution.t = *)
(*     let events = List.map convert_event (E.EventSet.elements es.E.events) in *)
(*     let iico_data = convert_rel es.E.intra_causality_data in *)
(*     let iico_ctrl = convert_rel es.E.intra_causality_control in *)
(**)
(*     let rfmap : Execution.RFMap.edge list = *)
(*       let mk_eiid_obj n = Execution.{ eiid = n } in *)
(*       rfmap |> S.RFMap.bindings *)
(*       |> List.map (fun (wt, rf) -> *)
(*           let wt_j = *)
(*             match wt with *)
(*             | S.Final loc -> *)
(*                 let loc = convert_location loc in *)
(*                 Execution.RFMap.Final loc *)
(*             | S.Load ev -> *)
(*                 let ev = mk_eiid_obj ev.S.E.eiid in *)
(*                 Execution.RFMap.Load ev *)
(*           in *)
(*           let rf_j = *)
(*             match rf with *)
(*             | S.Init -> Execution.RFMap.Init *)
(*             | S.Store ev -> *)
(*                 let ev = mk_eiid_obj ev.S.E.eiid in *)
(*                 Execution.RFMap.Store ev *)
(*           in *)
(*           Execution.RFMap.{ src = wt_j; tgt = rf_j }) *)
(*     in *)
(*     let viewed_before = List.map (fun (tag, r) -> (tag, convert_rel r)) vbss in *)
(*     let visible_po = *)
(*       let events_by_proc_and_poi = PU.make_by_proc_and_poi es in *)
(*       let po_edges = make_visible_po_nodeps es events_by_proc_and_poi in *)
(*       convert_rel po_edges *)
(*     in *)
(*     Execution. *)
(*       { *)
(*         events; *)
(*         iico_data; *)
(*         iico_ctrl; *)
(*         rfmap; *)
(*         viewed_before; *)
(*         visible_po = Some visible_po; *)
(*       } *)
(**)
(*   module TestResult = Top_herd.TestResult *)
(**)
(*   let convert (res : test_results) : Execution.t list = *)
(*     let _, iter = res in *)
(*     let l = ref [] in *)
(*     let _ = *)
(*       iter (fun ex -> *)
(*           let conc = ex.concrete in *)
(*           let es = conc.S.str in *)
(*           let rfmap = conc.S.rfmap in *)
(*           let vbss = Lazy.force ex.rels in *)
(*           let x = convert_es es rfmap vbss in *)
(*           l := x :: !l) *)
(*     in *)
(*     !l *)
(* end *)

module MakeDriver (Config : module type of DefaultConfig) = struct
  let top ~libdir ~unroll str =
    (* let (splitted : Splitter.result) = SP.split "T" chan in *)
    (* let dirty = DirtyBit.get splitted.Splitter.info in *)
    let libfind =
      let module ML = MyLib.Make (struct
        let includes = []
        let env = Some "HERDLIB"

        let libdir =
          match libdir with
          | Some libdir -> libdir
          | None -> Filename.concat Version.libdir "herd"

        let debug = false
      end) in
      ML.find
    in
    let module C = struct
      include Config

      let libfind = libfind
      let unroll = unroll
      let collect_graph_data = true
    end in
    let module PT = ParseTest.Top (C) in
    let _, results =
      PT.from_string ~filename:None ~contents:str StringMap.empty
    in
    match results with None -> assert false | Some results -> results
end

module AnalysisDriver = MakeDriver (DefaultConfig)

let top = AnalysisDriver.top
(* let module R = (val results) in *)
(* let module Conv = Converter (R.M.S) in *)
(* Conv.convert R.result *)
