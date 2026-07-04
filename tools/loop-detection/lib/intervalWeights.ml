type interval = { lo : int option; hi : int option }
type t = interval list

let empty = []
let top = [ { lo = None; hi = None } ]
let singleton n = [ { lo = Some n; hi = Some n } ]
let at_least n = [ { lo = Some n; hi = None } ]
let at_most n = [ { lo = None; hi = Some n } ]
let is_empty = function [] -> true | _ :: _ -> false

let add_int i j =
  if (j > 0 && i > max_int - j) || (j < 0 && i < min_int - j) then
    invalid_arg "IntervalWeights.plus: integer overflow"
  else i + j

let negate i =
  if Int.equal i min_int then
    invalid_arg "IntervalWeights.negate: cannot negate min_int"
  else -i

let succ i = if i = max_int then None else Some (i + 1)
let pred i = if i = min_int then None else Some (i - 1)

let compare_lo lo1 lo2 =
  match (lo1, lo2) with
  | None, None -> 0
  | None, Some _ -> -1
  | Some _, None -> 1
  | Some i, Some j -> Int.compare i j

let compare_hi hi1 hi2 =
  match (hi1, hi2) with
  | None, None -> 0
  | None, Some _ -> 1
  | Some _, None -> -1
  | Some i, Some j -> Int.compare i j

let le_bound lo hi =
  match (lo, hi) with None, _ | _, None -> true | Some lo, Some hi -> lo <= hi

let make lo hi = if le_bound lo hi then Some { lo; hi } else None

let interval_compare i j =
  let c = compare_lo i.lo j.lo in
  if c <> 0 then c else compare_hi i.hi j.hi

let can_merge left right =
  match (left.hi, right.lo) with
  | None, _ | _, None -> true
  | Some hi, Some lo -> (
      match succ hi with None -> true | Some next -> lo <= next)

let max_hi hi1 hi2 = if compare_hi hi1 hi2 >= 0 then hi1 else hi2

let normalize intervals =
  let intervals =
    intervals
    |> List.filter (fun i -> le_bound i.lo i.hi)
    |> List.sort interval_compare
  in
  let rec loop acc = function
    | [] -> List.rev acc
    | i :: is -> (
        match acc with
        | [] -> loop [ i ] is
        | prev :: acc_tail ->
            if can_merge prev i then
              loop ({ lo = prev.lo; hi = max_hi prev.hi i.hi } :: acc_tail) is
            else loop (i :: acc) is)
  in
  loop [] intervals

let equal t1 t2 = List.equal ( = ) t1 t2
let union t1 t2 = normalize (t1 @ t2)
let max_lo lo1 lo2 = if compare_lo lo1 lo2 >= 0 then lo1 else lo2
let min_hi hi1 hi2 = if compare_hi hi1 hi2 <= 0 then hi1 else hi2
let inter_interval i j = make (max_lo i.lo j.lo) (min_hi i.hi j.hi)

let intersection t1 t2 =
  List.fold_left
    (fun acc i ->
      List.fold_left
        (fun acc j ->
          match inter_interval i j with None -> acc | Some i -> i :: acc)
        acc t2)
    [] t1
  |> normalize

let subtract_interval i j =
  match inter_interval i j with
  | None -> [ i ]
  | Some _ ->
      let left =
        match j.lo with
        | None -> None
        | Some lo -> (
            match pred lo with None -> None | Some hi -> make i.lo (Some hi))
      in
      let right =
        match j.hi with
        | None -> None
        | Some hi -> (
            match succ hi with None -> None | Some lo -> make (Some lo) i.hi)
      in
      List.filter_map (fun x -> x) [ left; right ]

let diff t1 t2 =
  List.fold_left
    (fun pieces j -> List.concat_map (fun i -> subtract_interval i j) pieces)
    t1 t2
  |> normalize

let inverse_bound = function None -> None | Some i -> Some (negate i)

let inverse t =
  List.map (fun i -> { lo = inverse_bound i.hi; hi = inverse_bound i.lo }) t
  |> normalize

let plus_bound b1 b2 =
  match (b1, b2) with
  | None, _ | _, None -> None
  | Some i, Some j -> Some (add_int i j)

let plus_interval i j = { lo = plus_bound i.lo j.lo; hi = plus_bound i.hi j.hi }

let plus t1 t2 =
  List.fold_left
    (fun acc i -> List.fold_left (fun acc j -> plus_interval i j :: acc) acc t2)
    [] t1
  |> normalize

let all_singletons t =
  List.for_all
    (function { lo = Some lo; hi = Some hi } -> Int.equal lo hi | _ -> false)
    t

let pp_singletons fmt t =
  let ints =
    List.map
      (function { lo = Some n; hi = Some _ } -> n | _ -> assert false)
      t
  in
  Format.fprintf fmt "{%a}"
    (Format.pp_print_list
       ~pp_sep:(fun fmt () -> Format.fprintf fmt ", ")
       Format.pp_print_int)
    ints

let pp_interval fmt = function
  | { lo = None; hi = None } -> Format.fprintf fmt "Z"
  | { lo = Some lo; hi = None } -> Format.fprintf fmt "[%d,+inf)" lo
  | { lo = None; hi = Some hi } -> Format.fprintf fmt "(-inf,%d]" hi
  | { lo = Some lo; hi = Some hi } when Int.equal lo hi ->
      Format.fprintf fmt "{%d}" lo
  | { lo = Some lo; hi = Some hi } -> Format.fprintf fmt "[%d,%d]" lo hi

let pp fmt = function
  | [] -> Format.fprintf fmt "{}"
  | t when all_singletons t -> pp_singletons fmt t
  | t ->
      Format.pp_print_list
        ~pp_sep:(fun fmt () -> Format.fprintf fmt " U ")
        pp_interval fmt t
