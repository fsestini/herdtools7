open Catcheck
module G = Graph
module N = Graph.Node
module T = TypeDomain

let loc = TxtLoc.none
let var name = AST.Var (loc, name)
let konst k = AST.Konst (loc, k)
let op op children = AST.Op (loc, op, children)
let op1 op child = AST.Op1 (loc, op, child)

let binding ?(is_recursive = false) name exp =
  Cat.{ name; exp; is_recursive; location = loc }

let bindings =
  [
    binding "set_prim" (var "Exp");
    binding "rel_prim" (var "po");
    binding "set_empty" (konst (AST.Empty AST.SET));
    binding "rel_empty" (konst (AST.Empty AST.RLN));
    binding "set_union" (op AST.Union [ var "Exp"; var "W" ]);
    binding "set_inter" (op AST.Inter [ var "Exp"; var "W" ]);
    binding "set_diff" (op AST.Diff [ var "Exp"; var "W" ]);
    binding "rel_seq" (op AST.Seq [ var "po"; var "rf" ]);
    binding "rel_plus" (op1 AST.Plus (var "po"));
    binding "rel_inv" (op1 AST.Inv (var "po"));
    binding "toid_set" (op1 AST.ToId (var "Exp"));
    binding "cartesian" (op AST.Cartesian [ var "Exp"; var "W" ]);
    binding "mixed_seq" (op AST.Seq [ var "Exp"; var "po" ]);
    binding "mixed_union" (op AST.Union [ var "po"; var "Exp" ]);
    binding "bad_toid" (op1 AST.ToId (var "po"));
    binding "unknown_primitive" (var "definitely_unknown_symbol");
    binding "alias" (var "set_union");
    binding ~is_recursive:true "rec_set"
      (op AST.Union [ var "rec_set"; var "Exp" ]);
  ]

let () = Top.infer_types bindings
