open Catcheck

(* let test_exp : Cat.exp = *)
(*   let open Cat in *)
(*   inter [ seq [ ident "po"; to_id (ident "M") ]; ident "rf" ] *)
(**)
(* let test_stmt = *)
(*   let body = *)
(*     test_exp *)
(*     (* let open Cat in *) *)
(*     (* Binop (Union, [ test_exp; Binop (Seq, [ Id "foo"; Id "foo" ]) ]) *) *)
(*   in *)
(*  Cat.let_ "foo" body *)

module P = Cat.MakeParser (struct
  let libdir = "libdir"
end)

let () =
  let bs = P.read_bindings "test.cat" in
  (* Format.printf "%a@." Cat.pp_stmt test_stmt; *)
  (* let test_stmt_lbld = List.hd (Graph.label_all [ test_stmt ]) in *)
  (* Format.printf "%a@." *)
  (*   (Cat.pp_stmt ~pp_lbl:Format.pp_print_int ()) *)
  (*   test_stmt_lbld; *)
  (* let res = FW.forward_program ~max_rec_iters:1000 [ test_stmt ] in *)
  (* List.iter *)
  (*   (fun (n, v) -> Format.printf "%s = %a\n" n DRDomain.pp v) *)
  (*   res.values_in_order *)
  let module G = Graph.Make (DRDomain) in
  (* G.forward_all [ test_stmt ] *)
  G.solve_all bs
