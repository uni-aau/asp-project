cell(1,1,"c"). cell(1,2,"e"). cell(1,3,"b"). cell(1,4,"b"). cell(1,5,"c").
cell(2,1,"b"). cell(2,2,"e"). cell(2,3,"a"). cell(2,4,"d"). cell(2,5,"e").
cell(3,1,"a"). cell(3,2,"d"). cell(3,3,"a"). cell(3,4,"c"). cell(3,5,"e").
cell(4,1,"c"). cell(4,2,"a"). cell(4,3,"b"). cell(4,4,"e"). cell(4,5,"c").
cell(5,1,"e"). cell(5,2,"b"). cell(5,3,"a"). cell(5,4,"a"). cell(5,5,"a").

% For detailed step by step explanation, see pdf

% Dimensions of grid
row(1..R) :- R = #max { Row : cell(Row, _, _) }.
col(1..C) :- C = #max { Col : cell(_, Col, _) }.

% Generating the candidates for crossing out
{ crossedout(Row, Col, Symbol) } :- cell(Row, Col, Symbol).

% Constraint 1: No symbols appear more than once in any rows
:- cell(Row, Col1, Symbol), cell(Row, Col2, Symbol), 
   Col1 != Col2, 
   not crossedout(Row, Col1, Symbol), not crossedout(Row, Col2, Symbol).

:- cell(Row1, Col, Symbol), cell(Row2, Col, Symbol), 
   Row1 != Row2, 
   not crossedout(Row1, Col, Symbol), not crossedout(Row2, Col, Symbol).

% Constraint 2: Crossed-out symbols must not occur next to each other horizontally or vertically
nextTo(Row1, Col1, Row2, Col2) :- row(Row1), row(Row2), col(Col1), col(Col2), 
                            |Row1 - Row2| + |Col1 - Col2| = 1.
:- crossedout(Row1, Col1, _), crossedout(Row2, Col2, _), nextTo(Row1, Col1, Row2, Col2).


% Constraint 3: % 3) All symbols that are not crossed out should form a contiguous area (considering horizontal and vertical connections). 
% That means that each non-crossed-out symbol must be reached from all other non-crossed-out symbols by moving only horizontally or vertically over non-crossed-out symbols.
reachable(Row, Col, Row, Col) :- cell(Row, Col, _), not crossedout(Row, Col, _).
reachable(Row1, Col1, Row2, Col2) :- reachable(Row1, Col1, Row3, Col3), nextTo(Row3, Col3, Row2, Col2),
                             not crossedout(Row2, Col2, _).
:- cell(Row, Col, _), not crossedout(Row, Col, _), 
   not reachable(Row, Col, Row0, Col0), cell(Row0, Col0, _), not crossedout(Row0, Col0, _).

#show crossedout/3.