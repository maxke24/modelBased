#program base.

% Include the graph
#include "graph.lp".
#include "routes.lp".
#include "stops.lp".
#include "stop_times.lp".
#include "departures.lp".

source("oostende").
target("leuven").
departure(12).

chose_departure(T) :- T=T1+(0..3), departure(T1).

{source_id(R, X) : stops(R, X, S, _), departure_time(_, R, T)}5 :- source(S), chose_departure(T).
{target_id(R, X) : stops(R, X, S, _)}5 :- target(S).
:- source_id(R, X), target_id(R1, X1), R1 != R.
:- #count{1, R : trip_id(R, X)} < 1.

1{trip_id(R, X) : route(X, R, _, _)}5:- source_id(R, S), target_id(R, T).

intermediate_stops(S, N) :- trip_id(R, X), stops(R, S, _, N), stops(R, _, T, N1), target(T), N <= N1.

{start_time(F, T) : stop_times(R, S, T, 1)} = 1 :- trip_id(R, X), source_id(R, S), source(F).

{intermediate_time(S, T, N) : stop_times(R, F, T, N), stops(R, F, S, _)} = 1 :- intermediate_stops(F, N), trip_id(R, X).

travel_time(T) :- start_time(_, T1), intermediate_time(_, T2, N), N = #max{N' : intermediate_time(F', T', N')}, T = |T1 - T2|.

#minimize{T : chose_departure(T)}.
#minimize{T : travel_time(T)}.

hours(H) :- travel_time(T), H = T/(3600).
remainder(R) :- travel_time(T), R = T \ 3600.
minutes(M) :- travel_time(T), M = (T \ 3600) / 60.

#show chose_departure/1.
#show trip_id/2.
#show hours/1.
#show minutes/1.
