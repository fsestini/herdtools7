type set = CatSet.t
type rel = { domain : CatSet.t; range : CatSet.t }

module Set = struct
  let bottom = CatSet.empty
  let top = CatSet.universe
  let join = CatSet.union
  let meet = CatSet.inter
  let equal = CatSet.equal

  let builtin = function
    | "emptyset" -> Some CatSet.empty
    | s -> CatSet.of_primitive_set s

  let pp = CatSet.pp

  module Forward = struct
    let union es = List.fold_left CatSet.union CatSet.empty es
    let inter es = List.fold_left CatSet.inter CatSet.universe es
    let diff = CatSet.diff
    let comp x = CatSet.diff CatSet.universe x
    let try_ a b = join a b
  end

  module Backward = struct
    let union ~parent ~children_fw = List.map (meet parent) children_fw
    let inter ~parent ~children_fw = List.map (meet parent) children_fw

    let diff ~parent ~lchild_fw ~rchild_fw =
      let cx = meet parent lchild_fw in
      let cy = meet cx rchild_fw in
      (cx, cy)

    let comp ~parent ~child_fw = meet parent child_fw

    let try_ ~parent ~lchild_fw ~rchild_fw =
      (meet parent lchild_fw, meet parent rchild_fw)
  end
end

module Rel = struct
  let pp fmt t = Format.fprintf fmt "%a  x  %a" Set.pp t.domain Set.pp t.range

  let equal t1 t2 =
    Pair.equal CatSet.equal CatSet.equal (t1.domain, t1.range)
      (t2.domain, t2.range)

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

  (* FIXME: Remove Option.get *)
  let builtin = function
    | "id" -> Some id_rel
    | "po" -> Some top
    | "rf" ->
        let domain = CatSet.of_primitive_set "W" |> Option.get in
        let range = CatSet.of_primitive_set "R" |> Option.get in
        Some { domain; range }
    | "fr" ->
        let domain = CatSet.of_primitive_set "R" |> Option.get in
        let range = CatSet.of_primitive_set "W" |> Option.get in
        Some { domain; range }
    | "co" ->
        let domain = CatSet.of_primitive_set "W" |> Option.get in
        let range = CatSet.of_primitive_set "W" |> Option.get in
        Some { domain; range }
    | _s ->
        (* Format.eprintf "unknown relation builtin `%s`.@." s; *)
        None

  module Forward = struct
    let union = List.fold_left join bottom
    let inter = List.fold_left meet top
    let diff x _ = x
    let do_seq t1 t2 = { domain = t1.domain; range = t2.range }

    let seq l =
      let x, xs = Util.NonEmpty.uncons l in
      List.fold_left do_seq x xs

    let id_rel = top
    let cartesian domain range = { domain; range }
    let inv t = { domain = t.range; range = t.domain }
    let comp _ = top
    let toid s = { domain = s; range = s }
    let plus t = t
    let star _ = top
    let opt t = join id_rel t
    let try_ a b = join a b
  end

  module Backward = struct
    let inv ~parent ~child_fw =
      meet { domain = parent.range; range = parent.domain } child_fw

    let comp ~parent ~child_fw = meet parent child_fw
    let star ~parent ~child_fw = meet parent child_fw
    let plus ~parent ~child_fw = meet parent child_fw
    let opt ~parent ~child_fw = meet parent child_fw

    let to_id ~parent ~child_fw =
      CatSet.(inter (inter parent.domain parent.range) child_fw)

    let cartesian ~parent ~lchild_fw ~rchild_fw =
      let open CatSet in
      (inter parent.domain lchild_fw, inter parent.range rchild_fw)

    let union ~parent ~children_fw = List.map (meet parent) children_fw
    let inter ~parent ~children_fw = List.map (meet parent) children_fw

    let diff ~parent ~lchild_fw ~rchild_fw =
      let cx = meet parent lchild_fw in
      let cy = meet cx rchild_fw in
      (cx, cy)

    let try_ ~parent ~lchild_fw ~rchild_fw =
      (meet parent lchild_fw, meet parent rchild_fw)

    let seq ~parent ~children_fw =
      let xs =
        let x, y = Util.NonEmpty.uncons children_fw in
        List.cons x y
      in
      let n = List.length xs in
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
  end
end
