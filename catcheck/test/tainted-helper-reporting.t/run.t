Unknown set-valued helpers do not produce strengthening diagnostics, while
known endpoint refinements still do.

  $ catcheck toy.cat
  File "./toy.cat", line 2, characters 18-25:
  let known-left = [Exp & M]; rf
                    ^^^^^^^
    this expression may be strenghthened to `Exp & W`
  File "./toy.cat", line 3, characters 23-30:
  let known-right = rf; [Exp & M]
                         ^^^^^^^
    this expression may be strenghthened to `Exp & R`
