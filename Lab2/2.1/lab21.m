function n = lab21(a,b,c)

e = sp2AND(a,b);
f = spNOT(c);
d = spAND(e,f);
n = [e, f, d ];

endfunction