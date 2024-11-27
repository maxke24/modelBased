#program base.

% Include the graph
#include "routes.lp".
#include "stop_times.lp".
#include "stops.lp".

% Specify the start and end nodes.
start("oostende").
end("leuven").

start(X, Y) :- stops(B, E, X, S, Y), start(S).
end(X, Y) :- stops(B, E, X, S, Y), end(S).

{possible_routes(S, E) : stops(S, E, C, T)} = 1 :- start(T).
{possible_routes(S, E) : stops(S, E, C, T)} = 1 :- end(T).

{in(C, T, Id) : stops(S, E, C, T)} = N :- possible_routes(S, E), route(Id, S, E), N = #count{1, S, E, C : stops(S, E, C, _)}.

% {possible_routes(Id) : route(Id, X, _)} = 1 :- start_id(X).
% {possible_routes(Id) : route(Id, _, X)} = 1 :- end_id(X).

:- #count{1, X : possible_routes(X, Y)} < 2.

% :- in(C, T, Id), in(C, T, Id1), Id1 != Id.

:- #count{C : in(C, T, Id), in(C, T, Id1), Id1 = Id} < 1.

:- #count{1, I : in(C, T, I)} < 1.

#show start_id/1.
#show possible_routes/2.
#show in/3.
