type set = TaintSet.t
type rel = { domain : TaintSet.t; range : TaintSet.t }

module Set = struct
  include TaintSet

  let builtin = function
    | "emptyset" -> Some bottom
    | "ADDR" | "DC.CVAU" | "IC.IALLU" | "IC.IALLUIS" | "IC.IVAU"
    | "PTEDevice-GRE" | "PTEDevice-nGRE" | "PTEDevice-nGnRE"
    | "PTEDevice-nGnRnE" | "PTEINV" | "PTEISH" | "PTENSH" | "PTENormal"
    | "PTEOSH" | "PTETaggedNormal" | "PTEV" | "PTEXS" | "PTEiNC" | "PTEiWB"
    | "PTEiWT" | "PTEoNC" | "PTEoWB" | "PTEoWT" | "Restricted-CMODX" ->
        Some universe
    | s -> Option.map known (CatSet.of_primitive_set s)

  let join = union
  let meet = inter

  module Forward = struct
    let union es = List.fold_left join bottom es
    let inter es = List.fold_left meet universe es
    let diff = diff
    let comp = comp
    let try_ = join
    let if_ = join
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

    let if_ ~parent ~lchild_fw ~rchild_fw =
      (meet parent lchild_fw, meet parent rchild_fw)
  end
end

module Rel = struct
  let pp fmt t = Format.fprintf fmt "%a  x  %a" Set.pp t.domain Set.pp t.range

  let equal t1 t2 =
    Misc.pair_eq Set.equal Set.equal (t1.domain, t1.range) (t2.domain, t2.range)

  let domain t = t.domain
  let range t = t.range
  let bottom = { domain = TaintSet.bottom; range = TaintSet.bottom }
  let universe = { domain = TaintSet.universe; range = TaintSet.universe }
  let top = { domain = TaintSet.top; range = TaintSet.top }

  let join t1 t2 =
    {
      domain = Set.join t1.domain t2.domain;
      range = Set.join t1.range t2.range;
    }

  let meet t1 t2 =
    {
      domain = Set.meet t1.domain t2.domain;
      range = Set.meet t1.range t2.range;
    }

  let taint t =
    { domain = TaintSet.taint t.domain; range = TaintSet.taint t.range }

  let id_rel = universe
  let primitive_set name = CatSet.of_primitive_set name |> Option.get
  let known_set name = TaintSet.known (primitive_set name)

  let builtin = function
    | "id" -> Some id_rel
    | "po" | "ext" | "int" | "loc" | "same-low-order-bits" | "same-instance"
    | "sm" | "rmw" | "amo" | "co0" | "AFtoDB" | "inv-domain" | "iico_data"
    | "iico_ctrl" | "iico_order" | "TLBI-after" | "DC-after" | "IC-after"
    | "lxsx" | "rf-reg" ->
        Some universe
    | "rf" -> Some { domain = known_set "W"; range = known_set "R" }
    | "fr" -> Some { domain = known_set "R"; range = known_set "W" }
    | "co" -> Some { domain = known_set "W"; range = known_set "W" }
    | _ -> None

  module Forward = struct
    let union = List.fold_left join bottom
    let inter = List.fold_left meet universe

    let is_tainted t =
      TaintSet.is_tainted t.domain || TaintSet.is_tainted t.range

    let diff x y = if is_tainted y then taint x else x
    let do_seq t1 t2 = { domain = t1.domain; range = t2.range }

    let seq l =
      let x, xs = Util.NonEmpty.uncons l in
      List.fold_left do_seq x xs

    let id_rel = universe
    let cartesian domain range = { domain; range }
    let inv t = { domain = t.range; range = t.domain }
    let comp t = if is_tainted t then top else universe
    let toid s = { domain = s; range = s }
    let plus t = t
    let star t = if is_tainted t then top else universe
    let opt t = join id_rel t
    let try_ = join
    let if_ = join
  end

  module Backward = struct
    let inv ~parent ~child_fw =
      meet { domain = parent.range; range = parent.domain } child_fw

    let comp ~parent ~child_fw = meet parent child_fw
    let star ~parent ~child_fw = meet parent child_fw
    let plus ~parent ~child_fw = meet parent child_fw
    let opt ~parent ~child_fw = meet parent child_fw

    let to_id ~parent ~child_fw =
      Set.meet (Set.meet parent.domain parent.range) child_fw

    let cartesian ~parent ~lchild_fw ~rchild_fw =
      (Set.meet parent.domain lchild_fw, Set.meet parent.range rchild_fw)

    let union ~parent ~children_fw = List.map (meet parent) children_fw
    let inter ~parent ~children_fw = List.map (meet parent) children_fw

    let diff ~parent ~lchild_fw ~rchild_fw =
      let cx = meet parent lchild_fw in
      let cy = meet cx rchild_fw in
      (cx, cy)

    let try_ ~parent ~lchild_fw ~rchild_fw =
      (meet parent lchild_fw, meet parent rchild_fw)

    let if_ ~parent ~lchild_fw ~rchild_fw =
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
              let mid = Set.meet x1.range x2.domain in
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
