count_eq(_Val,[],0).							%count_eq
count_eq(Val,[H|T],C) :-	Val #= H #<=> V,		
							C #= V + C2,
							count_eq(Val,T,C2).

regions(Board,L1,L2) :-  	board_size(Board,NR,NC,NCells),
							flat_board(Board,FlatBoard),
							check_region(FlatBoard,NR,NC,[],[],L1,L2).

check_region(_,NR,NC,L1,L2,L1,L2) :-	NCells #= NR * NC,
										length(L1,LL1), length(L2,LL2),
										NCells #= LL1 + LL2.
							
check_region(FlatBoard,NR,NC,T1,T2,L1,L2) :-	element(Index,FlatBoard,V),		/*Index no Board = 1*/
												write(T1-T2),nl,
												V #= 1 #\/ V #= 2,
												count_eq(Index,T1,0),			/*Que ainda não foi adicionado a região*/
												count_eq(Index,T2,0),
												verify_connection(FlatBoard,Index,NR,NC,T1,T2,T3,T4,V),
												check_region(FlatBoard,NR,NC,T3,T4,L1,L2).
						
verify_connection(FlatBoard,Index,_,_,[],L2,[Index],L2,1) :- 	element(Index,FlatBoard,1).
verify_connection(FlatBoard,Index,_,_,L1,[],L1,[Index],2) :-	nl,element(Index,FlatBoard,2).

verify_connection(FlatBoard,Index,NR,NC,T1,L2,L1,L2,1) :-		length(T1,LT1), length(L1,LL1),
																LL1 #= LT1 + 1,
																sublist(T1,L1),
																element(_,T1,Pos),
																is_adj(Pos,Index,NR,NC),
																element(_,L1,Index),
																element(Index,FlatBoard,1),
																element(Pos,FlatBoard,1).

verify_connection(FlatBoard,Index,NR,NC,L1,T2,L1,L2,2) :-		length(T2,LT2), length(L2,LL2),
																LL2 #= LT2 + 1,
																sublist(T2,L2),
																element(_,T2,Pos),
																is_adj(Pos,Index,NR,NC),
																element(_,L2,Index),
																element(Index,FlatBoard,2),
																element(Pos,FlatBoard,2).

sublist([],_).
sublist([S1|Sn],L) :- 	element(_,L,S1),
						sublist(Sn,L).
															
is_adj(A,B,NR,NC) :- 	calc_index(A,Ra,Ca,NR,NC,1),
						calc_index(B,Rb,Cb,NR,NC,1),
						(Ra #= Rb #/\ (Ca #= Cb - 1 #\/ Ca #= Cb + 1)) #\/ (Ca #= Cb #/\ (Ra #= Rb + 1 #\/ Ra #= Rb - 1)).