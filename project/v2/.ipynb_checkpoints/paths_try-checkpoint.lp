#program base.

% Include the graph
#include "graph.lp".


% Specify the start and end nodes.
start(oostende).
end(leuven).

dep_time(10).

edge(X, Y, L) :- edge(Y, X, L).

% For each destination E, some outgoing edge from the start node should be selected
:- start(S), end(E), not selected(S,_,E) .

% No edge pointing to the start node should be selected
:- start(S), selected(_,S,_) .

% If an edge points to the end node, then it may be (or not be) selected for reaching it
0{selected(X,E,E)}1 :- edge(X,E,_), end(E) .

% If an outgoing edge from Y has been selected for reaching E, then an incoming edge may be (or not be) selected for reaching E
0{selected(X,Y,E)}1 :- edge(X,Y,_), selected(Y,_,E) .

% Compute the cost for reaching E
cost(E,C) :- C=#sum{W : edge(X,Y,W), selected(X,Y,E)}, end(E) .
%#minimize{C : cost(E,C)} .
#minimize{1,X, Y : selected(X, Y, _)} .

%intermediate_stop(S, H, M) :- stop_name(X, S), selected(S, _, _), departure_time(X, H+(0..1), M), dep_time(H), stop_sequence(X, 2).

%#show selected/3 .
#show cost/2 .