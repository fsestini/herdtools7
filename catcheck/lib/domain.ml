module type Typed = sig
  type set
  type rel

  module Set : sig
    val bottom : set
    val top : set
    val join : set -> set -> set
    val meet : set -> set -> set
    val equal : set -> set -> bool

    val builtin : string -> set option
    (** semantics of primitive/builtin set *)

    val pp : Format.formatter -> set -> unit

    module Forward : sig
      val union : set list -> set
      val inter : set list -> set
      val diff : set -> set -> set
      val comp : set -> set
    end

    module Backward : sig
      val union : parent:set -> children_fw:set list -> set list
      val inter : parent:set -> children_fw:set list -> set list
      val op_diff : parent:set -> lchild_fw:set -> rchild_fw:set -> set * set
      val comp : parent:set -> child_fw:set -> set
    end
  end

  module Rel : sig
    val bottom : rel
    val top : rel
    val join : rel -> rel -> rel
    val meet : rel -> rel -> rel
    val equal : rel -> rel -> bool

    val builtin : string -> rel option
    (** semantics of primitive/builtin relation *)

    val pp : Format.formatter -> rel -> unit

    module Forward : sig
      val union : rel list -> rel
      val inter : rel list -> rel
      val diff : rel -> rel -> rel
      val seq : rel Util.NonEmpty.t -> rel
      val cartesian : set -> set -> rel
      val inv : rel -> rel
      val comp : rel -> rel
      val toid : set -> rel
      val plus : rel -> rel
      val star : rel -> rel
      val opt : rel -> rel
    end

    module Backward : sig
      val union : parent:rel -> children_fw:rel list -> rel list
      val inter : parent:rel -> children_fw:rel list -> rel list
      val diff : parent:rel -> lchild_fw:rel -> rchild_fw:rel -> rel * rel
      val seq : parent:rel -> children_fw:rel Util.NonEmpty.t -> rel list
      val cartesian : parent:rel -> lchild_fw:set -> rchild_fw:set -> set * set
      val inv : parent:rel -> child_fw:rel -> rel
      val comp : parent:rel -> child_fw:rel -> rel
      val to_id : parent:rel -> child_fw:set -> rel
      val plus : parent:rel -> child_fw:rel -> rel
      val star : parent:rel -> child_fw:rel -> rel
      val opt : parent:rel -> child_fw:rel -> rel
    end
  end
end

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
