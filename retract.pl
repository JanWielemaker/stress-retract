loop(0) :- !.
loop(N) :-
	test, put_char(user_error, .),
	N2 is N - 1,
	loop(N2).

test :-
	N = 10000,
	numlist(0, N, List),
	sum_list(List, Sum),
	forall(between(0, N, X),
	       assertz(a(X))),
	thread_self(Me),
	thread_create(collect(Me), Id1, []),
	thread_create(collect(Me), Id2, []),
	thread_join(Id1, true),
	thread_join(Id2, true),
	thread_get_message(collected(N1)),
	thread_get_message(collected(N2)),
	ConcurrentSum is N1+N2,
	(   Sum == ConcurrentSum
	->  true
	;   format('~D \\== ~D~n', [Sum, ConcurrentSum]),
	    fail
	).

collect(Main) :-
	collect(0, N),
	thread_send_message(Main, collected(N)).

collect(N0, N) :-
	retract(a(A)), !,
	N1 is N0 + A,
	collect(N1, N).
collect(N, N).
