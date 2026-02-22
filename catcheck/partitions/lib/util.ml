module StringSet = struct
  let pp fmt t =
    let open Format in
    if StringSet.is_empty t then fprintf fmt "{}"
    else fprintf fmt "{ %s }" (String.concat ", " (StringSet.to_list t))
end
