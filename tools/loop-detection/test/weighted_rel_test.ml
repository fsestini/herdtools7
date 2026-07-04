module WeightedRel = Loop_detection.WeightedRel
module W = Loop_detection.IntervalWeights
module WR = WeightedRel.Make (W) (Int)

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

let print_unary_weight_or_exception name op w =
  try Format.printf "%s %a = %a@." name W.pp w W.pp (op w) with
  | WeightedRel.Unsupported msg ->
      Format.printf "%s %a = Unsupported %S@." name W.pp w msg
  | Invalid_argument msg ->
      Format.printf "%s %a = Invalid_argument %S@." name W.pp w msg
  | exn -> Format.printf "%s %a = %s@." name W.pp w (Printexc.to_string exn)

let print_binary_weight_or_exception name op w1 w2 =
  try Format.printf "%a %s %a = %a@." W.pp w1 name W.pp w2 W.pp (op w1 w2) with
  | WeightedRel.Unsupported msg ->
      Format.printf "%a %s %a = Unsupported %S@." W.pp w1 name W.pp w2 msg
  | Invalid_argument msg ->
      Format.printf "%a %s %a = Invalid_argument %S@." W.pp w1 name W.pp w2 msg
  | exn ->
      Format.printf "%a %s %a = %s@." W.pp w1 name W.pp w2
        (Printexc.to_string exn)

let print_of_list edges =
  Format.printf "of_list %a = %a@." pp_edge_list edges pp_rel (rel edges)

let print_fold r =
  let edges = WR.fold (fun edge acc -> edge :: acc) r [] |> List.rev in
  Format.printf "fold %a = %a@." pp_rel r pp_edge_list edges

let print_unary_rel name op r =
  Format.printf "%s %a = %a@." name pp_rel r pp_rel (op r)

let print_binary_rel name op r1 r2 =
  Format.printf "%a %s %a = %a@." pp_rel r1 name pp_rel r2 pp_rel (op r1 r2)

let () =
  Format.printf "pp %a = %a@." W.pp
    (finite [ -2; 0; 3 ])
    W.pp
    (finite [ -2; 0; 3 ]);
  Format.printf "pp %a = %a@." W.pp (W.at_least 3) W.pp (W.at_least 3);
  Format.printf "pp %a = %a@." W.pp (W.at_most (-3)) W.pp (W.at_most (-3));
  print_binary_weight "union" W.union (finite [ 1; 3 ]) (finite [ 2; 3 ]);
  print_binary_weight "union" W.union (finite [ 4 ]) (W.at_least 5);
  print_binary_weight "union" W.union (finite [ 2; 3; 4 ]) (W.at_least 5);
  print_binary_weight "union" W.union (finite [ 6 ]) (W.at_most 5);
  print_binary_weight "union" W.union (W.at_least 0) (W.at_most (-1));
  print_binary_weight_or_exception "union" W.union (finite [ 2 ]) (W.at_least 5);
  print_binary_weight_or_exception "union" W.union (finite [ 8 ]) (W.at_most 5);
  print_binary_weight_or_exception "union" W.union (W.at_least 5) (W.at_most 3);
  print_binary_weight "intersection" W.intersection (W.at_least 0) (W.at_most 2);
  print_binary_weight "diff" W.diff (finite [ 1; 2; 3 ]) (finite [ 2 ]);
  print_binary_weight "diff" W.diff (W.at_least 0) (W.at_least 3);
  print_binary_weight "diff" W.diff (W.at_least 0) (finite [ 0; 1; 2 ]);
  print_binary_weight "diff" W.diff (W.at_most 5) (finite [ 3; 4; 5 ]);
  print_binary_weight_or_exception "diff" W.diff W.top (finite [ 0 ]);
  print_binary_weight_or_exception "diff" W.diff (W.at_least 0) (finite [ 2 ]);
  print_binary_weight_or_exception "diff" W.diff (W.at_most 5) (finite [ 3 ]);
  print_unary_weight "inverse" W.inverse (finite [ -2; 0; 3 ]);
  print_unary_weight "inverse" W.inverse (W.at_least 3);
  print_binary_weight "plus" W.plus (finite [ 2; 4 ]) (W.at_least 3);
  print_binary_weight "plus" W.plus (W.at_least 0) (W.at_most 0);
  print_binary_weight "widen" W.widen (finite [ 1; 2 ]) (finite [ 1; 2; 3 ]);
  print_binary_weight "widen" W.widen (finite [ 1; 2 ]) (finite [ 0; 1; 2 ]);
  print_binary_weight "widen" W.widen (finite [ 1; 2 ]) (finite [ 0; 1; 2; 3 ]);
  print_unary_weight_or_exception "inverse" W.inverse (finite [ min_int ]);
  print_binary_weight_or_exception "plus" W.plus (finite [ max_int ])
    (finite [ 1 ])

