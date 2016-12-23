/*
PLOG - YIN YANG
ATENÇÃO: Mudar a fonte de letra para Consola
*/

:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).	

%:- include('RegionRule.pl').	
:- include('2x2Rule.pl').
:- include('ConnectedRule.pl').	
:- include('Display.pl').	
:- include('Generator.pl').	

yin_yang :- 	
	menu(Nr,Nc,Np), 
	generator(Nc,Nr,Np,B),
	write('unresolved'),nl,
	display_board(B), nl,
	print_time,
	fd_statistics, ! ,
	solve_yin_yang(B,R,[ffc]),
	write('resolved'),nl,
	display_board(R),
	print_time,
	fd_statistics .	
	
solve_yin_yang(Bi,Bf,Options) :-		
	load_vars(Bi,[],Bf,[],V1),
	domain(V1,1,2),
	connected(Bf),
	no_2x2(Bf),
	%regions(Bf),
	reset_timer,
	labeling(Options,V1) . 

mySelValores(Var, _Rest, BB, BB1) :-
	fd_set(Var, Set),
	select_rand_value(Set, Value),
	(   
	   first_bound(BB, BB1), Var #= Value
           ;   
	   later_bound(BB, BB1), Var #\= Value
    ).
	
select_rand_value(Set, Value) :-
	fdset_to_list(Set, Lis),
	random_select(Value, Lis, _) .
	

/*
Creates a new Board with the Vars and returns a list of the vars
*/

load_vars([],Bt,Bt,Vars,Vars).
load_vars([R1|Rn],T,Bt,TV,Vars) :-  load_row_vars(R1,[],Rf,TV,TV2),
									append(T,[Rf],T2),
									load_vars(Rn,T2,Bt,TV2,Vars).

load_row_vars([],Rf,Rf,Vars,Vars).						
load_row_vars([0|En],T,Rf,TV,Vars) :- 	append(T,[_X|[]],T2), !,
										append(TV,[_X|[]],TV2),
										load_row_vars(En,T2,Rf,TV2,Vars).
load_row_vars([E1|En],T,Rf,TV,Vars) :-	append(T,[E1|[]],T2), !,
										load_row_vars(En,T2,Rf,TV,Vars).