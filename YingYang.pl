/*
PLOG - YING YANG
ATENÇÃO: Mudar a fonte de letra para Consola
*/

:-include('RegionRule.pl').	
:-include('2x2Rule.pl').
:-include('ConnectedRule.pl').	
:-include('Display.pl').	
:-use_module(library(clpfd)).
:-use_module(library(lists)).

ying_yang :- 	write('board:'), read(N), nl,
				board(N,B), !,
				write('unresolved'),nl,
				display_board(B), nl, !,
				solve_ying_yang(B,R),
				write('resolved'),nl,
				display_board(R).

solve_ying_yang(Bi,Bf) :-		load_vars(Bi,[],Bf,[],V1),
								board_size(Bf,NR,NC,NCells),
								domain(V1,1,2),
								/*connected(Bf),*/
								no_2x2(Bf),
								regions(Bf,RL1,RL2),
								domain(RL1,1,NCells),
								domain(RL2,1,NCells),
								append(RL1,RL2,V2),
								all_distinct(V2),
								append(V1,V2,V3),
								labeling([ffc],V3),
								write(V1),
								write(RL1),
								write(RL2).
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


















					