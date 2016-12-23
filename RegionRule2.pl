/**
 tentativa de verificar regions 2 (nao chegou a funcionar)
 Abordagem :
 Tranformar a matriz do tabuleiro numa lista
 Verificar as regioes com check_region que utiliza duas listas vazias temporárias e que retorna
 L1 com os indices relativamente à região 1 e L2 com os indices da região 2
*/

regions(Board,L1,L2) :-  	board_size(Board,NR,NC,NCells),
							flat_board(Board,FlatBoard),
							check_region(FlatBoard,NR,NC,[],[],L1,L2). 

/*
check_region(Board,NumberRows,NumberColumns,T1,T2,Region1,Region2)
NR - Numero de linhas
NC - Numero de colunas
T1 - Lista temporaria da região 1
T2 - Lista temporaria da região 2
L1 - Lista com todos os elementos da região 1 (valor da célula = 1)
L2 - Lista com todos os elementos da região 2 (valor da célula = 2)
*/
check_region(_,NR,NC,L1,L2,L1,L2) :-	NCells #= NR * NC,						/*Condição de paragem*/
										%length(L1,LL1), length(L2,LL2),		/*NCells = length(L1) + length(L2)*/
										nvalue(LL1,L1),
										nvalue(LL2,L2),
										NCells #= LL1 + LL2.
									
check_region(FlatBoard,NR,NC,T1,T2,L1,L2) :-	element(Index,FlatBoard,V),		/*Index no Board = V*/
												write(T1-T2),nl,
												count_eq(Index,T1,0),			/*Que ainda não foi adicionado a nenhuma região*/
												count_eq(Index,T2,0),
												verify_connection(FlatBoard,Index,NR,NC,T1,T2,T3,T4,V),	/*Adicionar a região correta*/
												check_region(FlatBoard,NR,NC,T3,T4,L1,L2).			

/*
verify_connection(FlatBoard,Index,NumberRows,NumberColumns,T1,T2,REgion1,Region2,Value)
Index - Indice a processar
Value - Valor do Index

Adiciona Index à região correta
*/
												
verify_connection(FlatBoard,Index,_,_,[],L2,[Index],L2,1).  %:- element(Index,FlatBoard,1).				/*Valor 1 no Board e T1 = []*/
verify_connection(FlatBoard,Index,_,_,L1,[],L1,[Index],2).  %:-	element(Index,FlatBoard,2).				/*Valor 2 no Board e T2 = []*/

verify_connection(FlatBoard,Index,NR,NC,T1,L2,[Index|T1],L2,1) :-	element(_,T1,Pos),					/*Existe elemento em T1 de indice Pos*/
																	is_adj(Pos,Index,NR,NC),			/*Que é adjacente de Index a processar*/
																	element(Index,FlatBoard,1).			/*Valor 1 no Board*/

verify_connection(FlatBoard,Index,NR,NC,L1,T2,L1,[Index|T2],2) :-	element(_,T2,Pos),					/*Existe elemento em T2 de indice Pos*/
																	is_adj(Pos,Index,NR,NC),			/*Que é adjacente de Index a processar*/
																	element(Index,FlatBoard,2).			

/*
is_adj(A,B,NR,NC)
A - Index1
B - Index2

Verifica se A é adjacente de B
*/
																	
is_adj(A,B,NR,NC) :- 	calc_index(A,Ra,Ca,NR,NC,1),
						calc_index(B,Rb,Cb,NR,NC,1),
						(Ra #= Rb #/\ (Ca #= Cb - 1 #\/ Ca #= Cb + 1)) #\/ (Ca #= Cb #/\ (Ra #= Rb + 1 #\/ Ra #= Rb - 1)).

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
								(I #= (R - 1)*NC + C), (I #> 0 #/\ I #=< NR * NC).							
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
flat_board([R1|Rn],BoardFlat)
[R1|Rn] - Board em forma de Matriz
BoardFlat - Board em forma de lista
*/
							
flat_board([],[]).												
flat_board([R1|Rn],BoardFlat) :- 	append(R1,T,BoardFlat),
									flat_board(Rn,T).	