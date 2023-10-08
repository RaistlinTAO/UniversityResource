% True if A is a possible movement direction
m(A).

% True if p(X,Y) is on the board
on_board(p(X,Y)) :- 
    true.

% True if p(X1,Y1) is one step in direction M from p(X,Y) (no bounds check)
pos_step(p(X,Y), M, p(X1,Y1)) :-
    true.

% True if NPos is one step in direction M from Pos (with bounds check)
new_pos(Pos,M,NPos) :-
    true.

% True if a L has the same length as the number of squares on the board
complete(L) :-
    true.

% Perform a sequence of moves creating a spiral pattern, return the moves as L
spiral(L) :-
    true.
