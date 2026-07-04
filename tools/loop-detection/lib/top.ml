module Log = (val Logs.src_log (Logs.Src.create "top") : Logs.LOG)
open Herdlib
module T = LitmusTest
module W = IntervalWeights
module TR = Top_herd.TestResult

exception Error of string

let exn_message = function Error msg -> msg | exn -> Printexc.to_string exn

let warn_skipped_execution i exn =
  Printf.eprintf "Warning: skipping unsupported execution %d: %s\n%!" i
    (exn_message exn)

module Parser = ParseModel.Make (struct
  let debug = false
  let libfind file = file
end)

let eval_variant_cond =
  let rec go = function
    | AST.Variant _ -> false
    | AST.OpNot cond -> not (go cond)
    | AST.OpAnd (c1, c2) -> go c1 && go c2
    | AST.OpOr (c1, c2) -> go c1 || go c2
  in
  go

let rec parse_cat file =
  let _, _, ins = Parser.parse file in
  expand_ins (Filename.dirname file) ins

and expand_ins dir ins =
  List.concat_map
    (function
      | AST.Include (_, file) -> parse_cat (Filename.concat dir file)
      | AST.IfVariant (_, cond, then_ins, else_ins) ->
          expand_ins dir (if eval_variant_cond cond then then_ins else else_ins)
      | ins -> [ ins ])
    ins

let parse_model file =
  let opts, name, ins = Parser.parse file in
  let dir = Filename.dirname file in
  let stdlib =
    let stdlib = Filename.concat dir "stdlib.cat" in
    if String.equal (Filename.basename file) "stdlib.cat" then []
    else if Sys.file_exists stdlib then parse_cat stdlib
    else []
  in
  let ins = stdlib @ expand_ins dir ins in
  ((opts, name, ins), ins)

type graph_rel = { name : string; endpoints : (string * string) option }

let graph_rel name = { name; endpoints = None }
let graph_rel_between name ev1 ev2 = { name; endpoints = Some (ev1, ev2) }

