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
								domain(Vars,1,2), !,
								no_2x2(Bf),
								/*connected(Bf),*/
								labeling([],Vars).
								
/*No 2X2 group of cells can contain circles of a single color.*/
no_2x2([_]).
no_2x2([R1,R2|Rn]) :- 	no_2x2_aux(R1,R2),
						no_2x2([R2|Rn]).

no_2x2_aux([_],[_]).						
no_2x2_aux([E1,E2|En],[F1,F2|Fn]) :- 	check_values(E1,E2,F1,F2),
										no_2x2_aux([E2|En],[F2|Fn]).
									
check_values(Elem1,Elem2,Elem3,Elem4) :-	((Elem1 #\= Elem2) #\/ (Elem1 #\= Elem3) #\/ (Elem3#\=Elem4)).

/*Connected Rule
E1 | E2 
F1 | F2 
*/

connected([_]).
connected([R1,R2|Rn]) :- connected_aux(R1,R2),
						connected([R2|Rn]).


connected_aux([_],[_]).						
connected_aux([E1,E2|En],[F1,F2|Fn]) :- ((E1 #= E2 #\/ E1 #= F1) #/\
										(E2 #= E1 #\/ E2 #= F2) #/\
										(F1 #= E1 #\/ F1 #= F2) #/\
										(F2 #= E2 #\/ F2 #= F1)),
										connected_aux([E2|En],[F2|Fn]).	
								
								
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


















					