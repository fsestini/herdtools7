open Catcheck

module P = Cat.MakeParser (struct
  (* let libdir = "test-libdir" *)
  let libdir = "libdir"
end)

module E = TxtLoc.Extract ()

let () =
  (* let bs = P.read_bindings "test.cat" in *)
  let bs = P.read_bindings "aarch64.cat" in
  let module D = AbstractDomain.FromTyped (DRDomain) in
  let module G = Analysis.Make (D) in
  let results = G.solve_all bs in
  results
  |> List.iter (fun (loc, res) ->
      let combined = D.meet res.G.forward res.G.backward in
      if D.equal combined res.G.forward then
        Printf.printf "%a: %s: OK.\n" TxtLoc.pp loc (E.extract loc)
      else
        match combined with
        | D.Rel r ->
            let expected = CatSet.inter r.DRDomain.domain r.DRDomain.range in
            Printf.printf "%a:\n" TxtLoc.pp loc;
            Format.printf "  expression `%s` could be simplified to `[%a]`@."
              (E.extract loc) CatSet.pp expected
        | D.Set _ -> Format.printf "Found Set@."
        | D.Top -> Format.printf "Found Top@."
        | D.Bottom -> Format.printf "Found Bottom@.")
