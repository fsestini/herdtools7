module Log = (val Logs.src_log (Logs.Src.create "top") : Logs.LOG)
open Herdlib
module T = LitmusTest
module SW = WeightedRel.SetWeights
module TR = Top_herd.TestResult

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

  let pp_rel ~lbl fmt rel =
    let rel_list = Util.Iter.to_list (fun f -> E.EventRel.iter f rel) in
    let open Format in
    pp_print_list
      ~pp_sep:(fun fmt () -> fprintf fmt "@,")
      (fun fmt (ev1, ev2) ->
        fprintf fmt "%s -- %s -> %s" (E.pp_eiid ev1) lbl (E.pp_eiid ev2))
      fmt rel_list

  let test = O.test
  let result = O.result

  let execs =
    let l = ref [] in
    let _stats = result.exec_iter (fun exec -> l := exec :: !l) in
    List.rev !l

  let iterations_of_loop ~(proc : int) ~(start_spoi : int) ~(end_spoi : int)
      (evs : E.EventSet.t) : E.event list list =
    let by_poi =
      evs |> E.EventSet.to_list
      |> List.filter_map (fun ev ->
          let ( let* ) = Option.bind in
          let* proc' = E.proc_of ev in
          let* spoi = E.static_poi ev in
          let* poi = E.progorder_of ev in
          if Int.equal proc proc' then Some (spoi, poi, ev) else None)
      |> List.sort (fun (_, poi, _) (_, poi', _) -> Int.compare poi poi')
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
               let iters = full_iter :: iters in
               ([], iters)
             else (ev :: current, iters))
           ([], [])
    in
    List.rev (current :: iters)

  type lasso_candidate = {
    events : E.event list;
    rf : WR.t;
    co : WR.t;
    po : WR.t;
  }

  let overlap ~(lasso_po : E.EventRel.t) ~(lasso_co : E.EventRel.t)
      ~(lasso_rf : E.EventRel.t) ~(before_last_iteration : E.event list)
      ~(last_iteration : E.event list) : lasso_candidate option =
    let ( let* ) = Option.bind in
    let last_iteration_eiids = List.map (fun ev -> ev.E.eiid) last_iteration in
    (* let it2_eiids = List.map (fun ev -> ev.E.eiid) it2 in *)
    let is_lasso_event ev = List.mem ev.E.eiid last_iteration_eiids in
    let* branch_before_lasso =
      let brchs =
        before_last_iteration
        |> List.filter_map (fun ev -> if E.is_bcc ev then Some ev else None)
      in
      match brchs with [ brch ] -> Some brch | _ -> None
    in
    let* lasso_branch =
      let brchs =
        last_iteration
        |> List.filter_map (fun ev -> if E.is_bcc ev then Some ev else None)
      in
      match brchs with [ brch ] -> Some brch | _ -> None
    in

    (* Assign weights to input lasso co edges *)
    let co =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, true -> WR.add (ev1, ev2, SW.To_pos_inf 1) acc
          | true, false -> WR.add (ev1, ev2, SW.From_neg_inf (-1)) acc
          | true, true -> WR.add (ev1, ev2, SW.singleton 0) acc
          | false, false -> assert false)
        lasso_co WR.empty
    in
    let lasso_writes =
      lasso_co |> E.EventRel.nodes |> E.EventSet.to_list
      |> List.filter is_lasso_event
    in
    (* Add lasso co edges with +1 weight from each write to each other write (incl. self edges) *)
    let co =
      let edges =
        let ( let* ) x f = List.concat_map f x in
        let* ev1 = lasso_writes in
        let* ev2 = lasso_writes in
        [ (ev1, ev2, SW.To_pos_inf 1) ]
      in
      List.fold_right WR.add edges co
    in
    (* Compute transitive closure *)
    let co = WR.transitive_closure co in
    (* Adjust cross-lasso edges, so that lasso-to-external edges have strictly
       negative weight, and external-to-lasso edges have
       strictly positive weights. *)
    let co =
      WR.fold
        (fun (ev1, ev2, w) ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, true -> WR.add (ev1, ev2, SW.intersection w (SW.To_pos_inf 1))
          | true, false ->
              WR.add (ev1, ev2, SW.intersection w (SW.From_neg_inf (-1)))
          | _ -> WR.add (ev1, ev2, w))
        co WR.empty
    in

    let rf =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, true ->
              (* TODO: there could be other choices here. *)
              WR.add (ev1, ev2, SW.To_pos_inf 1) acc
          (* | true, false -> failwith "rf edge going from lasso to outside" *)
          | true, false -> WR.add (ev1, ev2, SW.singleton (-1)) acc
          | true, true -> WR.add (ev1, ev2, SW.singleton 0) acc
          | false, false -> assert false)
        lasso_rf WR.empty
    in

    (* Assign weights to existing po edges *)
    let po =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, true -> WR.add (ev1, ev2, SW.To_pos_inf 1) acc
          | true, false -> assert false
          | true, true -> WR.add (ev1, ev2, SW.singleton 0) acc
          | false, false -> assert false)
        lasso_po WR.empty
    in
    (* Add po edges to the next iteration *)
    let po =
      let po_edges_into_lasso =
        E.EventRel.fold
          (fun (ev1, ev2) l ->
            if E.event_equal ev1 branch_before_lasso then ev2 :: l else l)
          lasso_po []
      in
      List.fold_right
        (fun ev2 -> WR.add (lasso_branch, ev2, SW.singleton 1))
        po_edges_into_lasso po
    in
    (* Compute transitive closure *)
    let po = WR.transitive_closure po in

    (* TODO: Compute lasso rf-reg *)
    Some { events = last_iteration; po; co; rf }

  let find_static_loop_boundaries (_test : LitmusTest.test)
      (es : E.event_structure) =
    let ( let* ) = Option.bind in
    let events = es.events |> E.EventSet.to_list in
    let cutoffs =
      events
      |> List.filter_map (fun ev ->
          match (E.proc_of ev, ev.iiid) with
          | Some proc, IdSome iiid when E.is_cutoff ev ->
              let static_poi = iiid.static_poi in
              let poi = iiid.program_order_index in
              Some (proc, static_poi, poi)
          | _ -> None)
    in
    let* cutoff_proc, start_spoi, cutoff_poi =
      match cutoffs with
      | [] -> None
      | x :: [] -> Some x
      | _ :: _ :: _ ->
          invalid_arg "Multi-loop litmus tests are not supported yet."
    in
    let bcc_events =
      events
      |> List.filter_map (fun ev ->
          match (E.proc_of ev, ev.iiid) with
          | Some proc, IdSome iiid
            when E.is_bcc ev && Int.equal proc cutoff_proc ->
              Some iiid
          | _ -> None)
    in
    let* end_spoi =
      match bcc_events with
      | [ iiid ] when Int.equal iiid.program_order_index (cutoff_poi - 1) ->
          Some iiid.static_poi
      | _ -> None
    in
    Log.debug (fun m ->
        m "cutoff start_spoi: %d, end_spoi: %d@." start_spoi end_spoi);
    Some (cutoff_proc, start_spoi, end_spoi)

  let run (ltest : LitmusTest.test) () =
    let execs_with_cutoff =
      execs
      |> List.filter (fun exec ->
          let conc = TR.concrete exec in
          E.EventSet.exists E.is_cutoff conc.S.str.E.events)
    in
    let ( let* ) = Option.bind in
    let candidates =
      execs_with_cutoff
      |> List.filter_map (fun exec ->
          let conc = TR.concrete exec in
          let rels = TR.relations exec in
          let es = conc.S.str in
          let* proc, start_spoi, end_spoi =
            find_static_loop_boundaries ltest es
          in

          Log.debug (fun m ->
              let loop_prog =
                LitmusTest.prog_section ~proc ~start_spoi ~end_spoi ltest
              in
              m "Loop: %a" T.pp_prog_section loop_prog);

          let iterations =
            iterations_of_loop ~proc ~start_spoi ~end_spoi es.events
          in
          (* let () = *)
          (*   iterations *)
          (*   |> List.iteri (fun i iter -> *)
          (*       Log.debug (fun m -> m "Iteration #%d" i); *)
          (*       iter *)
          (*       |> List.iter (fun ev -> *)
          (*           Log.debug (fun m -> *)
          (*               m "  %s: %s" (E.pp_eiid ev) (E.pp_action ev)))) *)
          (* in *)
          let* last_iteration, before_last_iteration =
            match List.rev iterations with
            | _cutoff :: x :: y :: _ -> Some (x, y)
            | _ -> None (* need at least two iterations *)
          in
          let last_iteration_eiids =
            List.map (fun ev -> ev.E.eiid) last_iteration
          in
          let* () =
            (* Check that the two iterations are event-equal *)
            List.combine before_last_iteration last_iteration
            |> List.for_all (fun (ev1, ev2) ->
                E.Act.equal ev1.E.action ev2.E.action)
            |> Misc.Option.guard
          in
          let is_lasso_event ev = List.mem ev.E.eiid last_iteration_eiids in
          let* () =
            (* Temporary: check that there are no cross-iteration rf-reg edges. To be supported. *)
            rels |> List.assoc_opt "rf-reg"
            |> Option.value ~default:E.EventRel.empty
            |> E.EventRel.exists (fun (ev1, ev2) ->
                (is_lasso_event ev1 && not (is_lasso_event ev2))
                || (is_lasso_event ev2 && not (is_lasso_event ev1)))
            |> not |> Misc.Option.guard
          in
          let is_lasso_edge ev1 ev2 =
            (is_lasso_event ev1 || is_lasso_event ev2)
            && not (E.Act.is_cutoff ev1.E.action || E.Act.is_cutoff ev2.E.action)
          in
          let assign_zero_weight r =
            E.EventRel.fold
              (fun (ev1, ev2) -> WR.add (ev1, ev2, SW.singleton 0))
              r WR.empty
          in
          let co =
            List.assoc_opt "co" rels |> Option.value ~default:E.EventRel.empty
          in
          let rf =
            List.assoc_opt "rf" rels |> Option.value ~default:E.EventRel.empty
          in
          let po = conc.S.po in
          let lasso_co = co |> E.EventRel.restrict_rel is_lasso_edge in
          let lasso_rf = rf |> E.EventRel.restrict_rel is_lasso_edge in
          let lasso_po = po |> E.EventRel.restrict_rel is_lasso_edge in
          let other_co = E.EventRel.diff co lasso_co |> assign_zero_weight in
          let other_rf = E.EventRel.diff rf lasso_rf |> assign_zero_weight in
          let other_po = E.EventRel.diff po lasso_po |> assign_zero_weight in
          (* let rels = *)
          (*   let lasso_edges = [ ("co", lasso_co); ("rf", lasso_rf) ] in *)
          (*   rels *)
          (*   |> List.map (fun (tag, r) -> *)
          (*       match List.assoc_opt tag lasso_edges with *)
          (*       | Some lasso_r -> (tag, E.EventRel.diff r lasso_r) *)
          (*       | None -> (tag, r)) *)
          (* in *)
          let* lasso_cand =
            overlap ~lasso_po ~lasso_co ~lasso_rf ~before_last_iteration
              ~last_iteration
          in
          let po = WR.union lasso_cand.po other_po in
          let co = WR.union lasso_cand.co other_co in
          let rf = WR.union lasso_cand.rf other_rf in
          (* let rels = rels @ extra_edges in *)
          (* let () = *)
          (*   PP.dump_legend Out_channel.stdout test "" exec.TR.concrete rels *)
          (* in *)
          (* let _ = rels in *)
          Some (TR.concrete exec, { lasso_cand with po; co; rf }))
    in
    let print_dot () =
      candidates
      |> List.iter (fun (conc, lasso) ->
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
              let reduced_po = WR.transitive_reduction lasso.po in
              let reduced_co = WR.transitive_reduction lasso.co in
              (* let reduced_po = lasso.po in *)
              let to_edge r (ev1, ev2, w) = (r, ev1, ev2, w) in
              let edges =
                []
                |> WR.fold (fun ed -> List.cons (to_edge "po" ed)) reduced_po
                |> WR.fold (fun ed -> List.cons (to_edge "co" ed)) reduced_co
                |> WR.fold (fun ed -> List.cons (to_edge "rf" ed)) lasso.rf
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
  let analysis = HerdDriver.top ~libdir ~unroll str in
  let module R = (val analysis) in
  let module M = Make (R) in
  M.run test ()
