"Some lets are omitted here as they are identical to aarch64-v06.cat"
  $ mcat2config7 -set-libdir ./libdir -let pob libdir/aarch64-v07.cat
  DpCtrlIsbCsels* DpCtrlIsbCseld* [DpAddrCsels*,ISB] [DpAddrCseld*,ISB] [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W]
  $ mcat2config7 -set-libdir ./libdir -let bob libdir/aarch64-v07.cat
  DMB.ISHs** DMB.ISHd** DMB.OSHs** DMB.OSHd** DMB.SYs** DMB.SYd** DSB.ISHs** DSB.ISHd** [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] PosWRLA PodWRLA DMB.ISHLDsR* DMB.ISHLDdR* DMB.OSHLDsR* DMB.OSHLDdR* DMB.LDsR* DMB.LDdR* DSB.LDsR* DSB.LDdR* PosR*AP PodR*AP PosR*QP PodR*QP DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW Pos*WPL Pod*WPL
  $ mcat2config7 -set-libdir ./libdir -let tob libdir/aarch64-v07.cat
  $ mcat2config7 -set-libdir ./libdir -let pick-tob libdir/aarch64-v07.cat
  Fatal Error: let statements that were asked for are not in cat file
  $ mcat2config7 -set-libdir ./libdir -let tlo libdir/aarch64-v07.cat
