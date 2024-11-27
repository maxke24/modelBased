#program base.

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
shortest_path(X, Y, W) :- reachable(X, Y, W), #min{W' : reachable(_, _, W')} = W.

% Track the full sequence of nodes and edges in the shortest path
% and the total accumulated travel time for that path
shortest_in_path(X, Y) :- shortest_path(X, Y, _).
shortest_in_path(X, Z) :- shortest_in_path(X, Y), in(Y, Z, _), shortest_path(Y, Z, _).

% Time accumulation: finding the departure and arrival times
% Initialize the departure time at the source (oostende)
departure(oostende, H, M) :- source(oostende), departure_time(oostende, H, M).

% Calculate arrival time and next departure time along the path
arrival(Y, H2, M2) :- shortest_in_path(X, Y), in(X, Y, W),
                      departure(X, H1, M1),
                      travel_time(H1, M1, W, H2, M2).

% Define departure for the next segment based on arrival time
departure(Y, H2, M2) :- arrival(Y, H2, M2), shortest_in_path(Y, Z).

% Calculate travel time given start hour, start minute, and weight W
% travel_time(StartHour, StartMinute, TravelMinutes, ArrivalHour, ArrivalMinute)
travel_time(H1, M1, W, H2, M2) :-
    MTotal = M1 + W,
    H2 = H1 + MTotal / 60,
    M2 = MTotal % 60.

% Display the path with departure and arrival times
#show shortest_path/3.
#show departure/3.
#show arrival/3.
