let bitmap_of_partition : int -> bool StringMap.t = function
  | 0 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 1 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", true);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", true);
          ("W", true);
        ]
  | 2 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", true);
          ("W", true);
        ]
  | 3 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", true);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 4 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", true);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 5 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", true);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 6 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", true);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 7 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", true);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 8 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", true);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 9 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", true);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 10 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", true);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 11 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", true);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 12 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", true);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 13 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", true);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 14 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", true);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 15 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", true);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 16 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", true);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 17 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", true);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 18 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", true);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 19 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", true);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 20 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", true);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 21 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", true);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", true);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 22 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 23 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 24 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 25 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 26 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 27 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 28 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 29 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 30 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 31 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 32 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", true);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 33 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 34 ->
      StringMap.of_list
        [
          ("A", true);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 35 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 36 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", true);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 37 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 38 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 39 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 40 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 41 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 42 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 43 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 44 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 45 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 46 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 47 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 48 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", true);
          ("W", true);
        ]
  | 49 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", true);
          ("W", true);
        ]
  | 50 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", true);
          ("W", true);
        ]
  | 51 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 52 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 53 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 54 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 55 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", true);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 56 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", true);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 57 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", true);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 58 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", true);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", false);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", false);
        ]
  | 59 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 60 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 61 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 62 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 63 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 64 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", true);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 65 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", true);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 66 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", true);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 67 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 68 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 69 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 70 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 71 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 72 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 73 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 74 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 75 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 76 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", true);
          ("W", false);
        ]
  | 77 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", true);
          ("W", true);
        ]
  | 78 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 79 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 80 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 81 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 82 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", true);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 83 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", true);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 84 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", true);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 85 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 86 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", false);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", true);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 87 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", true);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 88 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", true);
          ("T", false);
          ("W", false);
        ]
  | 89 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 90 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", true);
          ("Imp", false);
          ("Instr", true);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 91 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", true);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 92 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", true);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 93 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", true);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 94 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", false);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | 95 ->
      StringMap.of_list
        [
          ("A", false);
          ("AF", false);
          ("DB", false);
          ("DMB.ISH", false);
          ("DMB.ISHLD", false);
          ("DMB.ISHST", false);
          ("DMB.LD", false);
          ("DMB.OSH", false);
          ("DMB.OSHLD", false);
          ("DMB.OSHST", false);
          ("DMB.ST", false);
          ("DMB.SY", false);
          ("DSB.ISH", false);
          ("DSB.ISHLD", false);
          ("DSB.ISHST", false);
          ("DSB.LD", false);
          ("DSB.OSH", false);
          ("DSB.OSHLD", false);
          ("DSB.OSHST", false);
          ("DSB.ST", false);
          ("DSB.SY", false);
          ("Exp", true);
          ("F", false);
          ("FAULT", false);
          ("ISB", false);
          ("IW", false);
          ("Imp", false);
          ("Instr", false);
          ("L", true);
          ("M", true);
          ("MMU", false);
          ("NoRet", false);
          ("PTE", false);
          ("Q", false);
          ("R", false);
          ("T", false);
          ("W", true);
        ]
  | _ -> invalid_arg "unknown partition"

