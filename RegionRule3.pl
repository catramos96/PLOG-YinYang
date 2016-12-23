/*
Variação do RegionRule1 em que podem ser processados alternadamente
indices com valor = 1 e valor = 2
*/

regions(Board) :-  	board_size(Board,NR,NC,NCells),
					flat_board(Board,FlatBoard),							/*Board Matrix em lista*/
					create_list(NCells,0,[],P), !,							/*lista de elementos não processados*/
					check_conectivity(FlatBoard,1,_,_,NR,NC,P,FlatBoard).
					
/*
check_conectivity(+FlatBoard,+Value,+Index1,+Index2+NumberRows,+NumberColumns,+ProcessedList,-FinalProcessedList)
Value - Valor a processar
Index1 - Indice do Board com valor a 1
Index2 - Indice do Board com valor a 2
ProcessedList - Lista de celulas processadas
FinalProcessedList - Lista final de celulas processadas

Verifica se o index1 e index2 ainda não foram processados
E processa o index de acordo com Value
*/

check_conectivity(FlatBoard,Value,Index1,Index2,NR,NC,P,PF) :- 	check_process(FlatBoard,1,Index1,Process1,P),
																check_process(FlatBoard,2,Index2,Process2,P), !,
																process_index(FlatBoard,Process1,Process2,Value,Index1,Index2,NR,NC,P,PF).

/*
check_process(FlatBoard,Value,Index,ProcessedList,ProcessedList)
Verifica se o Index do FlatBoard ja foi processado e se o seu valor no Board (X) é igual a Value
*/
check_process(FlatBoard,Value,Index,Process,PList) :- 	/*T == 1 -> não processado*/
														element(Index,PList,Processed) , (Processed #= 0) #<=> T,
														/*V == 1 -> Valor no tabuleiro = Value*/
														element(Index,FlatBoard,X), (X #= Value) #<=> V,
														/*V && T*/
														Process #<=> (V #/\ T).

/*
process_index(FlatBoard,Process1,Process2,Value,Index1,Index2,NumberRows,NumberColumns,ProcessedList,ProcessedListF)
Processa as celulas adjacentes do IndexX conforme os valores de Process1 e Process2
A condição de paragem é quando não é para processar nenhuma das celulas adjacentes
*/
process_index(FlatBoard,1,_,1,Index1,Index2,NR,NC,P,PF) :- 	process_adj(FlatBoard,1,Index1,Index2,NR,NC,P,PF).	/*Processar o index1*/
process_index(FlatBoard,_,1,2,Index1,Index2,NR,NC,P,PF) :- 	process_adj(FlatBoard,2,Index2,Index1,NR,NC,P,PF).	/*Processar o index2*/
process_index(FlatBoard,0,1,_,Index1,Index2,NR,NC,P,PF) :- 	process_adj(FlatBoard,2,Index2,Index1,NR,NC,P,PF).	/*Processar o index2*/
process_index(FlatBoard,1,0,_,Index1,Index2,NR,NC,P,PF) :- 	process_adj(FlatBoard,1,Index1,Index2,NR,NC,P,PF).	/*Processar o index1*/
process_index(_,0,0,_,_,_,_,_,P,P). 																															

/*
process_adj(FlatBoard,Value,Index,Next_index,NumberRows,NumberColumns,ProcessedList,ProcessedListF)
Processa Index com Value em Board e marca-o como processado
*/																																					
process_adj(FlatBoard,Value,Index,Next_index,NR,NC,P,PF) :- 		setList(Value,P,Index,P2),					/*Marca como processado*/
																	element(Index,FlatBoard,Value),				
																	/*U == 1 -> Index Valido*/
																	calc_index(Index,CellR,CellC,NR,NC,1),
																	
																	write(Value-Index-P2), nl,
																	
																	/*Proximas coordenadas*/
																	CellR1 #= CellR + 1, 
																	CellR2 #= CellR - 1,
																	CellC1 #= CellC + 1, 
																	CellC2 #= CellC - 1, 
																	
																	/*Indices das celulas adjacentes*/
																	calc_index(TopI,CellR2,CellC,NR,NC,TopValid),				
																	calc_index(LeftI,CellR,CellC2,NR,NC,LeftValid),				
																	calc_index(RightI,CellR,CellC1,NR,NC,RightValid),					
																	calc_index(BottomI,CellR1,CellC,NR,NC,BottomValid),
																	
																	TopValid #= 1 #\/ LeftValid #= 1 #\/ RightValid #= 1 #\/ BottomValid #= 1,
																	
																	/*Verifica a connectividade das celulas adjacentes*/
																	check_conectivity_aux(Value,Next_index,TopValid,TopI,FlatBoard,NR,NC,P2,P3),
																	check_conectivity_aux(Value,Next_index,LeftValid,LeftI,FlatBoard,NR,NC,P3,P4),
																	check_conectivity_aux(Value,Next_index,RightValid,RightI,FlatBoard,NR,NC,P4,P5),
																	check_conectivity_aux(Value,Next_index,BottomValid,BottomI,FlatBoard,NR,NC,P5,PF).

/*
check_conectivity_aux(Value,Next_index,Valid,Index,FlatBoard,NumberRows,NumberColumns,ProcessedList,ProcessedListF)
Processa o Next_index mas guarda Index para ser o próximo a processar na lista caso este seja válido
Se o Value = 1 então o valor de Index = 1 e o valor de Next_Index = 2
Se o Value = 2 então o valor de Index = 2 e o valor de Next_Index = 1
*/																	
check_conectivity_aux(1,Next_index,1,Index,Board,NR,NC,P,F)	:-	check_conectivity(Board,2,Index,Next_index,NR,NC,P,F).
																
check_conectivity_aux(2,Next_index,1,Index,Board,NR,NC,P,F)	:-	check_conectivity(Board,1,Next_index,Index,NR,NC,P,F).
																
check_conectivity_aux(_,_,0,_,_,_,_,P,P).

/*
count_eq(Val,List,C)
Val - Valor a pesquisar
List
C - número de ocorrencias de Val em List
*/

count_eq(_Val,[],0).							%count_eq
count_eq(Val,[H|T],C) :-	Val #= H #<=> V,		
							C #= V + C2,
							count_eq(Val,T,C2).

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