let prefix = "herdtools7.herd_core."

let create ?doc name = Logs.Src.create ?doc (prefix ^ name)
let set_level src l = Logs.Src.set_level src l
