module List : sig
  module Syntax : sig
    val ( let* ) : 'a list -> ('a -> 'b list) -> 'b list
  end
end

module NonEmpty : sig
  type 'a t

  val cons : 'a -> 'a list -> 'a t
  val uncons : 'a t -> 'a * 'a list
end