let () =
  print_of_list [ (1, 2, W.empty) ];
  print_of_list [ (2, 3, finite [ 0 ]); (2, 3, finite [ 1 ]) ];
  print_fold WR.empty;
  print_fold (rel [ (1, 2, finite [ 0 ]); (2, 3, finite [ 1 ]) ]);
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
  print_binary_rel "widen" WR.widen
    (rel [ (1, 2, finite [ 0 ]) ])
    (rel [ (1, 2, finite [ 0; 1 ]) ]);
  print_unary_rel "transitive_closure" WR.transitive_closure_widened WR.empty;
  print_unary_rel "transitive_closure" WR.transitive_closure_widened
    (rel [ (1, 2, finite [ 0 ]); (2, 3, finite [ 0 ]) ]);
  print_unary_rel "transitive_closure" WR.transitive_closure_widened
    (rel [ (1, 2, finite [ 1 ]); (2, 3, finite [ 2 ]) ]);
  print_unary_rel "transitive_closure" WR.transitive_closure_widened
    (rel
       [
         (1, 2, finite [ 1 ]);
         (2, 4, finite [ 1 ]);
         (1, 3, finite [ 2 ]);
         (3, 4, finite [ 2 ]);
       ]);
  print_unary_rel "transitive_closure" WR.transitive_closure_widened
    (rel [ (1, 1, finite [ 1 ]) ]);
  print_unary_rel "transitive_closure" WR.transitive_closure_widened
    (rel [ (1, 1, finite [ -1 ]) ]);
  print_unary_rel "transitive_closure" WR.transitive_closure_widened
    (rel [ (1, 2, finite [ 1 ]); (2, 1, finite [ 1 ]); (3, 4, finite [ 1 ]) ]);
  print_unary_rel "transitive_reduction" WR.transitive_reduction WR.empty;
  print_unary_rel "transitive_reduction" WR.transitive_reduction
    (rel [ (1, 2, finite [ 1 ]); (1, 3, finite [ 1 ]); (2, 3, finite [ 1 ]) ]);
  print_unary_rel "transitive_reduction" WR.transitive_reduction
    (rel [ (1, 2, finite [ 1 ]); (1, 3, finite [ 9 ]); (2, 3, finite [ 2 ]) ]);
  print_unary_rel "transitive_reduction" WR.transitive_reduction
    (rel
       [
         (1, 2, finite [ 7 ]);
         (1, 3, finite [ 7 ]);
         (1, 4, finite [ 7 ]);
         (2, 4, finite [ 7 ]);
         (3, 4, finite [ 7 ]);
       ]);
  print_unary_rel "transitive_reduction" WR.transitive_reduction
    (rel [ (1, 1, finite [ 5 ]) ]);
  print_unary_rel "transitive_reduction" WR.transitive_reduction
    (rel [ (1, 2, finite [ 0 ]); (2, 1, finite [ 1 ]) ]);
  print_unary_rel "transitive_reduction" WR.transitive_reduction
    (rel [ (1, 2, finite [ 0 ]); (2, 1, finite [ 0 ]) ]);
  print_unary_rel "transitive_reduction" WR.transitive_reduction
    (rel
       [
         (1, 2, finite [ 4 ]);
         (1, 3, finite [ 4 ]);
         (1, 4, finite [ 4 ]);
         (2, 1, finite [ 4 ]);
         (2, 3, finite [ 4 ]);
         (3, 4, finite [ 4 ]);
       ])
