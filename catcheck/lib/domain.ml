module type S = sig
  type t

  val bottom : t
  val join : t -> t -> t
  val meet : t -> t -> t
  val equal : t -> t -> bool

  (* Leaves *)
  (* val builtin_id : t (* meaning of id *) *)
  val builtin :
    string -> t option (* meaning of primitive/builtin named relation *)

  val to_id : AST.exp -> t
  val cartesian : AST.exp -> AST.exp -> t

  (* Forward transfer *)
  val op1_f : AST.op1 -> t -> t
  val op2_f : AST.op2 -> t list -> t

  (* Backward/demand transfer:
     Given parent demand and forward facts of children, produce demands for children
     in the same order as the children list. *)
  val op1_b : AST.op1 -> parent:t -> child_f:t -> t
  val op2_b : AST.op2 -> parent:t -> children_f:t list -> t list
  val pp : Format.formatter -> t -> unit
end
