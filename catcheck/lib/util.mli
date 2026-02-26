module List : sig
  module Syntax : sig
    val ( let* ) : 'a list -> ('a -> 'b list) -> 'b list
  end

  val traverse_option : ('a -> 'b option) -> 'a list -> 'b list option
end

module NonEmpty : sig
  type 'a t

  val cons : 'a -> 'a list -> 'a t
  val uncons : 'a t -> 'a * 'a list
  val map : ('a -> 'b) -> 'a t -> 'b t
end
