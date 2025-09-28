% Lab 1 - Date: 2025-09-20
% Instructor: Israel Pineda, Ph.D.


% Facts: family tree
parent(teresa, rocio).
parent(teresa, irene).
parent(teresa, mercedes).
parent(teresa, pablo).
parent(irene, alejandro).
parent(irene, mafer).
parent(irene, amy).
parent(mercedes, sebastian).
parent(mercedes, karen).
parent(rocio, maria).

% Relations
% grandparent(X,Y): X is grandparent of Y
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% sibling(X,Y): X and Y are siblings, same parent and not equal
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% ancestor(X,Y): X is ancestor of Y (direct or recursive)
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% Food preferences
% likes(Person, Food)
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

% food_friend(X,Y): X and Y like the same food and are different
food_friend(X, Y) :- likes(X, Food), likes(Y, Food), X \= Y.

% Numeric and list predicates
% factorial(N,F): F is N!
factorial(0, 1).
factorial(N, F) :- N > 0, N1 is N - 1, factorial(N1, F1), F is N * F1.

% sum_list(List, S): S is the sum of numbers in List
sum_list([], 0).
sum_list([H|T], S) :- sum_list(T, S1), S is H + S1.

% length_list(List, N): N is the length of List
length_list([], 0).
length_list([_|T], N) :- length_list(T, N1), N is N1 + 1.

% append_list(A,B,R): R is A appended to B
append_list([], L, L).
append_list([H|T], L2, [H|R]) :- append_list(T, L2, R).

% ------------------------------------------------------------------
%Answer
%
% 14) Who are the ancestors of a specific person?
% ?- ancestor(X, alejandro).
% X = irene ;
% X = teresa.
%
% 15) Who are siblings in your family tree?
% ?- sibling(X, Y).
% X = rocio, Y = irene ;
% X = rocio, Y = mercedes ;
% X = rocio, Y = pablo ;
% X = irene, Y = rocio ;
% X = irene, Y = mercedes ;
% X = irene, Y = pablo ;
% X = mercedes, Y = rocio ;
% X = mercedes, Y = irene ;
% X = mercedes, Y = pablo ;
% X = pablo, Y = rocio ;
% X = pablo, Y = irene ;
% X = pablo, Y = mercedes ;
% X = alejandro, Y = mafer ;
% X = alejandro, Y = amy ;
% X = mafer, Y = alejandro ;
% X = mafer, Y = amy ;
% X = amy, Y = alejandro ;
% X = amy, Y = mafer ;
% X = sebastian, Y = karen ;
% X = karen, Y = sebastian.
%
% 16) Who are food friends?
% ?- food_friend(X, Y).
% X = maria, Y = ana ;
% X = maria, Y = alicia ;
% X = maria, Y = tomas ;
% X = ana, Y = maria ;
% X = ana, Y = alicia ;
% X = ana, Y = tomas ;
% X = alicia, Y = maria ;
% X = alicia, Y = ana ;
% X = alicia, Y = tomas ;
% X = tomas, Y = maria ;
% X = tomas, Y = ana ;
% X = tomas, Y = alicia ;
% X = maria, Y = sofia ;
% X = maria, Y = elena ;
% X = sofia, Y = maria ;
% X = sofia, Y = elena ;
% X = elena, Y = maria ;
% X = elena, Y = sofia ;
% X = luis, Y = carlos ;
% X = luis, Y = raul ;
% X = carlos, Y = luis ;
% X = carlos, Y = raul ;
% X = raul, Y = luis ;
% X = raul, Y = carlos.
%
% 17) What is the factorial of 6?
% ?- factorial(6, F).
% F = 720.
%
% 18) What is the sum of [2,4,6,8] ?
% ?- sum_list([2,4,6,8], S).
% S = 20.
%
% 19) What is the length of [a,b,c,d] ?
% ?- length_list([a,b,c,d], N).
% N = 4.
%
% 20) Append [1,2] and [3,4].
% ?- append_list([1,2], [3,4], R).
% R = [1, 2, 3, 4].
% ------------------------------------------------------------------

