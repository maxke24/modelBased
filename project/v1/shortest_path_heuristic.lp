#program base.

% Include the graph
#include "graph.lp".

% Define the start and end nodes
start(oostende).
end(leuven).

% Define heuristic for A* (e.g., straight-line distance, estimated cost)
heuristic(X, Y, H) :- edge(X, Y, W), H = W / 2.

% Define paths using edges
path(X, Y, W) :- edge(X, Y, W).
path(X, Z, W + V + H) :- path(X, Y, W), edge(Y, Z, V), heuristic(Y, Z, H), X != Z.

% Minimize path length using A* heuristic
#minimize {W: path(oostende, leuven, W)}.

% Ensure start and end nodes are part of the solution
:- not path(oostende, leuven, _).

% Show the shortest path
#show path/3.
