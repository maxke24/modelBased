vertex(a; b; c; d; e; f).
edge(a, b; b, c; c, a; d,f; f,e; e,d; a,d; f,c; b,e).

{ in(X) : vertex(X) } = n.

X = Y :- in(X), in(Y), not edge(X, Y), not edge(Y, X).

#show in/1.