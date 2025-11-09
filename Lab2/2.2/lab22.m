1;
function lab22(a,b,c)

  d = lab21(a,b,c);   % d = [e f d]
  e = d(1);
  f = d(2);
  out = d(3);

  esw = sw2AND(a,b);
  fsw = swNOT(c);
  dsw = sw2AND(e,f);

  fprintf('Switching activity sp2AND: %.3f\n', esw);
  fprintf('Switching activity spNOT : %.3f\n', fsw);
  fprintf('Switching activity circuit : %.3f\n', dsw);



endfunction
