type test = AArch64Base.pseudo MiscParser.t
type proc = int

let prog (t : test) : (proc * AArch64Base.pseudo list) list =
  t.prog |> List.map (fun ((proc, _, _), code) -> (proc, code))

let prog_instructions (t : test) : (proc * AArch64Base.instruction list) list =
  prog t
  |> List.map (fun (proc, code) ->
      let code =
        code
        |> List.filter_map (fun (ins : AArch64Base.pseudo) ->
            match ins with Instruction i -> Some i | _ -> None)
      in
      (proc, code))

let static_poi_of_label (lbl : Label.t) =
  let rec go poi l =
    let open AArch64Base in
    match l with
    | [] -> invalid_arg "Label not found"
    | Label (lbl', _) :: _ when Label.equal lbl lbl' -> poi
    | Label _ :: rest -> go (poi + 1) rest
    | Instruction _ :: rest -> go (poi + 1) rest
    | _ :: rest -> go poi rest
  in
  fun test proc ->
    let p = List.assoc proc (prog test) in
    go 0 p

module MakeArch (C : sig
  val is_morello : bool
end) =
struct
  module SP = Splitter.Make (struct
    let debug = false
    let check_rename = fun s -> Some s
  end)

  module AArch64Value = CapabilityValue.Make (C)
  module AArch64 = MakeAArch64Base.Make (C)

  module LexConfig = struct
    let debug = false
  end

  module AArch64LexParse = struct
    type instruction = AArch64.parsedPseudo
    type token = AArch64Parser.token

    module Lexer = AArch64Lexer.Make (struct
      include LexConfig

      let is_morello = C.is_morello
    end)

    let lexer = Lexer.token
    let parser = AArch64Parser.main
  end

  module P0 =
    GenParser.Make (GenParser.DefaultConfig) (AArch64) (AArch64LexParse)

  type instruction = AArch64Base.instruction

  let parse chan =
    let (splitted : Splitter.result) = SP.split "T" chan in
    P0.parse chan splitted

  let parse_from_file = Misc.input_protect (fun ch -> parse ch)

  let show_instruction (ins : AArch64Base.instruction) =
    AArch64.dump_instruction ins
end
