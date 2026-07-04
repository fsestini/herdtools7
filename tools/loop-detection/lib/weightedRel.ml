exception Unsupported of string

module type Weight = sig
  type t

  val empty : t
  val top : t
  val singleton : int -> t
  val at_least : int -> t
  val at_most : int -> t
  val is_empty : t -> bool
  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
  val union : t -> t -> t
  val intersection : t -> t -> t
  val diff : t -> t -> t
  val inverse : t -> t
  val plus : t -> t -> t
  val widen : t -> t -> t
end

module SetWeights = struct
  type t =
    | Int_set of IntSet.t
        (** [Int_set s] represents the finite integer set given by [s]. *)
    | To_pos_inf of int
        (** [To_pos_inf n] represents the set of integers in the interval from
            [n] to positive infinity. *)
    | From_neg_inf of int
        (** [To_pos_inf n] represents the set of integers in the interval from
            negative infinity to [n]. *)
    | Z  (** [Z] represents the entire set of integers. *)

  let empty = Int_set IntSet.empty
  let top = Z
  let singleton (n : int) : t = Int_set (IntSet.singleton n)
  let at_least n = To_pos_inf n
  let at_most n = From_neg_inf n

  let mem (n : int) (t : t) =
    match t with
    | Int_set s -> IntSet.mem n s
    | To_pos_inf m -> m <= n
    | From_neg_inf m -> n <= m
    | Z -> true

  let is_empty = function
    | Int_set s -> IntSet.is_empty s
    | To_pos_inf _ | From_neg_inf _ | Z -> false

  let equal w1 w2 =
    match (w1, w2) with
    | Int_set s1, Int_set s2 -> IntSet.equal s1 s2
    | To_pos_inf n1, To_pos_inf n2 | From_neg_inf n1, From_neg_inf n2 ->
        Int.equal n1 n2
    | Z, Z -> true
    | (Int_set _ | To_pos_inf _ | From_neg_inf _ | Z), _ -> false

  let pp fmt = function
    | Int_set s ->
        let pp_ints fmt ints =
          Format.fprintf fmt "{%a}"
            (Format.pp_print_list
               ~pp_sep:(fun fmt () -> Format.fprintf fmt ", ")
               Format.pp_print_int)
            (IntSet.elements ints)
        in
        pp_ints fmt s
    | To_pos_inf n -> Format.fprintf fmt "[%d,+inf)" n
    | From_neg_inf n -> Format.fprintf fmt "(-inf,%d]" n
    | Z -> Format.fprintf fmt "Z"

  let range from_ until =
    let rec loop acc n =
      let acc = IntSet.add n acc in
      if n = from_ then acc else loop acc (n - 1)
    in
    if from_ > until then IntSet.empty else loop IntSet.empty until

  let negate i =
    if Int.equal i min_int then
      invalid_arg "SetWeights.negate: cannot negate min_int"
    else -i

  let add_int i j =
    if (j > 0 && i > max_int - j) || (j < 0 && i < min_int - j) then
      invalid_arg "SetWeights.plus: integer overflow"
    else i + j

  let succ i = if i = max_int then None else Some (i + 1)
  let pred i = if i = min_int then None else Some (i - 1)

  let unsupported op =
    let msg = Format.sprintf "SetWeights.%s: result is not representable" op in
    raise (Unsupported msg)

  let interval_equal s ~first ~last =
    if first > last then IntSet.is_empty s
    else
      match IntSet.elements s with
      | [] -> false
      | x :: xs ->
          Int.equal x first
          &&
          let rec loop prev = function
            | [] -> Int.equal prev last
            | x :: xs -> (
                match succ prev with
                | None -> false
                | Some expected -> Int.equal x expected && loop expected xs)
          in
          loop x xs

  let union_int_set_to_pos_inf s n =
    let below = IntSet.filter (fun i -> i < n) s in
    if IntSet.is_empty below then To_pos_inf n
    else
      match pred n with
      | None -> unsupported "union"
      | Some last ->
          let first = IntSet.min_elt below in
          if interval_equal below ~first ~last then To_pos_inf first
          else unsupported "union"

  let union_int_set_from_neg_inf s n =
    let above = IntSet.filter (fun i -> i > n) s in
    if IntSet.is_empty above then From_neg_inf n
    else
      match succ n with
      | None -> unsupported "union"
      | Some first ->
          let last = IntSet.max_elt above in
          if interval_equal above ~first ~last then From_neg_inf last
          else unsupported "union"

  let diff_to_pos_inf_int_set n s =
    let removed = IntSet.filter (fun i -> i >= n) s in
    if IntSet.is_empty removed then To_pos_inf n
    else
      let last = IntSet.max_elt removed in
      if interval_equal removed ~first:n ~last then
        match succ last with
        | None -> unsupported "diff"
        | Some n -> To_pos_inf n
      else unsupported "diff"

  let diff_from_neg_inf_int_set n s =
    let removed = IntSet.filter (fun i -> i <= n) s in
    if IntSet.is_empty removed then From_neg_inf n
    else
      let first = IntSet.min_elt removed in
      if interval_equal removed ~first ~last:n then
        match pred first with
        | None -> unsupported "diff"
        | Some n -> From_neg_inf n
      else unsupported "diff"

  let union w1 w2 =
    match (w1, w2) with
    | Z, _ | _, Z -> Z
    | Int_set s1, Int_set s2 -> Int_set (IntSet.union s1 s2)
    | To_pos_inf n1, To_pos_inf n2 -> To_pos_inf (min n1 n2)
    | From_neg_inf n1, From_neg_inf n2 -> From_neg_inf (max n1 n2)
    | Int_set s, To_pos_inf n | To_pos_inf n, Int_set s ->
        union_int_set_to_pos_inf s n
    | Int_set s, From_neg_inf n | From_neg_inf n, Int_set s ->
        union_int_set_from_neg_inf s n
    | To_pos_inf a, From_neg_inf b | From_neg_inf b, To_pos_inf a -> (
        match succ b with
        | None -> Z
        | Some b_succ -> if a <= b_succ then Z else unsupported "union")

  let intersection w1 w2 =
    match (w1, w2) with
    | Z, w | w, Z -> w
    | Int_set s1, Int_set s2 -> Int_set (IntSet.inter s1 s2)
    | To_pos_inf n1, To_pos_inf n2 -> To_pos_inf (max n1 n2)
    | From_neg_inf n1, From_neg_inf n2 -> From_neg_inf (min n1 n2)
    | Int_set s, To_pos_inf n | To_pos_inf n, Int_set s ->
        Int_set (IntSet.filter (fun i -> i >= n) s)
    | Int_set s, From_neg_inf n | From_neg_inf n, Int_set s ->
        Int_set (IntSet.filter (fun i -> i <= n) s)
    | To_pos_inf from, From_neg_inf until | From_neg_inf until, To_pos_inf from
      ->
        Int_set (range from until)

  let diff w1 w2 =
    match (w1, w2) with
    | Int_set s, _ when IntSet.is_empty s -> empty
    | _, Int_set s when IntSet.is_empty s -> w1
    | _, Z -> empty
    | Int_set s1, Int_set s2 -> Int_set (IntSet.diff s1 s2)
    | Int_set s, To_pos_inf n -> Int_set (IntSet.filter (fun i -> i < n) s)
    | Int_set s, From_neg_inf n -> Int_set (IntSet.filter (fun i -> i > n) s)
    | Z, Int_set _ -> unsupported "diff"
    | Z, To_pos_inf n -> (
        match pred n with
        | None -> unsupported "diff"
        | Some n -> From_neg_inf n)
    | Z, From_neg_inf n -> (
        match succ n with None -> unsupported "diff" | Some n -> To_pos_inf n)
    | To_pos_inf n, Int_set s -> diff_to_pos_inf_int_set n s
    | From_neg_inf n, Int_set s -> diff_from_neg_inf_int_set n s
    | To_pos_inf n1, To_pos_inf n2 ->
        if n2 <= n1 then empty else Int_set (range n1 (n2 - 1))
    | From_neg_inf n1, From_neg_inf n2 ->
        if n2 >= n1 then empty else Int_set (range (n2 + 1) n1)
    | To_pos_inf n1, From_neg_inf n2 -> (
        if n2 < n1 then w1
        else
          match succ n2 with
          | None -> unsupported "diff"
          | Some n -> To_pos_inf n)
    | From_neg_inf n1, To_pos_inf n2 -> (
        if n2 > n1 then w1
        else
          match pred n2 with
          | None -> unsupported "diff"
          | Some n -> From_neg_inf n)

  let inverse = function
    | Int_set s ->
        Int_set
          (IntSet.fold (fun i acc -> IntSet.add (negate i) acc) s IntSet.empty)
    | To_pos_inf n -> From_neg_inf (negate n)
    | From_neg_inf n -> To_pos_inf (negate n)
    | Z -> Z

  let cross_sum s1 s2 =
    IntSet.fold
      (fun i acc ->
        IntSet.fold (fun j acc -> IntSet.add (add_int i j) acc) s2 acc)
      s1 IntSet.empty

  let plus w1 w2 =
    match (w1, w2) with
    | Int_set s, _ when IntSet.is_empty s -> Int_set IntSet.empty
    | _, Int_set s when IntSet.is_empty s -> Int_set IntSet.empty
    | Z, _ | _, Z -> Z
    | Int_set s1, Int_set s2 -> Int_set (cross_sum s1 s2)
    | Int_set s, To_pos_inf n | To_pos_inf n, Int_set s ->
        To_pos_inf (add_int n (IntSet.min_elt s))
    | Int_set s, From_neg_inf n | From_neg_inf n, Int_set s ->
        From_neg_inf (add_int n (IntSet.max_elt s))
    | To_pos_inf n1, To_pos_inf n2 -> To_pos_inf (add_int n1 n2)
    | From_neg_inf n1, From_neg_inf n2 -> From_neg_inf (add_int n1 n2)
    | To_pos_inf _, From_neg_inf _ | From_neg_inf _, To_pos_inf _ -> Z

  (* Widening operator.

     The interesting case is finite-set vs finite-set.
     - If the finite bounds expand upward, widen to [To_pos_inf];
     - if they expand downward, widen to [From_neg_inf];
     - if both bounds expand, widen to [Z].

     If the bounds do not expand, keep the exact finite union. Other shapes
     already represent unboundedness, so widening falls back to union. *)
  let widen w1 w2 =
    match (w1, w2) with
    | Int_set old_s, Int_set new_s ->
        if IntSet.is_empty old_s then Int_set new_s
        else
          let joined = IntSet.union old_s new_s in
          let old_min = IntSet.min_elt old_s in
          let old_max = IntSet.max_elt old_s in
          let joined_min = IntSet.min_elt joined in
          let joined_max = IntSet.max_elt joined in
          let grows_down = joined_min < old_min in
          let grows_up = joined_max > old_max in
          if grows_down && grows_up then Z
          else if grows_down then From_neg_inf joined_max
          else if grows_up then To_pos_inf joined_min
          else Int_set joined
    | _, _ -> union w1 w2
