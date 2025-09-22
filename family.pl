% 1. Base de conocimiento de árbol genealógico
parent(teresa,rocio).
parent(teresa, irene).
parent(teresa, mercedes).
parent(teresa, pablo).
parent(irene, alejandro).
parent(irene, mafer).
parent(irene, amy).
parent(mercedes, sebastian).
parent(mercedes, karen).
parent(rocio, maria).

% 3. Reglas para abuelos, hermanos y ancestros
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% 4. Preferencias alimenticias
likes(maria, pizza).
likes(maria, pasta).
likes(ana, pizza).
likes(luis, sushi).
likes(sofia, pasta).
likes(carlos, sushi).
likes(alicia, pizza).
likes(elena, pasta).
likes(raul, sushi).
likes(tomas, pizza).

% 6. Regla food_friend/2: verdaderos si ambos gustan de la misma comida
food_friend(X, Y) :- likes(X, Food), likes(Y, Food), X \= Y.


% 8. Factorial recursivo
factorial(0, 1).
factorial(N, F) :- N > 0, N1 is N - 1, factorial(N1, F1), F is N * F1.

% 9. Suma de lista
sum_list([], 0).
sum_list([H|T], S) :- sum_list(T, S1), S is H + S1.

% 10. Procesamiento de listas

% 11. Longitud de lista
length_list([], 0).
length_list([_|T], N) :- length_list(T, N1), N is N1 + 1.

% 12. Append de listas
append_list([], L, L).
append_list([H|T], L2, [H|R]) :- append_list(T, L2, R).


