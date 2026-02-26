module type Var = sig
  type t

  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
  val should_report : t -> bool
end

(** Bounded join semi-lattice, on a finite set with decidable equality. *)
module type Lattice = sig
  type t

  val bottom : t
  val join : t -> t -> t
  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
end

(** Forward analysis. *)
module type Forward = sig
  type var
  type value
  type solution = var -> value
  type deps = var -> var list
  type rhs = solution -> var -> value

  val solve :
    vars:var list -> deps:deps -> rhs:rhs -> init:(var -> value) -> solution
end

module MakeForward (V : Var) (L : Lattice) :
  Forward with type var = V.t and type value = L.t

(** Backward analysis. *)
module type Backward = sig
  type var
  type value
  type solution = var -> value
  type step = solution -> var -> (var * value) list

  val solve : vars:var list -> step:step -> seeds:(var * value) list -> solution
end

module MakeBackward (V : Var) (L : Lattice) :
  Backward with type var = V.t and type value = L.t
