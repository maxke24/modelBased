clue(1, 0, 4; 2, 0, 2; 4, 0, 2; 0, 4, 1; 4, 5, 2; 5, 3, 3; 5, 4, 2).

#const n=4.

{h(R, C, 1..n)} = 1 :- R = 1..n, C = 1..n.
% R = 1, C = 1 ; R = 1, C = 2; R = 2, C = 1; R = 2, C = 2

:- not h(R, _, H), R = 1..n, H = 1..n.
:- not h(_, C, H), C = 1..n, H = 1..n.
% :- not h(1, _, 1)
% :- not h(1, _, 2)
% :- not h(2, _, 1)
% :- not h(2, _, 2)]

blocked(R, C, 0, C) :- h(R, C, H), h(R1, C, H1), R1 < R, H1 > H.
blocked(R, C, n+1, C) :- h(R, C, H), h(R1, C, H1), R1 > R, H1 > H.
blocked(R, C, R, 0) :- h(R, C, H), h(R, C1, H1), C1 < C, H1 > H.
blocked(R, C, R, n+1) :- h(R, C, H), h(R, C1, H1), C1 > C, H1 > H.

:- clue(R0, C0, N), #count{R, C: blocked(R, C, R0, C0)} != n-N.

#show h/3.