/*
PLOG - YING YANG
ATENÇÃO: Mudar a fonte de letra para Consola
*/

:-use_module(library(clpfd)).
:-use_module(library(lists)).

/*
1 - black
2 - white
*/
board(1,[	
			[0,0,0,0,0,0],
			[0,0,0,2,0,0],
			[0,0,2,2,1,0],
			[0,1,0,0,1,1],
			[2,0,1,0,2,0],
			[0,2,0,0,0,2]			
		]).
		
board(2,[	
			[0,0,0,0,0,0],
			[0,0,0,0,0,0],
			[0,0,0,0,0,0],
			[0,0,0,0,0,0],
			[0,0,0,0,0,0],
			[0,0,0,0,0,0]			
		]).
		
board(3,[	
			[1,0,0,1],
			[0,2,1,0],
			[0,1,0,0],
			[0,0,0,2]		
		]).
		
board(4,[	
			[0,0,0],
			[0,0,0],
			[0,0,0]		
		]).
board(5,[	
			[0,0,0],
			[0,0,0],
			[0,0,0]		
		]).
		
/*
DISPLAY
*/
display_board(ID) :- board(ID,M) , display_board(M).
display_board([R1|Rn]) :-   length(R1,NColumns),
							display_first_line(NColumns,1), nl, !,
							display_mid_lines([R1|Rn],NColumns), !,
							display_last_line(NColumns,1),nl, !.
							
display_first_line(NC,1) :-		display_symbol(9487), 
								display_symbol(9473), display_symbol(9473), display_symbol(9473),
								display_first_line(NC,2).
display_first_line(NC,C) :-		C is NC + 1, display_symbol(9491).
display_first_line(NC,C) :-		display_symbol(9523), 
								display_symbol(9473), display_symbol(9473), display_symbol(9473),
								C1 is C + 1,
								display_first_line(NC,C1).
	
display_last_line(NC,1)	:- 		display_symbol(9495), 
								display_symbol(9473), display_symbol(9473), display_symbol(9473),
								display_last_line(NC,2).
display_last_line(NC,C)	:-		C is NC + 1, display_symbol(9499).
display_last_line(NC,C)	:-		display_symbol(9531), 
								display_symbol(9473), display_symbol(9473), display_symbol(9473),
								C1 is C + 1,
								display_last_line(NC,C1).

display_mid_lines([R],_)	:-		display_line_1(R), nl.						
display_mid_lines([R1|Rn],NColumns) :- 	display_line_1(R1), nl,
										display_limits(NColumns,1),nl,
										display_mid_lines(Rn,NColumns).

display_line_1([]) :- 		display_symbol(9475).
display_line_1([C1|CN]) :- 	display_symbol(9475), write(' '), display_cell(C1), write(' '),
							display_line_1(CN).
								
display_limits(NC,1) :- display_symbol(9507),
						display_symbol(9473), display_symbol(9473), display_symbol(9473),
						display_limits(NC,2).
						
display_limits(NC,C) :- C is NC + 1, display_symbol(9515).
display_limits(NC,C) :- display_symbol(9547), 
						display_symbol(9473), display_symbol(9473), display_symbol(9473),
						C1 is C + 1,
						display_limits(NC,C1).
								

display_cell(2) :- display_symbol(9675).
display_cell(1) :- display_symbol(9679).
display_cell(0) :- write(' ').

display_symbol(Code) :- char_code(Char,Code), write(Char).

/*
SOLUTION
1-b
2-w
*/

ying_yang :- 	write('board:'), read(N), nl,
				board(N,B), !,
				write('unresolved'),nl,
				display_board(B), nl, !,
				solve_ying_yang(B,R),
				write('resolved'),nl,
				display_board(R).
				

solve_ying_yang(Bi,Bf) :-		load_vars(Bi,[],Bf,[],Vars),
								domain(Vars,1,2),
								connected(Bf),
								no_2x2(Bf),
								regions(Bf),
								labeling([ffc],Vars).
								
