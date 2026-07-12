module type S = sig
  type elt
  type weight = Weight.t
  type t

  val equal : t -> t -> bool

  val empty : t
  val of_list : (elt * elt * weight) list -> t
  val add : elt * elt * weight -> t -> t
  val fold : (elt * elt * weight -> 'a -> 'a) -> t -> 'a -> 'a
  val cartesian : elt list -> elt list -> weight -> t
  val union : t -> t -> t
  val intersection : t -> t -> t
  val diff : t -> t -> t
  val inverse : t -> t
  val sequence : t -> t -> t
  val filter : (elt -> elt -> weight -> bool) -> t -> t
  val transitive_closure : t -> t option

  val pp : (Format.formatter -> elt -> unit) -> Format.formatter -> t -> unit
end

module W = Weight

module Make (Elt : Set.OrderedType) : S with type elt = Elt.t = struct
  type elt = Elt.t
  type weight = W.t

  module EltMap = MyMap.Make (Elt)

  type t = weight EltMap.t EltMap.t

  let empty = EltMap.empty

  let add (src, dst, w) rel =
    if W.is_empty w then rel
    else
      EltMap.update src
        (function
          | None -> Some (EltMap.singleton dst w)
          | Some dsts ->
              Some
                (EltMap.update dst
                   (function None -> Some w | Some w' -> Some (W.union w w'))
                   dsts))
        rel

  let of_list edges =
    List.fold_left (fun rel edge -> add edge rel) EltMap.empty edges

  let fold f rel acc =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold (fun dst w acc -> f (src, dst, w) acc) dsts acc)
      rel acc

  let cartesian srcs dsts w =
    if W.is_empty w then EltMap.empty
    else
      List.fold_left
        (fun rel src ->
          List.fold_left (fun rel dst -> add (src, dst, w) rel) rel dsts)
        EltMap.empty srcs

  let union rel1 rel2 = EltMap.union (EltMap.union W.union) rel1 rel2

  let intersection rel1 rel2 =
    EltMap.fold
      (fun src dsts1 acc ->
        match EltMap.find_opt src rel2 with
        | None -> acc
        | Some dsts2 ->
            let dsts =
              EltMap.fold
                (fun dst w1 acc ->
                  match EltMap.find_opt dst dsts2 with
                  | None -> acc
                  | Some w2 ->
                      let w = W.intersection w1 w2 in
                      if W.is_empty w then acc else EltMap.add dst w acc)
                dsts1 EltMap.empty
            in
            if EltMap.is_empty dsts then acc else EltMap.add src dsts acc)
      rel1 EltMap.empty

  let diff rel1 rel2 =
    EltMap.fold
      (fun src dsts1 acc ->
        let dsts2 = EltMap.find_opt src rel2 in
        let dsts =
          EltMap.fold
            (fun dst w1 acc ->
              let w =
                match dsts2 with
                | None -> w1
                | Some dsts2 -> (
                    match EltMap.find_opt dst dsts2 with
                    | None -> w1
                    | Some w2 -> W.diff w1 w2)
              in
              if W.is_empty w then acc else EltMap.add dst w acc)
            dsts1 EltMap.empty
        in
        if EltMap.is_empty dsts then acc else EltMap.add src dsts acc)
      rel1 EltMap.empty

  let inverse rel =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold (fun dst w acc -> add (dst, src, W.inverse w) acc) dsts acc)
      rel EltMap.empty

  let sequence rel1 rel2 =
    EltMap.fold
      (fun src dsts acc ->
        EltMap.fold
          (fun mid w1 acc ->
            match EltMap.find_opt mid rel2 with
            | None -> acc
            | Some succs ->
                EltMap.fold
                  (fun dst w2 acc -> add (src, dst, W.plus w1 w2) acc)
                  succs acc)
          dsts acc)
      rel1 EltMap.empty

  let equal rel1 rel2 = EltMap.equal (EltMap.equal W.equal) rel1 rel2

  let transitive_closure rel =
    let max_iterations = 10 in
    let rec loop iteration current =
      if iteration >= max_iterations then
        None
      else
      let candidate = union current (sequence current current) in
      if equal current candidate then Some current
      else loop (iteration + 1) candidate
    in
    loop 0 rel

  let filter p (t : t) =
    fold
      (fun (x, y, w) acc -> if p x y w then add (x, y, w) acc else acc)
      t empty

  let pp pp_elt fmt rel =
    let pp_edge fmt (src, dst, w) =
      Format.fprintf fmt "(%a,%a,%a)" pp_elt src pp_elt dst W.pp w
    in
    let edges = fold (fun edge acc -> edge :: acc) rel [] |> List.rev in
    Format.fprintf fmt "{%a}"
      (Format.pp_print_list
         ~pp_sep:(fun fmt () -> Format.fprintf fmt "; ")
         pp_edge)
      edges
end
