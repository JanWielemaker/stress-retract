:- set_prolog_flag(optimise_debug, false).
:- use_module(library(plunit)).
:- set_test_options([load(always), silent(true), sto(true), cleanup(true)]).

:- meta_predicate
    loop(0, +).

loop(_, 0) :- !.
loop(G, N) :-
    call(G), put_char(user_error, '.'),
    N2 is N - 1,
    loop(G, N2).
