let uniq ~(eq : 'a -> 'a -> bool) (l : 'a list) : 'a list =
  let rec uniq eq acc l =
    match l with
    | [] -> List.rev acc
    | x :: xs when List.exists (eq x) xs -> uniq eq acc xs
    | x :: xs -> uniq eq (x :: acc) xs
  in
  uniq eq [] l
