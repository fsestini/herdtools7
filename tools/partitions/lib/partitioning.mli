module Partition : sig
  type t

  val compare : t -> t -> int
  val index : t -> int
  val pp : Format.formatter -> t -> unit
end

module PartitionSet : Set.S with type elt = Partition.t

type t

val labels : t -> string list
val partitions : t -> Partition.t list
val denotation : t -> string -> PartitionSet.t

val labels_of_partition : t -> Partition.t -> string list
(** Labels whose denotation contains the partition. *)

val simplify_labels : t -> string list -> string list
(** Remove labels whose denotation is implied by another label in the list. *)

val to_assoc : t -> (string * Partition.t list) list

val compute_partitions : AST.ins list -> t
(** Compute the partitioning induced by a parsed cat model. *)
