vertex(a; b; c; d; e; f).
edge(a,b; b,c; c,a; d,f; f,e; e,d; a,d; f,c; b,e).
color(g; b; r;).

{color(X, C) : color(C)} = 1 :- vertex(X).

% { color(a, b), color(b, g),  }
%:- color(a, b), color(b, b), edge(a, b)
:- color(X, C), color(Y, C), edge(X, Y).


%:- color(X,C), color(Y,C), edge(X,Y).
#show color/2.