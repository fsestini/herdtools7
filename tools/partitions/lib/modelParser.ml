let parse ~libdir file_path =
  let module ML = MyLib.Make (struct
    let includes = []
    let env = None
    let libdir = match libdir with Some libdir -> libdir | None -> "."
    let debug = false
  end) in
  let module Parser = ParseModel.Make (struct
    let debug = false
    let libfind = ML.find
  end) in
  let rec find_parse_deep (file_path : string) : AST.ins list =
    let _, (_, _, ast) = Parser.find_parse file_path in
    List.concat_map
      (function
        | AST.Include (_, fname) -> find_parse_deep fname
        | ins -> [ ins ])
      ast
  in
  find_parse_deep file_path
