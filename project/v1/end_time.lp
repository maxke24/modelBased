% Include the graph and schedule
#include "graph_subset.lp".
#include "schedule.lp".

% Make edges bidirectional if needed
edge(X, Y, W) :- edge(Y, X, W).

% Define source and target
source(oostende).
target(leuven).

% Track edges included in the path
{in(X, Y, W) : edge(X, Y, W)}.

% Initial path from the source
path(oostende, Y, W) :- in(oostende, Y, W).

% Recursive path calculation with accumulated weight
path(X, Z, K) :- path(X, Y, W1), in(Y, Z, W2), K = W1 + W2, K < 250.

% Track the nodes in the path
in_path(X, Y) :- path(X, Y, _).
in_path(X, Z) :- in_path(X, Y), in(Y, Z, _).

% Ensure there is a path from source to target
:- not path(oostende, leuven, _).

% Identify paths that reach the target
reachable(X, Y, W) :- path(X, Y, W), target(Y).

% Find the minimum weight to reach the target
shortest_path(X, Y, W, H2, M2) :- reachable(_, Y, W), #min{W' : reachable(_, _, W')} = W.

% Calculate travel time given start hour, start minute, and weight W
% Define valid ranges for M1, W, and H2
valid_range(M1) :- between(0, 59, M1).
valid_range(W) :- between(-60, 60, W).
valid_range(H2) :- between(0, 24*60, H2).

% Calculate travel time given start hour, start minute, and weight W
travel_time(H1, M1, W, ArrivalHour, ArrivalMinute) :-
    valid_range(M1),
    valid_range(W),
    valid_range(H2),
    MTotal is M1 + W,
    H20 is floor(ArrivalHour * 60 + ArrivalMinute) - W,
    ArrivingHour is H20 // 60,  >= 0, =< 23*60,
    Modulo is H20 mod 60,  >= 0, =< 59,
    ArrivingMinute is H20 mod 60.

% Display the path with departure and arrival times
#show shortest_path/4.