exception Unsupported of string

type loop_boundaries = { proc : int; start_spoi : int; end_spoi : int }
type 'ev iteration = { events : 'ev list; branch_event : 'ev }

type 'ev lasso = {
  predecessor : 'ev iteration;
  iteration : 'ev iteration;
}

let lasso_events lasso = lasso.iteration.events

type 'rel lazy_env = (string * 'rel Lazy.t) list

(* type 'a weighted_lasso = *)
(*   Lasso : (module WeightedRel.S with type t = 'rel and type elt = 'a) *)
(*         * ('a, 'rel) lasso *)
(*        -> 'ev weighted_lasso *)

let unsupported msg = raise (Unsupported msg)

module W = Weight

module Builder (E : Event.S) = struct
  module A = E.A

  (***********************************************************)
  (*     Detecting lassos                                    *)
  (***********************************************************)

  let find_static_loop_boundaries ~(cutoff : E.event) (es : E.event_structure) =
    let events = es.E.events |> E.EventSet.to_list in
    let iiid =
      match cutoff.E.iiid with
      | E.IdSome iiid -> iiid
      | _ -> unsupported "expected cutoff event with iiid"
    in
    let cutoff_proc = iiid.A.proc in
    let start_spoi = iiid.A.static_poi in
    let cutoff_poi = iiid.A.program_order_index in
    let bcc_events =
      events
      |> List.filter_map (fun ev ->
          match (E.proc_of ev, ev.E.iiid) with
          | Some proc, E.IdSome iiid
            when E.is_bcc ev && Int.equal proc cutoff_proc
                 && Int.equal iiid.A.program_order_index (cutoff_poi - 1) ->
              Some (ev, iiid)
          | _ -> None)
    in
    let end_spoi =
      match bcc_events with
      | [ (_ev, iiid) ] -> iiid.A.static_poi
      | _ -> unsupported "expected exactly one branch event per loop"
    in
    { proc = cutoff_proc; start_spoi; end_spoi }

  let iterations_of_loop loop (evs : E.EventSet.t) =
    let ( let* ) = Option.bind in
    let by_poi =
      evs |> E.EventSet.to_list
      |> List.filter_map (fun ev ->
          let* proc' = E.proc_of ev in
          let* spoi = E.static_poi ev in
          let* poi = E.progorder_of ev in
          if Int.equal loop.proc proc' then Some (spoi, poi, ev) else None)
      |> List.sort (fun (_, poi, ev) (_, poi', ev') ->
          match Int.compare poi poi' with
          | 0 -> Int.compare ev.E.eiid ev'.E.eiid
          | n -> n)
    in
    let all_iterations =
      by_poi
      |> List.filter (fun (spoi, _, _) ->
          loop.start_spoi <= spoi && spoi <= loop.end_spoi)
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
    | _ -> unsupported "cannot determine loop iterations"

  let build_lasso es cutoff =
    let loop = find_static_loop_boundaries ~cutoff es in
    let iterations = iterations_of_loop loop es.E.events in
    let lasso_candidate, predecessor =
      match List.rev iterations with
      | x :: y :: _ -> (x, y)
      | _ -> unsupported "need at least two iterations"
    in
    (* Check that the two iterations are event-equal *)
    let () =
      List.combine predecessor.events lasso_candidate.events
      |> List.for_all (fun (ev1, ev2) -> E.Act.equal ev1.E.action ev2.E.action)
      |> fun b -> if not b then unsupported "last two iterations do not match"
    in
    (* Check that all lasso memory events are reads *)
    let () =
      lasso_candidate.events
      |> List.iter (fun ev ->
          if E.is_mem ev && not (E.is_mem_load ev) then
            unsupported "non-read memory event in lasso")
    in
    { iteration = lasso_candidate; predecessor }

  let find_lasso es =
    let cutoffs = E.EventSet.filter E.is_cutoff es.E.events in
    match E.EventSet.to_list cutoffs with
    | [] -> `Finite
    | [ cutoff ] -> (
        try
          let lasso = build_lasso es cutoff in
          `Infinite lasso
        with Unsupported str -> `Unsupported str)
    | cutoffs ->
        let n = List.length cutoffs in
        let msg = Printf.sprintf "Execution with %d cutoff events" n in
        `Unsupported msg
end

module Weights (E : Event.S) (WR : WeightedRel.S with type elt = E.event) =
struct
  (***********************************************************)
  (*     Computing lasso weights                             *)
  (***********************************************************)

  type event_kind = Finite | Lasso

  let event_kind lasso_events ev =
    if E.EventSet.mem ev lasso_events then Lasso else Finite

  let all_offsets lasso_events src dst =
    match (event_kind lasso_events src, event_kind lasso_events dst) with
    | Finite, Finite -> W.singleton 0
    | Finite, Lasso -> W.at_least 1
    | Lasso, Finite -> W.at_most (-1)
    | Lasso, Lasso -> W.top

  let assign_weights (w : E.event -> E.event -> Weight.t) (r : E.event_rel) : WR.t
      =
    E.EventRel.fold
      (fun (src, dst) acc -> WR.add (src, dst, w src dst) acc)
      r WR.empty

  let assign_zero_weight = assign_weights (fun _ _ -> Weight.singleton 0)
  let assign_max_weights lasso_events = assign_weights (all_offsets lasso_events)

  let is_lasso_event lasso ev =
    List.exists (fun ev' -> E.event_equal ev ev') (lasso_events lasso)

  (* let find_init_rel name (init_env : E.event_rel lazy_env) = *)
  (*   match List.assoc_opt name init_env with *)
  (*   | Some v -> Lazy.force v *)
  (*   | None -> *)
  (*       unsupported (Printf.sprintf "expected relation in initial env: %s" name) *)

  let check_assign_rf_reg lasso rf_reg =
    let is_lasso_evt = is_lasso_event lasso in
    (* Check that there are no cross-iteration rf-reg edges. *)
    let () =
      rf_reg
      |> E.EventRel.exists (fun (ev1, ev2) ->
          (is_lasso_evt ev1 && not (is_lasso_evt ev2))
          || (is_lasso_evt ev2 && not (is_lasso_evt ev1)))
      |> fun cross_iter ->
      if cross_iter then unsupported "cross-iteration rf-reg"
    in
    assign_zero_weight rf_reg

  let check_assign_rf lasso rf =
    (* Check uniqueness of rf edges and assign weights *)
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          let is_not_uniquely_determined =
            lasso.iteration.events
            |> List.exists (fun ev ->
                not (Int.equal ev1.E.eiid ev.E.eiid)
                && Option.equal E.A.location_equal (E.location_of ev) (E.location_of ev1)
                && Option.equal E.A.V.equal (E.value_of ev) (E.value_of ev1))
          in
          if is_not_uniquely_determined then
            unsupported "rf is not uniquely determined"
          else
            match (is_lasso_event lasso ev1, is_lasso_event lasso ev2) with
            | false, true -> WR.add (ev1, ev2, W.at_least 1) acc
            | true, false | true, true -> unsupported "unexpected lasso write"
            | false, false -> WR.add (ev1, ev2, W.singleton 0) acc)
        rf WR.empty

  let assign_po lasso po =
    let po =
      E.EventRel.restrict_codomain (fun ev -> not (E.is_cutoff ev)) po
    in
    (* Assign weights to existing po edges *)
    let finite_po = po in
    let po =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event lasso ev1, is_lasso_event lasso ev2) with
          | false, true -> WR.add (ev1, ev2, W.at_least 1) acc
          | true, false -> unsupported "po edge going outside the lasso"
          | true, true -> WR.add (ev1, ev2, W.singleton 0) acc
          | false, false -> WR.add (ev1, ev2, W.singleton 0) acc)
        po WR.empty
    in
    (* Add po edges to the next iteration *)
    let po =
      let branch_before_lasso = lasso.predecessor.branch_event in
      let lasso_branch = lasso.iteration.branch_event in
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
    (* Compute transitive closure *)
    match WR.transitive_closure po with
    | Some po -> po
    | None -> unsupported "could not compute transitive closure of po"

  let check_assign_si_sm r =
    if E.EventRel.for_all (fun (ev1, ev2) -> E.event_equal ev1 ev2) r then
      assign_zero_weight r
    else unsupported "si/sm"

  let compute_initial_weights lasso (init_env : E.event_rel lazy_env) :
      (WR.t lazy_env, string) result =
    let lasso_evs = E.EventSet.of_list (lasso_events lasso) in
    let with_lazy_rel f r = lazy (f (Lazy.force r)) in
    try
      Ok
        (init_env
        |> List.map (fun (name, rel) ->
            match name with
            | "rf-reg" -> (name, with_lazy_rel (check_assign_rf_reg lasso) rel)
            | "rf" -> (name, with_lazy_rel (check_assign_rf lasso) rel)
            | "po" -> (name, with_lazy_rel (assign_po lasso) rel)
            | "int" | "ext" | "loc" ->
                (name, with_lazy_rel (assign_max_weights lasso_evs) rel)
            | "iico_data" | "iico_ctrl" | "iico_order" | "same-instance" ->
                (name, with_lazy_rel assign_zero_weight rel)
            | "si" | "sm" -> (name, with_lazy_rel check_assign_si_sm rel)
            | _ ->
                let msg = Printf.sprintf "unhandled initial relation `%s`" name in
                unsupported msg))
    with Unsupported msg -> Error msg

end
