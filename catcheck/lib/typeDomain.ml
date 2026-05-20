type t = Bottom | Set | Rel | Any

let top = Any
let bottom = Bottom

let pp fmt = function
  | Bottom -> Format.pp_print_string fmt "Bottom"
  | Set -> Format.pp_print_string fmt "Set"
  | Rel -> Format.pp_print_string fmt "Rel"
  | Any -> Format.pp_print_string fmt "Any"

let join x y =
  match (x, y) with
  | Any, _ | _, Any -> Any
  | Bottom, x | x, Bottom -> x
  | Set, Set -> Set
  | Rel, Rel -> Rel
  | Set, Rel | Rel, Set -> Any

let equal = ( = )

let builtin s =
  match s with
  | "id" | "po" | "rf" | "fr" | "co" -> Some Rel
  | "emptyset" -> Some Set
  | _ -> if Option.is_some (CatSet.of_primitive_set s) then Some Set else None

let konst_f = function
  | AST.Empty AST.SET | AST.Universe AST.SET -> Set
  | AST.Empty AST.RLN | AST.Universe AST.RLN -> Rel

let tag_f _ = Any
let compatible = List.fold_left join Bottom
let compatible_binary = function [ x; y ] -> compatible [ x; y ] | _ -> Any
let require_rel = join Rel
let require_set = join Set
let all_rel = List.fold_left join Rel

let op1_f (op : AST.op1) x =
  match op with
  | Inv | Plus | Star | Opt -> require_rel x
  | ToId -> if equal (require_set x) Any then Any else Rel
  | Comp -> x

let op2_f (op : AST.op2) xs =
  match op with
  | Union | Inter -> compatible xs
  | Diff -> compatible_binary xs
  | Seq -> if xs = [] then Any else all_rel xs
  | Cartesian -> (
      match require_set (compatible_binary xs) with Set -> Rel | _ -> Any)
  | Add | Tuple -> Any

let explicit_set_f = function [] -> Bottom | _ :: _ -> Any

let try_f x y = compatible [ x; y ]
let if_f x y = compatible [ x; y ]
