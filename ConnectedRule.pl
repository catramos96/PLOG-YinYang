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