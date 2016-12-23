/*
no_2x2(Board)
Analisa todas as linhas do tabuleiro e passa duas linhas consecutivas para
no_2x2_aux que analisa duas colunas consecutivas,obtendo um quadrado 2x2,
onde verifica os valores com check_values
*/

no_2x2([_]).
no_2x2([R1,R2|Rn]) :- 	no_2x2_aux(R1,R2),
						no_2x2([R2|Rn]).

no_2x2_aux([_],[_]).						
no_2x2_aux([E1,E2|En],[F1,F2|Fn]) :- 	check_values(E1,E2,F1,F2),
										no_2x2_aux([E2|En],[F2|Fn]).

/*
check_values(Elem1,Elem2,Elem3,Elem4) 	
Pelo menos um dos elementos com valor diferente aos restantes
*/									
check_values(Elem1,Elem2,Elem3,Elem4) :-	((Elem1 #\= Elem2) #\/ (Elem1 #\= Elem3) #\/ (Elem3 #\= Elem4)).
