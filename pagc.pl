:- module(agc, [with_agc/2]).

:- meta_predicate
    with_agc(0, +).

with_agc(G, N) :-
    thread_create(agc, Id),
    call_cleanup(loop(N, G), kill_thread(Id)).

loop(0, _) :- !.
loop(N, G) :-
    call(G),
    N2 is N - 1,
    loop(N2, G).

agc :-
    forall(between(1, infinite, X),
           atom_concat(a, X, _)).

kill_thread(Id) :-
    thread_signal(Id, abort),
    thread_join(Id, _).
