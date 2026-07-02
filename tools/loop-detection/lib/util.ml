module Iter = struct
  type ('a, 'b) t = ('a -> unit) -> 'b

  let to_list (t : ('a, 'b) t) =
    let l = ref [] in
    let b = t (fun x -> l := x :: !l) in
    (List.rev !l, b)

  let filter (f : 'a -> bool) (i : ('a, 'b) t) : ('a, 'b) t =
   fun k -> i (fun x -> if f x then k x else ())
end

module Option = struct
  let value_thunk ~f v = match v with None -> f () | Some x -> x
end

let fold_left_until (f : 'acc -> 'a -> 'acc option) (acc : 'acc) l =
  let acc = ref acc in
  try
    List.iter
      (fun x ->
        match f !acc x with
        | Some new_acc -> acc := new_acc
        | None -> raise Exit)
      l;
    !acc
  with Exit -> !acc

let uniq ~(eq : 'a -> 'a -> bool) (l : 'a list) : 'a list =
  let rec uniq eq acc l =
    match l with
    | [] -> List.rev acc
    | x :: xs when List.exists (eq x) xs -> uniq eq acc xs
    | x :: xs -> uniq eq (x :: acc) xs
  in
  uniq eq [] l
