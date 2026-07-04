type t = Int_set of IntSet.t | To_pos_inf of int | From_neg_inf of int | Z

let empty = Int_set IntSet.empty
let top = Z
let singleton (n : int) : t = Int_set (IntSet.singleton n)
let at_least n = To_pos_inf n
let at_most n = From_neg_inf n

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
      Format.fprintf fmt "{%a}"
        (Format.pp_print_list
           ~pp_sep:(fun fmt () -> Format.fprintf fmt ", ")
           Format.pp_print_int)
        (IntSet.elements s)
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
  raise (Weight.Unsupported msg)

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
      match succ last with None -> unsupported "diff" | Some n -> To_pos_inf n
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
  | To_pos_inf from, From_neg_inf until | From_neg_inf until, To_pos_inf from ->
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
      match pred n with None -> unsupported "diff" | Some n -> From_neg_inf n)
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
        match succ n2 with None -> unsupported "diff" | Some n -> To_pos_inf n)
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
