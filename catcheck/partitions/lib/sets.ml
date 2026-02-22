module Partition = struct
  type t = int

  let compare = Int.compare
end

module PSet = Set.Make (Partition)

type t = PSet.t

let is_subset : t -> t -> bool = PSet.subset
let is_disjoint : t -> t -> bool = fun t1 t2 -> PSet.is_empty (PSet.inter t1 t2)

let from_solutions (solutions : bool StringMap.t list) : t StringMap.t =
  let m = Hashtbl.create 20 in
  Hashtbl.add m "_" [];
  let insert_partition k p =
    let current_ps = Option.value ~default:[] (Hashtbl.find_opt m k) in
    Hashtbl.replace m k (p :: current_ps)
  in
  let () =
    solutions
    |> List.iteri (fun i sol ->
        insert_partition "_" i;
        sol |> StringMap.iter (fun s b -> if b then insert_partition s i))
  in
  Hashtbl.fold (fun s ps -> StringMap.add s (PSet.of_list ps)) m StringMap.empty

type facts = {
  subsets : StringSet.t;
  supersets : StringSet.t;
  disjoints : StringSet.t;
}

let compute_facts (m : t StringMap.t) : facts StringMap.t =
  StringMap.fold
    (fun s t acc ->
      let subsets, supersets, disjoints =
        StringMap.fold
          (fun s' t' ((subs, sups, disjs) as acc) ->
            if String.equal s s' then acc
            else if is_subset t' t then (StringSet.add s' subs, sups, disjs)
            else if is_subset t t' then (subs, StringSet.add s' sups, disjs)
            else if is_disjoint t t' then (subs, sups, StringSet.add s' disjs)
            else acc)
          m
          (StringSet.empty, StringSet.empty, StringSet.empty)
      in
      StringMap.add s { subsets; supersets; disjoints } acc)
    m StringMap.empty

let simplify_intersection (facts_map : facts StringMap.t) :
    bool StringMap.t -> bool StringMap.t =
  let should_include sol s b =
    let facts = StringMap.find s facts_map in
    if b then
      let subs = facts.subsets in
      StringSet.for_all (fun sub -> not (StringMap.find sub sol)) subs
    else
      let sups = StringSet.diff facts.supersets (StringSet.singleton "_") in
      let disjs = facts.disjoints in
      StringSet.for_all (fun sup -> StringMap.find sup sol) sups
      && not (StringSet.exists (fun disj -> StringMap.find disj sol) disjs)
  in
  fun m -> StringMap.filter (should_include m) m
