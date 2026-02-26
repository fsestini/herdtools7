module Log = (val Logs.src_log (Logs.Src.create "pset") : Logs.LOG)

type t = IntSet.t

let universe : t = Partitions.of_set_name "_"

let of_primitive_set s =
  try Some (Partitions.of_set_name s)
  with Invalid_argument msg ->
    Log.warn (fun m -> m "%s" msg);
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

let join_intersection : bool StringMap.t -> bool StringMap.t -> bool StringMap.t
    =
 fun m1 m2 ->
  StringMap.fold
    (fun k v acc ->
      let v' =
        try StringMap.find k m2
        with Not_found ->
          failwith (Format.sprintf "Not_found in join_intersection: %s" k)
      in
      StringMap.add k (v || v') acc)
    m1 StringMap.empty

let pp_intersection fmt sol =
  let open Format in
  sol |> StringMap.to_list
  |> pp_print_list
       ~pp_sep:(fun fmt () -> pp_print_string fmt " & ")
       (fun fmt (l, b) ->
         let pfx = if b then "" else "~" in
         fprintf fmt "%s%s" pfx l)
       fmt

let to_intersection (t : t) : bool StringMap.t option =
  match IntSet.to_list t with
  | [] -> None
  | x :: xs ->
      List.fold_left
        (fun acc i -> join_intersection (Partitions.bitmap_of_partition i) acc)
        (Partitions.bitmap_of_partition x)
        xs
      |> simplify_intersection |> Option.some

let pp fmt t =
  let of_prim x = of_primitive_set x |> Option.get in
  let predefined_sets =
    List.map (fun nm -> (nm, Partitions.of_set_name nm)) Partitions.set_names
    @ [
        ("Exp & R", inter (of_prim "Exp") (of_prim "R"));
        ("Exp & W", inter (of_prim "Exp") (of_prim "W"));
        ("Exp & M", inter (of_prim "Exp") (of_prim "M"));
      ]
  in
  match List.find_opt (fun (_nm, t') -> IntSet.equal t t') predefined_sets with
  | Some (nm, _) -> Format.pp_print_string fmt nm
  | None -> (
      match to_intersection t with
      | Some inter -> Format.fprintf fmt "%a" pp_intersection inter
      | None -> Format.fprintf fmt "emptyset")
(* (String.concat " ⊔ " (StringSet.to_list s)) *)
