module Make (G : sig
  type t
  type vertex

  module E : sig
    type t

    val src : t -> vertex
    val dst : t -> vertex
  end

  val iter_vertex : (vertex -> unit) -> t -> unit
  val iter_edges_e : (E.t -> unit) -> t -> unit
  val node_id : vertex -> string
  val label : vertex -> string
  val node_fillcolor : vertex -> string
  val edge_color : vertex -> vertex -> string option
end) =
struct
  let compare_node n1 n2 = String.compare (G.node_id n1) (G.node_id n2)

  let node_attrs n =
    Printf.sprintf
      "label=%S, shape=\"box\", style=\"rounded,filled\", fillcolor=%S"
      (G.label n) (G.node_fillcolor n)

  let edge_attrs src dst =
    match G.edge_color src dst with
    | None -> ""
    | Some color -> Printf.sprintf " [color=%S]" color

  let output_graph ch g =
    let vertices = ref [] in
    G.iter_vertex (fun v -> vertices := v :: !vertices) g;
    let vertices = List.sort compare_node !vertices in
    let edges = ref [] in
    G.iter_edges_e
      (fun e ->
        let src = G.E.src e in
        let dst = G.E.dst e in
        edges := (src, dst) :: !edges)
      g;
    let edges =
      !edges
      |> List.sort (fun (src1, dst1) (src2, dst2) ->
          match String.compare (G.node_id src1) (G.node_id src2) with
          | 0 -> String.compare (G.node_id dst1) (G.node_id dst2)
          | c -> c)
    in
    Printf.fprintf ch "digraph partitions {\n";
    Printf.fprintf ch "  rankdir=TB;\n";
    Printf.fprintf ch
      "  graph [splines=true, overlap=false, pack=72, packmode=\"array_u1\"];\n";
    Printf.fprintf ch "  node [fontname=\"Helvetica\"];\n";
    Printf.fprintf ch "  edge [arrowsize=0.7];\n\n";
    vertices
    |> List.iter (fun n ->
        Printf.fprintf ch "  %S [%s];\n" (G.node_id n) (node_attrs n));
    Printf.fprintf ch "\n";
    edges
    |> List.iter (fun (src, dst) ->
        Printf.fprintf ch "  %S -> %S%s;\n" (G.node_id src) (G.node_id dst)
          (edge_attrs src dst));
    Printf.fprintf ch "}\n"
end
