module Log = (val Logs.src_log (Logs.Src.create "top") : Logs.LOG)
open Herdlib
module T = LitmusTest
module SW = WeightedRel.SetWeights
module TR = Top_herd.TestResult

exception Error of string

module Make (O : Herdlib.RunTest.Outcome) = struct
  module S = O.M.S
  module E = S.E

  module D = Dot.Make (struct
    type node = E.event
    type edge = string * E.event * E.event * SW.t

    let node_id ev = Format.sprintf "eiid%d" ev.E.eiid
    let node_cluster ev = E.proc_of ev
    let endpoints (_, x, y, _) = (x, y)
    let node_label ev = Format.sprintf "%s: %s" (E.pp_eiid ev) (E.pp_action ev)
    let edge_label (r, _, _, w) = Format.asprintf "%s %a" r SW.pp w
  end)

  module WR =
    WeightedRel.Make
      (SW)
      (struct
        type t = E.event

        let compare = E.event_compare
      end)

  let get_rel_or_empty lbl rels =
    List.assoc_opt lbl rels |> Option.value ~default:E.EventRel.empty

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

  type weighted_edges = { rf : WR.t; po : WR.t }

  let build_lasso ~(rf_reg : E.event_rel) ~(rf : E.event_rel)
      ~(co : E.event_rel) ~(po : E.event_rel) ~(last_iteration : iteration)
      ~(before_last_iteration : iteration) : weighted_edges =
    (* Check that the only memory events are loads *)
    let () =
      last_iteration.events
      |> List.for_all (fun ev -> (not (E.is_mem ev)) || E.is_mem_load ev)
      |> fun b -> if not b then failwith "Non-read memory event"
    in
    (* Check that the two iterations are event-equal *)
    let () =
      List.combine before_last_iteration.events last_iteration.events
      |> List.for_all (fun (ev1, ev2) -> E.Act.equal ev1.E.action ev2.E.action)
      |> fun b -> if not b then failwith "Event mismatch in suffix iterations"
    in
    let is_lasso_event ev =
      let last_iteration_eiids =
        List.map (fun ev -> ev.E.eiid) last_iteration.events
      in
      List.mem ev.E.eiid last_iteration_eiids
    in
    (* Check that there are no cross-iteration rf-reg edges. *)
    let () =
      rf_reg
      |> E.EventRel.exists (fun (ev1, ev2) ->
          (is_lasso_event ev1 && not (is_lasso_event ev2))
          || (is_lasso_event ev2 && not (is_lasso_event ev1)))
      |> fun cross_iter -> if cross_iter then failwith "Cross-iteration rf-reg"
    in
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
            | false, true -> WR.add (ev1, ev2, SW.To_pos_inf 1) acc
            | true, false ->
                (* WR.add (ev1, ev2, SW.From_neg_inf (-1)) acc *)
                failwith "impossible: there should be no writes in the lasso"
            | true, true ->
                (* WR.add (ev1, ev2, SW.singleton 0) acc *)
                failwith "impossible: there should be no writes in the lasso"
            | false, false -> WR.add (ev1, ev2, SW.singleton 0) acc)
        rf WR.empty
    in
    (* Assign weights to existing po edges *)
    let finite_po = po in
    let po =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, true -> WR.add (ev1, ev2, SW.To_pos_inf 1) acc
          | true, false ->
              let msg =
                Printf.sprintf "lasso to outside po edge: %s -> %s"
                  (E.pp_eiid ev1) (E.pp_eiid ev2)
              in
              raise (Error msg)
          | true, true -> WR.add (ev1, ev2, SW.singleton 0) acc
          | false, false -> WR.add (ev1, ev2, SW.singleton 0) acc)
        po WR.empty
    in
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
        (fun ev2 -> WR.add (lasso_branch, ev2, SW.singleton 1))
        back_po_targets po
    in
    (* Compute transitive closure *)
    let po = WR.transitive_closure po in
    { rf; po }

  let run (ltest : LitmusTest.test) () =
    (* Collect all executions with a single cutoff event *)
    let execs_with_cutoff, _ =
      O.result.exec_iter
      |> Util.Iter.filter (fun exec ->
          let conc = TR.concrete exec in
          let cutoffs = E.EventSet.filter E.is_cutoff conc.S.str.E.events in
          match E.EventSet.cardinal cutoffs with
          | 0 -> false
          | 1 -> true
          | n -> failwith (Printf.sprintf "Execution with %d cutoff events" n))
      |> Util.Iter.to_list
    in
    let candidates =
      execs_with_cutoff
      |> List.filter_map (fun exec ->
          let conc = TR.concrete exec in
          let rels = TR.relations exec in
          let es = conc.S.str in

          try
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
                      PP.dump_es ch O.test es);
                  failwith "need at least two iterations"
            in
            let rf_reg = get_rel_or_empty "rf-reg" rels in
            let rf = get_rel_or_empty "rf" rels in
            let co = get_rel_or_empty "co" rels in
            let po = conc.S.po in
            let po =
              E.EventRel.restrict_codomain (fun ev -> not (E.is_cutoff ev)) po
            in
            let { rf; po } =
              build_lasso ~rf_reg ~rf ~co ~po ~last_iteration
                ~before_last_iteration
            in
            let assign_zero_weight r =
              E.EventRel.fold
                (fun (ev1, ev2) -> WR.add (ev1, ev2, SW.singleton 0))
                r WR.empty
            in
            let co = assign_zero_weight co in
            let rf_reg = assign_zero_weight rf_reg in
            let new_rels =
              [ ("po", po); ("rf", rf); ("co", co); ("rf-reg", rf_reg) ]
            in
            Some
              ( TR.concrete exec,
                before_last_iteration.branch_event,
                last_iteration,
                new_rels )
          with Error msg ->
            Out_channel.with_open_bin "error.dot" (fun ch ->
                PP.dump_es ch O.test es);
            prerr_string msg;
            prerr_string "\n";
            exit 1)
    in
    (* let ev_poi (ev : E.event) = *)
    (*   match ev.iiid with *)
    (*   | IdSome iiid -> iiid.program_order_index *)
    (*   | _ -> assert false *)
    (* in *)
    let print_dot () =
      candidates
      |> List.iter (fun (conc, _prev_branch, lasso, rels) ->
          Format.printf "%a@.@."
            (fun fmt () ->
              let all_nodes =
                conc.S.str.events |> E.EventSet.to_list
                |> List.filter (fun e -> not (E.is_cutoff e))
              in
              let is_lasso_node ev =
                List.exists
                  (fun lasso_ev -> E.event_equal ev lasso_ev)
                  lasso.events
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
              (* let reduced_po = WR.filter (fun _ _ w -> SW.mem 0 w) reduced_po in *)
              let reduced_po = WR.transitive_reduction reduced_po in
              (* let reduced_po = WR.union reduced_po branch_po in *)
              let to_edge r (ev1, ev2, w) = (r, ev1, ev2, w) in
              let edges =
                []
                |> WR.fold (fun ed -> List.cons (to_edge "po" ed)) reduced_po
                |> WR.fold
                     (fun ed -> List.cons (to_edge "co" ed))
                     (List.assoc "co" rels)
                |> WR.fold
                     (fun ed -> List.cons (to_edge "rf" ed))
                     (List.assoc "rf" rels)
                |> List.filter (fun (_, ev1, ev2, _) ->
                    not (E.is_cutoff ev1 || E.is_cutoff ev2))
              in
              D.pp_dot_graph fmt ~all_nodes ~is_lasso_node edges)
            ())
    in
    print_dot ();
    let _ = print_dot in
    ()

  (* result |> Iter.iteri (fun _i _exec -> ()) *)
end

let top ~libdir ~unroll file_path =
  let str = In_channel.with_open_text file_path In_channel.input_all in
  let test = T.parse_from_file file_path in
  let simul = HerdDriver.top ~libdir ~unroll str in
  let module R = (val simul) in
  let module M = Make (R) in
  M.run test ()
