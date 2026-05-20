type t

val known : CatSet.t -> t
val is_tainted : t -> bool
val carrier : t -> CatSet.t
val bottom : t
val universe : t
val top : t
val equal : t -> t -> bool
val pp : Format.formatter -> t -> unit
val union : t -> t -> t
val inter : t -> t -> t
val diff : t -> t -> t
val comp : t -> t
val taint : t -> t