let of_set_name : string -> IntSet.t = function
  | "A" -> IntSet.of_list [ 34 ]
  | "AF" ->
      IntSet.of_list
        [
          24;
          27;
          28;
          29;
          30;
          31;
          32;
          39;
          42;
          43;
          47;
          48;
          53;
          57;
          58;
          59;
          60;
          61;
          62;
          74;
          75;
          76;
          77;
          78;
          79;
          80;
          81;
          82;
        ]
  | "DB" ->
      IntSet.of_list
        [
          24;
          27;
          28;
          39;
          40;
          44;
          45;
          46;
          47;
          48;
          50;
          51;
          52;
          56;
          57;
          58;
          59;
          60;
          61;
          69;
          70;
          71;
          72;
          73;
          74;
          81;
          82;
          83;
        ]
  | "DMB.ISH" -> IntSet.of_list [ 7 ]
  | "DMB.ISHLD" -> IntSet.of_list [ 17 ]
  | "DMB.ISHST" -> IntSet.of_list [ 18 ]
  | "DMB.LD" -> IntSet.of_list [ 13 ]
  | "DMB.OSH" -> IntSet.of_list [ 15 ]
  | "DMB.OSHLD" -> IntSet.of_list [ 12 ]
  | "DMB.OSHST" -> IntSet.of_list [ 9 ]
  | "DMB.ST" -> IntSet.of_list [ 20 ]
  | "DMB.SY" -> IntSet.of_list [ 11 ]
  | "DSB.ISH" -> IntSet.of_list [ 16 ]
  | "DSB.ISHLD" -> IntSet.of_list [ 19 ]
  | "DSB.ISHST" -> IntSet.of_list [ 4 ]
  | "DSB.LD" -> IntSet.of_list [ 3 ]
  | "DSB.OSH" -> IntSet.of_list [ 14 ]
  | "DSB.OSHLD" -> IntSet.of_list [ 5 ]
  | "DSB.OSHST" -> IntSet.of_list [ 8 ]
  | "DSB.ST" -> IntSet.of_list [ 21 ]
  | "DSB.SY" -> IntSet.of_list [ 10 ]
  | "Exp" ->
      IntSet.of_list
        [
          0;
          1;
          2;
          22;
          23;
          34;
          35;
          36;
          37;
          64;
          65;
          66;
          67;
          87;
          88;
          89;
          90;
          91;
          92;
          93;
          94;
          95;
        ]
  | "F" ->
      IntSet.of_list
        [ 3; 4; 5; 6; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20; 21 ]
  | "FAULT" -> IntSet.of_list [ 32; 52; 53; 54; 55; 56; 57; 58 ]
  | "ISB" -> IntSet.of_list [ 6 ]
  | "IW" -> IntSet.of_list [ 1; 90; 91; 92 ]
  | "Imp" ->
      IntSet.of_list
        [
          3;
          4;
          5;
          6;
          7;
          8;
          9;
          10;
          11;
          12;
          13;
          14;
          15;
          16;
          17;
          18;
          19;
          20;
          21;
          24;
          25;
          26;
          27;
          28;
          29;
          30;
          31;
          32;
          33;
          38;
          39;
          40;
          41;
          42;
          43;
          44;
          45;
          46;
          47;
          48;
          49;
          50;
          51;
          52;
          53;
          54;
          55;
          56;
          57;
          58;
          59;
          60;
          61;
          62;
          63;
          68;
          69;
          70;
          71;
          72;
          73;
          74;
          75;
          76;
          77;
          78;
          79;
          80;
          81;
          82;
          83;
          84;
          85;
          86;
        ]
  | "Instr" ->
      IntSet.of_list
        [ 27; 28; 40; 41; 42; 43; 44; 45; 61; 62; 63; 64; 86; 87; 88; 89; 90 ]
  | "L" -> IntSet.of_list [ 95 ]
  | "M" ->
      IntSet.of_list
        [
          0;
          1;
          2;
          22;
          23;
          24;
          25;
          26;
          27;
          28;
          29;
          30;
          31;
          33;
          34;
          35;
          36;
          37;
          38;
          39;
          40;
          41;
          42;
          43;
          44;
          45;
          46;
          47;
          48;
          49;
          50;
          51;
          59;
          60;
          61;
          62;
          63;
          64;
          65;
          66;
          67;
          68;
          69;
          70;
          71;
          72;
          73;
          74;
          75;
          76;
          77;
          78;
          79;
          80;
          81;
          82;
          83;
          84;
          85;
          86;
          87;
          88;
          89;
          90;
          91;
          92;
          93;
          94;
          95;
        ]
  | "MMU" -> IntSet.of_list [ 32; 55; 56; 57 ]
  | "NoRet" ->
      IntSet.of_list
        [
          0;
          22;
          23;
          28;
          29;
          30;
          39;
          43;
          44;
          72;
          73;
          74;
          75;
          82;
          83;
          84;
          85;
          86;
          87;
        ]
  | "PTE" ->
      IntSet.of_list
        [ 22; 24; 25; 29; 31; 36; 37; 38; 46; 71; 80; 81; 82; 83; 84; 92; 93 ]
  | "Q" -> IntSet.of_list [ 36; 64; 65; 66 ]
  | "R" ->
      IntSet.of_list
        [
          0;
          22;
          23;
          28;
          29;
          30;
          33;
          34;
          35;
          36;
          37;
          38;
          39;
          43;
          44;
          45;
          59;
          60;
          61;
          62;
          63;
          64;
          65;
          66;
          67;
          68;
          69;
          70;
          71;
          72;
          73;
          74;
          75;
          76;
          79;
          80;
          81;
          82;
          83;
          84;
          85;
          86;
          87;
          88;
        ]
  | "T" ->
      IntSet.of_list
        [ 0; 1; 2; 48; 49; 50; 59; 66; 67; 68; 69; 73; 74; 75; 76; 77 ]
  | "W" ->
      IntSet.of_list
        [
          1;
          2;
          24;
          25;
          26;
          27;
          31;
          40;
          41;
          42;
          46;
          47;
          48;
          49;
          50;
          51;
          77;
          78;
          89;
          90;
          91;
          92;
          93;
          94;
          95;
        ]
  | "_" ->
      IntSet.of_list
        [
          0;
          1;
          2;
          3;
          4;
          5;
          6;
          7;
          8;
          9;
          10;
          11;
          12;
          13;
          14;
          15;
          16;
          17;
          18;
          19;
          20;
          21;
          22;
          23;
          24;
          25;
          26;
          27;
          28;
          29;
          30;
          31;
          32;
          33;
          34;
          35;
          36;
          37;
          38;
          39;
          40;
          41;
          42;
          43;
          44;
          45;
          46;
          47;
          48;
          49;
          50;
          51;
          52;
          53;
          54;
          55;
          56;
          57;
          58;
          59;
          60;
          61;
          62;
          63;
          64;
          65;
          66;
          67;
          68;
          69;
          70;
          71;
          72;
          73;
          74;
          75;
          76;
          77;
          78;
          79;
          80;
          81;
          82;
          83;
          84;
          85;
          86;
          87;
          88;
          89;
          90;
          91;
          92;
          93;
          94;
          95;
        ]
  | _ -> invalid_arg "unknown set identifier"

