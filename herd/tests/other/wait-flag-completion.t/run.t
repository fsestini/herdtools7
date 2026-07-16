Check the opt-in lasso-completion path against the complete AArch64 model.

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff ./wait-flag.litmus
  Warning: File "./wait-flag.litmus": infinite execution unsupported: weighted relation operation `all_topos_kont_rel` (User error)
