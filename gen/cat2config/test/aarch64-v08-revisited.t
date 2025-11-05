  $ mcat2config7 -set-libdir ./libdir -let dsb.full libdir/aarch64-v08-revisited.cat
  Fatal Error: let statements that were asked for are not in cat file
  $ mcat2config7 -set-libdir ./libdir -let dsb.ld libdir/aarch64-v08-revisited.cat
  Fatal Error: let statements that were asked for are not in cat file
  $ mcat2config7 -set-libdir ./libdir -let dsb.st libdir/aarch64-v08-revisited.cat
  Fatal Error: let statements that were asked for are not in cat file
  $ mcat2config7 -set-libdir ./libdir -let dmb.full libdir/aarch64-v08-revisited.cat
  DMB.ISHs** DMB.ISHd** DMB.OSHs** DMB.OSHd** DMB.SYs** DMB.SYd** DSB.ISHs** DSB.ISHd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.ld libdir/aarch64-v08-revisited.cat
  DMB.ISHLDs** DMB.ISHLDd** DMB.OSHLDs** DMB.OSHLDd** DMB.LDs** DMB.LDd** DSB.LDs** DSB.LDd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.st libdir/aarch64-v08-revisited.cat
  DMB.ISHSTs** DMB.ISHSTd** DMB.OSHSTs** DMB.OSHSTd** DMB.STs** DMB.STd** DSB.STs** DSB.STd**
  $ mcat2config7 -set-libdir ./libdir -let ca libdir/aarch64-v08-revisited.cat
  Fatal Error: let statements that were asked for are not in cat file
  $ mcat2config7 -set-libdir ./libdir -let lrs libdir/aarch64-v08-revisited.cat
  Fatal Error: let statements that were asked for are not in cat file
  $ mcat2config7 -set-libdir ./libdir -let lws libdir/aarch64-v08-revisited.cat
  Pos*W
  $ mcat2config7 -set-libdir ./libdir -let obs libdir/aarch64-v08-revisited.cat
  Rfe Fre Coe
  $ mcat2config7 -set-libdir ./libdir -let rmw libdir/aarch64-v08-revisited.cat
  LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr
  $ mcat2config7 -set-libdir ./libdir -let dob libdir/aarch64-v08-revisited.cat
  DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW DpCtrlIsbs* DpCtrlIsbd* [DpAddrs*,ISB] [DpAddrd*,ISB] DpAddrsW DpAddrdW [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpDatas*,Rfi] [DpDatad*,Rfi]
  $ mcat2config7 -set-libdir ./libdir -let pob libdir/aarch64-v08-revisited.cat
  DpAddrCselsW DpAddrCseldW DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W]
  $ mcat2config7 -set-libdir ./libdir -let aob libdir/aarch64-v08-revisited.cat
  LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ]
  $ mcat2config7 -set-libdir ./libdir -let bob libdir/aarch64-v08-revisited.cat
  DMB.ISHs** DMB.ISHd** DMB.OSHs** DMB.OSHd** DMB.SYs** DMB.SYd** DSB.ISHs** DSB.ISHd** [Amo.SwpAP,Pos*W] [Amo.SwpAP,Pod*W] [Amo.CasAP,Pos*W] [Amo.CasAP,Pod*W] [Amo.LdAddAP,Pos*W] [Amo.LdAddAP,Pod*W] [Amo.LdEorAP,Pos*W] [Amo.LdEorAP,Pod*W] [Amo.LdSetAP,Pos*W] [Amo.LdSetAP,Pod*W] [Amo.LdClrAP,Pos*W] [Amo.LdClrAP,Pod*W] DMB.ISHLDsR* DMB.ISHLDdR* DMB.OSHLDsR* DMB.OSHLDdR* DMB.LDsR* DMB.LDdR* DSB.LDsR* DSB.LDdR* DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW PosWRLA PodWRLA PosR*AP PodR*AP PosR*QP PodR*QP Pos*WPL Pod*WPL
  $ mcat2config7 -set-libdir ./libdir -let lob libdir/aarch64-v08-revisited.cat
  DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW DpCtrlIsbs* DpCtrlIsbd* [DpAddrs*,ISB] [DpAddrd*,ISB] DpAddrsW DpAddrdW [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpDatas*,Rfi] [DpDatad*,Rfi] DpAddrCselsW DpAddrCseldW DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W] LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ] DMB.ISHs** DMB.ISHd** DMB.OSHs** DMB.OSHd** DMB.SYs** DMB.SYd** DSB.ISHs** DSB.ISHd** [Amo.SwpAP,Pos*W] [Amo.SwpAP,Pod*W] [Amo.CasAP,Pos*W] [Amo.CasAP,Pod*W] [Amo.LdAddAP,Pos*W] [Amo.LdAddAP,Pod*W] [Amo.LdEorAP,Pos*W] [Amo.LdEorAP,Pod*W] [Amo.LdSetAP,Pos*W] [Amo.LdSetAP,Pod*W] [Amo.LdClrAP,Pos*W] [Amo.LdClrAP,Pod*W] DMB.ISHLDsR* DMB.ISHLDdR* DMB.OSHLDsR* DMB.OSHLDdR* DMB.LDsR* DMB.LDdR* DSB.LDsR* DSB.LDdR* DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW PosWRLA PodWRLA PosR*AP PodR*AP PosR*QP PodR*QP Pos*WPL Pod*WPL
  $ mcat2config7 -set-libdir ./libdir -let pick-lob libdir/aarch64-v08-revisited.cat
  $ mcat2config7 -set-libdir ./libdir -let ob libdir/aarch64-v08-revisited.cat
  DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW DpCtrlIsbs* DpCtrlIsbd* [DpAddrs*,ISB] [DpAddrd*,ISB] DpAddrsW DpAddrdW [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpDatas*,Rfi] [DpDatad*,Rfi] DpAddrCselsW DpAddrCseldW DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W] LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ] DMB.ISHs** DMB.ISHd** DMB.OSHs** DMB.OSHd** DMB.SYs** DMB.SYd** DSB.ISHs** DSB.ISHd** [Amo.SwpAP,Pos*W] [Amo.SwpAP,Pod*W] [Amo.CasAP,Pos*W] [Amo.CasAP,Pod*W] [Amo.LdAddAP,Pos*W] [Amo.LdAddAP,Pod*W] [Amo.LdEorAP,Pos*W] [Amo.LdEorAP,Pod*W] [Amo.LdSetAP,Pos*W] [Amo.LdSetAP,Pod*W] [Amo.LdClrAP,Pos*W] [Amo.LdClrAP,Pod*W] DMB.ISHLDsR* DMB.ISHLDdR* DMB.OSHLDsR* DMB.OSHLDdR* DMB.LDsR* DMB.LDdR* DSB.LDsR* DSB.LDdR* DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW PosWRLA PodWRLA PosR*AP PodR*AP PosR*QP PodR*QP Pos*WPL Pod*WPL
