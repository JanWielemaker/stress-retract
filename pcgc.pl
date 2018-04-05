:- module(cgc, [with_cgc/2]).

:- meta_predicate
    with_cgc(0, +).

with_cgc(G, N) :-
    thread_create(cgc, Id),
    call_cleanup(loop(N, G), kill_thread(Id)).

loop(0, _) :- !.
loop(N, G) :-
    call(G),
    put_char(user_error, '.'),
    N2 is N - 1,
    loop(N2, G).

cgc :-
    forall(between(1, infinite, _X),
           garbage_collect_clauses).

kill_thread(Id) :-
    thread_signal(Id, abort),
    thread_join(Id, _).
