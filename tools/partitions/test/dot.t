  $ catpart -set-libdir ../libdir --mode dot cats/simple_cover.cat
  digraph partitions {
    rankdir=TB;
    graph [splines=true, overlap=false, pack=72, packmode="array_u1"];
    node [fontname="Helvetica"];
    edge [arrowsize=0.7];
  
    "intersection:A&B" [label="A & B", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:A&B&C" [label="A & B & C", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:A&C" [label="A & C", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:B&C" [label="B & C", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "partition:0" [label="A & B \\ C", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:1" [label="B \\ (C | A)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:2" [label="B & C \\ A", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:3" [label="C \\ (B | A)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:4" [label="A \\ (C | B)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:5" [label="A & C \\ B", shape="box", style="rounded,filled", fillcolor="white"];
    "set:A" [label="A", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:B" [label="B", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:C" [label="C", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "universe" [label="Universe", shape="box", style="rounded,filled", fillcolor="gray95"];
  
    "intersection:A&B" -> "intersection:A&B&C" [color="gray80"];
    "intersection:A&B" -> "partition:0" [color="gray80"];
    "intersection:A&C" -> "intersection:A&B&C" [color="gray80"];
    "intersection:A&C" -> "partition:5" [color="gray80"];
    "intersection:B&C" -> "intersection:A&B&C" [color="gray80"];
    "intersection:B&C" -> "partition:2" [color="gray80"];
    "set:A" -> "intersection:A&B" [color="gray80"];
    "set:A" -> "intersection:A&C" [color="gray80"];
    "set:A" -> "partition:4" [color="gray80"];
    "set:B" -> "intersection:A&B" [color="gray80"];
    "set:B" -> "intersection:B&C" [color="gray80"];
    "set:B" -> "partition:1" [color="gray80"];
    "set:C" -> "intersection:A&C" [color="gray80"];
    "set:C" -> "intersection:B&C" [color="gray80"];
    "set:C" -> "partition:3" [color="gray80"];
    "universe" -> "set:A" [color="gray80"];
    "universe" -> "set:B" [color="gray80"];
    "universe" -> "set:C" [color="gray80"];
  }

  $ catpart -set-libdir ../libdir --mode dot cats/subseteq.cat
  digraph partitions {
    rankdir=TB;
    graph [splines=true, overlap=false, pack=72, packmode="array_u1"];
    node [fontname="Helvetica"];
    edge [arrowsize=0.7];
  
    "intersection:A&D" [label="A & D", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:A&D&E" [label="A & D & E", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:A&E" [label="A & E", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:B&D" [label="B & D", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:B&D&E" [label="B & D & E", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:B&E" [label="B & E", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:C&D" [label="C & D", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:C&D&E" [label="C & D & E", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:C&E" [label="C & E", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:D&E" [label="D & E", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "partition:0" [label="A & D \\ E", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:1" [label="Universe \\ (C | D | E)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:10" [label="B & E \\ (D | A)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:11" [label="A & E \\ D", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:2" [label="B & D \\ (E | A)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:3" [label="C & D \\ (E | B)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:4" [label="D \\ (E | C)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:5" [label="D & E \\ C", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:6" [label="E \\ (D | C)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:7" [label="C & E \\ (D | B)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:8" [label="C & D & E \\ B", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:9" [label="B & D & E \\ A", shape="box", style="rounded,filled", fillcolor="white"];
    "set:A" [label="A", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:B" [label="B", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:C" [label="C", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:D" [label="D", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:E" [label="E", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "universe" [label="Universe", shape="box", style="rounded,filled", fillcolor="gray95"];
  
    "intersection:A&D" -> "intersection:A&D&E" [color="gray80"];
    "intersection:A&D" -> "partition:0" [color="gray80"];
    "intersection:A&E" -> "intersection:A&D&E" [color="gray80"];
    "intersection:A&E" -> "partition:11" [color="gray80"];
    "intersection:B&D" -> "intersection:A&D" [color="gray80"];
    "intersection:B&D" -> "intersection:B&D&E" [color="gray80"];
    "intersection:B&D" -> "partition:2" [color="gray80"];
    "intersection:B&D&E" -> "intersection:A&D&E" [color="gray80"];
    "intersection:B&D&E" -> "partition:9" [color="gray80"];
    "intersection:B&E" -> "intersection:A&E" [color="gray80"];
    "intersection:B&E" -> "intersection:B&D&E" [color="gray80"];
    "intersection:B&E" -> "partition:10" [color="gray80"];
    "intersection:C&D" -> "intersection:B&D" [color="gray80"];
    "intersection:C&D" -> "intersection:C&D&E" [color="gray80"];
    "intersection:C&D" -> "partition:3" [color="gray80"];
    "intersection:C&D&E" -> "intersection:B&D&E" [color="gray80"];
    "intersection:C&D&E" -> "partition:8" [color="gray80"];
    "intersection:C&E" -> "intersection:B&E" [color="gray80"];
    "intersection:C&E" -> "intersection:C&D&E" [color="gray80"];
    "intersection:C&E" -> "partition:7" [color="gray80"];
    "intersection:D&E" -> "intersection:C&D&E" [color="gray80"];
    "intersection:D&E" -> "partition:5" [color="gray80"];
    "set:A" -> "intersection:A&D" [color="gray80"];
    "set:A" -> "intersection:A&E" [color="gray80"];
    "set:B" -> "intersection:B&D" [color="gray80"];
    "set:B" -> "intersection:B&E" [color="gray80"];
    "set:B" -> "set:A";
    "set:C" -> "intersection:C&D" [color="gray80"];
    "set:C" -> "intersection:C&E" [color="gray80"];
    "set:C" -> "set:B";
    "set:D" -> "intersection:C&D" [color="gray80"];
    "set:D" -> "intersection:D&E" [color="gray80"];
    "set:D" -> "partition:4" [color="gray80"];
    "set:E" -> "intersection:C&E" [color="gray80"];
    "set:E" -> "intersection:D&E" [color="gray80"];
    "set:E" -> "partition:6" [color="gray80"];
    "universe" -> "partition:1" [color="gray80"];
    "universe" -> "set:C" [color="gray80"];
    "universe" -> "set:D" [color="gray80"];
    "universe" -> "set:E" [color="gray80"];
  }

  $ catpart -set-libdir ../libdir --mode dot cats/disjoint.cat
  digraph partitions {
    rankdir=TB;
    graph [splines=true, overlap=false, pack=72, packmode="array_u1"];
    node [fontname="Helvetica"];
    edge [arrowsize=0.7];
  
    "partition:2" [label="Universe \\ (A | B | C)", shape="box", style="rounded,filled", fillcolor="white"];
    "set:A" [label="A", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:B" [label="B", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "set:C" [label="C", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
    "universe" [label="Universe", shape="box", style="rounded,filled", fillcolor="gray95"];
  
    "universe" -> "partition:2" [color="gray80"];
    "universe" -> "set:A" [color="gray80"];
    "universe" -> "set:B" [color="gray80"];
    "universe" -> "set:C" [color="gray80"];
  }

  $ catpart -set-libdir ../libdir --mode dot --subtree A cats/simple_cover.cat
  digraph partitions {
    rankdir=TB;
    graph [splines=true, overlap=false, pack=72, packmode="array_u1"];
    node [fontname="Helvetica"];
    edge [arrowsize=0.7];
  
    "intersection:A&B" [label="A & B", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:A&B&C" [label="A & B & C", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:A&C" [label="A & C", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "partition:0" [label="A & B \\ C", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:4" [label="A \\ (C | B)", shape="box", style="rounded,filled", fillcolor="white"];
    "partition:5" [label="A & C \\ B", shape="box", style="rounded,filled", fillcolor="white"];
    "set:A" [label="A", shape="box", style="rounded,filled", fillcolor="lightsteelblue1"];
  
    "intersection:A&B" -> "intersection:A&B&C" [color="gray80"];
    "intersection:A&B" -> "partition:0" [color="gray80"];
    "intersection:A&C" -> "intersection:A&B&C" [color="gray80"];
    "intersection:A&C" -> "partition:5" [color="gray80"];
    "set:A" -> "intersection:A&B" [color="gray80"];
    "set:A" -> "intersection:A&C" [color="gray80"];
    "set:A" -> "partition:4" [color="gray80"];
  }

  $ catpart -set-libdir ../libdir --mode dot --subtree 'A & B' cats/simple_cover.cat
  digraph partitions {
    rankdir=TB;
    graph [splines=true, overlap=false, pack=72, packmode="array_u1"];
    node [fontname="Helvetica"];
    edge [arrowsize=0.7];
  
    "intersection:A&B" [label="A & B", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "intersection:A&B&C" [label="A & B & C", shape="box", style="rounded,filled", fillcolor="lightyellow"];
    "partition:0" [label="A & B \\ C", shape="box", style="rounded,filled", fillcolor="white"];
  
    "intersection:A&B" -> "intersection:A&B&C" [color="gray80"];
    "intersection:A&B" -> "partition:0" [color="gray80"];
  }

  $ catpart -set-libdir ../libdir --mode dot --subtree Missing cats/simple_cover.cat
  catpart: no DAG node with label "Missing"
  [1]

  $ catpart -set-libdir ../libdir --mode json --subtree A cats/simple_cover.cat
  --subtree is only valid in dot mode
  [1]
