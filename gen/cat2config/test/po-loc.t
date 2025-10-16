  $ mcat2config7 -v -v -set-libdir ./libdir -show tree -let lws libdir/test.cat
  Found and opened: './libdir/test.cat'
  (lws)
      po-loc; [W]
  
  
  
  
  Pos*W


The result of this should be the same as lws
  $ mcat2config7 -v -v -set-libdir ./libdir -show tree -let lws-alt libdir/test.cat
  Found and opened: './libdir/test.cat'
  (lws-alt)
      loc & po; [W]
  
  the following sequence loc & po; [W] didn't generate relaxations because: loc not implemented
  
  
  
