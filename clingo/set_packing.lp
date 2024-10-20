#const n=4.
s(a, 1; b, 1; c, 1; b, 2; c, 2; d, 2; a, 3; c, 3; b, 4; d, 4;).
{in(1..n)}.
I = J :- in(I), in(J), s(X, I), s(X, J).
#maximize{1, I: in(I)}.

#show in/1.
