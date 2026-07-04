open Herdlib
module T = Loop_detection.LitmusTest
module SW = Loop_detection.WeightedRel.SetWeights

let file_path = "data/wait-flag.litmus"
let libdir = Some "libdir"
let unroll = None

let print_rel pp_eiid fold rels name =
  let rel = List.assoc name rels in
  let edges = fold (fun edge edges -> edge :: edges) rel [] |> List.rev in
  Format.printf "%s =@." name;
  List.iter
    (fun (src, dst, weight) ->
      Format.printf "  (%s,%s,%a)@." (pp_eiid src) (pp_eiid dst) SW.pp weight)
    edges

let () =
  let str = In_channel.with_open_text file_path In_channel.input_all in
  let ltest = T.parse_from_file file_path in
  let simul = Loop_detection.HerdDriver.top ~libdir ~unroll str in
  let module R : RunTest.Outcome = (val simul) in
  let module S = R.M.S in
  let module E = S.E in
  let module M = Loop_detection.Top.Make (R.M.S) in
  let module WR =
    Loop_detection.WeightedRel.Make
      (SW)
      (struct
        type t = E.event

        let compare = E.event_compare
      end)
  in
  let module MC = Loop_detection.ModelChecker.Make (R.M.S) (WR) in
  let execs = M.run ltest R.test R.result () in
  List.iteri
    (fun i ({ M.rels; _ } : M.infinite_exec) ->
      Format.printf "execution %d@." i;

      print_rel M.E.pp_eiid M.WR.fold rels "po";
      print_rel M.E.pp_eiid M.WR.fold rels "co";
      print_rel M.E.pp_eiid M.WR.fold rels "rf")
    execs
