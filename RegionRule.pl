/*
Region Rule
*/

count_eq(_Val,[],0).							%count_eq
count_eq(Val,[H|T],C) :-	Val #= H #<=> V,		
							C #= V + C2,
							count_eq(Val,T,C2).

regions(Board,RL1,RL2) :-  	board_size(Board,NR,NC,NCells),
							flat_board(Board,FlatBoard),				/*Board Matrix em lista*/
							count_eq(1,FlatBoard,N1),					/*N1 = Numero de 1 no Board*/
							count_eq(2,FlatBoard,N2),					/*N2 = Numero de 2 no Board*/
							NCells #= N1 + N2,							/*NCells = N1 + N2*/
							length(RL1,N1), length(RL2,N2),
							region_list(1,0,N1,FlatBoard,RL1),			/*RL1 Lista com os elementos com valor = 1*/
							region_list(2,0,N2,FlatBoard,RL2),			/*RL2 Lista com os elementos de valor = 2*/
							check_connectivity(RL1,RL1,NR,NC),
							check_connectivity(RL2,RL2,NR,NC).	/*Verifica a conectividade entre os elementos da regiao 1*/
							
check_connectivity([I1|In],RegionList,NR,NC). /*-> Função que vê se existe conectividade entre todos os elementos de RegionList*/
												

/*
List RegionList of length NCells with all the elements Value of FlatBoard 
*/

region_list(Value,NCells,NCells,FlatBoard,RegionList).							
region_list(Value,Count,NCells,FlatBoard,RegionList) :- 	element(Index,FlatBoard,Value),
															CountN is Count + 1,
															element(CountN,RegionList,Index),
															region_list(Value,CountN,NCells,FlatBoard,RegionList).


create_list(NCells,_,F,F) :- length(F,NCells).
create_list(NCells,Value,T,List) :- append(T,[Value],T2),
									create_list(NCells,Value,T2,List).
																		
board_size([R1|Rn],NRows,NColumns,NCells) :- 	length([R1|Rn],NRows), length(R1,NColumns),
												NCells is NRows * NColumns.

flat_board([],[]).												
flat_board([R1|Rn],BoardFlat) :- 	append(R1,T,BoardFlat),
									flat_board(Rn,T).
									
calc_index(I,R,C,NR,NC) :- 	(R #> 0 #/\ R #=< NR #/\ C #>0 #/\ C #=< NC),
							(I #> 0 #/\ I #=< NR*NC), 
							(I #= (R - 1)*NC + C).

setList(Element,ListI,Position,ListF) :- 	setCellRow(ListI,Position,1,Element,[],ListF).
							
setCellRow([],_,_,_,F,F).
setCellRow([_|L2],C,Nc,V,T,F) :- 	C is Nc ,!, append(T,[V|[]],T2),				/*If the counder Nc is C then its processing*/
									Nc1 = Nc + 1,									/*the pretended column*/
									setCellRow(L2,C,Nc1,V,T2,F).
									
setCellRow([L1|L2],C,Nc,V,T,F) :- 	append(T,[L1|[]],T2),
									Nc1 = Nc + 1,
									setCellRow(L2,C,Nc1,V,T2,F).	