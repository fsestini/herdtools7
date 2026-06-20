type t

val build_graph : Catpart.Partitioning.t -> t
(** Build the DAG representation of a partitioning. *)

val filter_subtree : root_label:string -> t -> t
(** Keep the node with the given label and all reachable descendants.

    @raise Invalid_argument if the label does not identify exactly one node. *)

module Dot : sig
  val output_graph : out_channel -> t -> unit
  (** Print a DAG graph in DOT format. *)
end
