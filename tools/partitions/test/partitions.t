  $ catpart -set-libdir ../libdir --mode json --partition-format string cats/simple_cover.cat
  {
    "A": [ "A & B & ~C", "A & ~B & ~C", "A & ~B & C", "A & B & C" ],
    "B": [ "A & B & ~C", "~A & B & ~C", "~A & B & C", "A & B & C" ],
    "C": [ "~A & B & C", "~A & ~B & C", "A & ~B & C", "A & B & C" ]
  }

  $ catpart -set-libdir ../libdir --mode json --partition-format int cats/simple_cover.cat
  { "A": [ 0, 4, 5, 6 ], "B": [ 0, 1, 2, 6 ], "C": [ 2, 3, 5, 6 ] }

  $ catpart -set-libdir ../libdir --mode json --partition-format string cats/simple_cover.cat | grep -q '"A & B & ~C"'

  $ catpart -set-libdir ../libdir --mode json --partition-format string cats/subseteq.cat
  {
    "A": [ "A & B & C & D & ~E", "A & B & C & ~D & E", "A & B & C & D & E" ],
    "B": [
      "A & B & C & D & ~E", "~A & B & C & D & ~E", "~A & B & C & D & E",
      "~A & B & C & ~D & E", "A & B & C & ~D & E", "A & B & C & D & E"
    ],
    "C": [
      "A & B & C & D & ~E", "~A & B & C & D & ~E", "~A & ~B & C & D & ~E",
      "~A & ~B & C & ~D & E", "~A & ~B & C & D & E", "~A & B & C & D & E",
      "~A & B & C & ~D & E", "A & B & C & ~D & E", "A & B & C & D & E"
    ],
    "D": [
      "A & B & C & D & ~E", "~A & B & C & D & ~E", "~A & ~B & C & D & ~E",
      "~A & ~B & ~C & D & ~E", "~A & ~B & ~C & D & E", "~A & ~B & C & D & E",
      "~A & B & C & D & E", "A & B & C & D & E"
    ],
    "E": [
      "~A & ~B & ~C & D & E", "~A & ~B & ~C & ~D & E", "~A & ~B & C & ~D & E",
      "~A & ~B & C & D & E", "~A & B & C & D & E", "~A & B & C & ~D & E",
      "A & B & C & ~D & E", "A & B & C & D & E"
    ]
  }

  $ catpart -set-libdir ../libdir --mode json --partition-format int cats/subseteq.cat
  {
    "A": [ 0, 11, 12 ],
    "B": [ 0, 2, 9, 10, 11, 12 ],
    "C": [ 0, 2, 3, 7, 8, 9, 10, 11, 12 ],
    "D": [ 0, 2, 3, 4, 5, 8, 9, 12 ],
    "E": [ 5, 6, 7, 8, 9, 10, 11, 12 ]
  }

  $ catpart -set-libdir ../libdir --mode json --partition-format string cats/disjoint.cat
  { "A": [ "A & ~B & ~C" ], "B": [ "~A & B & ~C" ], "C": [ "~A & ~B & C" ] }

  $ catpart -set-libdir ../libdir --mode json --partition-format int cats/disjoint.cat
  { "A": [ 0 ], "B": [ 1 ], "C": [ 3 ] }
