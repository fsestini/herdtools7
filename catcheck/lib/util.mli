module List : sig
  module Syntax : sig
    val ( let* ) : 'a list -> ('a -> 'b list) -> 'b list
  end
end
