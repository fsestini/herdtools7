open Herd_core
module W = Weight

module UnrestrictedInt = struct
  include Int

  let kind _ = `Infinite
end

module WR = WeightedRel.Make (UnrestrictedInt)

module LassoInt = struct
  include Int

  let is_lasso x = Int.equal (x mod 2) 1
  let kind x = if is_lasso x then `Infinite else `Finite
end

module LassoWR = WeightedRel.Make (LassoInt)
module IntSet = MySet.Make (Int)
module LassoRel = WeightedRel.MakeInnerRel (IntSet) (LassoWR)

let finite xs =
  List.fold_left (fun acc x -> W.union acc (W.singleton x)) W.empty xs

let rel edges = WR.of_list edges
let pp_int = Format.pp_print_int
let pp_rel = WR.pp pp_int
let pp_edge fmt (src, dst, w) = Format.fprintf fmt "(%d,%d,%a)" src dst W.pp w

let pp_edge_list fmt edges =
  Format.fprintf fmt "[%a]"
    (Format.pp_print_list
       ~pp_sep:(fun fmt () -> Format.fprintf fmt "; ")
       pp_edge)
    edges

let print_unary_weight name op w =
  Format.printf "%s %a = %a@." name W.pp w W.pp (op w)

let print_binary_weight name op w1 w2 =
  Format.printf "%a %s %a = %a@." W.pp w1 name W.pp w2 W.pp (op w1 w2)

let print_of_list edges =
  Format.printf "of_list %a = %a@." pp_edge_list edges pp_rel (rel edges)

let print_unary_rel name op r =
  Format.printf "%s %a = %a@." name pp_rel r pp_rel (op r)

let print_unary_rel_or_none name op r =
  match op r with
  | Some r' -> Format.printf "%s %a = %a@." name pp_rel r pp_rel r'
  | None -> Format.printf "%s %a = None@." name pp_rel r

let print_binary_rel name op r1 r2 =
  Format.printf "%a %s %a = %a@." pp_rel r1 name pp_rel r2 pp_rel (op r1 r2)

let print_lasso_rel name r =
  Format.printf "%s = %a@." name (LassoWR.pp pp_int) r

let () =
  print_binary_weight "union" W.union (finite [ 1; 3 ]) (finite [ 2; 3 ]);
  print_binary_weight "union" W.union (finite [ 4 ]) (W.at_least 5);
  print_binary_weight "union" W.union (finite [ 2; 3; 4 ]) (W.at_least 5);
  print_binary_weight "union" W.union (finite [ 6 ]) (W.at_most 5);
  print_binary_weight "union" W.union (W.at_least 0) (W.at_most (-1));
  print_binary_weight "union" W.union (finite [ 2 ]) (W.at_least 5);
  print_binary_weight "union" W.union (finite [ 8 ]) (W.at_most 5);
  print_binary_weight "union" W.union (W.at_least 5) (W.at_most 3);
  print_binary_weight "intersection" W.intersection (W.at_least 0) (W.at_most 2);
  print_binary_weight "diff" W.diff (finite [ 1; 2; 3 ]) (finite [ 2 ]);
  print_binary_weight "diff" W.diff (W.at_least 0) (W.at_least 3);
  print_binary_weight "diff" W.diff (W.at_least 0) (finite [ 0; 1; 2 ]);
  print_binary_weight "diff" W.diff (W.at_most 5) (finite [ 3; 4; 5 ]);
  print_binary_weight "diff" W.diff W.top (finite [ 0 ]);
  print_binary_weight "diff" W.diff (W.at_least 0) (finite [ 2 ]);
  print_binary_weight "diff" W.diff (W.at_most 5) (finite [ 3 ]);
  print_unary_weight "inverse" W.inverse (finite [ -2; 0; 3 ]);
  print_unary_weight "inverse" W.inverse (W.at_least 3);
  print_binary_weight "plus" W.plus (finite [ 2; 4 ]) (W.at_least 3);
  print_binary_weight "plus" W.plus (W.at_least 0) (W.at_most 0)

let () =
  print_of_list [ (1, 2, W.empty) ];
  print_of_list [ (2, 3, finite [ 0 ]); (2, 3, finite [ 1 ]) ];
  print_binary_rel "union" WR.union
    (rel [ (1, 2, finite [ 0 ]) ])
    (rel [ (2, 3, finite [ 1 ]) ]);
  print_binary_rel "intersection" WR.intersection
    (rel [ (1, 2, finite [ 0 ]) ])
    (rel [ (1, 2, finite [ 1 ]) ]);
  print_binary_rel "intersection" WR.intersection
    (rel [ (1, 2, finite [ 0; 1 ]) ])
    (rel [ (1, 2, finite [ 1; 2 ]) ]);
  print_binary_rel "diff" WR.diff
    (rel [ (1, 2, finite [ 0 ]) ])
    (rel [ (1, 2, finite [ 0 ]) ]);
  print_binary_rel "diff" WR.diff
    (rel [ (1, 2, finite [ 0; 1 ]) ])
    (rel [ (1, 2, finite [ 1 ]) ]);
  print_unary_rel "inverse" WR.inverse
    (rel [ (1, 2, finite [ 0 ]); (2, 3, finite [ 1 ]) ]);
  print_binary_rel "sequence" WR.sequence
    (rel [ (1, 2, finite [ 0 ]); (2, 3, finite [ 0 ]) ])
    (rel [ (2, 3, finite [ 1 ]); (3, 4, finite [ 1 ]) ]);
  print_unary_rel_or_none "transitive_closure" WR.transitive_closure WR.empty;
  print_unary_rel_or_none "transitive_closure" WR.transitive_closure
    (rel [ (1, 2, finite [ 0 ]); (2, 3, finite [ 0 ]) ]);
  print_unary_rel_or_none "transitive_closure" WR.transitive_closure
    (rel [ (1, 2, finite [ 1 ]); (2, 3, finite [ 2 ]) ]);
  print_unary_rel_or_none "transitive_closure" WR.transitive_closure
    (rel
       [
         (1, 2, finite [ 1 ]);
         (2, 4, finite [ 1 ]);
         (1, 3, finite [ 2 ]);
         (3, 4, finite [ 2 ]);
       ]);
  print_unary_rel_or_none "transitive_closure" WR.transitive_closure
    (rel [ (1, 1, finite [ 1 ]) ]);
  print_unary_rel_or_none "transitive_closure" WR.transitive_closure
    (rel [ (1, 1, finite [ -1 ]) ]);
  print_unary_rel_or_none "transitive_closure" WR.transitive_closure
    (rel [ (1, 2, finite [ 1 ]); (2, 1, finite [ 1 ]); (3, 4, finite [ 1 ]) ])

let () =
  let rel edges = LassoWR.of_list edges in
  print_lasso_rel "restricted of_list"
    (rel
       [
         (0, 2, finite [ -1; 0; 1 ]);
         (0, 1, finite [ 0; 1; 2 ]);
         (1, 2, finite [ -2; -1; 0 ]);
         (1, 3, finite [ -1; 0; 1 ]);
       ]);
  print_lasso_rel "impossible edge" (rel [ (0, 2, finite [ 1 ]) ]);
  print_lasso_rel "restricted cartesian"
    (LassoWR.cartesian [ 0; 1 ] [ 2; 3 ] W.top);
  print_lasso_rel "restricted sequence"
    (LassoWR.sequence
       (rel [ (0, 1, W.at_least 1) ])
       (rel [ (1, 2, W.at_most (-1)) ]));
  match
    LassoWR.transitive_closure
      (rel [ (0, 1, W.at_least 1); (1, 2, W.at_most (-1)) ])
  with
  | Some r -> print_lasso_rel "restricted transitive_closure" r
  | None -> Format.printf "restricted transitive_closure = None@."

let () =
  let positive_self = LassoWR.of_list [ (1, 1, W.singleton 1) ] in
  let zero_self = LassoWR.of_list [ (0, 0, W.singleton 0) ] in
  let zero_cycle =
    LassoWR.of_list
      [ (0, 1, W.at_least 1); (1, 0, W.at_most (-1)) ]
  in
  Format.printf "adapter positive self acyclic = %b@."
    (LassoRel.is_acyclic positive_self);
  Format.printf "adapter zero self irreflexive = %b@."
    (LassoRel.is_irreflexive zero_self);
  Format.printf "adapter zero cycle acyclic = %b@."
    (LassoRel.is_acyclic zero_cycle)

let () =
  Format.printf "adapter empty domain = %b@."
    (IntSet.is_empty (LassoRel.domain LassoRel.empty));
  Format.printf "adapter empty codomain = %b@."
    (IntSet.is_empty (LassoRel.codomain LassoRel.empty))

let () =
  let rel =
    LassoWR.of_list [ (0, 1, W.top); (0, 3, W.top); (2, 1, W.top) ]
  in
  let restricted =
    LassoRel.restrict_domains (Int.equal 0) (Int.equal 1) rel
  and restricted_domain = LassoRel.restrict_domain (Int.equal 0) rel
  and restricted_codomain = LassoRel.restrict_codomain (Int.equal 1) rel
  and restricted_codomain_to_set =
    LassoRel.restrict_codomain_to_set (IntSet.singleton 1) rel
  and restricted_to_sets =
    LassoRel.restrict_domains_to_sets
      (IntSet.singleton 0) (IntSet.singleton 1) rel
  in
  print_lasso_rel "adapter restrict_domain" restricted_domain;
  print_lasso_rel "adapter restrict_codomain" restricted_codomain;
  print_lasso_rel "adapter restrict_codomain_to_set" restricted_codomain_to_set;
  print_lasso_rel "adapter restrict_domains" restricted;
  print_lasso_rel "adapter restrict_domains_to_sets" restricted_to_sets

let () =
  let events = IntSet.of_list [ 0; 2 ]
  and rel = LassoWR.of_list [ (0, 2, W.singleton 0) ] in
  let expected = LassoWR.of_list [ (0, 2, W.singleton 0) ] in
  let zero_orders =
    LassoRel.all_topos_kont_rel events rel
      (fun _ -> false)
      (fun order _ -> LassoWR.equal order expected)
      false
  in
  let infinite_edge_rejected =
    try
      ignore
        (LassoRel.all_topos_kont_rel
           (IntSet.of_list [ 1; 3 ])
           (LassoWR.of_list [ (1, 3, W.singleton 0) ])
           (fun _ -> ())
           (fun _ () -> ())
           ());
      false
    with WeightedRel.Unsupported _ -> true
  in
  let infinite_node_rejected =
    try
      ignore
        (LassoRel.all_topos_kont_rel
           (IntSet.singleton 1) LassoRel.empty
           (fun _ -> ())
           (fun _ () -> ())
           ());
      false
    with WeightedRel.Unsupported _ -> true
  in
  let outside_infinite_edge_rejected =
    try
      ignore
        (LassoRel.all_topos_kont_rel
           events
           (LassoWR.of_list [ (1, 3, W.singleton 0) ])
           (fun _ -> ())
           (fun _ () -> ())
           ());
      false
    with WeightedRel.Unsupported _ -> true
  in
  let zero_compare = LassoRel.compare rel expected in
  let nonzero_lasso_rel = LassoWR.of_list [ (1, 3, W.top) ] in
  let nonzero_compare =
    Int.equal (LassoRel.compare nonzero_lasso_rel nonzero_lasso_rel) 0
    && LassoRel.compare rel nonzero_lasso_rel <> 0
  in
  Format.printf "adapter zero all_topos = %b@." zero_orders;
  Format.printf "adapter infinite-edge all_topos rejected = %b@."
    infinite_edge_rejected;
  Format.printf "adapter infinite-node all_topos rejected = %b@."
    infinite_node_rejected;
  Format.printf "adapter outside-infinite-edge all_topos rejected = %b@."
    outside_infinite_edge_rejected;
  Format.printf "adapter zero compare = %d@." zero_compare;
  Format.printf "adapter nonzero compare = %b@." nonzero_compare

let () =
  let rel =
    LassoWR.of_list [ (0, 2, W.singleton 0); (2, 4, W.singleton 0) ]
  in
  print_lasso_rel "adapter restrict_domain_transitive_closure"
    (LassoRel.restrict_domain_transitive_closure (IntSet.singleton 0) rel)
