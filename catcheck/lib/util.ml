module List = struct
  module Syntax = struct
    let ( let* ) xs f = List.concat_map f xs
  end
end