module Make (S : SemExtra.S) = struct
  module E = S.E
  module TRS = TR.Make (S)

  module D = Dot.Make (struct
    type node = E.event
    type edge = string * E.event * E.event * W.t

    let node_id ev = Format.sprintf "eiid%d" ev.E.eiid
    let node_cluster ev = E.proc_of ev
    let endpoints (_, x, y, _) = (x, y)
    let node_label ev = Format.sprintf "%s: %s" (E.pp_eiid ev) (E.pp_action ev)
    let edge_label (r, _, _, w) = Format.asprintf "%s %a" r W.pp w
  end)

  module WR =
    WeightedRel.Make
      (W)
      (struct
        type t = E.event

        let compare = E.event_compare
      end)

  module MC = ModelChecker.Make (S) (WR)

  module PrettySem (C : sig
    val showevents : PrettyConf.showevents
  end) =
  struct
    include S

    module O = struct
      include S.O

      module PC = struct
        include S.O.PC

        let showevents = C.showevents
      end
    end
  end

  let get_rel_or_empty lbl rels =
    List.assoc_opt lbl rels |> Option.value ~default:E.EventRel.empty

  let non_cutoff_events (conc : S.concrete) =
    E.EventSet.filter (fun ev -> not (E.is_cutoff ev)) conc.S.str.events

  let pp_rel ~lbl fmt rel =
    let rel_list, () = Util.Iter.to_list (fun f -> E.EventRel.iter f rel) in
    let open Format in
    pp_print_list
      ~pp_sep:(fun fmt () -> fprintf fmt "@,")
      (fun fmt (ev1, ev2) ->
        fprintf fmt "%s -- %s -> %s" (E.pp_eiid ev1) lbl (E.pp_eiid ev2))
      fmt rel_list

  let pp_event_list fmt evs =
    let open Format in
    pp_print_list
      ~pp_sep:(fun fmt () -> fprintf fmt "@,")
      (fun fmt ev -> fprintf fmt "  %s: %s" (E.pp_eiid ev) (E.pp_action ev))
      fmt evs

  module PP = Pretty.Make (S)

  let find_static_loop_boundaries (es : E.event_structure) =
    let events = es.events |> E.EventSet.to_list in
    let cutoffs =
      events
      |> List.filter_map (fun ev ->
          match ev.E.iiid with
          | IdSome iiid when E.is_cutoff ev -> Some iiid
          | _ -> None)
    in
    let cutoff_proc, start_spoi, cutoff_poi =
      match cutoffs with
      | [] -> failwith "find_static_loop_boundaries: no cutoff events found"
      | [ iiid ] ->
          let proc = iiid.proc in
          let static_poi = iiid.static_poi in
          let poi = iiid.program_order_index in
          (proc, static_poi, poi)
      | _ :: _ :: _ ->
          invalid_arg "Multi-loop litmus tests are not supported yet."
    in
    let bcc_events =
      events
      |> List.filter_map (fun ev ->
          match (E.proc_of ev, ev.iiid) with
          | Some proc, IdSome iiid
            when E.is_bcc ev && Int.equal proc cutoff_proc
                 && Int.equal iiid.program_order_index (cutoff_poi - 1) ->
              Some (ev, iiid)
          | _ -> None)
    in
    let end_spoi =
      match bcc_events with
      | [ (_ev, iiid) ]
      (* when Int.equal iiid.program_order_index (cutoff_poi - 1) *) ->
          iiid.static_poi
      | [] -> failwith "find_static_loop_boundaries: no BCC events"
      | bccs ->
          let open Format in
          let bccs = List.map (fun (ev, _iiid) -> E.pp_eiid ev) bccs in
          printf "BCCS: %a@."
            (pp_print_list
               ~pp_sep:(fun fmt () -> fprintf fmt ", ")
               pp_print_string)
            bccs;
          failwith "find_static_loop_boundaries: more than one BCC event"
    in
    Log.debug (fun m ->
        m "cutoff start_spoi: %d, end_spoi: %d@." start_spoi end_spoi);
    (cutoff_proc, start_spoi, end_spoi)

  type iteration = { events : E.event list; branch_event : E.event }

  let pp_iteration fmt (ix, i) =
    Format.fprintf fmt "@[<v 2>Iteration #%d@,%a@]" ix pp_event_list i.events

  let pp_iterations fmt iters =
    let open Format in
    fprintf fmt "Iterations:@.";
    pp_print_list
      ~pp_sep:(fun fmt () -> Format.fprintf fmt "@,")
      pp_iteration fmt iters

  let iterations_of_loop ~(proc : int) ~(start_spoi : int) ~(end_spoi : int)
      (evs : E.EventSet.t) : iteration list =
    (* : E.event list list = *)
    let by_poi =
      evs |> E.EventSet.to_list
      |> List.filter_map (fun ev ->
          let ( let* ) = Option.bind in
          let* proc' = E.proc_of ev in
          let* spoi = E.static_poi ev in
          let* poi = E.progorder_of ev in
          if Int.equal proc proc' then Some (spoi, poi, ev) else None)
      |> List.sort (fun (_, poi, ev) (_, poi', ev') ->
          match Int.compare poi poi' with
          | 0 -> Int.compare ev.E.eiid ev'.E.eiid
          | n -> n)
    in
    let all_iterations =
      by_poi
      |> List.filter (fun (spoi, _, _) ->
          start_spoi <= spoi && spoi <= end_spoi)
    in
    let current, iters =
      all_iterations
      |> List.fold_left
           (fun (current, iters) (_, _, ev) ->
             if E.is_bcc ev then
               let full_iter = ev :: current |> List.rev in
               let iters = { events = full_iter; branch_event = ev } :: iters in
               ([], iters)
             else (ev :: current, iters))
           ([], [])
    in
    match current with
    | [ ev ] when E.is_cutoff ev -> List.rev iters
    | [] -> failwith "iterations_of_loop: empty current"
    | _evs -> failwith "Cannot determine loop iterations"

  (* (not (E.event_equal ev ev1)) *)
  (* && E.is_mem_store ev *)
  (* && Option.equal S.A.V.equal (E.value_of ev) (E.value_of ev1) *)
  (* && Option.equal S.A.location_equal (E.location_of ev) *)
  (*      (E.location_of ev1) *)

  type weighted_edges = { rf : WR.t; po : WR.t; co : WR.t }

  let is_event_in ev evs =
    List.exists (fun ev' -> E.event_equal ev ev') evs

  let validate_lasso_memory lasso_events =
    let () =
      lasso_events
      |> List.iter (fun ev ->
             if E.is_mem ev then begin
               (match E.location_of ev with
               | Some _ -> ()
               | None -> failwith "Unsupported lasso memory event");
               if E.is_atomic ev || E.is_amo ev then
                 failwith "Unsupported lasso memory event";
               if not (E.is_mem_load ev || E.is_mem_store ev) then
                 failwith "Unsupported lasso memory event"
             end)
    in
    let lasso_writes = List.filter E.is_mem_store lasso_events in
    let rec check_unique_locations = function
      | [] -> ()
      | write :: writes ->
          if List.exists (E.same_location write) writes then
            failwith "Multiple lasso writes to same location";
          check_unique_locations writes
    in
    check_unique_locations lasso_writes;
    lasso_writes

  let validate_lasso_write_co_maximality ~events ~co ~lasso_writes =
    let writes =
      events |> E.EventSet.to_list |> List.filter E.is_mem_store
    in
    List.iter
      (fun lasso_write ->
        List.iter
          (fun write ->
            if
              (not (E.event_equal write lasso_write))
              && E.same_location write lasso_write
            then begin
              if E.EventRel.mem (lasso_write, write) co then
                failwith "Lasso write is not coherence-maximal";
              if not (E.EventRel.mem (write, lasso_write) co) then
                failwith "Lasso write is not coherence-maximal"
            end)
          writes)
      lasso_writes

  let build_weighted_co ~events ~co ~is_lasso_event ~lasso_writes =
    validate_lasso_write_co_maximality ~events ~co ~lasso_writes;
    let is_lasso_write ev = is_event_in ev lasso_writes in
    let co =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, false -> WR.add (ev1, ev2, W.singleton 0) acc
          | false, true ->
              if is_lasso_write ev2 then WR.add (ev1, ev2, W.at_least 1) acc
              else failwith "Unexpected co edge into lasso"
          | true, false -> failwith "Lasso write is not coherence-maximal"
          | true, true -> failwith "Unexpected lasso-to-lasso co edge")
        co WR.empty
    in
    List.fold_left
      (fun co write -> WR.add (write, write, W.at_least 1) co)
      co lasso_writes

  let validate_no_rf_from_lasso_writes ~rf ~lasso_writes =
    rf
    |> E.EventRel.exists (fun (ev1, _) -> is_event_in ev1 lasso_writes)
    |> fun lasso_source ->
    if lasso_source then failwith "rf source is a lasso write"

  let build_lasso ~(events : E.EventSet.t) ~(rf_reg : E.event_rel)
      ~(rf : E.event_rel)
      ~(co : E.event_rel) ~(po : E.event_rel) ~(last_iteration : iteration)
      ~(before_last_iteration : iteration) : weighted_edges =
    Log.debug (fun m -> m "building lasso");
    (* Check that the two iterations are event-equal *)
    let () =
      List.combine before_last_iteration.events last_iteration.events
      |> List.for_all (fun (ev1, ev2) -> E.Act.equal ev1.E.action ev2.E.action)
      |> fun b -> if not b then failwith "Event mismatch in suffix iterations"
    in
    let lasso_writes = validate_lasso_memory last_iteration.events in
    let is_lasso_event ev =
      is_event_in ev last_iteration.events
    in
    Log.debug (fun m -> m "check no cross-iteration rf-reg edges");
    (* Check that there are no cross-iteration rf-reg edges. *)
    let () =
      rf_reg
      |> E.EventRel.exists (fun (ev1, ev2) ->
          (is_lasso_event ev1 && not (is_lasso_event ev2))
          || (is_lasso_event ev2 && not (is_lasso_event ev1)))
      |> fun cross_iter -> if cross_iter then failwith "Cross-iteration rf-reg"
    in
    validate_no_rf_from_lasso_writes ~rf ~lasso_writes;
    Log.debug (fun m -> m "check uniqueness of rf edges");
    (* Check uniqueness of rf edges and assign weights *)
    let rf =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          let is_not_uniquely_determined =
            last_iteration.events
            |> List.exists (fun ev ->
                E.EventRel.mem (ev1, ev) co
                && Option.equal E.A.V.equal (E.value_of ev) (E.value_of ev1))
          in
          if is_not_uniquely_determined then
            failwith "rf is not uniquely determined"
          else
            match (is_lasso_event ev1, is_lasso_event ev2) with
            | false, true -> WR.add (ev1, ev2, W.at_least 1) acc
            | true, false | true, true -> failwith "rf source is a lasso write"
            | false, false -> WR.add (ev1, ev2, W.singleton 0) acc)
        rf WR.empty
    in
    let co = build_weighted_co ~events ~co ~is_lasso_event ~lasso_writes in
    Log.debug (fun m -> m "assigning weights to existing po edges");
    (* Assign weights to existing po edges *)
    let finite_po = po in
    let po =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, true -> WR.add (ev1, ev2, W.at_least 1) acc
          | true, false ->
              let msg =
                Printf.sprintf "lasso to outside po edge: %s -> %s"
                  (E.pp_eiid ev1) (E.pp_eiid ev2)
              in
              raise (Error msg)
          | true, true -> WR.add (ev1, ev2, W.singleton 0) acc
          | false, false -> WR.add (ev1, ev2, W.singleton 0) acc)
        po WR.empty
    in
    Log.debug (fun m -> m "adding loop-back po edges");
    (* Add po edges to the next iteration *)
    let po =
      let branch_before_lasso = before_last_iteration.branch_event in
      let lasso_branch = last_iteration.branch_event in
      let back_po_targets =
        E.EventRel.fold
          (fun (ev1, ev2) l ->
            if E.event_equal ev1 branch_before_lasso then ev2 :: l else l)
          finite_po []
      in
      List.fold_right
        (fun ev2 -> WR.add (lasso_branch, ev2, W.at_least 1))
        back_po_targets po
    in
    Log.debug (fun m -> m "computing transitive closure");
    (* Compute transitive closure *)
    (* let po = WR.transitive_closure po in *)
    let po = WR.transitive_closure_exact po in
    Log.debug (fun m -> m "done building lasso");
    { rf; po; co }

  type infinite_exec = {
    index : int;
    conc : S.concrete;
    lasso : iteration;
    rels : (string * WR.t) list;
  }

  let run ?(lenient = false) (ltest : LitmusTest.test) (test : S.test)
      (result : TRS.t) () =
    (* Collect all executions with a single cutoff event *)
    let execs, _ = result.exec_iter |> Util.Iter.to_list in
    let execs_with_cutoff =
      execs
      |> List.mapi (fun i exec ->
          let i = i + 1 in
          let conc = TR.concrete exec in
          let cutoffs = E.EventSet.filter E.is_cutoff conc.S.str.E.events in
          match E.EventSet.cardinal cutoffs with
          | 0 -> None
          | 1 -> Some (i, exec)
          | n ->
              let exn =
                Failure (Printf.sprintf "Execution with %d cutoff events" n)
              in
              if lenient then begin
                warn_skipped_execution i exn;
                None
              end
              else raise exn)
      |> List.filter_map (fun x -> x)
    in
    execs_with_cutoff
    |> List.filter_map (fun (i, exec) ->
        let conc = TR.concrete exec in
        let rels = TR.relations exec in
        let es = conc.S.str in

        let build () =
          (* Compute static loop bounds *)
          let proc, start_spoi, end_spoi = find_static_loop_boundaries es in

          Log.debug (fun m ->
              let loop_prog =
                LitmusTest.prog_section ~proc ~start_spoi ~end_spoi ltest
              in
              m "Loop:@.%a" T.pp_prog_section loop_prog);

          (* Compute loop iterations in execution graph *)
          let iterations =
            iterations_of_loop ~proc ~start_spoi ~end_spoi es.events
          in

          Log.debug (fun m ->
              let iters = List.mapi (fun i l -> (i, l)) iterations in
              m "%a" pp_iterations iters);

          (* Find unique, repeatable lasso *)
          let last_iteration, before_last_iteration =
            match List.rev iterations with
            | x :: y :: _ -> (x, y)
            | _ ->
                Out_channel.with_open_bin "error.dot" (fun ch ->
                    PP.dump_es ch test es);
                failwith "need at least two iterations"
          in
          let rf_reg = get_rel_or_empty "rf-reg" rels in
          let rf = get_rel_or_empty "rf" rels in
          let co = get_rel_or_empty "co" rels in
          let events = non_cutoff_events conc in
          let po = conc.S.po in
          let po =
            E.EventRel.restrict_codomain (fun ev -> not (E.is_cutoff ev)) po
          in
          let { rf; po; co } =
            build_lasso ~events ~rf_reg ~rf ~co ~po ~last_iteration
              ~before_last_iteration
          in
          let assign_zero_weight r =
            E.EventRel.fold
              (fun (ev1, ev2) -> WR.add (ev1, ev2, W.singleton 0))
              r WR.empty
          in
          let rf_reg = assign_zero_weight rf_reg in
          let new_rels =
            [ ("po", po); ("rf", rf); ("co", co); ("rf-reg", rf_reg) ]
          in
          {
            index = i;
            conc = TR.concrete exec;
            lasso = last_iteration;
            rels = new_rels;
          }
        in
        try Some (build ()) with
        | Sys.Break -> raise Sys.Break
        | exn ->
            if lenient then begin
              warn_skipped_execution i exn;
              None
            end
            else begin
              Out_channel.with_open_bin "error.dot" (fun ch ->
                  PP.dump_es ch test es);
              match exn with
              | Error msg ->
                  prerr_string msg;
                  prerr_string "\n";
                  exit 1
              | exn -> raise exn
            end)

  (* let ev_poi (ev : E.event) = *)
  (*   match ev.iiid with *)
  (*   | IdSome iiid -> iiid.program_order_index *)
  (*   | _ -> assert false *)
  (* in *)

  let print_dot (fmt : Format.formatter) (exec : infinite_exec) () =
    let conc = exec.conc in
    let lasso = exec.lasso in
    let rels = exec.rels in
    let all_nodes =
      conc.S.str.events |> E.EventSet.to_list
      |> List.filter (fun e -> not (E.is_cutoff e))
    in
    let is_lasso_node ev =
      List.exists (fun lasso_ev -> E.event_equal ev lasso_ev) lasso.events
    in
    (* let lasso_head = List.hd lasso.events in *)
    let po = List.assoc "po" rels in
    (* let branch_po = *)
    (*   WR.filter *)
    (*     (fun ev1 ev2 _ -> *)
    (*       E.event_equal ev1 prev_branch *)
    (*       && E.event_equal ev2 lasso_head *)
    (*       || E.event_equal lasso.branch_event ev1 *)
    (*          && E.event_equal lasso_head ev2) *)
    (*     po *)
    (* in *)
    let reduced_po = po in
    let reduced_po = WR.transitive_reduction reduced_po in
    (* let reduced_po = WR.union reduced_po branch_po in *)
    let to_edge r (ev1, ev2, w) = (r, ev1, ev2, w) in
    let edges =
      []
      |> WR.fold (fun ed -> List.cons (to_edge "po" ed)) reduced_po
      |> WR.fold (fun ed -> List.cons (to_edge "co" ed)) (List.assoc "co" rels)
      |> WR.fold (fun ed -> List.cons (to_edge "rf" ed)) (List.assoc "rf" rels)
      |> List.filter (fun (_, ev1, ev2, _) ->
          not (E.is_cutoff ev1 || E.is_cutoff ev2))
    in
    D.pp_dot_graph fmt ~all_nodes ~is_lasso_node edges

  let add_vb label src dst vbs =
    let rel =
      match List.assoc_opt label vbs with
      | None -> E.EventRel.empty
      | Some rel -> rel
    in
    (label, E.EventRel.add (src, dst) rel) :: List.remove_assoc label vbs

  let endpoint_matches endpoints src dst =
    match endpoints with
    | None -> true
    | Some (ev1, ev2) ->
        String.equal (E.pp_eiid src) ev1 && String.equal (E.pp_eiid dst) ev2

  let weighted_vbs { name; endpoints } rel =
    WR.fold
      (fun (src, dst, weight) vbs ->
        if endpoint_matches endpoints src dst then
          let label =
            if W.equal weight (W.singleton 0) then name
            else Format.asprintf "%s %a" name W.pp weight
          in
          add_vb label src dst vbs
        else vbs)
      rel []
    |> List.rev

  let dump_exec_graph graph_rels showevents model test model_ins i exec =
    let checked = MC.check_all exec.conc exec.lasso.events exec.rels model_ins in
    let force_rel = checked.force_rel in
    List.iter
      (fun name ->
        Printf.eprintf "Warning: execution %d violates %s\n%!" i name)
      checked.failed_checks;
    let graph_rel name =
      let rel = force_rel name in
      if String.equal name "co" then WR.transitive_reduction rel else rel
    in
    let vbs =
      graph_rels
      |> List.map (fun spec -> weighted_vbs spec (graph_rel spec.name))
      |> List.concat
    in
    let path = Printf.sprintf "out-%d.dot" i in
    Out_channel.with_open_bin path (fun ch ->
        let selected_showevents = showevents in
        let module PP =
          Pretty.Make (PrettySem (struct
            let showevents = selected_showevents
          end))
        in
        PP.dump_legend ch model test PrettyConf.ShowAll exec.conc vbs);
    path

  (* result |> Iter.iteri (fun _i _exec -> ()) *)
end

let default_graph_rels = [ graph_rel "co"; graph_rel "fr" ]

let top ?(graph_rels = default_graph_rels)
    ?(showevents = PrettyConf.NonRegEvents) ?(lenient = false) ~libdir ~unroll
    file_path =
  let str = In_channel.with_open_text file_path In_channel.input_all in
  let ltest = T.parse_from_file file_path in
  let model_path =
    match libdir with
    | None -> "aarch64.cat"
    | Some dir -> Filename.concat dir "aarch64.cat"
  in
  let model_ast, model_ins = parse_model model_path in
  let model = Model.Generic (model_path, model_ast) in
  let simul = HerdDriver.top ~libdir ~unroll str in
  let module R : RunTest.Outcome = (val simul) in
  let module M = Make (R.M.S) in
  let execs = M.run ~lenient ltest R.test R.result () in
  execs
  |> List.iter (fun exec ->
         let i = exec.M.index in
         try
           let path =
             M.dump_exec_graph graph_rels showevents model R.test model_ins i
               exec
           in
           Printf.printf "Wrote %s\n%!" path
         with
         | Sys.Break -> raise Sys.Break
         | exn ->
             if lenient then warn_skipped_execution i exn else raise exn);
  print_endline "Done."
