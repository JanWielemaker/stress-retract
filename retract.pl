:- use_module(library(lists)).
:- use_module(library(apply)).

test(Threads, Length) :-
	numlist(0, Length, List),
	sum_list(List, Sum),
	forall(between(0, Length, X),
	       assertz(a(X))),
	thread_self(Me),
	length(TIDS, Threads),
	maplist(thread_create(collect(Me)), TIDS),
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

collect(Main) :-
	collect(0, N),
	thread_send_message(Main, collected(N)).

collect(N0, N) :-
	retract(a(A)), !,
	N1 is N0 + A,
	collect(N1, N).
collect(N, N).