end

module type S = sig
  type elt
  type weight
  type t

  val empty : t
  val of_list : (elt * elt * weight) list -> t
  val add : elt * elt * weight -> t -> t
  val fold : (elt * elt * weight -> 'a -> 'a) -> t -> 'a -> 'a
  val cartesian : elt list -> elt list -> weight -> t
  val union : t -> t -> t
  val intersection : t -> t -> t
  val diff : t -> t -> t
  val inverse : t -> t
  val sequence : t -> t -> t
  val filter : (elt -> elt -> weight -> bool) -> t -> t

  val transitive_closure_widened : t -> t
  (** Positive transitive closure. The returned edge set is exact w.r.t.
      reachability in the input relation, but edge weights may be sound
      overapproximations. *)

  val transitive_closure_exact : t -> t

  val transitive_reduction : t -> t
  (** Transitive reduction, computed independently for each [W.equal] weight
      class. Edge redundancy is decided only from the same-weight topology;
      weights on kept edges are preserved. *)

  val equal : t -> t -> bool
  val pp : (Format.formatter -> elt -> unit) -> Format.formatter -> t -> unit
  val widen : t -> t -> t
end

module Make
    (W : Weight)
    (Elt : sig
      type t

      val compare : t -> t -> int
    end) : S with type elt = Elt.t and type weight = W.t = struct
  type elt = Elt.t
  type weight = W.t

  module EltMap = MyMap.Make (Elt)

  type t = weight EltMap.t EltMap.t

  let empty = EltMap.empty
  let elt_equal x y = Elt.compare x y = 0

  let add (src, dst, w) rel =
    if W.is_empty w then rel
    else
      EltMap.update src
        (function
          | None -> Some (EltMap.singleton dst w)
          | Some dsts ->
              Some
                (EltMap.update dst
                   (function None -> Some w | Some w' -> Some (W.union w w'))
                   dsts))
        rel

  let of_list edges =
    List.fold_left (fun rel edge -> add edge rel) EltMap.empty edges

  let fold f rel acc =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold (fun dst w acc -> f (src, dst, w) acc) dsts acc)
      rel acc

  let cartesian srcs dsts w =
    if W.is_empty w then EltMap.empty
    else
      List.fold_left
        (fun rel src ->
          List.fold_left (fun rel dst -> add (src, dst, w) rel) rel dsts)
        EltMap.empty srcs

  let union rel1 rel2 = EltMap.union (EltMap.union W.union) rel1 rel2

  let intersection rel1 rel2 =
    EltMap.fold
      (fun src dsts1 acc ->
        match EltMap.find_opt src rel2 with
        | None -> acc
        | Some dsts2 ->
            let dsts =
              EltMap.fold
                (fun dst w1 acc ->
                  match EltMap.find_opt dst dsts2 with
                  | None -> acc
                  | Some w2 ->
                      let w = W.intersection w1 w2 in
                      if W.is_empty w then acc else EltMap.add dst w acc)
                dsts1 EltMap.empty
            in
            if EltMap.is_empty dsts then acc else EltMap.add src dsts acc)
      rel1 EltMap.empty

  let diff rel1 rel2 =
    EltMap.fold
      (fun src dsts1 acc ->
        let dsts2 = EltMap.find_opt src rel2 in
        let dsts =
          EltMap.fold
            (fun dst w1 acc ->
              let w =
                match dsts2 with
                | None -> w1
                | Some dsts2 -> (
                    match EltMap.find_opt dst dsts2 with
                    | None -> w1
                    | Some w2 -> W.diff w1 w2)
              in
              if W.is_empty w then acc else EltMap.add dst w acc)
            dsts1 EltMap.empty
        in
        if EltMap.is_empty dsts then acc else EltMap.add src dsts acc)
      rel1 EltMap.empty

  let inverse rel =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold (fun dst w acc -> add (dst, src, W.inverse w) acc) dsts acc)
      rel EltMap.empty

  let sequence rel1 rel2 =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold
          (fun mid w1 acc ->
            match EltMap.find_opt mid rel2 with
            | None -> acc
            | Some succs ->
                EltMap.fold
                  (fun dst w2 acc -> add (src, dst, W.plus w1 w2) acc)
                  succs acc)
          dsts acc)
      rel1 EltMap.empty

  let equal rel1 rel2 = EltMap.equal (EltMap.equal W.equal) rel1 rel2
  let widen rel1 rel2 = EltMap.union (EltMap.union W.widen) rel1 rel2

  let transitive_closure_ ~widen rel =
    let max_iterations = 1000 in
    let rec loop iteration current =
      if iteration >= max_iterations then
        raise (Unsupported "weighted relation transitive closure did not stabilize");
      let candidate = union current (sequence current current) in
      let next = widen current candidate in
      if equal current next then current else loop (iteration + 1) next
    in
    loop 0 rel

  let transitive_closure_widened rel =
    let widen rel1 rel2 = EltMap.union (EltMap.union W.widen) rel1 rel2 in
    transitive_closure_ ~widen rel

  let transitive_closure_exact rel =
    let widen _ rel2 = rel2 in
    transitive_closure_ ~widen rel

  let successors rel src =
    match EltMap.find_opt src rel with
    | None -> []
    | Some dsts -> List.map fst (EltMap.to_list dsts)

  let nodes rel =
    fold
      (fun (src, dst, _) nodes ->
        nodes |> EltMap.add src () |> EltMap.add dst ())
      rel EltMap.empty
    |> EltMap.to_list |> List.map fst

  let predecessors rel dst =
    fold
      (fun (src, dst', _) acc -> if elt_equal dst dst' then src :: acc else acc)
      rel []

  let reachable_nodes ~successors src =
    let rec loop visited = function
      | [] -> visited
      | node :: stack ->
          if EltMap.mem node visited then loop visited stack
          else
            let visited = EltMap.add node () visited in
            loop visited (successors node @ stack)
    in
    loop EltMap.empty [ src ]

  let scc_ids rel =
    let rec loop next_id ids = function
      | [] -> ids
      | node :: nodes ->
          if EltMap.mem node ids then loop next_id ids nodes
          else
            let forward = reachable_nodes ~successors:(successors rel) node in
            let backward =
              reachable_nodes ~successors:(predecessors rel) node
            in
            let component =
              EltMap.fold
                (fun node () acc ->
                  if EltMap.mem node backward then EltMap.add node next_id acc
                  else acc)
                forward EltMap.empty
            in
            let ids =
              EltMap.fold
                (fun node id ids -> EltMap.add node id ids)
                component ids
            in
            loop (next_id + 1) ids nodes
    in
    loop 0 EltMap.empty (nodes rel)

  let scc_pair_equal (src1, dst1) (src2, dst2) =
    Int.equal src1 src2 && Int.equal dst1 dst2

  let add_scc_node node nodes =
    if List.exists (Int.equal node) nodes then nodes else node :: nodes

  let add_scc_pair pair pairs =
    if List.exists (scc_pair_equal pair) pairs then pairs else pair :: pairs

  let scc_successors pairs src =
    List.fold_left
      (fun succs (src', dst) ->
        if Int.equal src src' then add_scc_node dst succs else succs)
      [] pairs

  let scc_reachable_without_pair pairs ~skip_src ~skip_dst src target =
    let rec loop visited = function
      | [] -> false
      | node :: stack ->
          if List.exists (Int.equal node) visited then loop visited stack
          else
            let visited = node :: visited in
            let succs =
              scc_successors pairs node
              |> List.filter (fun dst ->
                  not (Int.equal node skip_src && Int.equal dst skip_dst))
            in
            if List.exists (Int.equal target) succs then true
            else loop visited (succs @ stack)
    in
    loop [] [ src ]

  let reduce_scc_pairs pairs =
    List.filter
      (fun (src, dst) ->
        not
          (scc_reachable_without_pair pairs ~skip_src:src ~skip_dst:dst src dst))
      pairs

  (* Reduce one same-weight subrelation by preserving SCC-internal edges and
     transitively reducing only the acyclic SCC condensation graph. *)
  let transitive_reduction_same_weight rel =
    let ids = scc_ids rel in
    let edges = fold (fun edge edges -> edge :: edges) rel [] in
    let internal_edges, inter_edges, pairs =
      List.fold_left
        (fun (internal_edges, inter_edges, pairs) ((src, dst, _) as edge) ->
          let src_id = EltMap.find src ids in
          let dst_id = EltMap.find dst ids in
          if Int.equal src_id dst_id then
            (edge :: internal_edges, inter_edges, pairs)
          else
            ( internal_edges,
              (src_id, dst_id, edge) :: inter_edges,
              add_scc_pair (src_id, dst_id) pairs ))
        ([], [], []) edges
    in
    let kept_pairs = reduce_scc_pairs pairs in
    let keep_pair src_id dst_id =
      List.exists (scc_pair_equal (src_id, dst_id)) kept_pairs
    in
    let kept_edges =
      List.fold_left
        (fun acc (src_id, dst_id, edge) ->
          if keep_pair src_id dst_id then edge :: acc else acc)
        internal_edges inter_edges
    in
    List.fold_left (fun rel edge -> add edge rel) EltMap.empty kept_edges

  let rec add_to_weight_group ((_, _, w) as edge) = function
    | [] -> [ (w, add edge EltMap.empty) ]
    | (group_w, group) :: groups ->
        if W.equal w group_w then (group_w, add edge group) :: groups
        else (group_w, group) :: add_to_weight_group edge groups

  let weight_groups rel =
    fold (fun edge groups -> add_to_weight_group edge groups) rel []
    |> List.map snd

  let transitive_reduction rel =
    List.fold_left
      (fun acc group -> union acc (transitive_reduction_same_weight group))
      EltMap.empty (weight_groups rel)

  let pp pp_elt fmt rel =
    let pp_edge fmt (src, dst, w) =
      Format.fprintf fmt "(%a,%a,%a)" pp_elt src pp_elt dst W.pp w
    in
    let edges = fold (fun edge acc -> edge :: acc) rel [] |> List.rev in
    Format.fprintf fmt "{%a}"
      (Format.pp_print_list
         ~pp_sep:(fun fmt () -> Format.fprintf fmt "; ")
         pp_edge)
      edges

  let filter p (t : t) =
    fold
      (fun (x, y, w) acc -> if p x y w then add (x, y, w) acc else acc)
      t empty
end
