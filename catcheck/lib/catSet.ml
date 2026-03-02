module Log = (val Logs.src_log (Logs.Src.create "pset") : Logs.LOG)

type t = IntSet.t

let universe : t = Partitions.of_set_name "_"

let of_primitive_set s =
  try Some (Partitions.of_set_name s)
  with Invalid_argument _msg ->
    (* Log.warn (fun m -> m "%s" msg); *)
    (* FIXME:  *)
    None

let empty : t = IntSet.empty
let union (s1 : t) (s2 : t) : t = IntSet.union s1 s2
let inter (s1 : t) (s2 : t) : t = IntSet.inter s1 s2
let diff x y = IntSet.diff x y
let is_subset s1 s2 = IntSet.subset s1 s2
let equal s1 s2 = IntSet.equal s1 s2

let simplify_intersection : bool StringMap.t -> bool StringMap.t =
  let should_include sol s b =
    if b then
      let subs = Partitions.subsets s in
      StringSet.for_all (fun sub -> not (StringMap.find sub sol)) subs
    else
      let sups =
        StringSet.diff (Partitions.supersets s) (StringSet.singleton "_")
      in
      let disjs = Partitions.disjoints s in
      StringSet.for_all (fun sup -> StringMap.find sup sol) sups
      && not (StringSet.exists (fun disj -> StringMap.find disj sol) disjs)
  in
  fun m -> StringMap.filter (should_include m) m

let pp_intersection fmt sol =
  let open Format in
  sol |> StringMap.to_list
  |> pp_print_list
       ~pp_sep:(fun fmt () -> pp_print_string fmt " & ")
       (fun fmt (l, b) ->
         let pfx = if b then "" else "~" in
         fprintf fmt "%s%s" pfx l)
       fmt

let predefined_sets =
  let of_prim x = of_primitive_set x |> Option.get in
  [
    ( "Imp & TTD & W",
      inter (of_prim "NExp") (inter (of_prim "PTE") (of_prim "W")) );
    ( "Imp & TTD & R",
      inter (of_prim "NExp") (inter (of_prim "PTE") (of_prim "R")) );
    ("Exp & R", inter (of_prim "Exp") (of_prim "R"));
    ("Exp & W", inter (of_prim "Exp") (of_prim "W"));
    ("Exp & M", inter (of_prim "Exp") (of_prim "M"));
    ("Imp & M", inter (of_prim "NExp") (of_prim "M"));
    ("Imp & Tag & R", inter (inter (of_prim "NExp") (of_prim "T")) (of_prim "R"));
  ]
  @ List.map (fun nm -> (nm, Partitions.of_set_name nm)) Partitions.set_names
  |> List.fast_sort (fun (_, s) (_, s') ->
      Int.compare (IntSet.cardinal s) (IntSet.cardinal s'))
  |> List.rev

let pp =
  let rec loop disjs rest =
    match
      List.find_opt (fun (_nm, t') -> IntSet.subset t' rest) predefined_sets
    with
    | Some (nm, t') -> loop (nm :: disjs) (IntSet.diff rest t')
    | None -> (disjs, rest)
  in
  fun fmt t ->
    if IntSet.is_empty t then Format.fprintf fmt "emptyset"
    else
      let disjs, rest = loop [] t in
      let rest_disjs =
        rest |> IntSet.to_list
        |> List.map (fun n ->
            Format.asprintf "%a" pp_intersection
              (simplify_intersection (Partitions.bitmap_of_partition n)))
      in
      let str = String.concat " | " (disjs @ rest_disjs) in
      Format.pp_print_string fmt str
