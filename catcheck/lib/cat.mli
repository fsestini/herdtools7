type binding = {
  name : string;
  exp : AST.exp;
  is_recursive : bool;
  location : TxtLoc.t;
}

module MakeParser (_ : sig
  val libdir : string
end) : sig
  val read_bindings : string -> binding list
end