let subsets : string -> StringSet.t = function
  | "A" -> StringSet.of_list []
  | "AF" -> StringSet.of_list []
  | "DB" -> StringSet.of_list []
  | "DMB.ISH" -> StringSet.of_list []
  | "DMB.ISHLD" -> StringSet.of_list []
  | "DMB.ISHST" -> StringSet.of_list []
  | "DMB.LD" -> StringSet.of_list []
  | "DMB.OSH" -> StringSet.of_list []
  | "DMB.OSHLD" -> StringSet.of_list []
  | "DMB.OSHST" -> StringSet.of_list []
  | "DMB.ST" -> StringSet.of_list []
  | "DMB.SY" -> StringSet.of_list []
  | "DSB.ISH" -> StringSet.of_list []
  | "DSB.ISHLD" -> StringSet.of_list []
  | "DSB.ISHST" -> StringSet.of_list []
  | "DSB.LD" -> StringSet.of_list []
  | "DSB.OSH" -> StringSet.of_list []
  | "DSB.OSHLD" -> StringSet.of_list []
  | "DSB.OSHST" -> StringSet.of_list []
  | "DSB.ST" -> StringSet.of_list []
  | "DSB.SY" -> StringSet.of_list []
  | "Exp" -> StringSet.of_list [ "A"; "IW"; "L"; "Q" ]
  | "F" ->
      StringSet.of_list
        [
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "ISB";
        ]
  | "FAULT" -> StringSet.of_list [ "MMU" ]
  | "ISB" -> StringSet.of_list []
  | "IW" -> StringSet.of_list []
  | "Imp" ->
      StringSet.of_list
        [
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "MMU";
        ]
  | "Instr" -> StringSet.of_list []
  | "L" -> StringSet.of_list []
  | "M" ->
      StringSet.of_list
        [ "A"; "Exp"; "IW"; "Instr"; "L"; "NoRet"; "PTE"; "Q"; "R"; "T"; "W" ]
  | "MMU" -> StringSet.of_list []
  | "NoRet" -> StringSet.of_list []
  | "PTE" -> StringSet.of_list []
  | "Q" -> StringSet.of_list []
  | "R" -> StringSet.of_list [ "A"; "NoRet"; "Q" ]
  | "T" -> StringSet.of_list []
  | "W" -> StringSet.of_list [ "IW"; "L" ]
  | "_" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "F";
          "FAULT";
          "ISB";
          "IW";
          "Imp";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | _ -> invalid_arg "unknown set identifier"

