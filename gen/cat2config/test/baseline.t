  $ mcat2config7 -help
  Usage: mcat2config7 [options]* cats*
    -v  be verbose
    -let <statement> print out selected let statements
    -conds <cond> choose what variant conditions to set
    -unroll <unroll> choose how many times transitive and reflexive and transitive operators unroll. Default = 1
    -tree <true|false> print out expanded cat file
    -set-libdir <path> set location of libdir to <path>
    -show <tree|tree-only|lets> show info on parsed model
    -help  Display this list of options
    --help  Display this list of options
  $ mcat2config7 -set-libdir ./libdir -let bob libdir/aarch64.cat
  DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL
  $ mcat2config7 -set-libdir ./libdir -let dob libdir/aarch64.cat
  DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW [DpCtrls*,DC.CVAUp] [DpCtrld*,DC.CVAUp] [DpCtrls*,IC.IVAUp] [DpCtrld*,IC.IVAUp] [DpAddrs*,Pos*W] [DpAddrs*,Pod*W] [DpAddrd*,Pos*W] [DpAddrd*,Pod*W] [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpAddrs*,RfiPT] [DpAddrd*,RfiPT] [DpDatas*,Rfi] [DpDatad*,Rfi] [DpDatas*,RfiPT] [DpDatad*,RfiPT]
  $ mcat2config7 -set-libdir ./libdir -let ob libdir/aarch64.cat
  PosRRIP PodRRIP DpCtrlIsbs* DpCtrlIsbd* DpCtrlIsbCsels* DpCtrlIsbCseld* [DpAddrs*,ISB] [DpAddrd*,ISB] [DpAddrCsels*,ISB] [DpAddrCseld*,ISB] DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW [DpCtrls*,DC.CVAUp] [DpCtrld*,DC.CVAUp] [DpCtrls*,IC.IVAUp] [DpCtrld*,IC.IVAUp] [DpAddrs*,Pos*W] [DpAddrs*,Pod*W] [DpAddrd*,Pos*W] [DpAddrd*,Pod*W] [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpAddrs*,RfiPT] [DpAddrd*,RfiPT] [DpDatas*,Rfi] [DpDatad*,Rfi] [DpDatas*,RfiPT] [DpDatad*,RfiPT] DpAddrCselsW DpAddrCseldW [DpAddrCsels*,DC.CVAUp] [DpAddrCseld*,DC.CVAUp] [DpAddrCsels*,IC.IVAUp] [DpAddrCseld*,IC.IVAUp] DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpCtrlCsels*,DC.CVAUp] [DpCtrlCseld*,DC.CVAUp] [DpCtrlCsels*,IC.IVAUp] [DpCtrlCseld*,IC.IVAUp] [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W] LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ] DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL [PosRRIP,DSB.ISH] [PodRRIP,DSB.ISH] [PosRRIP,DSB.ISH,ISB] [PodRRIP,DSB.ISH,ISB] [PosRRIP,DSB.ISH,DC.CVAUp] [PodRRIP,DSB.ISH,DC.CVAUp] [PosRRIP,DSB.ISH,IC.IVAUp] [PodRRIP,DSB.ISH,IC.IVAUp] RfePI FreIP
