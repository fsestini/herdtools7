module List = struct
  module Syntax = struct
    let ( let* ) xs f = List.concat_map f xs
  end

  let rec traverse_option f =
    let ( let* ) = Option.bind in
    function
    | [] -> Some []
    | x :: xs ->
        let* x' = f x in
        let* xs' = traverse_option f xs in
        Some (x' :: xs')
end

module NonEmpty = struct
  type 'a t = 'a * 'a list

  let cons x xs = (x, xs)
  let uncons t = t
  let map f (x, xs) = (f x, Stdlib.List.map f xs)
end
