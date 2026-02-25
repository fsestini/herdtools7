module List = struct
  module Syntax = struct
    let ( let* ) xs f = List.concat_map f xs
  end
end

module NonEmpty = struct
  type 'a t = 'a * 'a list

  let cons x xs = (x, xs)
  let uncons t = t
end
