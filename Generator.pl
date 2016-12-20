/*
Board generator
*/

generator(Nc,Nr,Np,Bf) :- 
	%criar um tabuleiro vazio
	create_empty_board(Nc,Nr,Bi) ,
	%resolve-lo
	solve_ying_yang(Bi,B) ,
	%escolher o numero de pecas que sao eliminadas
	Nrem is Nc * Nr - Np , 
	%eliminar as restantes aleatoriamente
	remove_pieces(Nrem,Nc,Nr,B,Bf) .
	
create_empty_board( _, 0, []) :- !.	
create_empty_board(Nc,Nr,[H|T]) :- 
    create_empty_board_aux(Nc,H),
    NewR is Nr - 1,
    create_empty_board(Nc,NewR,T).
	
create_empty_board_aux(0,[]) :- ! .	
create_empty_board_aux(Nc,[0|H2]) :-
	NewC is Nc - 1,
	create_empty_board_aux(NewC,H2).

remove_pieces(0,_,_,B,B) .
remove_pieces(Nrem,Nc,Nr,B,Bf) :-
	%posicao aleatoria
	random_coords(B,Nr,Nc,R,C,_), 
	%elimina 
	remove_piece(B,R,C,NewB),
	%recalcula
	NewRem is Nrem - 1 ,
	remove_pieces(NewRem,Nc,Nr,NewB,Bf).
	
remove_piece(B,R,C,Bf) :-
	nth0(R,B,Row),
	%muda o elemento na linha
	length(L1,C) ,
	append(L1,[_|L2],Row),
	append(L1,[0|L2],NewRow),
	%muda a linha no board
	length(L3,R),
	append(L3,[_|L4],B),
	append(L3,[NewRow|L4],Bf) .
		
random_coords(B,Nr,Nc,R,C,Elem):-
	%random Row e Col
	random(0,Nc,C),
	random(0,Nr,R), 
	%verifica se essa posicao esta vazia
	nth0(R,B,Row), nth0(C,Row,Elem),
	verify_elem(B,Nr,Nc,R,C,Elem) .
random_coords(B,Nr,Nc,R,C,Elem) :- random_coords(B,Nr,Nc,R,C,Elem) .
	
verify_elem(_,_,_,_,_,1) .
verify_elem(_,_,_,_,_,2) .