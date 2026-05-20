open Catcheck

module P = Cat.MakeParser (struct
  let libdir = "libdir"
end)

let () =
  let prims = P.read_bindings "../primitives.cat" in
  let bs = P.read_bindings "aarch64.cat" in
  Top.report_any_types (prims @ bs)
