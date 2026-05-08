  $ loop_detection -set-libdir ./libdir data/wait-flag.litmus
  Loop:
    LDR W1,[X0]
    CBZ W1,L0
  Iteration #0
    b: R[x]=S1
    i: R1:X0q=x
    j: W1:X1q=S2
    k: R1:X1q=S3
    l: Branching(bcc)
  Iteration #1
    c: R[x]=S5
    m: R1:X0q=x
    n: W1:X1q=S6
    o: R1:X1q=S7
    p: Branching(bcc)
  Iteration #2
    d: R[x]=S9
    q: R1:X0q=x
    r: W1:X1q=S10
    s: R1:X1q=S11
    t: Branching(bcc)
  Iteration #3
    u: CutOff:L0

  $ loop_detection -set-libdir ./libdir data/spinloop.litmus
  Loop:
    LDR W0,[X1]
    SUB W4,W0,#1
    CBNZ W4,L0
  Iteration #0
    b: R[x]=S1
    i: R1:X1q=x
    j: W1:X0q=S2
    k: R1:X0q=S3
    l: W1:X4q=S6
    m: R1:X4q=S6
    n: Branching(bcc)
  Iteration #1
    c: R[x]=S8
    o: R1:X1q=x
    p: W1:X0q=S9
    q: R1:X0q=S10
    r: W1:X4q=S13
    s: R1:X4q=S13
    t: Branching(bcc)
  Iteration #2
    d: R[x]=S15
    u: R1:X1q=x
    v: W1:X0q=S16
    w: R1:X0q=S17
    x: W1:X4q=S20
    y: R1:X4q=S20
    z: Branching(bcc)
  Iteration #3
    ev26: CutOff:L0
