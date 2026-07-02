module Iter = struct
  type 'a t = ('a -> unit) -> unit

  let to_list (t : 'a t) =
    let l = ref [] in
    t (fun x -> l := x :: !l);
    List.rev !l
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
