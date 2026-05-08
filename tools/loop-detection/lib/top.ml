module Log = (val Logs.src_log (Logs.Src.create "top") : Logs.LOG)

(* module Iter = struct *)
(*   type ('a, 'b) t = ('a -> unit) -> 'b *)
(**)
(*   let iteri (f : int -> 'a -> unit) (i : ('a, 'b) t) : 'b = *)
(*     let k = ref 0 in *)
(*     let b = *)
(*       i (fun x -> *)
(*           f !k x; *)
(*           k := !k + 1) *)
(*     in *)
(*     b *)
(* end *)

module Util = struct
  let fold_left_until (f : 'acc -> 'a -> 'acc option) (acc : 'acc) l =
    let acc = ref acc in
    try
      List.iter
        (fun x ->
          match f !acc x with
          | Some new_acc -> acc := new_acc
          | None -> raise Exit)
        l;
      !acc
    with Exit -> !acc
end

module T = LitmusTest.MakeArch (struct
  let is_morello = false
end)

module Make (O : Herdlib.RunTest.Outcome) = struct
  open Herdlib
  module S = O.M.S
  module E = S.E

  let test = O.test
  let ess, result = O.result

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
    let* end_spoi =
      events
      |> List.find_map (fun ev ->
          match (E.proc_of ev, ev.iiid) with
          | Some proc, IdSome iiid
            when E.is_bcc ev && Int.equal proc cutoff_proc
                 && Int.equal iiid.program_order_index (cutoff_poi - 1) ->
              Some iiid.static_poi
          | _ -> None)
    in
    Log.debug (fun m ->
        m "cutoff start_spoi: %d, end_spoi: %d@." start_spoi end_spoi);
    Some (cutoff_proc, start_spoi, end_spoi)

  let run (test : LitmusTest.test) () =
    let ess_with_cutoff =
      ess |> List.filter (fun es -> E.EventSet.exists E.is_cutoff es.E.events)
    in
    let es = List.hd ess_with_cutoff in
    let proc_poi = find_static_loop_boundaries test es in
    match proc_poi with
    | None -> Format.printf "Could not find any loops@."
    | Some (proc, start_spoi, end_spoi) ->
        Log.debug (fun m ->
            m "Loop detected: proc: %d, start_spoi: %d, end_spoi: %d@." proc
              start_spoi end_spoi);
        let prog_ins = LitmusTest.prog_instructions test in
        let proc_prog = List.assoc proc prog_ins in
        let loop_prog =
          List.take (end_spoi - start_spoi + 1) (List.drop start_spoi proc_prog)
        in
        Format.printf "Loop:@.";
        let () =
          loop_prog
          |> List.iter (fun ins ->
              Format.printf "  %s@." (T.show_instruction ins))
        in
        let iterations =
          iterations_of_loop ~proc ~start_spoi ~end_spoi es.events
        in
        iterations
        |> List.iteri (fun i iter ->
            Format.printf "Iteration #%d@." i;
            iter
            |> List.iter (fun ev ->
                Format.printf "  %s: %s@." (E.pp_eiid ev) (E.pp_action ev)))

  (* result |> Iter.iteri (fun _i _exec -> ()) *)
end

let top ~libdir file_path =
  let str = In_channel.with_open_text file_path In_channel.input_all in
  let test = T.parse_from_file file_path in
  let analysis = HerdDriver.top ~libdir str in
  let module R = (val analysis) in
  let module M = Make (R) in
  M.run test ()
