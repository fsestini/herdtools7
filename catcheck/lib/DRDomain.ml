type t = { domain : CatSet.t; range : CatSet.t }

let bottom = { domain = CatSet.empty; range = CatSet.empty }
let top = { domain = CatSet.universe; range = CatSet.universe }

let join t1 t2 =
  {
    domain = CatSet.union t1.domain t2.domain;
    range = CatSet.union t1.range t2.range;
  }

let meet t1 t2 =
  {
    domain = CatSet.inter t1.domain t2.domain;
    range = CatSet.inter t1.range t2.range;
  }

let id_rel = top

let builtin = function
  | "id" -> Some id_rel
  | "po" -> Some top
  | "rf" ->
      let domain = CatSet.of_primitive_set "W" in
      let range = CatSet.of_primitive_set "R" in
      Some { domain; range }
  | s -> failwith (Format.sprintf "unknown builtin: %s" s)

let op1_f (op : AST.op1) t =
  let open AST in
  match op with
  | Opt -> join id_rel t
  | Plus -> t
  | Star -> top
  | Comp -> top
  | Inv -> { domain = t.range; range = t.domain }
  | ToId -> assert false

let seq t1 t2 = { domain = t1.domain; range = t2.range }

let to_id exp =
  let s = CatSet.of_set_expr exp in
  { domain = s; range = s }

let cartesian a b =
  { domain = CatSet.of_set_expr a; range = CatSet.of_set_expr b }

let op2_f (op : AST.op2) l =
  let open AST in
  match (op, l) with
  | Union, l -> List.fold_left join bottom l
  | Inter, l -> List.fold_left meet top l
  | Diff, [ x; _ ] -> x
  | Diff, _ -> failwith "invalid diff"
  | Seq, [] -> failwith "invalid seq"
  | Seq, x :: xs -> List.fold_left seq x xs
  | Cartesian, _ -> assert false
  | Add, _ -> failwith "op2_f: Add not supported"
  | Tuple, _ -> failwith "op2_f: Tuple not supported"

let pp fmt : t -> unit =
 fun t -> Format.fprintf fmt "%a x %a" CatSet.pp t.domain CatSet.pp t.range

let equal t1 t2 =
  Pair.equal CatSet.equal CatSet.equal (t1.domain, t1.range)
    (t2.domain, t2.range)

let op1_b (op : AST.op1) ~(parent : t) ~(child_f : t) : t =
  let open AST in
  match op with
  | Inv -> meet { domain = parent.range; range = parent.domain } child_f
  | Comp -> meet parent child_f
  | Star | Plus | Opt -> meet parent child_f
  | ToId -> failwith "op1_b ToId"

let op2_b (op : AST.op2) ~(parent : t) ~(children_f : t list) : t list =
  let open AST in
  match (op, children_f) with
  | Cartesian, _ -> failwith "op2_b Cartesian"
  | Add, _ -> failwith "op2_b Add"
  | Tuple, _ -> failwith "op2_b Tuple"
  | Union, fs | Inter, fs -> List.map (meet parent) fs
  | Diff, [ x_f; y_f ] ->
      let cx = meet parent x_f in
      let cy = meet (meet parent x_f) y_f in
      [ cx; cy ]
  | Diff, _ -> failwith "invalid diff"
  | Seq, [] -> failwith "invalid seq"
  | Seq, [ x_f ] -> [ meet parent x_f ]
  | Seq, xs ->
      let n = List.length xs in
      if n = 0 then failwith "invalid seq";

      let mids =
        let rec go acc = function
          | x1 :: (x2 :: _ as tl) ->
              let mid = CatSet.inter x1.range x2.domain in
              go (mid :: acc) tl
          | _ -> List.rev acc
        in
        go [] xs
      in

      let mk i =
        if n = 1 then parent
        else if i = 0 then { domain = parent.domain; range = List.nth mids 0 }
        else if i = n - 1 then
          { domain = List.nth mids (n - 2); range = parent.range }
        else { domain = List.nth mids (i - 1); range = List.nth mids i }
      in

      List.mapi
        (fun i cf ->
          let want = mk i in
          meet want cf)
        xs
