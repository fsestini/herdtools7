module Partition = struct
  type t = { index : int; solution : (string * bool) list }

  let make ~index ~solution =
    let solution =
      List.sort (fun (s, _) (s', _) -> String.compare s s') solution
    in
    { index; solution }

  let compare p1 p2 = Int.compare p1.index p2.index

  let pp fmt (p : t) =
    let open Format in
    p.solution
    |> pp_print_list
         ~pp_sep:(fun fmt () -> pp_print_string fmt " & ")
         (fun fmt (l, b) ->
           let pfx = if b then "" else "~" in
           fprintf fmt "%s%s" pfx l)
         fmt

  let index p = p.index
end

module PartitionSet = Set.Make (Partition)
module LabelMap = Map.Make (String)

type t = {
  labels : string list;
  partitions : PartitionSet.t;
  denotations : PartitionSet.t LabelMap.t;
}

let labels t = t.labels
let partitions t = PartitionSet.elements t.partitions

let denotation t label =
  match LabelMap.find_opt label t.denotations with
  | Some denotation -> denotation
  | None -> invalid_arg (Printf.sprintf "unknown label: %s" label)

let labels_of_partition t partition =
  t.labels
  |> List.filter (fun label -> PartitionSet.mem partition (denotation t label))

let simplify_labels t labels =
  labels
  |> List.filter (fun label ->
      not
        (List.exists
           (fun other_label ->
             (not (String.equal other_label label))
             && PartitionSet.subset (denotation t other_label)
                  (denotation t label))
           labels))

let to_assoc t =
  t.labels
  |> List.filter_map (fun label ->
      let denotation = denotation t label in
      if PartitionSet.is_empty denotation then None
      else Some (label, PartitionSet.elements denotation))

let make ~labels solutions =
  let labels = List.sort_uniq String.compare labels in
  let empty_denotations =
    labels
    |> List.fold_left
         (fun denotations label ->
           LabelMap.add label PartitionSet.empty denotations)
         LabelMap.empty
  in
  let partitions, denotations =
    solutions
    |> List.fold_left
         (fun (partitions, denotations) (index, solution) ->
           let partition = Partition.make ~index ~solution in
           let partitions = PartitionSet.add partition partitions in
           let denotations =
             solution
             |> List.fold_left
                  (fun denotations (label, member) ->
                    if member then
                      let denotation =
                        Option.value ~default:PartitionSet.empty
                          (LabelMap.find_opt label denotations)
                      in
                      LabelMap.add label
                        (PartitionSet.add partition denotation)
                        denotations
                    else denotations)
                  denotations
           in
           (partitions, denotations))
         (PartitionSet.empty, empty_denotations)
  in
  { labels; partitions; denotations }

let compute_partitions (ins : AST.ins list) : t =
  let formulas = Interpreter.constraints_of_cat ins in
  let solver = Solver.create () in
  let symbols_map = Hashtbl.create 15 in
  let formulas =
    formulas
    |> List.map (fun f ->
        Logic.map
          (fun x ->
            match Hashtbl.find_opt symbols_map x with
            | Some lit -> lit
            | None ->
                let lit = Solver.fresh_lit solver in
                Hashtbl.add symbols_map x lit;
                lit)
          f)
  in
  formulas |> List.iter (Solver.add_clause solver);
  let rec loop acc () =
    try
      Solver.solve solver;
      let solver_solution =
        Hashtbl.fold
          (fun v l -> List.cons (v, (l, Solver.value solver l)))
          symbols_map []
      in
      let solution = List.map (fun (v, (_, b)) -> (v, b)) solver_solution in
      let acc = solution :: acc in
      try
        Solver.exclude solver (List.map snd solver_solution);
        loop acc ()
      with Minisat.Unsat -> acc
    with Minisat.Unsat -> acc
  in
  let solutions = loop [] () in
  let labels =
    Hashtbl.fold (fun label _ labels -> label :: labels) symbols_map []
  in
  solutions
  |> List.mapi (fun index solution -> (index, solution))
  |> make ~labels
