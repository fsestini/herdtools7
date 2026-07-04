open Herdlib
module T = Loop_detection.LitmusTest
module W = Loop_detection.IntervalWeights

module Parser = ParseModel.Make (struct
  let debug = false
  let libfind file = file
end)

let file_path = "data/wait-flag.litmus"
let libdir = Some "libdir"
let libdir_path = "libdir"
let unroll = None
let model_path = Filename.concat libdir_path "aarch64.cat"

let eval_variant_cond =
  let rec go = function
    | AST.Variant _ -> false
    | AST.OpNot cond -> not (go cond)
    | AST.OpAnd (c1, c2) -> go c1 && go c2
    | AST.OpOr (c1, c2) -> go c1 || go c2
  in
  go

let rec parse_cat file =
  let _, _, ins = Parser.parse file in
  expand_ins (Filename.dirname file) ins

and expand_ins dir ins =
  List.concat_map
    (function
      | AST.Include (_, file) -> parse_cat (Filename.concat dir file)
      | AST.IfVariant (_, cond, then_ins, else_ins) ->
          expand_ins dir (if eval_variant_cond cond then then_ins else else_ins)
      | ins -> [ ins ])
    ins

let print_rel pp_eiid fold rels name =
  let rel = List.assoc name rels in
  let edges = fold (fun edge edges -> edge :: edges) rel [] |> List.rev in
  Format.printf "%s =@." name;
  List.iter
    (fun (src, dst, weight) ->
      Format.printf "  (%s,%s,%a)@." (pp_eiid src) (pp_eiid dst) W.pp weight)
    edges

let () =
  let str = In_channel.with_open_text file_path In_channel.input_all in
  let ltest = T.parse_from_file file_path in
  let simul = Loop_detection.HerdDriver.top ~libdir ~unroll str in
  let module R : RunTest.Outcome = (val simul) in
  let module M = Loop_detection.Top.Make (R.M.S) in
  let model = parse_cat model_path in
  let execs = M.run ltest R.test R.result () in
  List.iter
    (fun ({ M.index; conc; lasso; rels } : M.infinite_exec) ->
      let force_rel = M.MC.check conc lasso.M.events rels model in
      Format.printf "execution %d@." index;

      print_rel M.E.pp_eiid M.WR.fold rels "po";
      print_rel M.E.pp_eiid M.WR.fold rels "co";
      print_rel M.E.pp_eiid M.WR.fold rels "rf";
      match force_rel "ob" with
      | ob -> print_rel M.E.pp_eiid M.WR.fold (("ob", ob) :: rels) "ob"
      | exception Loop_detection.WeightedRel.Unsupported msg ->
          Format.printf "ob unsupported: %s@." msg)
    execs
