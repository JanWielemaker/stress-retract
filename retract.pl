:- use_module(library(lists)).
:- use_module(library(apply)).

:- dynamic
	a/1.

test(Threads, Length) :-
	numlist(0, Length, List),
	sum_list(List, Sum),
	forall(between(0, Length, X),
	       ( term(X, T),
		 assertz(a(T)))),
	thread_self(Me),
	length(TIDS, Threads),
	maplist(thread_create(collect(Me, Length)), TIDS),
	maplist(thread_join, TIDS),
	findall(C, ( between(1, Threads, _),
		     thread_get_message(collected(C))
		   ), CL),
	sum_list(CL, ConcurrentSum),
	(   Sum == ConcurrentSum
	->  true
	;   format('~D \\== ~D~n', [Sum, ConcurrentSum]),
	    fail
	).

collect(Main, Length) :-
	collect(0, Length, 0, N),
	thread_send_message(Main, collected(N)).

collect(I, End, N0, N) :-
	I =< End, !,
	(   term(I, T),
	    retract(a(T))
	->  N1 is N0 + I
	;   N1 = N0
	),
	I2 is I+1,
	collect(I2, End, N1, N).
collect(_, _, N, N).

term(N, x(N)) :- N mod  5 =:= 0, !.
term(N, y(N)) :- N mod 13 =:= 0, !.
term(N, N).
