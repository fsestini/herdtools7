Check the opt-in lasso-completion path against the complete AArch64 model.

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff ./wait-flag.litmus | sed '/^Time/d;/^$/d'
  Warning: File "./wait-flag.litmus": unrolling limit exceeded at L0, legal outcomes may be missing.
  Test wait-flag Allowed
  States 1
  Loop Ok
  Witnesses
  Positive: 1 Negative: 3
  Condition exists (Diverges(P1))
  Observation wait-flag Sometimes 1 3
  Hash=aff2e9e86bbf69b319a40a82069056f4

Check that [Diverges] selects only the execution whose lasso belongs to P1.
The other three executions are finite, and the lasso does not belong to P0.

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff -conds ./diverges-p1.cond ./wait-flag.litmus 2>/dev/null | grep -E '^(Positive|Condition|Observation)'
  Positive: 1 Negative: 3
  Condition exists (Diverges(P1))
  Observation wait-flag Sometimes 1 3

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff -conds ./diverges-p0.cond ./wait-flag.litmus 2>/dev/null | grep -E '^(Positive|Condition|Observation)'
  Positive: 0 Negative: 4
  Condition exists (Diverges(P0))
  Observation wait-flag Never 0 4

Check that the final lasso graph annotates Cat [show] relations and a
relation added by [-doshow] with their exact weights.

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff -show all -doshow loc -o - ./wait-flag.litmus 2>/dev/null | awk '/digraph G \{/ {block=""} {block = block $0 "\n"} END {printf "%s", block}' | grep -E 'label="(rf \[1,\+inf\)|loc Z|ctrl \{0\}|ca \(-inf,-1\])"'
  eiid4 -> eiid3 [label="rf [1,+inf)", color="red", fontcolor="red"];
  eiid3 -> eiid3 [label="loc Z", color="brown", fontcolor="brown"];
  eiid1 -> eiid2 [label="ctrl {0}", color="indigo", fontcolor="indigo"];
  eiid1 -> eiid15 [label="ctrl {0}", color="indigo", fontcolor="indigo"];
  eiid3 -> eiid0 [label="ca (-inf,-1]", color="blue", fontcolor="blue"];
