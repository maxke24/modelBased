#program base.

#include "graph.lp".
#include "routes.lp".
#include "stops.lp".
#include "stop_times.lp".

source("oostende").
target("vertrijk").

% Step 1: Define source and target stop IDs
source_stop(R, X) :- stops(R, X, S, _), source(S).
target_stop(R, X) :- stops(R, X, S, _), target(S).

% Step 2: Trip selection for the path from source to target
reachable(X) :- source_stop(R, X).
reachable(Y) :- reachable(X), transfer(X, Y).

% Step 3: Define valid transfers between routes
transfer(X, Y) :- stops(R1, X, _, _), stops(R2, Y, _, _), R1 != R2, X = Y.

% Step 4: Ensure a valid path from source to target
valid_trip(R) :- source_stop(R, _).
valid_trip(R) :- valid_trip(R1), transfer(X, Y), stops(R1, X, _, _), stops(R, Y, _, _).

% Step 5: Calculate total travel time
start_time(T1) :- valid_trip(R), source_stop(R, S), stop_times(R, S, T1, _).
arrival_time(T2) :- valid_trip(R), target_stop(R, S), stop_times(R, S, T2, _).

travel_time(T) :- start_time(T1), arrival_time(T2), T = |T2 - T1|.
#minimize { T : travel_time(T) }.

#show valid_trip/1.
#show travel_time/1.
