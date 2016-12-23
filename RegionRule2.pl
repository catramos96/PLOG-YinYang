/*
 tentativa de verificar regions 2 (nao chegou a funcionar)
 Abordagem : 
*/

regions(Board,NR,NC,NCells,L1,L2) :-  	flat_board(Board,FlatBoard),
										check_region(FlatBoard,NR,NC,[],[],L1,L2). 

check_region(_,NR,NC,L1,L2,L1,L2) :-	NCells #= NR * NC,						/*Condição de paragem*/
										%length(L1,LL1), length(L2,LL2),
										nvalue(LL1,L1),
										nvalue(LL2,L2),
										NCells #= LL1 + LL2.

/*T1 - Lista com Indexes do board com valor = 1 
  T2 - Lista com Indexes do board com valor = 2*/										
check_region(FlatBoard,NR,NC,T1,T2,L1,L2) :-	element(Index,FlatBoard,V),		/*Index no Board = V*/
												write(T1-T2),nl,
												count_eq(Index,T1,0),			/*Que ainda não foi adicionado a nenhuma região*/
												count_eq(Index,T2,0),
												verify_connection(FlatBoard,Index,NR,NC,T1,T2,T3,T4,V),	/*Adicionar a região correta*/
												check_region(FlatBoard,NR,NC,T3,T4,L1,L2).				/* Verificar outros indexs*/
						
verify_connection(FlatBoard,Index,_,_,[],L2,[Index],L2,1).  %:- element(Index,FlatBoard,1).	
verify_connection(FlatBoard,Index,_,_,L1,[],L1,[Index],2).  %:-	element(Index,FlatBoard,2).

verify_connection(FlatBoard,Index,NR,NC,T1,L2,[Index|T1],L2,1) :-	element(_,T1,Pos),					/*Elemento Pos em T1*/
																	is_adj(Pos,Index,NR,NC),			/*Adjacente de Index*/
																	element(Index,FlatBoard,1).			/*No Board com valor 1*/

verify_connection(FlatBoard,Index,NR,NC,L1,T2,L1,[Index|T2],2) :-	element(_,T2,Pos),					/*Elemento Pos em T2*/
																	is_adj(Pos,Index,NR,NC),			/*Adjacente de Index*/
																	element(Index,FlatBoard,2).			/*No Board com valor 2*/
															
is_adj(A,B,NR,NC) :- 	calc_index(A,Ra,Ca,NR,NC,1),
						calc_index(B,Rb,Cb,NR,NC,1),
						(Ra #= Rb #/\ (Ca #= Cb - 1 #\/ Ca #= Cb + 1)) #\/ (Ca #= Cb #/\ (Ra #= Rb + 1 #\/ Ra #= Rb - 1)).
	
calc_index(I,R,C,NR,NC,1) :- 	(R #> 0 #/\ R #=< NR),
								(C #> 0 #/\ C #=< NC),
								(I #= (R - 1)*NC + C), (I #> 0 #/\ I #=< NR * NC).							
calc_index(_,_,_,_,_,0).

count_eq(_Val,[],0).							%count_eq
count_eq(Val,[H|T],C) :-	Val #= H #<=> V,		
							C #= V + C2,
							count_eq(Val,T,C2).
							
flat_board([],[]).												
flat_board([R1|Rn],BoardFlat) :- 	append(R1,T,BoardFlat),
									flat_board(Rn,T).	