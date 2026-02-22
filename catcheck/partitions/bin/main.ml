open Partitions

let () =
  let fname = Sys.argv.(1) in
  let content =
    In_channel.with_open_text fname (fun ch -> In_channel.input_all ch)
  in
  let solutions = Solver.run content in
  let partitioned_sets = Sets.from_solutions solutions in
  let facts_map = Sets.compute_facts partitioned_sets in
  solutions
  |> List.iter (fun sol ->
      let simplified = Sets.simplify_intersection facts_map sol in
      Format.printf "%a@." Solver.pp_solution simplified)
(* facts_map *)
(* |> StringMap.iter *)
(*      Sets.( *)
(*        fun s facts -> *)
(*          Format.printf "Subsets of %s: %a@." s StringSet.pp facts.subsets; *)
(*          Format.printf "Supersets of %s: %a@." s StringSet.pp facts.supersets; *)
(*          Format.printf "Disjoints of %s: %a@." s StringSet.pp facts.disjoints) *)