let supersets : string -> StringSet.t = function
  | "A" -> StringSet.of_list [ "Exp"; "M"; "R"; "_" ]
  | "AF" -> StringSet.of_list [ "Imp"; "_" ]
  | "DB" -> StringSet.of_list [ "Imp"; "_" ]
  | "DMB.ISH" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.ISHLD" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.ISHST" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.LD" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.OSH" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.OSHLD" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.OSHST" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.ST" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DMB.SY" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.ISH" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.ISHLD" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.ISHST" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.LD" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.OSH" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.OSHLD" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.OSHST" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.ST" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "DSB.SY" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "Exp" -> StringSet.of_list [ "M"; "_" ]
  | "F" -> StringSet.of_list [ "Imp"; "_" ]
  | "FAULT" -> StringSet.of_list [ "Imp"; "_" ]
  | "ISB" -> StringSet.of_list [ "F"; "Imp"; "_" ]
  | "IW" -> StringSet.of_list [ "Exp"; "M"; "W"; "_" ]
  | "Imp" -> StringSet.of_list [ "_" ]
  | "Instr" -> StringSet.of_list [ "M"; "_" ]
  | "L" -> StringSet.of_list [ "Exp"; "M"; "W"; "_" ]
  | "M" -> StringSet.of_list [ "_" ]
  | "MMU" -> StringSet.of_list [ "FAULT"; "Imp"; "_" ]
  | "NoRet" -> StringSet.of_list [ "M"; "R"; "_" ]
  | "PTE" -> StringSet.of_list [ "M"; "_" ]
  | "Q" -> StringSet.of_list [ "Exp"; "M"; "R"; "_" ]
  | "R" -> StringSet.of_list [ "M"; "_" ]
  | "T" -> StringSet.of_list [ "M"; "_" ]
  | "W" -> StringSet.of_list [ "M"; "_" ]
  | "_" -> StringSet.of_list []
  | _ -> invalid_arg "unknown set identifier"

let disjoints : string -> StringSet.t = function
  | "A" ->
      StringSet.of_list
        [
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "IW";
          "Imp";
          "Instr";
          "L";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "T";
          "W";
        ]
  | "AF" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "F";
          "ISB";
          "IW";
          "L";
          "Q";
        ]
  | "DB" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "F";
          "ISB";
          "IW";
          "L";
          "Q";
        ]
  | "DMB.ISH" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.ISHLD" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.ISHST" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.LD" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.OSH" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.OSHLD" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.OSHST" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.ST" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DMB.SY" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.ISH" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.ISHLD" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.ISHST" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.LD" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.OSH" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.OSHLD" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.OSHST" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.ST" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "DSB.SY" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "Exp";
          "FAULT";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "Exp" ->
      StringSet.of_list
        [
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "Imp";
          "MMU";
        ]
  | "F" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "Exp";
          "FAULT";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "FAULT" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "F";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "ISB" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "FAULT";
          "IW";
          "Instr";
          "L";
          "M";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "IW" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "Imp";
          "L";
          "MMU";
          "NoRet";
          "Q";
          "R";
        ]
  | "Imp" -> StringSet.of_list [ "A"; "Exp"; "IW"; "L"; "Q" ]
  | "Instr" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "L";
          "MMU";
          "PTE";
          "T";
        ]
  | "L" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "IW";
          "Imp";
          "Instr";
          "MMU";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
        ]
  | "M" ->
      StringSet.of_list
        [
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "MMU";
        ]
  | "MMU" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "Exp";
          "F";
          "ISB";
          "IW";
          "Instr";
          "L";
          "M";
          "NoRet";
          "PTE";
          "Q";
          "R";
          "T";
          "W";
        ]
  | "NoRet" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "IW";
          "L";
          "MMU";
          "Q";
          "W";
        ]
  | "PTE" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "Instr";
          "L";
          "MMU";
          "T";
        ]
  | "Q" ->
      StringSet.of_list
        [
          "A";
          "AF";
          "DB";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "IW";
          "Imp";
          "L";
          "MMU";
          "NoRet";
          "W";
        ]
  | "R" ->
      StringSet.of_list
        [
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "IW";
          "L";
          "MMU";
          "W";
        ]
  | "T" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "Instr";
          "L";
          "MMU";
          "PTE";
        ]
  | "W" ->
      StringSet.of_list
        [
          "A";
          "DMB.ISH";
          "DMB.ISHLD";
          "DMB.ISHST";
          "DMB.LD";
          "DMB.OSH";
          "DMB.OSHLD";
          "DMB.OSHST";
          "DMB.ST";
          "DMB.SY";
          "DSB.ISH";
          "DSB.ISHLD";
          "DSB.ISHST";
          "DSB.LD";
          "DSB.OSH";
          "DSB.OSHLD";
          "DSB.OSHST";
          "DSB.ST";
          "DSB.SY";
          "F";
          "FAULT";
          "ISB";
          "MMU";
          "NoRet";
          "Q";
          "R";
        ]
  | "_" -> StringSet.of_list []
  | _ -> invalid_arg "unknown set identifier"

let set_names = [ "R"; "W"; "M"; "FAULT"; "MMU"; "F" ]
