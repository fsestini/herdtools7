open Herdlib
module W = IntervalWeights

module Make
    (S : SemExtra.S)
    (WR : WeightedRel.S with type elt = S.E.event and type weight = W.t) =
struct
  module E = S.E
  module I = LazyInterpreter.Make (S.E.EventSet) (W) (WR)

  type event_kind = Finite | Lasso

  let event_kind lasso_events ev =
    if E.EventSet.mem ev lasso_events then Lasso else Finite

  let all_offsets lasso_events src dst =
    match (event_kind lasso_events src, event_kind lasso_events dst) with
    | Finite, Finite -> W.singleton 0
    | Finite, Lasso -> W.at_least 1
    | Lasso, Finite -> W.at_most (-1)
    | Lasso, Lasso -> W.top

  let add_if_absent name value map =
    if StringMap.mem name map then map else StringMap.add name value map

  let relation_of_event_rel events rel =
    E.EventRel.fold
      (fun (src, dst) acc ->
        if E.EventSet.mem src events && E.EventSet.mem dst events then
          WR.add (src, dst, W.singleton 0) acc
        else acc)
      rel WR.empty

  let relation_of_pred events lasso_events pred =
    E.EventSet.fold
      (fun src acc ->
        E.EventSet.fold
          (fun dst acc ->
            if pred src dst then
              WR.add (src, dst, all_offsets lasso_events src dst) acc
            else acc)
          events acc)
      events WR.empty

  let relation_of_pred_zero events pred =
    E.EventSet.fold
      (fun src acc ->
        E.EventSet.fold
          (fun dst acc ->
            if pred src dst then WR.add (src, dst, W.singleton 0) acc else acc)
          events acc)
      events WR.empty

  let identity_rel events =
    E.EventSet.fold
      (fun ev acc -> WR.add (ev, ev, W.singleton 0) acc)
      events WR.empty

  let restrict_weighted_rel events rel =
    WR.filter
      (fun src dst _ -> E.EventSet.mem src events && E.EventSet.mem dst events)
      rel

  let add_relation name rel map = StringMap.add name rel map
  let add_empty_rel name map = add_if_absent name WR.empty map
  let add_set name set map = StringMap.add name set map
  let add_empty_set name map = add_if_absent name E.EventSet.empty map

  let default_empty_sets =
    [
      "emptyset";
      "A";
      "L";
      "Q";
      "NoRet";
      "PTE";
      "PTEV";
      "PTEINV";
      "D-PTE";
      "I-PTE";
      "AF";
      "DB";
      "MMU";
      "D-MMU";
      "I-MMU";
      "Translation";
      "AccessFlag";
      "Instr";
      "Within-CMODX-List";
      "Restricted-CMODX";
      "TLBI";
      "DC.CVAU";
      "IC";
      "IC.IALLUIS";
      "IC.IALLU";
      "IC.IVAU";
      "T";
      "Tag";
      "TagCheck";
      "FAULT";
      "EXC-ENTRY";
      "EXC-RET";
      "SVC";
      "TTD";
      "D-TTD";
      "I-TTD";
      "HU";
      "TTDV";
      "TTDINV";
      "Normal";
      "Device";
      "Device-GRE";
      "Device-nGRE";
      "Device-nGnRE";
      "Device-nGnRnE";
      "NSH";
      "ISH";
      "OSH";
      "iNC";
      "iWT";
      "iWB";
      "oNC";
      "oWT";
      "oWB";
      "SPEC";
      "EXEC";
      "SPURIOUS";
      "IW";
      "FW";
      "AMO";
      "DMB.NSH";
      "DMB.NSHLD";
      "DMB.NSHST";
      "DMB.ISH";
      "DMB.ISHLD";
      "DMB.ISHST";
      "DMB.OSH";
      "DMB.OSHLD";
      "DMB.OSHST";
      "DMB.SY";
      "DMB.ST";
      "DMB.LD";
      "DSB.NSH";
      "DSB.NSHLD";
      "DSB.NSHST";
      "DSB.ISH";
      "DSB.ISHLD";
      "DSB.ISHST";
      "DSB.OSH";
      "DSB.OSHLD";
      "DSB.OSHST";
      "DSB.SY";
      "DSB.ST";
      "DSB.LD";
      "ISB";
    ]

  let default_empty_relations =
    [
      "co0";
      "lxsx";
      "inv-domain";
      "TLBI-after";
      "DC-after";
      "IC-after";
      "ctrlisb";
      "same-tag-loc";
      "oa-changes";
      "at-least-one-writable";
    ]

  let set_builtins events =
    let filter pred = E.EventSet.filter pred events in
    let sets =
      StringMap.empty
      |> add_set "emptyset" E.EventSet.empty
      |> add_set "M" (filter E.is_mem)
      |> add_set "R" (filter E.is_mem_load)
      |> add_set "W" (filter E.is_mem_store)
      |> add_set "Exp" (filter E.is_explicit)
      |> add_set "NExp" (filter E.is_not_explicit)
      |> add_set "B" (filter E.is_commit)
      |> add_set "BCC" (filter E.is_bcc)
      |> add_set "PRED" (filter E.is_pred)
      |> add_set "F" (filter E.is_barrier)
      |> add_set "Rreg" (filter E.is_reg_load_any)
      |> add_set "Wreg" (filter E.is_reg_store_any)
      |> add_set "ADDR" E.EventSet.empty
      |> add_set "DATA" E.EventSet.empty
      |> add_set "SPEC" E.EventSet.empty
      |> add_set "EXEC" events
      |> add_set "AMO" (filter E.is_amo)
      |> add_set "SPURIOUS" (filter E.is_spurious)
      |> add_set "IW" (filter E.is_mem_store_init)
    in
    let sets =
      List.fold_left
        (fun sets (name, pred) ->
          add_set name (filter (fun ev -> pred ev.E.action)) sets)
        sets E.Act.arch_sets
    in
    List.fold_left
      (fun sets name -> add_empty_set name sets)
      sets default_empty_sets

  let relation_builtins conc events lasso_events builtins =
    let rels =
      List.fold_left
        (fun rels (name, rel) ->
          add_relation name (restrict_weighted_rel events rel) rels)
        StringMap.empty builtins
    in
    let id = identity_rel events in
    let add_event_rel name rel rels =
      add_if_absent name (relation_of_event_rel events rel) rels
    in
    let rels =
      rels |> add_if_absent "id" id
      |> add_if_absent "loc"
           (relation_of_pred events lasso_events E.same_location)
      |> add_if_absent "same-low-order-bits"
           (relation_of_pred events lasso_events E.same_low_order_bits)
      |> add_if_absent "int" (relation_of_pred events lasso_events E.same_proc)
      |> add_if_absent "ext"
           (relation_of_pred events lasso_events (fun src dst ->
                not (E.same_proc src dst)))
      |> add_if_absent "sm" id |> add_if_absent "si" id
      |> add_event_rel "rmw" conc.S.atomic_load_store
      |> add_event_rel "amo"
           (E.EventRel.restrict_rel E.po_eq conc.S.atomic_load_store)
      |> add_event_rel "control" conc.S.str.E.control
      |> add_event_rel "iico_data" conc.S.str.E.intra_causality_data
      |> add_event_rel "iico_ctrl" conc.S.str.E.intra_causality_control
      |> add_event_rel "iico_order" conc.S.str.E.intra_causality_order
      |> add_if_absent "same-instance"
           (relation_of_pred_zero events E.same_instance)
      |> add_event_rel "pco" conc.S.pco
    in
    let rels =
      List.fold_left
        (fun rels (name, pred) ->
          let rel =
            relation_of_pred events lasso_events (fun src dst ->
                pred src.E.action dst.E.action)
          in
          add_if_absent name rel rels)
        rels E.Act.arch_rels
    in
    List.fold_left
      (fun rels name -> add_empty_rel name rels)
      rels default_empty_relations

  let check (conc : S.concrete) (lasso_events : E.event list)
      (builtins : (string * WR.t) list) (model : AST.ins list) : string -> WR.t
      =
    let events =
      E.EventSet.filter (fun ev -> not (E.is_cutoff ev)) conc.S.str.events
    in
    let lasso_events = E.EventSet.of_list lasso_events in
    let builtins = relation_builtins conc events lasso_events builtins in
    let set_builtins = set_builtins events in
    let with_overrides = StringMap.empty in
    let interpreted =
      I.interpret ~lasso_events ~events ~builtins ~set_builtins ~with_overrides
        model
    in
    fun sym -> I.force_rel interpreted sym
end
