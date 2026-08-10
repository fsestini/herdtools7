Check the opt-in lasso-completion path against the complete AArch64 model.

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff,vmsa ./tlbi-completion.litmus | sed '/^Time/d;/^$/d' | sed '/^Hash/d;/^$/d'
  Warning: File "./tlbi-completion.litmus": unrolling limit exceeded at L0, legal outcomes may be missing.
  Test TLBI-completion Allowed
  States 1
  Loop Ok
  Witnesses
  Positive: 1 Negative: 3
  Flag Maintnenace-scope-for-DSB-ST-is-deprecated
  Condition exists (Diverges(P1))
  Observation TLBI-completion Sometimes 1 3
