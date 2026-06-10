module type Graph = sig
  type node
  type edge

  val node_id : node -> string
  val node_cluster : node -> int option
  val endpoints : edge -> node * node
  val node_label : node -> string
  val edge_label : edge -> string
end

(* eiid2 [label="c: W[x]=0\lInit", shape="box", color="blue"]; *)
(* eiid1 -> eiid9 [label="po", color="black", fontcolor="black"]; *)

module Make (G : Graph) : sig
  val pp_dot_graph :
    Format.formatter ->
    all_nodes:G.node list ->
    is_lasso_node:(G.node -> bool) ->
    G.edge list ->
    unit
end = struct
  let pp_dot_graph fmt ~all_nodes ~is_lasso_node edges =
    let clustered, unclustered =
      List.partition_map
        (fun n ->
          match G.node_cluster n with
          | Some cl -> Either.Left (n, cl)
          | None -> Either.Right n)
        all_nodes
    in
    let clusters =
      clustered
      |> List.fold_left
           (fun m (n, cl) -> IntMap.add_to_list cl n m)
           IntMap.empty
    in
    let pp_node n =
      let nid = G.node_id n in
      let lbl = Format.sprintf "%s: %s" nid (G.node_label n) in
      Format.fprintf fmt "%s [label=%S, shape=\"box\", color=\"blue\"];@." nid
        lbl
    in
    Format.fprintf fmt "digraph G {@.";
    List.iter pp_node unclustered;
    clusters
    |> IntMap.iter (fun cl l ->
        let in_lasso, out_lasso = List.partition is_lasso_node l in
        Format.fprintf fmt "subgraph cluster_proc%d {@." cl;
        Format.fprintf fmt
          "rank=sink; label=\"Thread %d\"; color=magenta; shape=box;@." cl;
        List.iter pp_node out_lasso;
        if not (List.is_empty in_lasso) then begin
          Format.fprintf fmt "subgraph cluster_proc%d {@." cl;
          Format.fprintf fmt
            "rank=sink; label=\"Lasso\"; color=magenta; shape=box;@.";
          List.iter pp_node in_lasso;
          Format.fprintf fmt "}@."
        end;
        Format.fprintf fmt "}@.");
    edges
    |> List.iter (fun edge ->
        let src, tgt = G.endpoints edge in
        let src_id = G.node_id src in
        let tgt_id = G.node_id tgt in
        let lbl = G.edge_label edge in
        let color = "black" in
        Format.fprintf fmt "%s -> %s [label=%S, color=%S, fontscolor=%S];@."
          src_id tgt_id lbl color color);
    Format.fprintf fmt "}@."
end
