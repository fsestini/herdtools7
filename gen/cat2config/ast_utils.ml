module Pprinters : sig
  val show_exp : AST.exp -> string
end = struct
  type op1 = [%import: AST.op1] [@@deriving show { with_path = false }]
  type op2 = [%import: AST.op2] [@@deriving show { with_path = false }]
  type var = [%import: AST.var] [@@deriving show { with_path = false }]
  type tag = [%import: AST.tag] [@@deriving show { with_path = false }]
  type varset = [%import: AST.varset]

  type set_or_rln = [%import: AST.set_or_rln]
  [@@deriving show { with_path = false }]

  type konst = [%import: AST.konst] [@@deriving show { with_path = false }]
  type pat0 = [%import: AST.pat0] [@@deriving show { with_path = false }]
  type pat = [%import: AST.pat] [@@deriving show { with_path = false }]

  let pp_varset : Format.formatter -> varset -> unit =
   fun fmt t -> Format.fprintf fmt "%s" (StringSet.pp_id "," t)

  module TxtLoc = struct
    type t = TxtLoc.t

    let pp : Format.formatter -> t -> unit = fun fmt _ -> Format.fprintf fmt "_"
  end

  type exp = [%import: AST.exp] [@@deriving show { with_path = false }]
  and cond = [%import: AST.cond] [@@deriving show { with_path = false }]

  and variant_cond = [%import: AST.variant_cond]
  [@@deriving show { with_path = false }]

  and set_clause = [%import: AST.set_clause]
  [@@deriving show { with_path = false }]

  and clause = [%import: AST.clause] [@@deriving show { with_path = false }]
  and binding = [%import: AST.binding] [@@deriving show { with_path = false }]
end
