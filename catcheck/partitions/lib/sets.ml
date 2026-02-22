module Partition = struct
  type t = int

  let make i = i
  let compare = Int.compare
end

module PSet = Set.Make (Partition)

type partitioned = PSet.t
type conj_map = bool StringMap.t

let is_subset : partitioned -> partitioned -> bool = PSet.subset

let is_disjoint : partitioned -> partitioned -> bool =
 fun t1 t2 -> PSet.is_empty (PSet.inter t1 t2)

let from_solutions (solutions : conj_map list) :
    conj_map IntMap.t * partitioned StringMap.t =
  let conj_maps = Hashtbl.create 20 in
  let m = Hashtbl.create 20 in
  Hashtbl.add m "_" [];
  let insert_partition k p =
    let current_ps = Option.value ~default:[] (Hashtbl.find_opt m k) in
    Hashtbl.replace m k (p :: current_ps)
  in
  let () =
    solutions
    |> List.iteri (fun i sol ->
        Hashtbl.add conj_maps i sol;
        let p = Partition.make i in
        insert_partition "_" p;
        sol |> StringMap.iter (fun s b -> if b then insert_partition s p))
  in
  let partitioned =
    Hashtbl.fold
      (fun s ps -> StringMap.add s (PSet.of_list ps))
      m StringMap.empty
  in
  let conjs = Hashtbl.fold IntMap.add conj_maps IntMap.empty in
  (conjs, partitioned)

type facts = {
  subsets : StringSet.t;
  supersets : StringSet.t;
  disjoints : StringSet.t;
}

let compute_facts (m : partitioned StringMap.t) : facts StringMap.t =
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

(* Dumping as OCaml structures. *)

let dump_partitions (m : conj_map IntMap.t) : unit =
  Format.printf "let bitmap_of_partition : int -> bool StringMap.t = function@.";
  m
  |> IntMap.iter (fun k v ->
      Format.(
        printf "  | %d -> StringMap.of_list [%a]@." k
          (pp_print_list
             ~pp_sep:(fun fmt () -> pp_print_string fmt "; ")
             (fun fmt (s, b) -> fprintf fmt "(%S, %b)" s b))
          (StringMap.to_list v)));
  Format.printf "  | _ -> invalid_arg %S@." "unknown partition"

let dump_defs (m : partitioned StringMap.t) : unit =
  Format.printf "let of_set_name : string -> IntSet.t = function@.";
  let () =
    m
    |> StringMap.iter (fun k v ->
        let lst = PSet.to_list v in
        Format.(
          printf "  | %S -> IntSet.of_list [%a]@." k
            (pp_print_list
               ~pp_sep:(fun fmt () -> pp_print_string fmt "; ")
               pp_print_int)
            lst))
  in
  Format.printf "  | _ -> invalid_arg %S@." "unknown set identifier"

let dump_facts (m : facts StringMap.t) : unit =
  let print_fact_set fn_name f =
    Format.printf "let %s : string -> StringSet.t = function@." fn_name;
    m
    |> StringMap.iter (fun s fs ->
        let set = f fs in
        Format.(
          printf "  | %S -> StringSet.of_list [%a]@." s
            (pp_print_list
               ~pp_sep:(fun fmt () -> pp_print_string fmt "; ")
               (fun fmt s -> fprintf fmt "%S" s))
            (StringSet.to_list set)));
    Format.printf "  | _ -> invalid_arg %S@." "unknown set identifier"
  in
  print_fact_set "subsets" (fun fs -> fs.subsets);
  print_fact_set "supersets" (fun fs -> fs.supersets);
  print_fact_set "disjoints" (fun fs -> fs.disjoints)
