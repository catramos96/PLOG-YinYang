/**
Region Rule
Encontrar uma celula preta e branca com element
Escolher caminho apartir da preta e branca:
	- encontrar indexes para as quatro direcções 
	- processar quantro direções
	- cada celula processada pode ou não ser com aquele valor ou pode ainda não ser processada se ja foi processada
	- como saber se foi processada ? lista em que cada indice é um ou zero conforme se foi processada ou nao (<=>)
	
Problema
	- Preenche tudo com 1 no principio, o melhor é ir avançando com valores 1 e 2 ao mesmo tempo
	
Solução
	- Processar index1 index2 alternadamente
*/

count_eq(_Val,[],0).							%count_eq
count_eq(Val,[H|T],C) :-	Val #= H #<=> V,		
							C #= V + C2,
							count_eq(Val,T,C2).

regions(Board) :-  	board_size(Board,NR,NC,NCells),
					flat_board(Board,FlatBoard),				/*Board Matrix em lista*/
					
					count_eq(1,FlatBoard,N1),					/*N1 = Numero de 1 no Board*/
					count_eq(2,FlatBoard,N2),					/*N2 = Numero de 2 no Board*/
					NCells #= N1 + N2,							/*NCells = N1 + N2*/
					
					element(I1,FlatBoard,1),					/*obter indice de peça preta*/
					element(I2,FlatBoard,2),					/*obter indice de peça branca*/
					
					create_list(NCells,0,[],P1), !, 			/*lista de elementos não processados*/

					check_conectivity(FlatBoard,I1,1,NR,NC,P1,P2),
					write(1-P2),nl,
					check_conectivity(FlatBoard,I2,2,NR,NC,P2,FlatBoard), !,
					write(2-FlatBoard),nl.

/*
check_conectivity(+FlatBoard,+Index,+Value,+NumberRows,+NumberColumns,+ProcessedList,-FinalProcessedList,+Processed?)
FlatBoard - Board in form of a lista
Index - Index in the FlatBoard to be processed
Value - expected value
NumberRows - Number of Rows in the original board Matrix
NumberColumns - Number os Columns in the original board Matrix
ProcessedList - List of processed indexes
FinalProcessedList - Final List of processed indexes
Processed? - Index has already been processed ?
*/
check_conectivity(FlatBoard,Index,Value,NR,NC,P,PF) :- 	/*T == 1 -> não processado*/
														element(Index,P,Processed) , (Processed #= 0) #<=> T,
														/*V == 1 -> Valor no tabuleiro = Value*/
														element(Index,FlatBoard,X), (X #= Value) #<=> V,
														/*U == 1 -> Index Valido*/
														calc_index(Index,CellR,CellC,NR,NC,R), (R #= 1) #<=> U,
														/*V && T*/
														Process #<=> (V #/\ T #/\ U), !,
														process_index(FlatBoard,Index,Value,CellR,CellC,NR,NC,P,PF,Process).
																																					
process_index(FlatBoard,Index,Value,CellR,CellC,NR,NC,P,PF,1) :- 	/*Marcar como processado*/
																	setList(Value,P,Index,P2),
																	
																	/*Proximas coordenadas*/
																	CellR1 #= CellR + 1, 
																	CellR2 #= CellR - 1,
																	CellC1 #= CellC + 1, 
																	CellC2 #= CellC - 1, !,
																	
																	calc_index(TopI,CellR2,CellC,NR,NC,TopValid),				
																	calc_index(LeftI,CellR,CellC2,NR,NC,LeftValid),				
																	calc_index(RightI,CellR,CellC1,NR,NC,RightValid),					
																	calc_index(BottomI,CellR1,CellC,NR,NC,BottomValid), !,
																	
																	/*TopValid #= 1 #\/ LeftValid #= 1 #\/ RightValid #= 1 #\/ BottomValid #= 1, !,
																	TopValue #= Value #\/ LeftValue #= Value #\/ RightValue #= Value #\/ BottomValue #= Value, !,*/
																	
																	check_conectivity_aux(TopValid,TopI,FlatBoard,Value,TopValue,NR,NC,P2,P3),
																	check_conectivity_aux(LeftValid,LeftI,FlatBoard,Value,LeftValue,NR,NC,P3,P4),
																	check_conectivity_aux(RightValid,RightI,FlatBoard,Value,RightValue,NR,NC,P4,P5),
																	check_conectivity_aux(BottomValid,BottomI,FlatBoard,Value,BottomValue,NR,NC,P5,PF).

process_index(FlatBoard,Index,Value,CellR,CellC,NR,NC,PF,PF,0).
																	
check_conectivity_aux(1,Index,Board,Value,Value,NR,NC,P,F)	:-	element(Index,Board,Value),
																check_conectivity(Board,Index,Value,NR,NC,P,F).
check_conectivity_aux(_,_,_,_,-1,_,_,P,P).

/*
create_list(NCells,Value,T,List)
NCells - Numero de Cells da Lista (Length)
Value - Valor default de todas as celulas
T - Lista temporaria, no inicio = []
List - Lista final
*/
create_list(NCells,_,F,F) :- length(F,NCells).
create_list(NCells,Value,T,List) :- append(T,[Value],T2),
									create_list(NCells,Value,T2,List).
/*
board_size([R1|Rn],NRows,NColumns,NCells)
[R1|Rn] - Board em forma de Matriz
NRows - Numero de Rows
NColumns - Numero de Columns
NCells - Numero total de Cells
*/																	
board_size([R1|Rn],NRows,NColumns,NCells) :- 	length([R1|Rn],NRows), length(R1,NColumns),
												NCells is NRows * NColumns.
/*
flat_board([R1|Rn],BoardFlat)
[R1|Rn] - Board em forma de Matriz
BoardFlat - Board em forma de lista
*/
flat_board([],[]).												
flat_board([R1|Rn],BoardFlat) :- 	append(R1,T,BoardFlat),
									flat_board(Rn,T).
/*
calc_index(I,R,C,NR,NC,V)
I - Index
R - Row que pertence a Index
C - Column que pertence a Index
NR - Numero de Rows do Board Original
NC - Numbero de Columns do Board Original
V - Se o Index é valido
*/					
calc_index(I,R,C,NR,NC,1) :- 	(R #> 0 #/\ R #=< NR),
								(C #> 0 #/\ C #=< NC),
								(I #= (R - 1)*NC + C), (I #> 0 #/\ I #=< NR*NC).
								
calc_index(_,_,_,_,_,0).

/*
setList(Element,ListI,Position,ListF) 
Element - Elemento na posição Position na ListF
ListI - Lista Inicial
Position
ListF - Lista Final
*/
setList(Element,ListI,Position,ListF) :- 	length(ListI,Length), 
											Position #=< Length,
											Position #>= 1,
											append(B,[_|C],ListI),
											length(B,LB), length(C, LC),
											LB #= Position - 1,
											Length #= 1 + LB + LC,
											append(B,[Element|C],ListF),
											length(ListF,Length).