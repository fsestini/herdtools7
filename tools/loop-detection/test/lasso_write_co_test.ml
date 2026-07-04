open Herdlib
module T = Loop_detection.LitmusTest
module W = Loop_detection.IntervalWeights

let file_path = "data/wait-flag.litmus"
let libdir = Some "libdir"
let unroll = None

let plain_rel_of_weighted fold rel empty add =
  fold (fun (src, dst, _) acc -> add (src, dst) acc) rel empty

let print_rel pp_eiid fold rel =
  let edges = fold (fun edge edges -> edge :: edges) rel [] |> List.rev in
  List.iter
    (fun (src, dst, weight) ->
      Format.printf "  (%s,%s,%a)@." (pp_eiid src) (pp_eiid dst) W.pp weight)
    edges

let print_rejection name f =
  match f () with
  | () -> Format.printf "%s = <unexpected success>@." name
  | exception _ -> Format.printf "%s = rejected@." name

let print_acceptance name f =
  match f () with
  | () -> Format.printf "%s = accepted@." name
  | exception _ -> Format.printf "%s = <unexpected rejection>@." name

let () =
  let str = In_channel.with_open_text file_path In_channel.input_all in
  let ltest = T.parse_from_file file_path in
  let simul = Loop_detection.HerdDriver.top ~libdir ~unroll str in
  let module R : RunTest.Outcome = (val simul) in
  let module M = Loop_detection.Top.Make (R.M.S) in
  let exec =
    match M.run ltest R.test R.result () with
    | exec :: _ -> exec
    | [] -> failwith "expected an infinite execution"
  in
  let events = M.non_cutoff_events exec.M.conc in
  let event_list = M.E.EventSet.to_list events in
  let lasso_write =
    event_list
    |> List.find (fun ev -> M.E.is_mem_store ev && not (M.E.is_mem_store_init ev))
  in
  let init_write = event_list |> List.find M.E.is_mem_store_init in
  let read = event_list |> List.find M.E.is_mem_load in
  let co =
    let co = List.assoc "co" exec.M.rels in
    plain_rel_of_weighted M.WR.fold co M.E.EventRel.empty M.E.EventRel.add
  in
  let is_lasso_event ev = M.E.event_equal ev lasso_write in
  let weighted_co =
    M.build_weighted_co ~events ~co ~is_lasso_event
      ~lasso_writes:[ lasso_write ]
  in
  Format.printf "co =@.";
  print_rel M.E.pp_eiid M.WR.fold weighted_co;
  print_rejection "multiple_same_loc_writes" (fun () ->
      ignore (M.validate_lasso_memory [ init_write; lasso_write ]));
  print_acceptance "same_loc_read" (fun () ->
      ignore (M.validate_lasso_memory [ lasso_write; read ]));
  print_rejection "rf_from_lasso_write" (fun () ->
      let rf = M.E.EventRel.add (lasso_write, read) M.E.EventRel.empty in
      M.validate_no_rf_from_lasso_writes ~rf ~lasso_writes:[ lasso_write ]);
  print_rejection "not_co_maximal" (fun () ->
      let is_lasso_event ev = M.E.event_equal ev init_write in
      ignore
        (M.build_weighted_co ~events ~co ~is_lasso_event
           ~lasso_writes:[ init_write ]))
