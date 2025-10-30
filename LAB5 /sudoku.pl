% Lab 5: Sudoku Solver using Constraint Logic Programming
% Author: Aleortz
% University: YachayTech
%
% This solution implements a Sudoku solver using CLPFD (Constraint Logic Programming
% over Finite Domains). The program uses constraints to declaratively specify the
% Sudoku rules and lets the constraint solver find solutions efficiently. The main
% predicates handle board representation, constraint application, and solution
% visualization.
% -----------------------------------------------------------------------------

:- use_module(library(clpfd)).

% -----------------------------
% 1) Main Sudoku solver predicate
% -----------------------------
% sudoku(Rows): Solves a 9x9 Sudoku puzzle represented as a list of 9 lists
% Each internal list represents a row with numbers 1-9 or variables
sudoku(Rows) :-
    length(Rows, 9),
    maplist(same_length(Rows), Rows),
    append(Rows, Vs),         % Unifica todas las variables en una lista
    Vs ins 1..9,             % Establece el dominio de las variables (1-9)
    maplist(all_distinct, Rows),                    % Restricción por filas
    transpose(Rows, Columns),                       % Obtiene las columnas
    maplist(all_distinct, Columns),                 % Restricción por columnas
    Rows = [A,B,C,D,E,F,G,H,I],                    % Descompone en filas
    blocks(A, B, C), blocks(D, E, F), blocks(G, H, I). % Restricción por bloques 3x3

% -----------------------------
% 2) 3x3 Block constraints
% -----------------------------
% blocks/3: Verifica que cada bloque 3x3 contenga números diferentes
blocks([], [], []).
blocks([A,B,C|Bs1], [D,E,F|Bs2], [G,H,I|Bs3]) :-
    all_distinct([A,B,C,D,E,F,G,H,I]),
    blocks(Bs1, Bs2, Bs3).

% -----------------------------
% 3) Output formatting
% -----------------------------
% print_sudoku/1: Muestra el tablero de Sudoku de manera formateada
print_sudoku([]).
print_sudoku([Row|Rows]) :-
    write(Row), nl,
    print_sudoku(Rows).

% -----------------------------
% 4) Example puzzle
% -----------------------------
% example/2: Define un puzzle de Sudoku para pruebas
example(1, [
    [5,3,_,_,7,_,_,_,_],
    [6,_,_,1,9,5,_,_,_],
    [_,9,8,_,_,_,_,6,_],
    [8,_,_,_,6,_,_,_,3],
    [4,_,_,8,_,3,_,_,1],
    [7,_,_,_,2,_,_,_,6],
    [_,6,_,_,_,_,2,8,_],
    [_,_,_,4,1,9,_,_,5],
    [_,_,_,_,8,_,_,7,9]
]).
