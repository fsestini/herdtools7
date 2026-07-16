Check the opt-in lasso-completion path against the complete AArch64 model.

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff ./wait-flag.litmus | sed '/^Time/d;/^$/d'
  Warning: File "./wait-flag.litmus": unrolling limit exceeded at L0, legal outcomes may be missing.
  Test wait-flag Required
  States 1
  Loop Ok
  Witnesses
  Positive: 4 Negative: 0
  Condition forall (true)
  Observation wait-flag Always 4 0
  Hash=aff2e9e86bbf69b319a40a82069056f4

Check that the final lasso graph annotates Cat [show] relations and a
relation added by [-doshow] with their exact weights.

  $ herd7 -set-libdir ../libdir/aarch64/ArmARM-M.c -variant infinite,cutoff -show all -doshow loc -o - ./wait-flag.litmus 2>/dev/null | awk '/digraph G \{/ {block=""} {block = block $0 "\n"} END {printf "%s", block}' | grep -E 'label="(rf@\[1,\+inf\)|loc@Z|ctrl@\{0\}|ca@\(-inf,-1\])"'
  eiid4 -> eiid3 [label="rf@[1,+inf)", color="red", fontcolor="red"];
  eiid3 -> eiid3 [label="loc@Z", color="brown", fontcolor="brown"];
  eiid1 -> eiid2 [label="ctrl@{0}", color="indigo", fontcolor="indigo"];
  eiid1 -> eiid15 [label="ctrl@{0}", color="indigo", fontcolor="indigo"];
  eiid3 -> eiid0 [label="ca@(-inf,-1]", color="blue", fontcolor="blue"];
