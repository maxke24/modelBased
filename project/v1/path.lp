#program base.

% Include the graph
#include "graph_subset.lp".

edge(X, Y, W) :- edge(Y, X, W).

source(oostende).
target(leuven).

{in(X, Y, W) : edge(X, Y, W)}.

% Initial path from the source
path(oostende, Y, W) :- in(oostende, Y, W).

% Recursive path calculation
path(X, Z, K) :- path(X, Y, W1), in(Y, Z, W2), K = W1 + W2, K < 250.

% Track the nodes in the path
in_path(X, Y) :- path(X, Y, _).
in_path(X, Z) :- in_path(X, Y), in(Y, Z, _).

% Ensure there is a path from source to target
:- not path(oostende, leuven, _).

% Only show paths that reach the target
reachable(X, Y, W) :- path(X, Y, W), target(Y).

shortest_path(X, Y, W) :- reachable(X, Y, W), #min{W' : reachable(X', Y', W')} = W.

#minimize{1, X, Y, W : in(X, Y, W)}.
#minimize{W : shortest_path(X, Y, W)}.

% Show the paths and nodes in the path
#show shortest_path/3.
#show in/3.
