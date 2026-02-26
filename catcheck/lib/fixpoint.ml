module Log = (val Logs.src_log (Logs.Src.create "fixpoint") : Logs.LOG)

module type Var = sig
  type t

  val compare : t -> t -> int
  val pp : Format.formatter -> t -> unit
  val should_report : t -> bool
end

module type Lattice = sig
  type t

  val bottom : t
  val join : t -> t -> t
  val equal : t -> t -> bool
  val pp : Format.formatter -> t -> unit
end

module MakeWorklist (T : sig
  type t

  val compare : t -> t -> int
end) : sig
  type t

  val empty : t
  val push : t -> T.t -> t
  val pop : t -> (T.t * t) option
end = struct
  module S = Set.Make (T)

  type t = S.t

  let empty = S.empty
  let push t el = S.add el t

  let pop t =
    match S.to_list t with [] -> None | x :: xs -> Some (x, S.of_list xs)
end

module type Forward = sig
  type var
  type value
  type solution = var -> value

  (* Reverse dependencies:
     if [v] changes, which vars should be reprocessed? *)
  type deps = var -> var list

  (* Equation right-hand side:
     compute the "desired" value for [v] from the current solution. *)
  type rhs = solution -> var -> value

  val solve :
    vars:var list -> deps:deps -> rhs:rhs -> init:(var -> value) -> solution
end

module MakeForward (Var : Var) (Lat : Lattice) :
  Forward with type var = Var.t and type value = Lat.t = struct
  type var = Var.t
  type value = Lat.t

  module M = Map.Make (Var)
  module WL = MakeWorklist (Var)

  type solution = var -> value
  type deps = var -> var list
  type rhs = solution -> var -> value

  let solve ~vars ~deps ~rhs ~init : solution =
    (* initial store *)
    let store0 = List.fold_left (fun m v -> M.add v (init v) m) M.empty vars in

    let get store v =
      match M.find_opt v store with Some x -> x | None -> Lat.bottom
    in

    (* solution view of the current store *)
    let sol_of store : solution = fun v -> get store v in

    let rec loop (store : value M.t) (wl : WL.t) : value M.t =
      match WL.pop wl with
      | None -> store
      | Some (v, wl) ->
          let oldv = get store v in
          let desired = rhs (sol_of store) v in
          (* let newv = Lat.join oldv desired in *)
          if Var.should_report v then
            Log.app (fun m ->
                m "Forward fixpoint step for var: %a. Old: %a; desired: %a"
                  Var.pp v Lat.pp oldv Lat.pp desired);
          let newv =
            try Lat.join oldv desired
            with Invalid_argument msg ->
              Log.debug (fun m ->
                  m "Failed forward fixpoint step for var: %a" Var.pp v);
              raise (Invalid_argument msg)
          in

          if Lat.equal newv oldv then loop store wl
          else
            let store = M.add v newv store in

            (* schedule dependents *)
            let wl = List.fold_left WL.push wl (deps v) in
            loop store wl
    in

    let wl = List.fold_left WL.push WL.empty vars in
    let store_final = loop store0 wl in
    let sol_final : solution = sol_of store_final in
    sol_final
end

module type Backward = sig
  type var
  type value
  type solution = var -> value

  (* One propagation step from a processed variable [v]:
     return a list of (target, contribution) to be joined into the target. *)
  type step = solution -> var -> (var * value) list

  val solve : vars:var list -> step:step -> seeds:(var * value) list -> solution
end

module MakeBackward (Var : Var) (Lat : Lattice) :
  Backward with type var = Var.t and type value = Lat.t = struct
  type var = Var.t
  type value = Lat.t
  type solution = Var.t -> Lat.t
  type step = solution -> Var.t -> (Var.t * Lat.t) list

  module VM = Map.Make (Var)
  module WL = MakeWorklist (Var)

  let solve :
      vars:var list ->
      step:(solution -> var -> (var * value) list) ->
      seeds:(var * value) list ->
      solution =
   fun ~vars ~step ~seeds ->
    (* Initialize store with bottom for all declared vars. *)
    let store0 =
      List.fold_left (fun m v -> VM.add v Lat.bottom m) VM.empty vars
    in
    let get store v = Option.value ~default:Lat.bottom (VM.find_opt v store) in
    let sol_of store : solution = fun v -> get store v in

    (* Seed: join in seed values, and push any var that actually changed. *)
    let store0, wl0 =
      List.fold_left
        (fun (store, wl) (v, x) ->
          let oldv = get store v in
          let newv = Lat.join oldv x in
          if Lat.equal newv oldv then (store, wl)
          else (VM.add v newv store, WL.push wl v))
        (store0, WL.empty) seeds
    in

    (* Main propagation loop *)
    let rec loop (store : value VM.t) (wl : WL.t) : value VM.t =
      match WL.pop wl with
      | None -> store
      | Some (v, wl) ->
          let sol = sol_of store in
          let updates = step sol v in

          let store, wl =
            List.fold_left
              (fun (store, wl) (u, delta) ->
                let oldu = get store u in
                let newu = Lat.join oldu delta in
                if Lat.equal newu oldu then (store, wl)
                else (VM.add u newu store, WL.push wl u))
              (store, wl) updates
          in
          loop store wl
    in

    let store_final = loop store0 wl0 in
    sol_of store_final
end
