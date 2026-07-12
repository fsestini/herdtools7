type loop_boundaries = { proc : int; start_spoi : int; end_spoi : int }
type 'rel lasso_rels = { rf : 'rel; po : 'rel; co : 'rel; rf_reg : 'rel }
type 'ev iteration = { events : 'ev list; branch_event : 'ev }

type ('ev, 'rel) lasso = {
  iteration : 'ev iteration;
  initial_weights : 'rel lasso_rels;
}

type 'a weighted_lasso =
  Lasso : (module WeightedRel.S with type t = 'rel and type elt = 'a)
        * ('a, 'rel) lasso
       -> 'ev weighted_lasso

exception Unsupported of string

let unsupported msg = raise (Unsupported msg)

module W = Weight

module Make (S : SemExtra.S) (WR : WeightedRel.S with type elt = S.E.event) =
struct
  module E = S.E
  module A = S.A

  type nonrec iteration = E.event iteration
  type nonrec lasso = (E.event, WR.t) lasso

  let find_static_loop_boundaries ~(cutoff : E.event) (es : E.event_structure) =
    let events = es.E.events |> E.EventSet.to_list in
    let iiid =
      match cutoff.E.iiid with
      | E.IdSome iiid -> iiid
      | _ -> failwith "expected cutoff event with iiid"
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
    | _evs -> failwith "cannot determine loop iterations"

  let assign_zero_weight r =
    E.EventRel.fold
      (fun (ev1, ev2) -> WR.add (ev1, ev2, W.singleton 0))
      r WR.empty

  let compute_lasso_weights ~lasso_candidate ~predecessor input_rels =
    let { rf; po; co; rf_reg } = input_rels in
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
    let is_lasso_event ev =
      List.exists (fun ev' -> E.event_equal ev ev') lasso_candidate.events
    in
    (* Check that there are no cross-iteration rf-reg edges. *)
    let () =
      rf_reg
      |> E.EventRel.exists (fun (ev1, ev2) ->
          (is_lasso_event ev1 && not (is_lasso_event ev2))
          || (is_lasso_event ev2 && not (is_lasso_event ev1)))
      |> fun cross_iter ->
      if cross_iter then unsupported "cross-iteration rf-reg"
    in
    (* Check uniqueness of rf edges and assign weights *)
    let rf =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          let is_not_uniquely_determined =
            lasso_candidate.events
            |> List.exists (fun ev ->
                E.EventRel.mem (ev1, ev) co
                && Option.equal E.A.V.equal (E.value_of ev) (E.value_of ev1))
          in
          if is_not_uniquely_determined then
            unsupported "rf is not uniquely determined"
          else
            match (is_lasso_event ev1, is_lasso_event ev2) with
            | false, true -> WR.add (ev1, ev2, W.at_least 1) acc
            | true, false | true, true -> failwith "unexpected lasso write"
            | false, false -> WR.add (ev1, ev2, W.singleton 0) acc)
        rf WR.empty
    in
    (* Assign weights to existing po edges *)
    let finite_po = po in
    let po =
      E.EventRel.fold
        (fun (ev1, ev2) acc ->
          match (is_lasso_event ev1, is_lasso_event ev2) with
          | false, true -> WR.add (ev1, ev2, W.at_least 1) acc
          | true, false -> failwith "po edge going outside the lasso"
          | true, true -> WR.add (ev1, ev2, W.singleton 0) acc
          | false, false -> WR.add (ev1, ev2, W.singleton 0) acc)
        po WR.empty
    in
    (* Add po edges to the next iteration *)
    let po =
      let branch_before_lasso = predecessor.branch_event in
      let lasso_branch = lasso_candidate.branch_event in
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
    let po =
      match WR.transitive_closure po with
      | Some po -> po
      | None -> unsupported "could not compute transitive closure of po"
    in
    let co = assign_zero_weight co in
    let rf_reg = assign_zero_weight rf_reg in
    { rf; po; co; rf_reg }

  let build_lasso es cutoff ~rf_reg ~rf ~co ~po =
    let loop = find_static_loop_boundaries ~cutoff es in
    let iterations = iterations_of_loop loop es.E.events in
    let lasso_candidate, predecessor =
      match List.rev iterations with
      | x :: y :: _ -> (x, y)
      | _ -> unsupported "need at least two iterations"
    in
    let initial_weights =
      compute_lasso_weights { rf_reg; rf; co; po } ~lasso_candidate ~predecessor
    in
    { iteration = lasso_candidate; initial_weights }

  let find_lasso conc ~rf_reg ~rf ~co =
    let cutoffs = E.EventSet.filter E.is_cutoff conc.S.str.E.events in
    match E.EventSet.to_list cutoffs with
    | [] -> `Finite
    | [ cutoff ] -> (
        let es = conc.S.str in
        let po = conc.S.po in
        let po =
          E.EventRel.restrict_codomain (fun ev -> not (E.is_cutoff ev)) po
        in
        try
          let lasso = build_lasso es cutoff ~rf_reg ~rf ~co ~po in
          `Infinite lasso
        with Unsupported str -> `Unsupported str)
    | cutoffs ->
        let n = List.length cutoffs in
        let msg = Printf.sprintf "Execution with %d cutoff events" n in
        `Unsupported msg
end
