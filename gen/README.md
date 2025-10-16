## Sets

empty set {}
IW: initial writes
W: set of all write events, including IW
R: set of all read events
F: set of all fence events
B: set of all branch events
_: universe of all events of a candidate relaxation

## Relations
po
rf
loc: relation between events accessing the same memory location
ext: relation between events on different processors
(*): cartesian product of two relations
r?: identity closure of r
r*: reflexive-transitive closure
r+: transitive closure
~r: complement
r^-1: inverse
