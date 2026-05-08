type test = AArch64Base.pseudo MiscParser.t
type proc = int

val prog : test -> (proc * AArch64Base.pseudo list) list
val prog_instructions : test -> (proc * AArch64Base.instruction list) list
val static_poi_of_label : Label.t -> test -> proc -> int

module MakeArch (C : sig
  val is_morello : bool
end) : sig
  type instruction = AArch64Base.instruction

  val parse_from_file : string -> test
  val show_instruction : instruction -> string
end
