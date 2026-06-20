type t
type lit
type solution = bool StringMap.t

val create : unit -> t
val fresh_lit : t -> lit
val add_clause : t -> lit Logic.t -> unit

val solve : t -> unit
(** Solve current constraints.
    @raise Minisat.Unsat if UNSAT. *)

val value : t -> lit -> bool
val exclude : t -> (lit * bool) list -> unit
