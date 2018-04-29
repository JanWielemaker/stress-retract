:- use_module(library(random)).
:- [pcgc].

:- dynamic db/2.

run :-
    on_signal(segv, _, default),
    with_cgc(run(10 000), 100 000).

run(0) :-
    !.
run(N) :-
    (   maybe(0.001)
    ->  retractall(db(_,_)),
        put_char(user_error, .)
    ;   random_term(T),
        cache(T, 1)
    ),
    N2 is N - 1,
    run(N2).


cache(Term, As) :-
    forall(retract(db(Term, _)), true),
    asserta(db(Term, As)).

random_term(T) :-
    random_between(0'a, 0'g, C),
    atom_codes(N, [C]),
    random_between(1, 500, C2),
    atom_codes(A, [C2]),
    T =.. [N,A].
