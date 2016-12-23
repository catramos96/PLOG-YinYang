/**
Region Rule1
Verifica a connectividade através de uma pesquisa em largura primeiro nas celulas de valor 1 e depois nas celulas de valor 2
Inicialmente o tabuleiro é transformado numa lista e é usado uma lista auxiliar do mesmo tamanho com todos os elementos a 0
Por cada Index processado altera-se na lista auxiliar na posição Index para o valor 1 ou 2 conforme o valor a analisar
Apenas se processa indices que ainda não foram processados
Condição de paragem: Não houver mais índices para processar
*/

regions(Board,Nr,Nc) :- NCells is Nr * Nc,
						flat_board(Board,FlatBoard),				/*Board Matrix em lista*/
						
						count_eq(1,FlatBoard,N1),					/*N1 = Numero de 1 no Board*/
						count_eq(2,FlatBoard,N2),					/*N2 = Numero de 2 no Board*/
						NCells #= N1 + N2,							/*NCells = N1 + N2*/
						
						element(I1,FlatBoard,1),					/*obter indice de peça preta*/
						element(I2,FlatBoard,2),					/*obter indice de peça branca*/
						
						create_list(NCells,0,[],P1), !, 			/*lista de elementos não processados*/

						check_conectivity(FlatBoard,I1,1,Nr,Nc,P1,P2),
						write(1-P2),nl,
						check_conectivity(FlatBoard,I2,2,Nr,Nc,P2,FlatBoard), !,
						write(2-FlatBoard),nl.

/*
check_conectivity(+FlatBoard,+Index,+Value,+NumberRows,+NumberColumns,+ProcessedList,-FinalProcessedList)
FlatBoard - Board in form of a lista
Index - Index in the FlatBoard to be processed
Value - expected value
NumberRows - Number of Rows in the original board Matrix
NumberColumns - Number os Columns in the original board Matrix
ProcessedList - List of processed indexes
FinalProcessedList - Final List of processed indexes
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

/*
process_index(FlatBoard,Index,Value,CellR,CellC,NR,NC,P,PF,Process)
Se Process = 1 então é processado os indices adjacentes de Index
*/														
process_index(FlatBoard,Index,Value,CellR,CellC,NR,NC,P,PF,1) :- 	/*Marcar como processado -> marcar posição do index a processar com o valor 1*/
																	setList(Value,P,Index,P2),
																	
																	/*Proximas coordenadas*/
																	CellR1 #= CellR + 1, 
																	CellR2 #= CellR - 1,
																	CellC1 #= CellC + 1, 
																	CellC2 #= CellC - 1, !,
																	
																	/*Calcula indexes dos adjacentes*/
																	
																	calc_index(TopI,CellR2,CellC,NR,NC,TopValid),				
																	calc_index(LeftI,CellR,CellC2,NR,NC,LeftValid),				
																	calc_index(RightI,CellR,CellC1,NR,NC,RightValid),					
																	calc_index(BottomI,CellR1,CellC,NR,NC,BottomValid), !,
																	
																	/*TopValid #= 1 #\/ LeftValid #= 1 #\/ RightValid #= 1 #\/ BottomValid #= 1, !,
																	TopValue #= Value #\/ LeftValue #= Value #\/ RightValue #= Value #\/ BottomValue #= Value, !,
																	
																	Verificar connectividade com células adjacentes*/
																	
																	check_conectivity_aux(TopValid,TopI,FlatBoard,Value,TopValue,NR,NC,P2,P3),
																	check_conectivity_aux(LeftValid,LeftI,FlatBoard,Value,LeftValue,NR,NC,P3,P4),
																	check_conectivity_aux(RightValid,RightI,FlatBoard,Value,RightValue,NR,NC,P4,P5),
																	check_conectivity_aux(BottomValid,BottomI,FlatBoard,Value,BottomValue,NR,NC,P5,PF).

process_index(FlatBoard,Index,Value,CellR,CellC,NR,NC,PF,PF,0).

/*
check_conectivity_aux(Valid,Index,Board,Value,IndexValue,NR,NC,P,F)
Valid - 1 true  or 0 false
Value - Valor espectável 
IndexValue - Valor da célula

Se  célula for válida e com o mesmo valor espectável então verifica-se a conectividade no index.
*/																	
check_conectivity_aux(1,Index,Board,Value,Value,NR,NC,P,F)	:-	element(Index,Board,Value), write(Index),
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
Calcula o número do index para a coluna C e linha R de uma matriz com NR Linhas e NC Colunas.
*/					
calc_index(I,R,C,NR,NC,1) :- 	(R #> 0 #/\ R #=< NR),
								(C #> 0 #/\ C #=< NC),
								(I #= (R - 1)*NC + C), (I #> 0 #/\ I #=< NR*NC).
								
calc_index(_,_,_,_,_,0).

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