type test = AArch64Base.pseudo MiscParser.t
type proc = int

val prog : test -> (proc * AArch64Base.pseudo list) list
val prog_instructions : test -> (proc * AArch64Base.instruction list) list
val static_poi_of_label : Label.t -> test -> proc -> int

val prog_section :
  proc:int ->
  start_spoi:int ->
  end_spoi:int ->
  test ->
  AArch64Base.instruction list

val pp_prog_section : Format.formatter -> AArch64Base.instruction list -> unit

type instruction = AArch64Base.instruction

val parse_from_file : string -> test
val show_instruction : instruction -> string
