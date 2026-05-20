open Catcheck
module G = Graph
module N = Graph.Node
module T = TypeDomain

let loc = TxtLoc.none
let var name = AST.Var (loc, name)
let konst k = AST.Konst (loc, k)
let op op children = AST.Op (loc, op, children)
let op1 op child = AST.Op1 (loc, op, child)
let app func arg = AST.App (loc, func, arg)
let explicit_set children = AST.ExplicitSet (loc, children)

let match_ scrutinee clauses default =
  AST.Match (loc, scrutinee, clauses, default)

let match_set scrutinee body =
  AST.MatchSet (loc, scrutinee, body, AST.EltRem (None, None, var "Exp"))

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
    binding "range_rel" (app (var "range") (var "rf"));
    binding "domain_rel" (app (var "domain") (var "rf"));
    binding "explicit_set" (explicit_set [ var "Exp"; var "W" ]);
    binding "helper_app"
      (app (var "intervening") (op AST.Tuple [ var "W"; var "po" ]));
    binding "helper_set_app"
      (app (var "oa-changes") (op AST.Tuple [ var "Exp"; var "po" ]));
    binding "match_set"
      (match_ (var "Exp") [ ("case", var "W") ] (Some (var "R")));
    binding "match_rel"
      (match_ (var "Exp") [ ("case", var "po") ] (Some (var "rf")));
    binding "match_set_expr" (match_set (var "Exp") (var "W"));
    binding "unknown_app" (app (var "definitely_unknown_function") (var "Exp"));
    binding "alias" (var "set_union");
    binding ~is_recursive:true "rec_set"
      (op AST.Union [ var "rec_set"; var "Exp" ]);
  ]

let () = Top.infer_types bindings