Option -show tree
  $ mcat2config7 -set-libdir ./libdir -show tree libdir/aarch64.cat
  (va-loc)
     [NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];same-low-order-bits;[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];loc
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];same-low-order-bits;[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];loc
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT];same-low-order-bits;[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];loc
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT];same-low-order-bits;[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];loc
  
  (tr-ib)
     [NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT]
  
  (tc-ib)
  
  (tc-before)
     [NExp&T&R];iico_data;B;iico_ctrl;[Exp&M]
    |[NExp&T&R];iico_data;B;iico_ctrl;[TagCheck&FAULT]
  
  (scl)
     loc
  
  (sca-class)
     [M&Exp];sm;[M&Exp]
  
  (same-loc)
     M;loc;M
    |[MMU&Translation&FAULT];same-low-order-bits
    |same-low-order-bits;[MMU&Translation&FAULT]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];TTD-same-oa;[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];same-low-order-bits
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];TTD-same-oa;[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT];same-low-order-bits
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];TTD-same-oa;[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];same-low-order-bits
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];TTD-same-oa;[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT];same-low-order-bits
  
  (rf-mem)
     rf
  
  (pob)
     pick-addr-dep;[Exp&W]
    |pick-addr-dep;[NExp&PTE&W]
    |pick-addr-dep;TLBI
    |pick-addr-dep;DC.CVAU
    |pick-addr-dep;IC.IALLUIS
    |pick-addr-dep;IC.IALLU
    |pick-addr-dep;IC.IVAU
    |pick-data-dep
    |pick-ctrl-dep;[Exp&W]
    |pick-ctrl-dep;[NExp&PTE&W]
    |pick-ctrl-dep;TLBI
    |pick-ctrl-dep;DC.CVAU
    |pick-ctrl-dep;IC.IALLUIS
    |pick-ctrl-dep;IC.IALLU
    |pick-ctrl-dep;IC.IVAU
    |pick-addr-dep;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&M];po;[NExp&PTE&W]
  
  (po-va-loc)
     po;[NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc]
    |po;[NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc]
    |po;[NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc]
    |po;[NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc]
  
  (po-scl-ob)
  
  (pick-lob)
  
  (pick-dtrm)
     lrs
    |iico_data
    |iico_ctrl
  
  (pick-dep)
  
  (obs)
     [Exp&M];[rf&ext];[Exp&M]
    |[Exp&M];[ca&ext];[Exp&M]
    |[Exp&W];[rf&ext];[NExp&T&R]
    |[NExp&T&R];[ca&ext];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[ca&ext];[Exp&W]
    |[NExp&PTE];rf
    |rf;[NExp&PTE]
    |[NExp&PTE&W];ca;W
    |W;ca;[NExp&PTE&W]
    |TLBI;TLBI-after;[NExp&PTE&R];ca;W
    |rf;[NExp&Instr&R]
    |IC-after
    |DC.CVAU;DC-after;W
    |W;DC-after;DC.CVAU
    |IC.IALLUIS;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IALLU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IVAU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
  
  (ob)
     [NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT]
    |[NExp&Instr&R];iico_data;B;iico_ctrl
    |[NExp&Instr&R];iico_data;B;iico_ctrl;iico_data
    |[NExp&Instr&R];po;[Exp&R]
    |[Exp&R];ctrl;ISB;po
    |[Exp&R];ctrl;EXC-ENTRY-IFB;po
    |[Exp&R];ctrl;EXC-RET-IFB;po
    |[Exp&R];pick-ctrl-dep;ISB;po
    |[Exp&R];pick-ctrl-dep;EXC-ENTRY-IFB;po
    |[Exp&R];pick-ctrl-dep;EXC-RET-IFB;po
    |[Exp&R];addr;[Exp&M];po;ISB;po
    |[Exp&R];addr;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];addr;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;ISB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&M];[po&M&loc&M];[Exp&W]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&M&loc&M];[Exp&W]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&M&loc&M];[MMU&FAULT]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W]
    |[NExp&PTE&R];[po&M&loc&M];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[Exp&M];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |addr
    |data
    |ctrl;[Exp&W]
    |ctrl;[NExp&PTE&W]
    |ctrl;TLBI
    |ctrl;DC.CVAU
    |ctrl;IC.IALLUIS
    |ctrl;IC.IALLU
    |ctrl;IC.IVAU
    |addr;[Exp&M];po;[Exp&W]
    |addr;[Exp&M];po;[NExp&PTE&W]
    |addr;[Exp&M];lrs;[Exp&R]
    |addr;[Exp&M];lrs;[NExp&T&R]
    |data;[Exp&M];lrs;[Exp&R]
    |data;[Exp&M];lrs;[NExp&T&R]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&W]
    |pick-addr-dep;[NExp&PTE&W]
    |pick-addr-dep;TLBI
    |pick-addr-dep;DC.CVAU
    |pick-addr-dep;IC.IALLUIS
    |pick-addr-dep;IC.IALLU
    |pick-addr-dep;IC.IVAU
    |pick-data-dep
    |pick-ctrl-dep;[Exp&W]
    |pick-ctrl-dep;[NExp&PTE&W]
    |pick-ctrl-dep;TLBI
    |pick-ctrl-dep;DC.CVAU
    |pick-ctrl-dep;IC.IALLUIS
    |pick-ctrl-dep;IC.IALLU
    |pick-ctrl-dep;IC.IVAU
    |pick-addr-dep;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&M];po;[NExp&PTE&W]
    |[Exp&M];rmw;[Exp&M]
    |[Exp&M];rmw;lrs;A
    |[Exp&M];rmw;lrs;Q
    |[NExp&PTE&R];rmw;[NExp&PTE&W]
    |[Exp&M];po;DMB.ISH;po;[Exp&M]
    |[Exp&M];po;DMB.ISH;po;[NExp&T&R]
    |[Exp&M];po;DMB.ISH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.OSH;po;[Exp&M]
    |[Exp&M];po;DMB.OSH;po;[NExp&T&R]
    |[Exp&M];po;DMB.OSH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.SY;po;[Exp&M]
    |[Exp&M];po;DMB.SY;po;[NExp&T&R]
    |[Exp&M];po;DMB.SY;po;[MMU&FAULT]
    |[Exp&M];po;dsb.full;po;[Exp&M]
    |[Exp&M];po;dsb.full;po;[NExp&T&R]
    |[Exp&M];po;dsb.full;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISH;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSH;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.SY;po;[Exp&M]
    |[NExp&T&R];po;DMB.SY;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.SY;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.full;po;[Exp&M]
    |[NExp&T&R];po;dsb.full;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.full;po;[MMU&FAULT]
    |[Exp&M];po;DMB.ISH;po;DC.CVAU
    |[Exp&M];po;DMB.OSH;po;DC.CVAU
    |[Exp&M];po;DMB.SY;po;DC.CVAU
    |[Exp&M];po;dsb.full;po;DC.CVAU
    |DC.CVAU;po;DMB.ISH;po;[Exp&M]
    |DC.CVAU;po;DMB.OSH;po;[Exp&M]
    |DC.CVAU;po;DMB.SY;po;[Exp&M]
    |DC.CVAU;po;dsb.full;po;[Exp&M]
    |DC.CVAU;po;DMB.ISH;po;DC.CVAU
    |DC.CVAU;po;DMB.OSH;po;DC.CVAU
    |DC.CVAU;po;DMB.SY;po;DC.CVAU
    |DC.CVAU;po;dsb.full;po;DC.CVAU
    |[Exp&R];po;DMB.ISHLD;po;[Exp&M]
    |[Exp&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.OSHLD;po;[Exp&M]
    |[Exp&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.LD;po;[Exp&M]
    |[Exp&R];po;DMB.LD;po;[NExp&T&R]
    |[Exp&R];po;DMB.LD;po;[MMU&FAULT]
    |[Exp&R];po;dsb.ld;po;[Exp&M]
    |[Exp&R];po;dsb.ld;po;[NExp&T&R]
    |[Exp&R];po;dsb.ld;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.LD;po;[Exp&M]
    |[NExp&T&R];po;DMB.LD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.LD;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.ld;po;[Exp&M]
    |[NExp&T&R];po;dsb.ld;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.ld;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ISHST;po;[Exp&W]
    |[Exp&W];po;DMB.ISHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.OSHST;po;[Exp&W]
    |[Exp&W];po;DMB.OSHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ST;po;[Exp&W]
    |[Exp&W];po;DMB.ST;po;[MMU&FAULT]
    |[Exp&W];po;dsb.st;po;[Exp&W]
    |[Exp&W];po;dsb.st;po;[MMU&FAULT]
    |A;amo;L;po;[Exp&M]
    |A;amo;L;po;[NExp&T&R]
    |A;amo;L;po;[MMU&FAULT]
    |L;po;A
    |A;po;[Exp&M]
    |A;po;[NExp&T&R]
    |A;po;[MMU&FAULT]
    |Q;po;[Exp&M]
    |Q;po;[NExp&T&R]
    |Q;po;[MMU&FAULT]
    |A;iico_order;[Exp&M]
    |A;iico_order;[NExp&T&R]
    |A;iico_order;[MMU&FAULT]
    |Q;iico_order;[Exp&M]
    |Q;iico_order;[NExp&T&R]
    |Q;iico_order;[MMU&FAULT]
    |[Exp&M];po;L
    |[NExp&T&R];po;L
    |[Exp&M];iico_order;L
    |[NExp&T&R];iico_order;L
    |[Exp&R];[po&M&loc&M];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |TLBI-after;TLBI;po;dsb.full;po;[Exp&M]
    |TLBI-after;TLBI;po;dsb.full;po;ISB
    |TLBI-after;TLBI;po;dsb.full;po;DC.CVAU
    |TLBI-after;TLBI;po;dsb.full;po;IC.IVAU
    |TLBI-after;TLBI;po;dsb.full;po;ISB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-ENTRY-IFB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-RET-IFB;po;[NExp&M]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;IC.IVAU
    |[Exp&M];[rf&ext];[Exp&M]
    |[Exp&M];[ca&ext];[Exp&M]
    |[Exp&W];[rf&ext];[NExp&T&R]
    |[NExp&T&R];[ca&ext];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[ca&ext];[Exp&W]
    |[NExp&PTE];rf
    |rf;[NExp&PTE]
    |[NExp&PTE&W];ca;W
    |W;ca;[NExp&PTE&W]
    |TLBI;TLBI-after;[NExp&PTE&R];ca;W
    |rf;[NExp&Instr&R]
    |IC-after
    |DC.CVAU;DC-after;W
    |W;DC-after;DC.CVAU
    |IC.IALLUIS;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IALLU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IVAU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
  
  (lwfs)
     [Exp&M];[po&M&loc&M];[Exp&W]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&M&loc&M];[Exp&W]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&M&loc&M];[MMU&FAULT]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W]
    |[NExp&PTE&R];[po&M&loc&M];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
  
  (local-hw-reqs)
     [NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT]
    |[NExp&Instr&R];iico_data;B;iico_ctrl
    |[NExp&Instr&R];iico_data;B;iico_ctrl;iico_data
    |[NExp&Instr&R];po;[Exp&R]
    |[Exp&R];ctrl;ISB;po
    |[Exp&R];ctrl;EXC-ENTRY-IFB;po
    |[Exp&R];ctrl;EXC-RET-IFB;po
    |[Exp&R];pick-ctrl-dep;ISB;po
    |[Exp&R];pick-ctrl-dep;EXC-ENTRY-IFB;po
    |[Exp&R];pick-ctrl-dep;EXC-RET-IFB;po
    |[Exp&R];addr;[Exp&M];po;ISB;po
    |[Exp&R];addr;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];addr;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;ISB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&M];[po&M&loc&M];[Exp&W]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&M&loc&M];[Exp&W]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&M&loc&M];[MMU&FAULT]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W]
    |[NExp&PTE&R];[po&M&loc&M];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[Exp&M];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |addr
    |data
    |ctrl;[Exp&W]
    |ctrl;[NExp&PTE&W]
    |ctrl;TLBI
    |ctrl;DC.CVAU
    |ctrl;IC.IALLUIS
    |ctrl;IC.IALLU
    |ctrl;IC.IVAU
    |addr;[Exp&M];po;[Exp&W]
    |addr;[Exp&M];po;[NExp&PTE&W]
    |addr;[Exp&M];lrs;[Exp&R]
    |addr;[Exp&M];lrs;[NExp&T&R]
    |data;[Exp&M];lrs;[Exp&R]
    |data;[Exp&M];lrs;[NExp&T&R]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&W]
    |pick-addr-dep;[NExp&PTE&W]
    |pick-addr-dep;TLBI
    |pick-addr-dep;DC.CVAU
    |pick-addr-dep;IC.IALLUIS
    |pick-addr-dep;IC.IALLU
    |pick-addr-dep;IC.IVAU
    |pick-data-dep
    |pick-ctrl-dep;[Exp&W]
    |pick-ctrl-dep;[NExp&PTE&W]
    |pick-ctrl-dep;TLBI
    |pick-ctrl-dep;DC.CVAU
    |pick-ctrl-dep;IC.IALLUIS
    |pick-ctrl-dep;IC.IALLU
    |pick-ctrl-dep;IC.IVAU
    |pick-addr-dep;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&M];po;[NExp&PTE&W]
    |[Exp&M];rmw;[Exp&M]
    |[Exp&M];rmw;lrs;A
    |[Exp&M];rmw;lrs;Q
    |[NExp&PTE&R];rmw;[NExp&PTE&W]
    |[Exp&M];po;DMB.ISH;po;[Exp&M]
    |[Exp&M];po;DMB.ISH;po;[NExp&T&R]
    |[Exp&M];po;DMB.ISH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.OSH;po;[Exp&M]
    |[Exp&M];po;DMB.OSH;po;[NExp&T&R]
    |[Exp&M];po;DMB.OSH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.SY;po;[Exp&M]
    |[Exp&M];po;DMB.SY;po;[NExp&T&R]
    |[Exp&M];po;DMB.SY;po;[MMU&FAULT]
    |[Exp&M];po;dsb.full;po;[Exp&M]
    |[Exp&M];po;dsb.full;po;[NExp&T&R]
    |[Exp&M];po;dsb.full;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISH;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSH;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.SY;po;[Exp&M]
    |[NExp&T&R];po;DMB.SY;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.SY;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.full;po;[Exp&M]
    |[NExp&T&R];po;dsb.full;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.full;po;[MMU&FAULT]
    |[Exp&M];po;DMB.ISH;po;DC.CVAU
    |[Exp&M];po;DMB.OSH;po;DC.CVAU
    |[Exp&M];po;DMB.SY;po;DC.CVAU
    |[Exp&M];po;dsb.full;po;DC.CVAU
    |DC.CVAU;po;DMB.ISH;po;[Exp&M]
    |DC.CVAU;po;DMB.OSH;po;[Exp&M]
    |DC.CVAU;po;DMB.SY;po;[Exp&M]
    |DC.CVAU;po;dsb.full;po;[Exp&M]
    |DC.CVAU;po;DMB.ISH;po;DC.CVAU
    |DC.CVAU;po;DMB.OSH;po;DC.CVAU
    |DC.CVAU;po;DMB.SY;po;DC.CVAU
    |DC.CVAU;po;dsb.full;po;DC.CVAU
    |[Exp&R];po;DMB.ISHLD;po;[Exp&M]
    |[Exp&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.OSHLD;po;[Exp&M]
    |[Exp&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.LD;po;[Exp&M]
    |[Exp&R];po;DMB.LD;po;[NExp&T&R]
    |[Exp&R];po;DMB.LD;po;[MMU&FAULT]
    |[Exp&R];po;dsb.ld;po;[Exp&M]
    |[Exp&R];po;dsb.ld;po;[NExp&T&R]
    |[Exp&R];po;dsb.ld;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.LD;po;[Exp&M]
    |[NExp&T&R];po;DMB.LD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.LD;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.ld;po;[Exp&M]
    |[NExp&T&R];po;dsb.ld;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.ld;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ISHST;po;[Exp&W]
    |[Exp&W];po;DMB.ISHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.OSHST;po;[Exp&W]
    |[Exp&W];po;DMB.OSHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ST;po;[Exp&W]
    |[Exp&W];po;DMB.ST;po;[MMU&FAULT]
    |[Exp&W];po;dsb.st;po;[Exp&W]
    |[Exp&W];po;dsb.st;po;[MMU&FAULT]
    |A;amo;L;po;[Exp&M]
    |A;amo;L;po;[NExp&T&R]
    |A;amo;L;po;[MMU&FAULT]
    |L;po;A
    |A;po;[Exp&M]
    |A;po;[NExp&T&R]
    |A;po;[MMU&FAULT]
    |Q;po;[Exp&M]
    |Q;po;[NExp&T&R]
    |Q;po;[MMU&FAULT]
    |A;iico_order;[Exp&M]
    |A;iico_order;[NExp&T&R]
    |A;iico_order;[MMU&FAULT]
    |Q;iico_order;[Exp&M]
    |Q;iico_order;[NExp&T&R]
    |Q;iico_order;[MMU&FAULT]
    |[Exp&M];po;L
    |[NExp&T&R];po;L
    |[Exp&M];iico_order;L
    |[NExp&T&R];iico_order;L
  
  (lob)
     [NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT]
    |[NExp&Instr&R];iico_data;B;iico_ctrl
    |[NExp&Instr&R];iico_data;B;iico_ctrl;iico_data
    |[NExp&Instr&R];po;[Exp&R]
    |[Exp&R];ctrl;ISB;po
    |[Exp&R];ctrl;EXC-ENTRY-IFB;po
    |[Exp&R];ctrl;EXC-RET-IFB;po
    |[Exp&R];pick-ctrl-dep;ISB;po
    |[Exp&R];pick-ctrl-dep;EXC-ENTRY-IFB;po
    |[Exp&R];pick-ctrl-dep;EXC-RET-IFB;po
    |[Exp&R];addr;[Exp&M];po;ISB;po
    |[Exp&R];addr;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];addr;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;ISB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&M];[po&M&loc&M];[Exp&W]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&M&loc&M];[Exp&W]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&M&loc&M];[MMU&FAULT]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W]
    |[NExp&PTE&R];[po&M&loc&M];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[Exp&M];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |addr
    |data
    |ctrl;[Exp&W]
    |ctrl;[NExp&PTE&W]
    |ctrl;TLBI
    |ctrl;DC.CVAU
    |ctrl;IC.IALLUIS
    |ctrl;IC.IALLU
    |ctrl;IC.IVAU
    |addr;[Exp&M];po;[Exp&W]
    |addr;[Exp&M];po;[NExp&PTE&W]
    |addr;[Exp&M];lrs;[Exp&R]
    |addr;[Exp&M];lrs;[NExp&T&R]
    |data;[Exp&M];lrs;[Exp&R]
    |data;[Exp&M];lrs;[NExp&T&R]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&W]
    |pick-addr-dep;[NExp&PTE&W]
    |pick-addr-dep;TLBI
    |pick-addr-dep;DC.CVAU
    |pick-addr-dep;IC.IALLUIS
    |pick-addr-dep;IC.IALLU
    |pick-addr-dep;IC.IVAU
    |pick-data-dep
    |pick-ctrl-dep;[Exp&W]
    |pick-ctrl-dep;[NExp&PTE&W]
    |pick-ctrl-dep;TLBI
    |pick-ctrl-dep;DC.CVAU
    |pick-ctrl-dep;IC.IALLUIS
    |pick-ctrl-dep;IC.IALLU
    |pick-ctrl-dep;IC.IVAU
    |pick-addr-dep;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&M];po;[NExp&PTE&W]
    |[Exp&M];rmw;[Exp&M]
    |[Exp&M];rmw;lrs;A
    |[Exp&M];rmw;lrs;Q
    |[NExp&PTE&R];rmw;[NExp&PTE&W]
    |[Exp&M];po;DMB.ISH;po;[Exp&M]
    |[Exp&M];po;DMB.ISH;po;[NExp&T&R]
    |[Exp&M];po;DMB.ISH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.OSH;po;[Exp&M]
    |[Exp&M];po;DMB.OSH;po;[NExp&T&R]
    |[Exp&M];po;DMB.OSH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.SY;po;[Exp&M]
    |[Exp&M];po;DMB.SY;po;[NExp&T&R]
    |[Exp&M];po;DMB.SY;po;[MMU&FAULT]
    |[Exp&M];po;dsb.full;po;[Exp&M]
    |[Exp&M];po;dsb.full;po;[NExp&T&R]
    |[Exp&M];po;dsb.full;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISH;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSH;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.SY;po;[Exp&M]
    |[NExp&T&R];po;DMB.SY;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.SY;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.full;po;[Exp&M]
    |[NExp&T&R];po;dsb.full;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.full;po;[MMU&FAULT]
    |[Exp&M];po;DMB.ISH;po;DC.CVAU
    |[Exp&M];po;DMB.OSH;po;DC.CVAU
    |[Exp&M];po;DMB.SY;po;DC.CVAU
    |[Exp&M];po;dsb.full;po;DC.CVAU
    |DC.CVAU;po;DMB.ISH;po;[Exp&M]
    |DC.CVAU;po;DMB.OSH;po;[Exp&M]
    |DC.CVAU;po;DMB.SY;po;[Exp&M]
    |DC.CVAU;po;dsb.full;po;[Exp&M]
    |DC.CVAU;po;DMB.ISH;po;DC.CVAU
    |DC.CVAU;po;DMB.OSH;po;DC.CVAU
    |DC.CVAU;po;DMB.SY;po;DC.CVAU
    |DC.CVAU;po;dsb.full;po;DC.CVAU
    |[Exp&R];po;DMB.ISHLD;po;[Exp&M]
    |[Exp&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.OSHLD;po;[Exp&M]
    |[Exp&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.LD;po;[Exp&M]
    |[Exp&R];po;DMB.LD;po;[NExp&T&R]
    |[Exp&R];po;DMB.LD;po;[MMU&FAULT]
    |[Exp&R];po;dsb.ld;po;[Exp&M]
    |[Exp&R];po;dsb.ld;po;[NExp&T&R]
    |[Exp&R];po;dsb.ld;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.LD;po;[Exp&M]
    |[NExp&T&R];po;DMB.LD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.LD;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.ld;po;[Exp&M]
    |[NExp&T&R];po;dsb.ld;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.ld;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ISHST;po;[Exp&W]
    |[Exp&W];po;DMB.ISHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.OSHST;po;[Exp&W]
    |[Exp&W];po;DMB.OSHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ST;po;[Exp&W]
    |[Exp&W];po;DMB.ST;po;[MMU&FAULT]
    |[Exp&W];po;dsb.st;po;[Exp&W]
    |[Exp&W];po;dsb.st;po;[MMU&FAULT]
    |A;amo;L;po;[Exp&M]
    |A;amo;L;po;[NExp&T&R]
    |A;amo;L;po;[MMU&FAULT]
    |L;po;A
    |A;po;[Exp&M]
    |A;po;[NExp&T&R]
    |A;po;[MMU&FAULT]
    |Q;po;[Exp&M]
    |Q;po;[NExp&T&R]
    |Q;po;[MMU&FAULT]
    |A;iico_order;[Exp&M]
    |A;iico_order;[NExp&T&R]
    |A;iico_order;[MMU&FAULT]
    |Q;iico_order;[Exp&M]
    |Q;iico_order;[NExp&T&R]
    |Q;iico_order;[MMU&FAULT]
    |[Exp&M];po;L
    |[NExp&T&R];po;L
    |[Exp&M];iico_order;L
    |[NExp&T&R];iico_order;L
  
  (inv-scope)
     inv-domain
  
  (inv-domain)
  
  (intervening)
  
  (hw-reqs)
     [NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[MMU&FAULT]
    |[NExp&Instr&R];iico_data;B;iico_ctrl
    |[NExp&Instr&R];iico_data;B;iico_ctrl;iico_data
    |[NExp&Instr&R];po;[Exp&R]
    |[Exp&R];ctrl;ISB;po
    |[Exp&R];ctrl;EXC-ENTRY-IFB;po
    |[Exp&R];ctrl;EXC-RET-IFB;po
    |[Exp&R];pick-ctrl-dep;ISB;po
    |[Exp&R];pick-ctrl-dep;EXC-ENTRY-IFB;po
    |[Exp&R];pick-ctrl-dep;EXC-RET-IFB;po
    |[Exp&R];addr;[Exp&M];po;ISB;po
    |[Exp&R];addr;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];addr;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;ISB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&M];[po&M&loc&M];[Exp&W]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&M&loc&M];[Exp&W]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[Exp&M];[po&M&loc&M];[MMU&FAULT]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[MMU&FAULT]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[MMU&FAULT]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W]
    |[NExp&PTE&R];[po&M&loc&M];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[NExp&PTE&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[NExp&PTE&W]
    |[Exp&M];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[Exp&M];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&T&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&M&loc&M];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |[NExp&PTE&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&W];sm;[M&Exp]
    |addr
    |data
    |ctrl;[Exp&W]
    |ctrl;[NExp&PTE&W]
    |ctrl;TLBI
    |ctrl;DC.CVAU
    |ctrl;IC.IALLUIS
    |ctrl;IC.IALLU
    |ctrl;IC.IVAU
    |addr;[Exp&M];po;[Exp&W]
    |addr;[Exp&M];po;[NExp&PTE&W]
    |addr;[Exp&M];lrs;[Exp&R]
    |addr;[Exp&M];lrs;[NExp&T&R]
    |data;[Exp&M];lrs;[Exp&R]
    |data;[Exp&M];lrs;[NExp&T&R]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&W]
    |pick-addr-dep;[NExp&PTE&W]
    |pick-addr-dep;TLBI
    |pick-addr-dep;DC.CVAU
    |pick-addr-dep;IC.IALLUIS
    |pick-addr-dep;IC.IALLU
    |pick-addr-dep;IC.IVAU
    |pick-data-dep
    |pick-ctrl-dep;[Exp&W]
    |pick-ctrl-dep;[NExp&PTE&W]
    |pick-ctrl-dep;TLBI
    |pick-ctrl-dep;DC.CVAU
    |pick-ctrl-dep;IC.IALLUIS
    |pick-ctrl-dep;IC.IALLU
    |pick-ctrl-dep;IC.IVAU
    |pick-addr-dep;[Exp&M];po;[Exp&W]
    |pick-addr-dep;[Exp&M];po;[NExp&PTE&W]
    |[Exp&M];rmw;[Exp&M]
    |[Exp&M];rmw;lrs;A
    |[Exp&M];rmw;lrs;Q
    |[NExp&PTE&R];rmw;[NExp&PTE&W]
    |[Exp&M];po;DMB.ISH;po;[Exp&M]
    |[Exp&M];po;DMB.ISH;po;[NExp&T&R]
    |[Exp&M];po;DMB.ISH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.OSH;po;[Exp&M]
    |[Exp&M];po;DMB.OSH;po;[NExp&T&R]
    |[Exp&M];po;DMB.OSH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.SY;po;[Exp&M]
    |[Exp&M];po;DMB.SY;po;[NExp&T&R]
    |[Exp&M];po;DMB.SY;po;[MMU&FAULT]
    |[Exp&M];po;dsb.full;po;[Exp&M]
    |[Exp&M];po;dsb.full;po;[NExp&T&R]
    |[Exp&M];po;dsb.full;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISH;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSH;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.SY;po;[Exp&M]
    |[NExp&T&R];po;DMB.SY;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.SY;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.full;po;[Exp&M]
    |[NExp&T&R];po;dsb.full;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.full;po;[MMU&FAULT]
    |[Exp&M];po;DMB.ISH;po;DC.CVAU
    |[Exp&M];po;DMB.OSH;po;DC.CVAU
    |[Exp&M];po;DMB.SY;po;DC.CVAU
    |[Exp&M];po;dsb.full;po;DC.CVAU
    |DC.CVAU;po;DMB.ISH;po;[Exp&M]
    |DC.CVAU;po;DMB.OSH;po;[Exp&M]
    |DC.CVAU;po;DMB.SY;po;[Exp&M]
    |DC.CVAU;po;dsb.full;po;[Exp&M]
    |DC.CVAU;po;DMB.ISH;po;DC.CVAU
    |DC.CVAU;po;DMB.OSH;po;DC.CVAU
    |DC.CVAU;po;DMB.SY;po;DC.CVAU
    |DC.CVAU;po;dsb.full;po;DC.CVAU
    |[Exp&R];po;DMB.ISHLD;po;[Exp&M]
    |[Exp&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.OSHLD;po;[Exp&M]
    |[Exp&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.LD;po;[Exp&M]
    |[Exp&R];po;DMB.LD;po;[NExp&T&R]
    |[Exp&R];po;DMB.LD;po;[MMU&FAULT]
    |[Exp&R];po;dsb.ld;po;[Exp&M]
    |[Exp&R];po;dsb.ld;po;[NExp&T&R]
    |[Exp&R];po;dsb.ld;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.LD;po;[Exp&M]
    |[NExp&T&R];po;DMB.LD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.LD;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.ld;po;[Exp&M]
    |[NExp&T&R];po;dsb.ld;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.ld;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ISHST;po;[Exp&W]
    |[Exp&W];po;DMB.ISHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.OSHST;po;[Exp&W]
    |[Exp&W];po;DMB.OSHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ST;po;[Exp&W]
    |[Exp&W];po;DMB.ST;po;[MMU&FAULT]
    |[Exp&W];po;dsb.st;po;[Exp&W]
    |[Exp&W];po;dsb.st;po;[MMU&FAULT]
    |A;amo;L;po;[Exp&M]
    |A;amo;L;po;[NExp&T&R]
    |A;amo;L;po;[MMU&FAULT]
    |L;po;A
    |A;po;[Exp&M]
    |A;po;[NExp&T&R]
    |A;po;[MMU&FAULT]
    |Q;po;[Exp&M]
    |Q;po;[NExp&T&R]
    |Q;po;[MMU&FAULT]
    |A;iico_order;[Exp&M]
    |A;iico_order;[NExp&T&R]
    |A;iico_order;[MMU&FAULT]
    |Q;iico_order;[Exp&M]
    |Q;iico_order;[NExp&T&R]
    |Q;iico_order;[MMU&FAULT]
    |[Exp&M];po;L
    |[NExp&T&R];po;L
    |[Exp&M];iico_order;L
    |[NExp&T&R];iico_order;L
    |[Exp&R];[po&M&loc&M];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |TLBI-after;TLBI;po;dsb.full;po;[Exp&M]
    |TLBI-after;TLBI;po;dsb.full;po;ISB
    |TLBI-after;TLBI;po;dsb.full;po;DC.CVAU
    |TLBI-after;TLBI;po;dsb.full;po;IC.IVAU
    |TLBI-after;TLBI;po;dsb.full;po;ISB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-ENTRY-IFB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-RET-IFB;po;[NExp&M]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;IC.IVAU
  
  (haz-ob)
     [Exp&R];[po&M&loc&M];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |TLBI-after;TLBI;po;dsb.full;po;[Exp&M]
    |TLBI-after;TLBI;po;dsb.full;po;ISB
    |TLBI-after;TLBI;po;dsb.full;po;DC.CVAU
    |TLBI-after;TLBI;po;dsb.full;po;IC.IVAU
    |TLBI-after;TLBI;po;dsb.full;po;ISB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-ENTRY-IFB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-RET-IFB;po;[NExp&M]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;IC.IVAU
  
  (f-ob)
     [NExp&Instr&R];po;[Exp&R]
  
  (f-ib)
     [NExp&Instr&R];iico_data;B;iico_ctrl
    |[NExp&Instr&R];iico_data;B;iico_ctrl;iico_data
  
  (ets-ob)
  
  (enumerate-ordered-pairs)
  
  (dtrm)
     lrs
    |iico_data
  
  (dob)
     addr
    |data
    |ctrl;[Exp&W]
    |ctrl;[NExp&PTE&W]
    |ctrl;TLBI
    |ctrl;DC.CVAU
    |ctrl;IC.IALLUIS
    |ctrl;IC.IALLU
    |ctrl;IC.IVAU
    |addr;[Exp&M];po;[Exp&W]
    |addr;[Exp&M];po;[NExp&PTE&W]
    |addr;[Exp&M];lrs;[Exp&R]
    |addr;[Exp&M];lrs;[NExp&T&R]
    |data;[Exp&M];lrs;[Exp&R]
    |data;[Exp&M];lrs;[NExp&T&R]
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;[Exp&W]
  
  (dmb.sy)
     dmb.fullsy
    |dmb.ish
  
  (dmb.st)
     DMB.ISHST
    |DMB.OSHST
    |DMB.ST
    |dsb.st
  
  (dmb.ld)
     DMB.ISHLD
    |DMB.OSHLD
    |DMB.LD
    |dsb.ld
  
  (dmb.full)
     DMB.ISH
    |DMB.OSH
    |DMB.SY
    |dsb.full
  
  (co0)
  
  (bob)
     [Exp&M];po;DMB.ISH;po;[Exp&M]
    |[Exp&M];po;DMB.ISH;po;[NExp&T&R]
    |[Exp&M];po;DMB.ISH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.OSH;po;[Exp&M]
    |[Exp&M];po;DMB.OSH;po;[NExp&T&R]
    |[Exp&M];po;DMB.OSH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.SY;po;[Exp&M]
    |[Exp&M];po;DMB.SY;po;[NExp&T&R]
    |[Exp&M];po;DMB.SY;po;[MMU&FAULT]
    |[Exp&M];po;dsb.full;po;[Exp&M]
    |[Exp&M];po;dsb.full;po;[NExp&T&R]
    |[Exp&M];po;dsb.full;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISH;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSH;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.SY;po;[Exp&M]
    |[NExp&T&R];po;DMB.SY;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.SY;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.full;po;[Exp&M]
    |[NExp&T&R];po;dsb.full;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.full;po;[MMU&FAULT]
    |[Exp&M];po;DMB.ISH;po;DC.CVAU
    |[Exp&M];po;DMB.OSH;po;DC.CVAU
    |[Exp&M];po;DMB.SY;po;DC.CVAU
    |[Exp&M];po;dsb.full;po;DC.CVAU
    |DC.CVAU;po;DMB.ISH;po;[Exp&M]
    |DC.CVAU;po;DMB.OSH;po;[Exp&M]
    |DC.CVAU;po;DMB.SY;po;[Exp&M]
    |DC.CVAU;po;dsb.full;po;[Exp&M]
    |DC.CVAU;po;DMB.ISH;po;DC.CVAU
    |DC.CVAU;po;DMB.OSH;po;DC.CVAU
    |DC.CVAU;po;DMB.SY;po;DC.CVAU
    |DC.CVAU;po;dsb.full;po;DC.CVAU
    |[Exp&R];po;DMB.ISHLD;po;[Exp&M]
    |[Exp&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.OSHLD;po;[Exp&M]
    |[Exp&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.LD;po;[Exp&M]
    |[Exp&R];po;DMB.LD;po;[NExp&T&R]
    |[Exp&R];po;DMB.LD;po;[MMU&FAULT]
    |[Exp&R];po;dsb.ld;po;[Exp&M]
    |[Exp&R];po;dsb.ld;po;[NExp&T&R]
    |[Exp&R];po;dsb.ld;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.LD;po;[Exp&M]
    |[NExp&T&R];po;DMB.LD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.LD;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.ld;po;[Exp&M]
    |[NExp&T&R];po;dsb.ld;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.ld;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ISHST;po;[Exp&W]
    |[Exp&W];po;DMB.ISHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.OSHST;po;[Exp&W]
    |[Exp&W];po;DMB.OSHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ST;po;[Exp&W]
    |[Exp&W];po;DMB.ST;po;[MMU&FAULT]
    |[Exp&W];po;dsb.st;po;[Exp&W]
    |[Exp&W];po;dsb.st;po;[MMU&FAULT]
    |A;amo;L;po;[Exp&M]
    |A;amo;L;po;[NExp&T&R]
    |A;amo;L;po;[MMU&FAULT]
    |L;po;A
    |A;po;[Exp&M]
    |A;po;[NExp&T&R]
    |A;po;[MMU&FAULT]
    |Q;po;[Exp&M]
    |Q;po;[NExp&T&R]
    |Q;po;[MMU&FAULT]
    |A;iico_order;[Exp&M]
    |A;iico_order;[NExp&T&R]
    |A;iico_order;[MMU&FAULT]
    |Q;iico_order;[Exp&M]
    |Q;iico_order;[NExp&T&R]
    |Q;iico_order;[MMU&FAULT]
    |[Exp&M];po;L
    |[NExp&T&R];po;L
    |[Exp&M];iico_order;L
    |[NExp&T&R];iico_order;L
  
  (basic-dep)
  
  (aob)
     [Exp&M];rmw;[Exp&M]
    |[Exp&M];rmw;lrs;A
    |[Exp&M];rmw;lrs;Q
    |[NExp&PTE&R];rmw;[NExp&PTE&W]
  
  (all-TLBI-Imp_TTD_R-enums)
  
  (all-IC-Imp_Instr_R-enums)
  
  (all-DC-Exp_W-enums)
  
  (add_pair)
  
  (add_both_choices)
  
  (Within-CMODX-List)
  
  (Translation)
  
  (Tag-obs)
     [Exp&W];[rf&ext];[NExp&T&R]
    |[NExp&T&R];[ca&ext];[Exp&W]
  
  (Tag)
     T
  
  (TTDV)
     PTEV
  
  (TTDINV)
     PTEINV
  
  (TTD-update-needsBBM)
  
  (TTD-same-oa)
  
  (TTD-read-ordered-before)
     TLBI-after;TLBI;po;dsb.full;po;[Exp&M]
    |TLBI-after;TLBI;po;dsb.full;po;ISB
    |TLBI-after;TLBI;po;dsb.full;po;DC.CVAU
    |TLBI-after;TLBI;po;dsb.full;po;IC.IVAU
    |TLBI-after;TLBI;po;dsb.full;po;ISB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-ENTRY-IFB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-RET-IFB;po;[NExp&M]
  
  (TTD-obs)
     [NExp&PTE];rf
    |rf;[NExp&PTE]
    |[NExp&PTE&W];ca;W
    |W;ca;[NExp&PTE&W]
    |TLBI;TLBI-after;[NExp&PTE&R];ca;W
  
  (TTD)
     PTE
  
  (TLBuncacheable-pred)
  
  (TLBUncacheable)
     MMU;Translation
    |MMU;AccessFlag
  
  (TLBI-ob)
     TLBI-after;TLBI;po;dsb.full;po;[Exp&M]
    |TLBI-after;TLBI;po;dsb.full;po;ISB
    |TLBI-after;TLBI;po;dsb.full;po;DC.CVAU
    |TLBI-after;TLBI;po;dsb.full;po;IC.IVAU
    |TLBI-after;TLBI;po;dsb.full;po;ISB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-ENTRY-IFB;po;[NExp&M]
    |TLBI-after;TLBI;po;dsb.full;po;EXC-RET-IFB;po;[NExp&M]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[Exp&M];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[MMU&FAULT];iico_ctrl;B;iico_data;[NExp&PTE&R];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&Exp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&DC.CVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&IC.IVAU&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&ISB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-ENTRY-IFB&po&NExp&M&ext]
    |[po&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&loc];[TLBI-after&TLBI&po&dsb.full&po&EXC-RET-IFB&po&NExp&M&ext]
  
  (TLBI-ca)
     TLBI;TLBI-after;[NExp&PTE&R];ca;W
  
  (TLBI-Imp_TTD_R-pairs)
  
  (Shareability)
     NSH
    |ISH
    |OSH
  
  (SPONTANEOUS)
     SPURIOUS
  
  (PTEV)
  
  (PTEINV)
  
  (PTE-update-needsBBM)
  
  (PTE-SH-update)
     NSH;ca;ISH
    |NSH;ca;OSH
    |ISH;ca;OSH
    |ISH;ca;NSH
    |OSH;ca;NSH
    |OSH;ca;ISH
  
  (PTE-OCH-update)
     oNC;ca;oWT
    |oNC;ca;oWB
    |oWT;ca;oWB
    |oWT;ca;oNC
    |oWB;ca;oNC
    |oWB;ca;oWT
  
  (PTE-OA-update-writable)
     PTE;ca;PTE;ca;PTE
  
  (PTE-OA-update)
     PTE;ca;PTE
  
  (PTE-MT-update)
     Normal;ca;Device-GRE
    |Normal;ca;Device-nGRE
    |Normal;ca;Device-nGnRE
    |Normal;ca;Device-nGnRnE
    |Device-GRE;ca;Normal
    |Device-nGRE;ca;Normal
    |Device-nGnRE;ca;Normal
    |Device-nGnRnE;ca;Normal
  
  (PTE-ICH-update)
     iNC;ca;iWT
    |iNC;ca;iWB
    |iWT;ca;iWB
    |iWT;ca;iNC
    |iWB;ca;iNC
    |iWB;ca;iWT
  
  (PTE-DT-update)
     Device-GRE;ca;Device-nGRE
    |Device-GRE;ca;Device-nGnRE
    |Device-GRE;ca;Device-nGnRnE
    |Device-nGRE;ca;Device-GRE
    |Device-nGRE;ca;Device-nGnRE
    |Device-nGRE;ca;Device-nGnRnE
    |Device-nGnRE;ca;Device-GRE
    |Device-nGnRE;ca;Device-nGRE
    |Device-nGnRE;ca;Device-nGnRnE
    |Device-nGnRnE;ca;Device-GRE
    |Device-nGnRnE;ca;Device-nGRE
    |Device-nGnRnE;ca;Device-nGnRE
  
  (PTE)
  
  (OuterCacheability)
     oWB
    |oWT
    |oNC
  
  (MMU)
  
  (Instr-read-ordered-before)
     IC-after;IC.IALLUIS;po;dsb.full;po;[Exp&M]
    |IC-after;IC.IALLUIS;po;dsb.full;po;ISB
    |IC-after;IC.IALLUIS;po;dsb.full;po;DC.CVAU
    |IC-after;IC.IALLUIS;po;dsb.full;po;IC.IVAU
    |IC-after;IC.IALLU;po;dsb.full;po;[Exp&M]
    |IC-after;IC.IALLU;po;dsb.full;po;ISB
    |IC-after;IC.IALLU;po;dsb.full;po;DC.CVAU
    |IC-after;IC.IALLU;po;dsb.full;po;IC.IVAU
    |IC-after;IC.IVAU;po;dsb.full;po;[Exp&M]
    |IC-after;IC.IVAU;po;dsb.full;po;ISB
    |IC-after;IC.IVAU;po;dsb.full;po;DC.CVAU
    |IC-after;IC.IVAU;po;dsb.full;po;IC.IVAU
  
  (Instr-obs)
     rf;[NExp&Instr&R]
    |IC-after
    |DC.CVAU;DC-after;W
    |W;DC-after;DC.CVAU
    |IC.IALLUIS;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IALLU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IVAU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
  
  (Instr)
  
  (InnerCacheability)
     iWB
    |iWT
    |iNC
  
  (Imp)
     NExp
  
  (IFB-ob)
     [Exp&R];ctrl;ISB;po
    |[Exp&R];ctrl;EXC-ENTRY-IFB;po
    |[Exp&R];ctrl;EXC-RET-IFB;po
    |[Exp&R];pick-ctrl-dep;ISB;po
    |[Exp&R];pick-ctrl-dep;EXC-ENTRY-IFB;po
    |[Exp&R];pick-ctrl-dep;EXC-RET-IFB;po
    |[Exp&R];addr;[Exp&M];po;ISB;po
    |[Exp&R];addr;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];addr;[Exp&M];po;EXC-RET-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;ISB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-ENTRY-IFB;po
    |[Exp&R];pick-addr-dep;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&PTE&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;ISB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-ENTRY-IFB;po
    |[NExp&T&R];iico_data;B;iico_ctrl;[Exp&M];po;EXC-RET-IFB;po
  
  (IFB)
     ISB
    |EXC-ENTRY-IFB
    |EXC-RET-IFB
  
  (IC-ob)
     [NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLUIS;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IALLU;po;dsb.full;po;IC.IVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;[Exp&M]
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;ISB
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;DC.CVAU
    |[NExp&Instr&R];po;[NExp&Instr&R];IC-after;IC.IVAU;po;dsb.full;po;IC.IVAU
  
  (IC-ca)
     IC.IALLUIS;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IALLU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
    |IC.IVAU;IC-after;[NExp&Instr&R];ca;W;DC-after;DC.CVAU
  
  (IC)
     IC.IALLUIS
    |IC.IALLU
    |IC.IVAU
  
  (HU-pred)
  
  (HU)
     NExp;[PTE&W]
  
  (Exp-obs)
     [Exp&M];[rf&ext];[Exp&M]
    |[Exp&M];[ca&ext];[Exp&M]
  
  (Exp-haz-ob)
     [Exp&R];[po&M&loc&M];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&Translation&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&same-low-order-bits&MMU&Translation&FAULT];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&Exp&M&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&Exp&M&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
    |[Exp&R];[po&MMU&FAULT&iico_ctrl&B&iico_data&NExp&PTE&R&TTD-same-oa&NExp&PTE&R&iico_data&B&iico_ctrl&MMU&FAULT&same-low-order-bits];[Exp&R];[ca&ext];[Exp&W]
  
  (EXC-RET-IFB)
     EXC-RET
  
  (EXC-ENTRY-IFB)
     EXC-ENTRY
  
  (Device)
     Device-GRE
    |Device-nGRE
    |Device-nGnRE
    |Device-nGnRnE
  
  (DSB-ob)
  
  (DB)
  
  (C_TLBI)
     TLBI;po;dsb.full
  
  (C_IC)
     IC.IALLUIS;po;dsb.full
    |IC.IALLU;po;dsb.full
    |IC.IVAU;po;dsb.full
  
  (CMODX-unordered-conflicts)
  
  (CMODX-ordering)
  
  (CMODX-conflicts)
  
  (BBM)
     PTEV;ca;PTEINV;co;PTEV
  
  (AccessFlag)
  
  (AFtoDB)
  
  (AF)
  
  
  
  




Option -show tree in conjunction with -let should only show the specified relation
  $ mcat2config7 -set-libdir ./libdir -let bob -show tree libdir/aarch64.cat
  (bob)
     [Exp&M];po;DMB.ISH;po;[Exp&M]
    |[Exp&M];po;DMB.ISH;po;[NExp&T&R]
    |[Exp&M];po;DMB.ISH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.OSH;po;[Exp&M]
    |[Exp&M];po;DMB.OSH;po;[NExp&T&R]
    |[Exp&M];po;DMB.OSH;po;[MMU&FAULT]
    |[Exp&M];po;DMB.SY;po;[Exp&M]
    |[Exp&M];po;DMB.SY;po;[NExp&T&R]
    |[Exp&M];po;DMB.SY;po;[MMU&FAULT]
    |[Exp&M];po;dsb.full;po;[Exp&M]
    |[Exp&M];po;dsb.full;po;[NExp&T&R]
    |[Exp&M];po;dsb.full;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISH;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSH;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSH;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSH;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.SY;po;[Exp&M]
    |[NExp&T&R];po;DMB.SY;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.SY;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.full;po;[Exp&M]
    |[NExp&T&R];po;dsb.full;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.full;po;[MMU&FAULT]
    |[Exp&M];po;DMB.ISH;po;DC.CVAU
    |[Exp&M];po;DMB.OSH;po;DC.CVAU
    |[Exp&M];po;DMB.SY;po;DC.CVAU
    |[Exp&M];po;dsb.full;po;DC.CVAU
    |DC.CVAU;po;DMB.ISH;po;[Exp&M]
    |DC.CVAU;po;DMB.OSH;po;[Exp&M]
    |DC.CVAU;po;DMB.SY;po;[Exp&M]
    |DC.CVAU;po;dsb.full;po;[Exp&M]
    |DC.CVAU;po;DMB.ISH;po;DC.CVAU
    |DC.CVAU;po;DMB.OSH;po;DC.CVAU
    |DC.CVAU;po;DMB.SY;po;DC.CVAU
    |DC.CVAU;po;dsb.full;po;DC.CVAU
    |[Exp&R];po;DMB.ISHLD;po;[Exp&M]
    |[Exp&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.OSHLD;po;[Exp&M]
    |[Exp&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[Exp&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[Exp&R];po;DMB.LD;po;[Exp&M]
    |[Exp&R];po;DMB.LD;po;[NExp&T&R]
    |[Exp&R];po;DMB.LD;po;[MMU&FAULT]
    |[Exp&R];po;dsb.ld;po;[Exp&M]
    |[Exp&R];po;dsb.ld;po;[NExp&T&R]
    |[Exp&R];po;dsb.ld;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.ISHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.ISHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.ISHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.OSHLD;po;[Exp&M]
    |[NExp&T&R];po;DMB.OSHLD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.OSHLD;po;[MMU&FAULT]
    |[NExp&T&R];po;DMB.LD;po;[Exp&M]
    |[NExp&T&R];po;DMB.LD;po;[NExp&T&R]
    |[NExp&T&R];po;DMB.LD;po;[MMU&FAULT]
    |[NExp&T&R];po;dsb.ld;po;[Exp&M]
    |[NExp&T&R];po;dsb.ld;po;[NExp&T&R]
    |[NExp&T&R];po;dsb.ld;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ISHST;po;[Exp&W]
    |[Exp&W];po;DMB.ISHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.OSHST;po;[Exp&W]
    |[Exp&W];po;DMB.OSHST;po;[MMU&FAULT]
    |[Exp&W];po;DMB.ST;po;[Exp&W]
    |[Exp&W];po;DMB.ST;po;[MMU&FAULT]
    |[Exp&W];po;dsb.st;po;[Exp&W]
    |[Exp&W];po;dsb.st;po;[MMU&FAULT]
    |A;amo;L;po;[Exp&M]
    |A;amo;L;po;[NExp&T&R]
    |A;amo;L;po;[MMU&FAULT]
    |L;po;A
    |A;po;[Exp&M]
    |A;po;[NExp&T&R]
    |A;po;[MMU&FAULT]
    |Q;po;[Exp&M]
    |Q;po;[NExp&T&R]
    |Q;po;[MMU&FAULT]
    |A;iico_order;[Exp&M]
    |A;iico_order;[NExp&T&R]
    |A;iico_order;[MMU&FAULT]
    |Q;iico_order;[Exp&M]
    |Q;iico_order;[NExp&T&R]
    |Q;iico_order;[MMU&FAULT]
    |[Exp&M];po;L
    |[NExp&T&R];po;L
    |[Exp&M];iico_order;L
    |[NExp&T&R];iico_order;L
  
  
  
  
  DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL
  $ mcat2config7 -set-libdir ./libdir -show lets libdir/aarch64.cat
  va-loc
  tr-ib
  tc-ib
  tc-before
  scl
  sca-class
  same-loc
  rf-mem
  pob
  po-va-loc
  po-scl-ob
  pick-lob
  pick-dtrm
  pick-dep
  obs
  ob
  lwfs
  local-hw-reqs
  lob
  inv-scope
  inv-domain
  intervening
  hw-reqs
  haz-ob
  f-ob
  f-ib
  ets-ob
  enumerate-ordered-pairs
  dtrm
  dob
  dmb.sy
  dmb.st
  dmb.ld
  dmb.full
  co0
  bob
  basic-dep
  aob
  all-TLBI-Imp_TTD_R-enums
  all-IC-Imp_Instr_R-enums
  all-DC-Exp_W-enums
  add_pair
  add_both_choices
  Within-CMODX-List
  Translation
  Tag-obs
  Tag
  TTDV
  TTDINV
  TTD-update-needsBBM
  TTD-same-oa
  TTD-read-ordered-before
  TTD-obs
  TTD
  TLBuncacheable-pred
  TLBUncacheable
  TLBI-ob
  TLBI-ca
  TLBI-Imp_TTD_R-pairs
  Shareability
  SPONTANEOUS
  PTEV
  PTEINV
  PTE-update-needsBBM
  PTE-SH-update
  PTE-OCH-update
  PTE-OA-update-writable
  PTE-OA-update
  PTE-MT-update
  PTE-ICH-update
  PTE-DT-update
  PTE
  OuterCacheability
  MMU
  Instr-read-ordered-before
  Instr-obs
  Instr
  InnerCacheability
  Imp
  IFB-ob
  IFB
  IC-ob
  IC-ca
  IC
  HU-pred
  HU
  Exp-obs
  Exp-haz-ob
  EXC-RET-IFB
  EXC-ENTRY-IFB
  Device
  DSB-ob
  DB
  C_TLBI
  C_IC
  CMODX-unordered-conflicts
  CMODX-ordering
  CMODX-conflicts
  BBM
  AccessFlag
  AFtoDB
  AF
  $ mcat2config7 -set-libdir ./libdir -let Exp-haz-ob libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TTD-read-ordered-before libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TLBI-ob libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let Instr-read-ordered-before libdir/aarch64.cat
  DSB.ISH [DSB.ISH,ISB] [DSB.ISH,DC.CVAUp] [DSB.ISH,IC.IVAUp]
  $ mcat2config7 -set-libdir ./libdir -let IC-ob libdir/aarch64.cat
  [PosRRIP,DSB.ISH] [PodRRIP,DSB.ISH] [PosRRIP,DSB.ISH,ISB] [PodRRIP,DSB.ISH,ISB] [PosRRIP,DSB.ISH,DC.CVAUp] [PodRRIP,DSB.ISH,DC.CVAUp] [PosRRIP,DSB.ISH,IC.IVAUp] [PodRRIP,DSB.ISH,IC.IVAUp]
  $ mcat2config7 -set-libdir ./libdir -let haz-ob libdir/aarch64.cat
  [PosRRIP,DSB.ISH] [PodRRIP,DSB.ISH] [PosRRIP,DSB.ISH,ISB] [PodRRIP,DSB.ISH,ISB] [PosRRIP,DSB.ISH,DC.CVAUp] [PodRRIP,DSB.ISH,DC.CVAUp] [PosRRIP,DSB.ISH,IC.IVAUp] [PodRRIP,DSB.ISH,IC.IVAUp]
  $ mcat2config7 -set-libdir ./libdir -let hw-reqs libdir/aarch64.cat
  PosRRIP PodRRIP DpCtrlIsbs* DpCtrlIsbd* DpCtrlIsbCsels* DpCtrlIsbCseld* [DpAddrs*,ISB] [DpAddrd*,ISB] [DpAddrCsels*,ISB] [DpAddrCseld*,ISB] DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW [DpCtrls*,DC.CVAUp] [DpCtrld*,DC.CVAUp] [DpCtrls*,IC.IVAUp] [DpCtrld*,IC.IVAUp] [DpAddrs*,Pos*W] [DpAddrs*,Pod*W] [DpAddrd*,Pos*W] [DpAddrd*,Pod*W] [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpAddrs*,RfiPT] [DpAddrd*,RfiPT] [DpDatas*,Rfi] [DpDatad*,Rfi] [DpDatas*,RfiPT] [DpDatad*,RfiPT] DpAddrCselsW DpAddrCseldW [DpAddrCsels*,DC.CVAUp] [DpAddrCseld*,DC.CVAUp] [DpAddrCsels*,IC.IVAUp] [DpAddrCseld*,IC.IVAUp] DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpCtrlCsels*,DC.CVAUp] [DpCtrlCseld*,DC.CVAUp] [DpCtrlCsels*,IC.IVAUp] [DpCtrlCseld*,IC.IVAUp] [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W] LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ] DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL [PosRRIP,DSB.ISH] [PodRRIP,DSB.ISH] [PosRRIP,DSB.ISH,ISB] [PodRRIP,DSB.ISH,ISB] [PosRRIP,DSB.ISH,DC.CVAUp] [PodRRIP,DSB.ISH,DC.CVAUp] [PosRRIP,DSB.ISH,IC.IVAUp] [PodRRIP,DSB.ISH,IC.IVAUp]
  $ mcat2config7 -set-libdir ./libdir -let Exp-obs libdir/aarch64.cat
  Rfe Fre
  $ mcat2config7 -set-libdir ./libdir -let Tag-obs libdir/aarch64.cat
  RfePT FreTP
  $ mcat2config7 -set-libdir ./libdir -let TLBuncacheable-pred libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let HU-pred libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TLBI-ca libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TTD-obs libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let IC-ca libdir/aarch64.cat
  FreIP
  $ mcat2config7 -set-libdir ./libdir -let Instr-obs libdir/aarch64.cat
  RfePI FreIP
  $ mcat2config7 -set-libdir ./libdir -let obs libdir/aarch64.cat
  RfePI FreIP
  $ mcat2config7 -set-libdir ./libdir -let ob libdir/aarch64.cat
  PosRRIP PodRRIP DpCtrlIsbs* DpCtrlIsbd* DpCtrlIsbCsels* DpCtrlIsbCseld* [DpAddrs*,ISB] [DpAddrd*,ISB] [DpAddrCsels*,ISB] [DpAddrCseld*,ISB] DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW [DpCtrls*,DC.CVAUp] [DpCtrld*,DC.CVAUp] [DpCtrls*,IC.IVAUp] [DpCtrld*,IC.IVAUp] [DpAddrs*,Pos*W] [DpAddrs*,Pod*W] [DpAddrd*,Pos*W] [DpAddrd*,Pod*W] [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpAddrs*,RfiPT] [DpAddrd*,RfiPT] [DpDatas*,Rfi] [DpDatad*,Rfi] [DpDatas*,RfiPT] [DpDatad*,RfiPT] DpAddrCselsW DpAddrCseldW [DpAddrCsels*,DC.CVAUp] [DpAddrCseld*,DC.CVAUp] [DpAddrCsels*,IC.IVAUp] [DpAddrCseld*,IC.IVAUp] DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpCtrlCsels*,DC.CVAUp] [DpCtrlCseld*,DC.CVAUp] [DpCtrlCsels*,IC.IVAUp] [DpCtrlCseld*,IC.IVAUp] [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W] LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ] DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL [PosRRIP,DSB.ISH] [PodRRIP,DSB.ISH] [PosRRIP,DSB.ISH,ISB] [PodRRIP,DSB.ISH,ISB] [PosRRIP,DSB.ISH,DC.CVAUp] [PodRRIP,DSB.ISH,DC.CVAUp] [PosRRIP,DSB.ISH,IC.IVAUp] [PodRRIP,DSB.ISH,IC.IVAUp] RfePI FreIP
  $ mcat2config7 -set-libdir ./libdir -let BBM libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let CMODX-conflicts libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let CMODX-ordering libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let CMODX-unordered-conflicts libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let tc-before libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let tc-ib libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let f-ib libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let DSB-ob libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let EXC-ENTRY-IFB libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let EXC-RET-IFB libdir/aarch64.cat
  Fatal Error: Variable not in matcher: EXC-RET
  $ mcat2config7 -set-libdir ./libdir -let IFB libdir/aarch64.cat
  ISBs** ISBd**
  $ mcat2config7 -set-libdir ./libdir -let IFB-ob libdir/aarch64.cat
  DpCtrlIsbs* DpCtrlIsbd* DpCtrlIsbCsels* DpCtrlIsbCseld* [DpAddrs*,ISB] [DpAddrd*,ISB] [DpAddrCsels*,ISB] [DpAddrCseld*,ISB]
  $ mcat2config7 -set-libdir ./libdir -let dob libdir/aarch64.cat
  DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW [DpCtrls*,DC.CVAUp] [DpCtrld*,DC.CVAUp] [DpCtrls*,IC.IVAUp] [DpCtrld*,IC.IVAUp] [DpAddrs*,Pos*W] [DpAddrs*,Pod*W] [DpAddrd*,Pos*W] [DpAddrd*,Pod*W] [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpAddrs*,RfiPT] [DpAddrd*,RfiPT] [DpDatas*,Rfi] [DpDatad*,Rfi] [DpDatas*,RfiPT] [DpDatad*,RfiPT]
  $ mcat2config7 -set-libdir ./libdir -let f-ob libdir/aarch64.cat
  PosRRIP PodRRIP
  $ mcat2config7 -set-libdir ./libdir -let pob libdir/aarch64.cat
  DpAddrCselsW DpAddrCseldW [DpAddrCsels*,DC.CVAUp] [DpAddrCseld*,DC.CVAUp] [DpAddrCsels*,IC.IVAUp] [DpAddrCseld*,IC.IVAUp] DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpCtrlCsels*,DC.CVAUp] [DpCtrlCseld*,DC.CVAUp] [DpCtrlCsels*,IC.IVAUp] [DpCtrlCseld*,IC.IVAUp] [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W]
  $ mcat2config7 -set-libdir ./libdir -let aob libdir/aarch64.cat
  LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ]
  $ mcat2config7 -set-libdir ./libdir -let bob libdir/aarch64.cat
  DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL
  $ mcat2config7 -set-libdir ./libdir -let po-scl-ob libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TLBUncacheable libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let ets-ob libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let lob libdir/aarch64.cat
  PosRRIP PodRRIP DpCtrlIsbs* DpCtrlIsbd* DpCtrlIsbCsels* DpCtrlIsbCseld* [DpAddrs*,ISB] [DpAddrd*,ISB] [DpAddrCsels*,ISB] [DpAddrCseld*,ISB] DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW [DpCtrls*,DC.CVAUp] [DpCtrld*,DC.CVAUp] [DpCtrls*,IC.IVAUp] [DpCtrld*,IC.IVAUp] [DpAddrs*,Pos*W] [DpAddrs*,Pod*W] [DpAddrd*,Pos*W] [DpAddrd*,Pod*W] [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpAddrs*,RfiPT] [DpAddrd*,RfiPT] [DpDatas*,Rfi] [DpDatad*,Rfi] [DpDatas*,RfiPT] [DpDatad*,RfiPT] DpAddrCselsW DpAddrCseldW [DpAddrCsels*,DC.CVAUp] [DpAddrCseld*,DC.CVAUp] [DpAddrCsels*,IC.IVAUp] [DpAddrCseld*,IC.IVAUp] DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpCtrlCsels*,DC.CVAUp] [DpCtrlCseld*,DC.CVAUp] [DpCtrlCsels*,IC.IVAUp] [DpCtrlCseld*,IC.IVAUp] [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W] LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ] DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL
  $ mcat2config7 -set-libdir ./libdir -let pick-lob libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let local-hw-reqs libdir/aarch64.cat
  PosRRIP PodRRIP DpCtrlIsbs* DpCtrlIsbd* DpCtrlIsbCsels* DpCtrlIsbCseld* [DpAddrs*,ISB] [DpAddrd*,ISB] [DpAddrCsels*,ISB] [DpAddrCseld*,ISB] DpAddrs* DpAddrd* DpDatas* DpDatad* DpCtrlsW DpCtrldW [DpCtrls*,DC.CVAUp] [DpCtrld*,DC.CVAUp] [DpCtrls*,IC.IVAUp] [DpCtrld*,IC.IVAUp] [DpAddrs*,Pos*W] [DpAddrs*,Pod*W] [DpAddrd*,Pos*W] [DpAddrd*,Pod*W] [DpAddrs*,Rfi] [DpAddrd*,Rfi] [DpAddrs*,RfiPT] [DpAddrd*,RfiPT] [DpDatas*,Rfi] [DpDatad*,Rfi] [DpDatas*,RfiPT] [DpDatad*,RfiPT] DpAddrCselsW DpAddrCseldW [DpAddrCsels*,DC.CVAUp] [DpAddrCseld*,DC.CVAUp] [DpAddrCsels*,IC.IVAUp] [DpAddrCseld*,IC.IVAUp] DpDataCsels* DpDataCseld* DpCtrlCselsW DpCtrlCseldW [DpCtrlCsels*,DC.CVAUp] [DpCtrlCseld*,DC.CVAUp] [DpCtrlCsels*,IC.IVAUp] [DpCtrlCseld*,IC.IVAUp] [DpAddrCsels*,Pos*W] [DpAddrCsels*,Pod*W] [DpAddrCseld*,Pos*W] [DpAddrCseld*,Pod*W] LxSx Amo.Swp Amo.Cas Amo.LdAdd Amo.LdEor Amo.LdSet Amo.LdClr Amo.StAdd Amo.StEor Amo.StSet Amo.StClr [LxSx,RfiPA] [Amo.Swp,RfiPA] [Amo.Cas,RfiPA] [Amo.LdAdd,RfiPA] [Amo.LdEor,RfiPA] [Amo.LdSet,RfiPA] [Amo.LdClr,RfiPA] [Amo.StAdd,RfiPA] [Amo.StEor,RfiPA] [Amo.StSet,RfiPA] [Amo.StClr,RfiPA] [LxSx,RfiPQ] [Amo.Swp,RfiPQ] [Amo.Cas,RfiPQ] [Amo.LdAdd,RfiPQ] [Amo.LdEor,RfiPQ] [Amo.LdSet,RfiPQ] [Amo.LdClr,RfiPQ] [Amo.StAdd,RfiPQ] [Amo.StEor,RfiPQ] [Amo.StSet,RfiPQ] [Amo.StClr,RfiPQ] DMB.ISHs** DMB.ISHd** DMB.ISHs*RPT DMB.ISHd*RPT DMB.OSHs** DMB.OSHd** DMB.OSHs*RPT DMB.OSHd*RPT DMB.SYs** DMB.SYd** DMB.SYs*RPT DMB.SYd*RPT DSB.ISHs** DSB.ISHd** DSB.ISHs*RPT DSB.ISHd*RPT DMB.ISHsR*TP DMB.ISHdR*TP DMB.ISHsRRTT DMB.ISHdRRTT DMB.OSHsR*TP DMB.OSHdR*TP DMB.OSHsRRTT DMB.OSHdRRTT DMB.SYsR*TP DMB.SYdR*TP DMB.SYsRRTT DMB.SYdRRTT DSB.ISHsR*TP DSB.ISHdR*TP DSB.ISHsRRTT DSB.ISHdRRTT [DMB.ISHs**,DC.CVAUp] [DMB.ISHd**,DC.CVAUp] [DMB.OSHs**,DC.CVAUp] [DMB.OSHd**,DC.CVAUp] [DMB.SYs**,DC.CVAUp] [DMB.SYd**,DC.CVAUp] [DSB.ISHs**,DC.CVAUp] [DSB.ISHd**,DC.CVAUp] [DC.CVAUps**,DMB.ISH] [DC.CVAUpd**,DMB.ISH] [DC.CVAUps**,DMB.OSH] [DC.CVAUpd**,DMB.OSH] [DC.CVAUps**,DMB.SY] [DC.CVAUpd**,DMB.SY] [DC.CVAUps**,DSB.ISH] [DC.CVAUpd**,DSB.ISH] [DC.CVAUps**,DMB.ISH,DC.CVAUp] [DC.CVAUpd**,DMB.ISH,DC.CVAUp] [DC.CVAUps**,DMB.OSH,DC.CVAUp] [DC.CVAUpd**,DMB.OSH,DC.CVAUp] [DC.CVAUps**,DMB.SY,DC.CVAUp] [DC.CVAUpd**,DMB.SY,DC.CVAUp] [DC.CVAUps**,DSB.ISH,DC.CVAUp] [DC.CVAUpd**,DSB.ISH,DC.CVAUp] DMB.ISHLDsR* DMB.ISHLDdR* DMB.ISHLDsRRPT DMB.ISHLDdRRPT DMB.OSHLDsR* DMB.OSHLDdR* DMB.OSHLDsRRPT DMB.OSHLDdRRPT DMB.LDsR* DMB.LDdR* DMB.LDsRRPT DMB.LDdRRPT DSB.LDsR* DSB.LDdR* DSB.LDsRRPT DSB.LDdRRPT DMB.ISHLDsR*TP DMB.ISHLDdR*TP DMB.ISHLDsRRTT DMB.ISHLDdRRTT DMB.OSHLDsR*TP DMB.OSHLDdR*TP DMB.OSHLDsRRTT DMB.OSHLDdRRTT DMB.LDsR*TP DMB.LDdR*TP DMB.LDsRRTT DMB.LDdRRTT DSB.LDsR*TP DSB.LDdR*TP DSB.LDsRRTT DSB.LDdRRTT DMB.ISHSTsWW DMB.ISHSTdWW DMB.OSHSTsWW DMB.OSHSTdWW DMB.STsWW DMB.STdWW DSB.STsWW DSB.STdWW [Amo.SwpAP,Pos**] [Amo.SwpAP,Pod**] [Amo.CasAP,Pos**] [Amo.CasAP,Pod**] [Amo.LdAddAP,Pos**] [Amo.LdAddAP,Pod**] [Amo.LdEorAP,Pos**] [Amo.LdEorAP,Pod**] [Amo.LdSetAP,Pos**] [Amo.LdSetAP,Pod**] [Amo.LdClrAP,Pos**] [Amo.LdClrAP,Pod**] [Amo.SwpAP,Pos*RPT] [Amo.SwpAP,Pod*RPT] [Amo.CasAP,Pos*RPT] [Amo.CasAP,Pod*RPT] [Amo.LdAddAP,Pos*RPT] [Amo.LdAddAP,Pod*RPT] [Amo.LdEorAP,Pos*RPT] [Amo.LdEorAP,Pod*RPT] [Amo.LdSetAP,Pos*RPT] [Amo.LdSetAP,Pod*RPT] [Amo.LdClrAP,Pos*RPT] [Amo.LdClrAP,Pod*RPT] PosWRLA PodWRLA PosR*AP PodR*AP PosRRAT PodRRAT PosR*QP PodR*QP PosRRQT PodRRQT Pos*WPL Pod*WPL PosRWTL PodRWTL
  $ mcat2config7 -set-libdir ./libdir -let lwfs libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let dtrm libdir/aarch64.cat
  Rfi
  $ mcat2config7 -set-libdir ./libdir -let basic-dep libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let pick-dtrm libdir/aarch64.cat
  Rfi
  $ mcat2config7 -set-libdir ./libdir -let pick-dep libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let PTE libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let PTEV libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let PTEINV libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let inv-domain libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let AF libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let DB libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let MMU libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let Translation libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let AccessFlag libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let Instr libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let Within-CMODX-List libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let AFtoDB libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let co0 libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let IC libdir/aarch64.cat
  IC.IVAUps** IC.IVAUpd**
  $ mcat2config7 -set-libdir ./libdir -let Imp libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let SPONTANEOUS libdir/aarch64.cat
  Fatal Error: Variable not in matcher: SPURIOUS
  $ mcat2config7 -set-libdir ./libdir -let inv-scope libdir/aarch64.cat
  Fatal Error: Variable not in matcher: inv-domain
  $ mcat2config7 -set-libdir ./libdir -let TTD libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let Tag libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let HU libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let intervening libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let sca-class libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let dmb.sy libdir/aarch64.cat
  DMB.SYs** DMB.SYd** DMB.ISHs** DMB.ISHd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.st libdir/aarch64.cat
  DMB.ISHSTs** DMB.ISHSTd** DMB.OSHSTs** DMB.OSHSTd** DMB.STs** DMB.STd** DSB.STs** DSB.STd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.ld libdir/aarch64.cat
  DMB.ISHLDs** DMB.ISHLDd** DMB.OSHLDs** DMB.OSHLDd** DMB.LDs** DMB.LDd** DSB.LDs** DSB.LDd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.full libdir/aarch64.cat
  DMB.ISHs** DMB.ISHd** DMB.OSHs** DMB.OSHd** DMB.SYs** DMB.SYd** DSB.ISHs** DSB.ISHd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.ld libdir/aarch64.cat
  DMB.ISHLDs** DMB.ISHLDd** DMB.OSHLDs** DMB.OSHLDd** DMB.LDs** DMB.LDd** DSB.LDs** DSB.LDd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.st libdir/aarch64.cat
  DMB.ISHSTs** DMB.ISHSTd** DMB.OSHSTs** DMB.OSHSTd** DMB.STs** DMB.STd** DSB.STs** DSB.STd**
  $ mcat2config7 -set-libdir ./libdir -let PTE-MT-update libdir/aarch64.cat
  Fatal Error: Variable not in matcher: Normal
  $ mcat2config7 -set-libdir ./libdir -let PTE-SH-update libdir/aarch64.cat
  Fatal Error: Variable not in matcher: NSH
  $ mcat2config7 -set-libdir ./libdir -let PTE-ICH-update libdir/aarch64.cat
  Fatal Error: Variable not in matcher: iNC
  $ mcat2config7 -set-libdir ./libdir -let PTE-OCH-update libdir/aarch64.cat
  Fatal Error: Variable not in matcher: oNC
  $ mcat2config7 -set-libdir ./libdir -let PTE-DT-update libdir/aarch64.cat
  Fatal Error: Variable not in matcher: Device-GRE
  $ mcat2config7 -set-libdir ./libdir -let PTE-OA-update libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let PTE-OA-update-writable libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let PTE-update-needsBBM libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TTDV libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TTDINV libdir/aarch64.cat
  Fatal Error: Variable not in matcher: PTEINV
  $ mcat2config7 -set-libdir ./libdir -let TTD-update-needsBBM libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TTD libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let Device libdir/aarch64.cat
  Fatal Error: Variable not in matcher: Device-GRE
  $ mcat2config7 -set-libdir ./libdir -let Shareability libdir/aarch64.cat
  Fatal Error: Variable not in matcher: NSH
  $ mcat2config7 -set-libdir ./libdir -let InnerCacheability libdir/aarch64.cat
  Fatal Error: Variable not in matcher: iWB
  $ mcat2config7 -set-libdir ./libdir -let OuterCacheability libdir/aarch64.cat
  Fatal Error: Variable not in matcher: oWB
  $ mcat2config7 -set-libdir ./libdir -let rf-mem libdir/aarch64.cat
  Rfe
  $ mcat2config7 -set-libdir ./libdir -let tr-ib libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TTD-same-oa libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let same-loc libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let scl libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let va-loc libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let po-va-loc libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let rf-mem libdir/aarch64.cat
  Rfe
  $ mcat2config7 -set-libdir ./libdir -let Imp libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let C_TLBI libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let C_IC libdir/aarch64.cat
  [IC.IVAUps**,DSB.ISH] [IC.IVAUpd**,DSB.ISH]
  $ mcat2config7 -set-libdir ./libdir -let add_pair libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let add_both_choices libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let enumerate-ordered-pairs libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let TLBI-Imp_TTD_R-pairs libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let all-TLBI-Imp_TTD_R-enums libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let all-DC-Exp_W-enums libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let all-IC-Imp_Instr_R-enums libdir/aarch64.cat
  $ mcat2config7 -set-libdir ./libdir -let dmb.sy libdir/aarch64.cat
  DMB.SYs** DMB.SYd** DMB.ISHs** DMB.ISHd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.st libdir/aarch64.cat
  DMB.ISHSTs** DMB.ISHSTd** DMB.OSHSTs** DMB.OSHSTd** DMB.STs** DMB.STd** DSB.STs** DSB.STd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.ld libdir/aarch64.cat
  DMB.ISHLDs** DMB.ISHLDd** DMB.OSHLDs** DMB.OSHLDd** DMB.LDs** DMB.LDd** DSB.LDs** DSB.LDd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.full libdir/aarch64.cat
  DMB.ISHs** DMB.ISHd** DMB.OSHs** DMB.OSHd** DMB.SYs** DMB.SYd** DSB.ISHs** DSB.ISHd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.ld libdir/aarch64.cat
  DMB.ISHLDs** DMB.ISHLDd** DMB.OSHLDs** DMB.OSHLDd** DMB.LDs** DMB.LDd** DSB.LDs** DSB.LDd**
  $ mcat2config7 -set-libdir ./libdir -let dmb.st libdir/aarch64.cat
  DMB.ISHSTs** DMB.ISHSTd** DMB.OSHSTs** DMB.OSHSTd** DMB.STs** DMB.STd** DSB.STs** DSB.STd**
