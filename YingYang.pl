/*
PLOG - YING YANG
ATENÇÃO: Mudar a fonte de letra para Consola
*/

:- include('RegionRule.pl').	
:- include('2x2Rule.pl').
:- include('ConnectedRule.pl').	
:- include('Display.pl').	
:- include('Generator.pl').	
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).	

menu(Nr,Nc,Np) :-
	menu_rc(Nr,Nc),
	menu_piece(Nr,Nc,Np).

menu_rc(Nr,Nc) :- 
	write('Number of columns and rows between 3 and 15 (inclusive)'),nl,
	write('Cols :'), read(Nc), nl, 
	verify_values_between(Nc,2,16),
	write('Rows :'), read(Nr), nl, 
	verify_values_between(Nr,2,16).
	
menu_rc(Nr,Nc) :- 
	write('Invalid values! Insert again. '),nl,
	menu_rc(Nr,Nc) .

menu_piece(Nr,Nc,Np) :- 
	write('Number of pieces: '),nl,write('(1) automatic'),nl,write('(2) choosen by player'),nl,
	read(Choice), 
	verify_choice(Choice,Np,Nc,Nr).
	
menu_piece(Nr,Nc,Np) :- 
	write('Invalid values! Insert again. '),nl,
	menu_piece(Nr,Nc,Np) .
	
%se a escolha for automatica fica 1 terco das pecas	
verify_choice(1,Np,Nc,Nr) :- 	
	N is Nc * Nr / 3 ,
	Np is floor(N) . 
	
%se o utilizador poder escolher fica entre 1 e metade das pecas	
verify_choice(2,Np,Nc,Nr) :- 
	M is Nr * Nc / 2,
	Max is floor(M),
	write('Pieces number between 1 and '),write(Max),write(' (inclusive) : '),read(Np),nl,
	verify_values_between(Np,0,Max + 1) .
	
verify_values_between(N,Min,Max) :- N > Min , N < Max .

ying_yang :- 	
	menu(Nr,Nc,Np), 
	generator(Nc,Nr,Np,B),
	write('unresolved'),nl,
	display_board(B), nl,
	print_time,
	fd_statistics, ! ,
	solve_ying_yang(B,R),
	write('resolved'),nl,
	display_board(R),
	print_time,
	fd_statistics .	
	
solve_ying_yang(Bi,Bf) :-		
	load_vars(Bi,[],Bf,[],V1),
	board_size(Bf,NR,NC,NCells),
	domain(V1,1,2),
	connected(Bf),
	no_2x2(Bf),
	%regions(Bf,RL1,RL2),
	%domain(RL1,1,NCells),
	%domain(RL2,1,NCells),
	%append(RL1,RL2,V2),
	%all_distinct(V2),
	%append(V1,V2,V3),
	reset_timer,
	labeling([ffc],V1) . 	%leftmost, min, max, first_fail, anti_fisrt_fail, ffc, max_regret, variable(sel)
	%write(V1),
	%write(RL1),
	%write(RL2).
								
reset_timer :- statistics(walltime,_).	

print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.
	
/*	
ying_yang :- 	write('board:'), read(N), nl,
				board(N,B), !,
				write('unresolved'),nl,
				display_board(B), nl, !,
				solve_ying_yang(B,R),
				write('resolved'),nl,
				display_board(R).

								*/
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


















					