/*No 2X2 group of cells can contain circles of a single color.*/
no_2x2([_]).
no_2x2([R1,R2|Rn]) :- 	no_2x2_aux(R1,R2),
						no_2x2([R2|Rn]).

no_2x2_aux([_],[_]).						
no_2x2_aux([E1,E2|En],[F1,F2|Fn]) :- 	check_values(E1,E2,F1,F2),
										no_2x2_aux([E2|En],[F2|Fn]).
									
check_values(Elem1,Elem2,Elem3,Elem4) :-	((Elem1 #\= Elem2) #\/ (Elem1 #\= Elem3) #\/ (Elem3#\=Elem4)).

/*Connected Rule
E1 | E2 | E3 -> first row
F1 | F2 | F3 -> mid row
G1 | G2 | G3 -> last row
*/

connected([R1,R2,R3|Rn]) :- 	connected_first_row(R1,R2),
								connected_other_rows([R1,R2,R3|Rn]).
								
connected_corner(Corner,A,B) :- (Corner #= A #\/ Corner #= B).
connected_limit(A,B,C,D) :- (A #= B #\/ A #= C #\/ A #= D).
connected_center(Center,A,B,C,D) :- (Center #= A #\/ Center #= B #\/ Center #= C #\/ Center #= D).

/*
E1 | E2 | E3 | E4 | E5 -> first row
F1 | F2 | F3 | F4 | F5 -> second row

connected_corner 		= E1->E2 || E1->F1
connected_first_row_aux = E2->E1 || E2-F2 || E2->E3  ... E3-> ... E4->
connected_corner		= E5->E4 || E5->F5
*/						

connected_first_row([Cx1,Cx2,Cx3|Cxn],[Cy1,Cy2,Cy3|Cyn]) :- connected_corner(Cx1,Cx2,Cy1), 			/*left corner*/
															connected_first_row_aux([Cx1,Cx2,Cx3|Cxn],[Cy1,Cy2,Cy3|Cyn]).

connected_first_row_aux([Cxn,Cxn1],[_,Cyn1]) :- 				connected_corner(Cxn1,Cxn,Cyn1).	/*right corner*/
connected_first_row_aux([Cx1,Cx2,Cx3|Cxn],[_,Cy2,Cy3|Cyn]) :-	connected_limit(Cx2,Cx1,Cx3,Cy2),	/*top limit cells*/
																connected_first_row_aux([Cx2,Cx3|Cxn],[Cy2,Cy3|Cyn]).
															

/*
E1 | E2 | E3 | E4 | E5 -> row n
F1 | F2 | F3 | F4 | F5 -> row n1
G1 | G2 | G3 | G4 | G5 -> row n2
*/
connected_other_rows([Rn,Rn1]) :-	connected_last_row(Rn,Rn1).
connected_other_rows([[Cx1|Cxn],[Cy1,Cy2|Cyn],[Cz1|Czn]|Rn]) :- 	connected_limit(Cy1,Cx1,Cy2,Cz1), 	/*left limit*/
																	connected_other_rows_aux([Cx1|Cxn],[Cy1,Cy2|Cyn],[Cz1|Czn]),
																	connected_other_rows([[Cy1,Cy2|Cyn],[Cz1|Czn]|Rn]).

connected_other_rows_aux([_,_,Cx3],[_,Cy2,Cy3],[_,_,Cz3])	:-					connected_limit(Cy3,Cx3,Cy2,Cz3). 						/*right limit*/												
connected_other_rows_aux([_,Cx2,Cx3|Cxn],[Cy1,Cy2,Cy3|Cyn],[_,Cz2,Cz3|Czn]) :-	connected_center(Cy2,Cx2,Cy1,Cy3,Cz2),	/*center cells*/
																				connected_other_rows_aux([Cx2,Cx3|Cxn],[Cy2,Cy3|Cyn],[Cz2,Cz3|Czn]).

/*
E1 | E2 | E3 | E4 | E5 -> before last row
F1 | F2 | F3 | F4 | F5 -> last row
*/

connected_last_row([Cx1,Cx2,Cx3|Cxn],[Cy1,Cy2,Cy3|Cyn]) :- 	connected_corner(Cy1,Cy2,Cx1), 			/*left corner*/
															connected_last_row_aux([Cx1,Cx2,Cx3|Cxn],[Cy1,Cy2,Cy3|Cyn]).

connected_last_row_aux([_,Cxn1],[Cyn,Cyn1]) :- 				connected_corner(Cyn1,Cyn,Cxn1).		/*right corner*/
connected_last_row_aux([_,Cx2,Cx3|Cxn],[Cy1,Cy2,Cy3|Cyn]) :-	connected_limit(Cy2,Cy1,Cy3,Cx2), 	/*bottom limit cells*/
																connected_last_row_aux([Cx2,Cx3|Cxn],[Cy2,Cy3|Cyn]).
	
/*
Regions Rule - Only 2 regions: white and black
*/

count_eq(_Val,[],0).							%count_eq
count_eq(Val,[H|T],C) :-	Val #= H #<=> V,		
							C #= V + C2,
							count_eq(Val,T,C2).

regions(Bf) :-  	board_size(Bf,NR,NC,_),
					flat_board(Bf,FB),
					element(I,FB,1),
					element(J,FB,2),
					region(FB,1,I,NR,NC,[],RA),
					region(FB,2,J,NR,NC,[],RB).
				
/*
T1 - Indices com o valor = 1 já percorridoss
T2 - Indices com o valor = 2 já percorridos
*/
region(Board,V,I,NR,NC,T,F) :- 	(Vn #= 1 #\/ Vn #= 2) #/\ (VT #= 0 #\/ VT #= 1),	
									element(I,Board,Vn),
									count_eq(I,T,VT),
									region_aux(V,Vn,VT,Board,I,NR,NC,T,F).
							

region_aux(1,2,_,_,_,_,_,F,F) :- write('End 2'),nl.
region_aux(2,1,_,_,_,_,_,F,F) :- write('End 3'),nl.
region_aux(V,V,1,_,I,_,_,T,F) :- count_eq(I,T,1).
region_aux(V,V,0,Board,I,NR,NC,T,F) :- 		append(T,[I],T2),
											calc_index(I,R,C,NR,NC),
											(R0 #= R-1 #/\ R1 #= R+1 #/\ I0 #= I-1 #/\ I1 #= I+1),
											calc_index(I2,R0,C,NR,NC), calc_index(I3,R1,C,NR,NC),

											region(Board,V,I1,NR,NC,T2,T3),  	%left
											region(Board,V,I3,NR,NC,T3,T4), 	%bottom
											region(Board,V,I0,NR,NC,T4,T5),  	%right
											region(Board,V,I2,NR,NC,T5,F). 		%top
								

same_lists([],[],1).										
same_lists([X|Xn],[Y|Yn],C) :- 	X #= Y,
								same_lists(Xn,Yn,C).
same_lists(_,_,0).							
have_elements([],_).
have_elements([X|Xn],Y) :- count_eq(X,Y,1), have_elements(Xn,Y).

						
																		
board_size([R1|Rn],NRows,NColumns,NCells) :- 	length([R1|Rn],NRows), length(R1,NColumns),
												NCells is NRows * NColumns.

flat_board([],[]).												
flat_board([R1|Rn],BoardFlat) :- 	append(R1,T,BoardFlat),
									flat_board(Rn,T).
									
calc_index(I,R,C,NR,NC) :- 	(I #> 0 #/\ I #=< NR*NC), 
							(I #= (R - 1)*NC + C).
							
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


















					