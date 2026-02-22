type 'a atom = Var of 'a | Neg of 'a
type 'a t = Atom of 'a atom | Conj of 'a t list | Disj of 'a t list

let var x = Atom (Var x)
let neg_atom = function Var x -> Neg x | Neg x -> Var x

let rec neg = function
  | Atom a -> Atom (neg_atom a)
  | Conj l -> Disj (List.map neg l)
  | Disj l -> Conj (List.map neg l)

let conj l = Conj l
let disj l = Disj l
let impl a b = disj [ neg a; b ]

module Disj : sig
  type 'a t

  val pure : 'a -> 'a t
  val append : 'a t -> 'a t -> 'a t
  val empty : 'a t
  val to_list : 'a t -> 'a list
end = struct
  type 'a t = 'a list

  let pure x = [ x ]
  let append l1 l2 = l1 @ l2
  let empty = []
  let to_list l = l
end

module Conj : sig
  type 'a t

  val pure : 'a -> 'a t
  val append : 'a t -> 'a t -> 'a t
  val empty : 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
  val to_list : 'a t -> 'a list
end = struct
  type 'a t = 'a list

  let pure x = [ x ]
  let append l1 l2 = l1 @ l2
  let empty = []
  let bind x f = List.concat_map f x
  let to_list l = l
end

type 'a disj = 'a Disj.t
type 'a conj = 'a Conj.t

let disj_of_conj : 'a atom disj conj -> 'a atom disj conj -> 'a atom disj conj =
  let ( let* ) = Conj.bind in
  fun cj1 cj2 ->
    let* dj1 = cj1 in
    let* dj2 = cj2 in
    Conj.pure (Disj.append dj1 dj2)

let rec to_cnf_ : 'a t -> 'a atom disj conj = function
  | Atom a -> Conj.pure (Disj.pure a)
  | Conj l ->
      let aux = List.map to_cnf_ l in
      List.fold_left Conj.append Conj.empty aux
  | Disj l ->
      let aux = List.map to_cnf_ l in
      List.fold_left disj_of_conj (Conj.pure Disj.empty) aux

let to_cnf (t : 'a t) : 'a atom list list =
  to_cnf_ t |> Conj.to_list |> List.map Disj.to_list

let pp pp_var fmt t =
  let open Format in
  let pp_atom fmt = function
    | Var v -> pp_var fmt v
    | Neg v -> fprintf fmt "~%a" pp_var v
  in
  let rec pp_prec context_prec fmt = function
    | Atom a -> pp_atom fmt a
    | Conj [] -> pp_print_string fmt "true"
    | Disj [] -> pp_print_string fmt "false"
    | Conj [ x ] -> pp_prec context_prec fmt x
    | Disj [ x ] -> pp_prec context_prec fmt x
    | Conj l ->
        let current_prec = 1 in
        let pp_items fmt =
          pp_print_list
            ~pp_sep:(fun fmt () -> pp_print_string fmt " & ")
            (pp_prec current_prec) fmt l
        in
        if current_prec < context_prec then fprintf fmt "(%t)" pp_items
        else pp_items fmt
    | Disj l ->
        let current_prec = 0 in
        let pp_items fmt =
          pp_print_list
            ~pp_sep:(fun fmt () -> pp_print_string fmt " | ")
            (pp_prec current_prec) fmt l
        in
        if current_prec < context_prec then fprintf fmt "(%t)" pp_items
        else pp_items fmt
  in
  pp_prec 0 fmt t

let pp_cnf pp_var fmt cnf =
  let open Format in
  let pp_atom fmt = function
    | Var v -> pp_var fmt v
    | Neg v -> fprintf fmt "~%a" pp_var v
  in
  let pp_clause fmt = function
    | [] -> pp_print_string fmt "false"
    | clause ->
        pp_print_list
          ~pp_sep:(fun fmt () -> pp_print_string fmt " | ")
          pp_atom fmt clause
  in
  match cnf with
  | [] -> pp_print_string fmt "true"
  | _ ->
      pp_print_list
        ~pp_sep:(fun fmt () -> pp_print_string fmt " & ")
        (fun fmt clause -> fprintf fmt "(%a)" pp_clause clause)
        fmt cnf
