type 'a atom = Var of 'a | Neg of 'a
type 'a t

val var : 'a -> 'a t
val neg : 'a t -> 'a t
val conj : 'a t list -> 'a t
val disj : 'a t list -> 'a t
val impl : 'a t -> 'a t -> 'a t

val pp : (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a t -> unit
(** Pretty-print a formula. *)

val to_cnf : 'a t -> 'a atom list list
(** Convert boolean formula to Conjunctive Normal Form. *)

val pp_cnf : (Format.formatter -> 'a -> unit) -> Format.formatter -> 'a atom list list -> unit
(** Pretty-print a formula in Conjunctive Normal Form. *)
