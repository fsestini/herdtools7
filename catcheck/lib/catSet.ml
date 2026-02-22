type t = IntSet.t

let universe : t = Partitions.of_set_name "_"
let of_primitive_set = Partitions.of_set_name
let empty : t = IntSet.empty
let union (s1 : t) (s2 : t) : t = IntSet.union s1 s2
let inter (s1 : t) (s2 : t) : t = IntSet.inter s1 s2
let is_subset s1 s2 = IntSet.subset s1 s2
let equal s1 s2 = IntSet.equal s1 s2

let rec of_set_expr (e : AST.exp) : t =
  let open AST in
  match e with
  | Var (_, s) -> of_primitive_set s
  | Op (_, Union, es) -> List.fold_left union empty (List.map of_set_expr es)
  | Op (_, Inter, es) -> List.fold_left inter universe (List.map of_set_expr es)
  | Op (_, Diff, [ x; y ]) -> IntSet.diff (of_set_expr x) (of_set_expr y)
  | Op1 (_, Inv, e) -> IntSet.diff universe (of_set_expr e)
  | _ -> failwith "invalid set exp"

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
  match
    List.find_opt
      (fun nm -> IntSet.equal t (Partitions.of_set_name nm))
      Partitions.set_names
  with
  | Some nm -> Format.pp_print_string fmt nm
  | None -> (
      match to_intersection t with
      | Some inter -> Format.fprintf fmt "%a" pp_intersection inter
      | None -> Format.fprintf fmt "emptyset")
(* (String.concat " ⊔ " (StringSet.to_list s)) *)
