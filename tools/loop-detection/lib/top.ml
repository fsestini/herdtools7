module Log = (val Logs.src_log (Logs.Src.create "top") : Logs.LOG)
open Herdlib
module T = LitmusTest
module W = IntervalWeights
module TR = Top_herd.TestResult

exception Error of string

let exn_message = function Error msg -> msg | exn -> Printexc.to_string exn

let warn_skipped_execution i exn =
  Printf.eprintf "Warning: skipping unsupported execution %d: %s\n%!" i
    (exn_message exn)

module Parser = ParseModel.Make (struct
  let debug = false
  let libfind file = file
end)

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

let parse_model file =
  let opts, name, ins = Parser.parse file in
  let dir = Filename.dirname file in
  let stdlib =
    let stdlib = Filename.concat dir "stdlib.cat" in
    if String.equal (Filename.basename file) "stdlib.cat" then []
    else if Sys.file_exists stdlib then parse_cat stdlib
    else []
  in
  let ins = stdlib @ expand_ins dir ins in
  ((opts, name, ins), ins)

type graph_rel = { name : string; endpoints : (string * string) option }

let graph_rel name = { name; endpoints = None }
let graph_rel_between name ev1 ev2 = { name; endpoints = Some (ev1, ev2) }

module Make (S : SemExtra.S) = struct
  module E = S.E
  module TRS = TR.Make (S)

  module D = Dot.Make (struct
    type node = E.event
    type edge = string * E.event * E.event * W.t

    let node_id ev = Format.sprintf "eiid%d" ev.E.eiid
    let node_cluster ev = E.proc_of ev
    let endpoints (_, x, y, _) = (x, y)
    let node_label ev = Format.sprintf "%s: %s" (E.pp_eiid ev) (E.pp_action ev)
    let edge_label (r, _, _, w) = Format.asprintf "%s %a" r W.pp w
  end)

  module WR =
    WeightedRel.Make
      (W)
      (struct
        type t = E.event

        let compare = E.event_compare
      end)

  module MC = ModelChecker.Make (S) (WR)

  module PrettySem (C : sig
    val showevents : PrettyConf.showevents
  end) =
  struct
    include S

    module O = struct
      include S.O

      module PC = struct
        include S.O.PC

        let showevents = C.showevents
      end
    end
  end

  let get_rel_or_empty lbl rels =
    List.assoc_opt lbl rels |> Option.value ~default:E.EventRel.empty

  let non_cutoff_events (conc : S.concrete) =
    E.EventSet.filter (fun ev -> not (E.is_cutoff ev)) conc.S.str.events

  let pp_rel ~lbl fmt rel =
    let rel_list, () = Util.Iter.to_list (fun f -> E.EventRel.iter f rel) in
    let open Format in
    pp_print_list
      ~pp_sep:(fun fmt () -> fprintf fmt "@,")
      (fun fmt (ev1, ev2) ->
        fprintf fmt "%s -- %s -> %s" (E.pp_eiid ev1) lbl (E.pp_eiid ev2))
      fmt rel_list

  let pp_event_list fmt evs =
    let open Format in
    pp_print_list
      ~pp_sep:(fun fmt () -> fprintf fmt "@,")
      (fun fmt ev -> fprintf fmt "  %s: %s" (E.pp_eiid ev) (E.pp_action ev))
      fmt evs

  module PP = Pretty.Make (S)

  type iteration = { events : E.event list; branch_event : E.event }

  let pp_iteration fmt (ix, i) =
    Format.fprintf fmt "@[<v 2>Iteration #%d@,%a@]" ix pp_event_list i.events

  let pp_iterations fmt iters =
    let open Format in
    fprintf fmt "Iterations:@.";
    pp_print_list
      ~pp_sep:(fun fmt () -> Format.fprintf fmt "@,")
      pp_iteration fmt iters

  let is_event_in ev evs = List.exists (fun ev' -> E.event_equal ev ev') evs

  module L = Lasso.Make (S) (W) (WR)

  type infinite_exec = { index : int; conc : S.concrete; lasso : L.lasso }

  let run ?(lenient = false) (result : TRS.t) () =
    let execs, _ = result.exec_iter |> Util.Iter.to_list in
    execs
    |> List.mapi (fun index exec ->
        let conc = TR.concrete exec in
        let rels = TR.relations exec in
        let rf_reg = List.assoc "rf-reg" rels in
        let rf = List.assoc "rf" rels in
        let co = List.assoc "co" rels in
        let lasso = L.find_lasso conc ~rf_reg ~rf ~co in
        match lasso with
        | `Finite -> None
        | `Infinite lasso -> Some { index; conc; lasso }
        | `Unsupported msg -> if lenient then None else failwith msg)
    |> List.filter_map (fun x -> x)

  let add_vb label src dst vbs =
    let rel =
      match List.assoc_opt label vbs with
      | None -> E.EventRel.empty
      | Some rel -> rel
    in
    (label, E.EventRel.add (src, dst) rel) :: List.remove_assoc label vbs

  let endpoint_matches endpoints src dst =
    match endpoints with
    | None -> true
    | Some (ev1, ev2) ->
        String.equal (E.pp_eiid src) ev1 && String.equal (E.pp_eiid dst) ev2

  let weighted_vbs { name; endpoints } rel =
    WR.fold
      (fun (src, dst, weight) vbs ->
        if endpoint_matches endpoints src dst then
          let label =
            if W.equal weight (W.singleton 0) then name
            else Format.asprintf "%s %a" name W.pp weight
          in
          add_vb label src dst vbs
        else vbs)
      rel []
    |> List.rev

  (* TODO: use this *)
  (* let dump_exec_graph graph_rels showevents model test model_ins i exec = *)
  (*   let checked = *)
  (*     MC.check_all exec.conc exec.lasso.iteration.events exec.rels model_ins *)
  (*   in *)
  (*   let force_rel = checked.force_rel in *)
  (*   List.iter *)
  (*     (fun name -> *)
  (*       Printf.eprintf "Warning: execution %d violates %s\n%!" i name) *)
  (*     checked.failed_checks; *)
  (*   let graph_rel name = *)
  (*     let rel = force_rel name in *)
  (*     if String.equal name "co" then WR.transitive_reduction rel else rel *)
  (*   in *)
  (*   let vbs = *)
  (*     graph_rels *)
  (*     |> List.map (fun spec -> weighted_vbs spec (graph_rel spec.name)) *)
  (*     |> List.concat *)
  (*   in *)
  (*   let path = Printf.sprintf "out-%d.dot" i in *)
  (*   Out_channel.with_open_bin path (fun ch -> *)
  (*       let selected_showevents = showevents in *)
  (*       let module PP = Pretty.Make (PrettySem (struct *)
  (*         let showevents = selected_showevents *)
  (*       end)) in *)
  (*       PP.dump_legend ch model test PrettyConf.ShowAll exec.conc vbs); *)
  (*   path *)

  (* result |> Iter.iteri (fun _i _exec -> ()) *)
end

let default_graph_rels = [ graph_rel "co"; graph_rel "fr" ]

(* TODO: use as reference *)
(* let top ?(graph_rels = default_graph_rels) *)
(*     ?(showevents = PrettyConf.NonRegEvents) ?(lenient = false) ~libdir ~unroll *)
(*     file_path = *)
(*   let str = In_channel.with_open_text file_path In_channel.input_all in *)
(*   let ltest = T.parse_from_file file_path in *)
(*   let model_path = *)
(*     match libdir with *)
(*     | None -> "aarch64.cat" *)
(*     | Some dir -> Filename.concat dir "aarch64.cat" *)
(*   in *)
(*   let model_ast, model_ins = parse_model model_path in *)
(*   let model = Model.Generic (model_path, model_ast) in *)
(*   let simul = HerdDriver.top ~libdir ~unroll str in *)
(*   let module R : RunTest.Outcome = (val simul) in *)
(*   let module M = Make (R.M.S) in *)
(*   let execs = M.run ~lenient ltest R.test R.result () in *)
(*   execs *)
(*   |> List.iter (fun exec -> *)
(*       let i = exec.M.index in *)
(*       try *)
(*         let path = *)
(*           M.dump_exec_graph graph_rels showevents model R.test model_ins i exec *)
(*         in *)
(*         Printf.printf "Wrote %s\n%!" path *)
(*       with *)
(*       | Sys.Break -> raise Sys.Break *)
(*       | exn -> if lenient then warn_skipped_execution i exn else raise exn); *)
(*   print_endline "Done." *)
