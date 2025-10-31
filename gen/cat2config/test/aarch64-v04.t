"Some lets are omitted here as they are identical to aarch64-v03.cat"
  $ mcat2config7 -set-libdir ./libdir -let intrinsic libdir/aarch64-v04.cat
  $ mcat2config7 -set-libdir ./libdir -let rmw libdir/aarch64-v04.cat
  LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr
  $ mcat2config7 -set-libdir ./libdir -let aob libdir/aarch64-v04.cat
  LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ]
  $ mcat2config7 -set-libdir ./libdir -let tob libdir/aarch64-v04.cat
  $ mcat2config7 -set-libdir ./libdir -let tlo libdir/aarch64-v04.cat
