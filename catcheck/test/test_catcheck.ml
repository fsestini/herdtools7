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
  (* let libdir = "test-libdir" *)
  let libdir = "libdir"
end)

module E = TxtLoc.Extract ()

let () =
  (* let bs = P.read_bindings "test.cat" in *)
  let bs = P.read_bindings "aarch64.cat" in

  (* Format.printf "%a@." Cat.pp_stmt test_stmt; *)
  (* let test_stmt_lbld = List.hd (Graph.label_all [ test_stmt ]) in *)
  (* Format.printf "%a@." *)
  (*   (Cat.pp_stmt ~pp_lbl:Format.pp_print_int ()) *)
  (*   test_stmt_lbld; *)
  (* let res = FW.forward_program ~max_rec_iters:1000 [ test_stmt ] in *)
  (* List.iter *)
  (*   (fun (n, v) -> Format.printf "%s = %a\n" n DRDomain.pp v) *)
  (*   res.values_in_order *)
  let module G = Analysis.Make (DRDomain) in
  (* G.forward_all [ test_stmt ] *)
  let results = G.solve_all bs in
  results
  |> List.iter (fun (loc, res) ->
      let combined = DRDomain.meet res.G.forward res.G.backward in
      if DRDomain.equal combined res.G.forward then
        Printf.printf "%a: %s: OK.\n" TxtLoc.pp loc (E.extract loc)
      else
        let expected =
          CatSet.inter combined.DRDomain.domain combined.DRDomain.range
        in
        Printf.printf "%a:\n" TxtLoc.pp loc;
        Format.printf "  expression `%s` could be simplified to `[%a]`@."
          (E.extract loc) CatSet.pp expected)
