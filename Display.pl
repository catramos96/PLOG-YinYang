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
			[1,0,0],
			[0,0,2]		
		]).
board(5,[	
			[0,0,0],
			[0,0,0],
			[0,0,0]		
		]).
		
board(6,[	
			[0,0,2,0,2],
			[0,1,1,0,0],
			[0,0,0,0,2],
			[0,0,0,0,1],
			[0,0,2,0,2]			
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