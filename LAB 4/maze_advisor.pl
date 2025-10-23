% Name: Christopher Ortiz
% University: YachayTech
%
% In this solution, reasoning is modeled through logical rules that determine
% the possibility of movement (can_move/2) and explain the status of each
% transition (reason/3). The predicate can_move/2 combines declarative
% knowledge (graph edges and blocking constraints) to derive valid actions,
% while reason/3 justifies those actions with human-readable explanations.
% The recursive traversal (move/4) performs depth-first search, prints decision
% traces at each step, and prevents cycles using a visited list.
% find_path/3 orchestrates the search and returns a valid path; additionally,
% why/2 explains local causes and find_path_stats/5 records metrics (number of
% steps and visited nodes). Altogether, recursion, graphs, and rules are
% integrated to produce both intelligent behavior and its explanation.
% -----------------------------------------------------------------------------

% -----------------------------
% 4) Base facts (graph representation and blockages)
% -----------------------------
edge(entrance, a).
edge(a, b).
edge(a, c).
edge(b, exit).
edge(c, b).

% Door is blocked from a to c.
blocked(a, c).

% -----------------------------
% 5) Reasoning rules
% -----------------------------
% A move is possible if there is an edge and it is not blocked.
can_move(X, Y) :-
    edge(X, Y),
    \+ blocked(X, Y).

% Explanations:
reason(X, Y, 'path is open') :-
    can_move(X, Y).

reason(X, Y, 'path is blocked') :-
    blocked(X, Y).

% Additional explanation: destination reached
reason(_X, Y, 'destination reached') :-
    Y == exit.

% -----------------------------
% 6) Recursive traversal with explanation (DFS)
% -----------------------------
% Base case: can move directly from X to Y. Prints the action taken.
move(X, Y, Visited, [Y|Visited]) :-
    can_move(X, Y),
    format('Moving from ~w to ~w.~n', [X, Y]).

% Recursive case: explore a reachable, unvisited neighbor Z and try to reach Y from Z.
move(X, Y, Visited, Path) :-
    can_move(X, Z),
    \+ member(Z, Visited),
    format('Exploring from ~w to ~w...~n', [X, Z]),
    move(Z, Y, [Z|Visited], Path).

% -----------------------------
% 7) Main predicate
% -----------------------------
find_path(X, Y, Path) :-
    move(X, Y, [X], RevPath),
    reverse(RevPath, Path).

% -----------------------------
% Optional extensions (Part 5)
% -----------------------------

% 5.2) why/2 explains local reasoning between two nodes.
% Prints all applicable reasons (if any).
why(X, Y) :-
    (   findall(R, reason(X, Y, R), Reasons),
        Reasons \= []
    ->  forall(member(Ri, Reasons),
               format('From ~w to ~w: ~w.~n', [X, Y, Ri]))
    ;   ( edge(X, Y)
        -> format('From ~w to ~w: no explicit reason matched.~n', [X, Y])
        ;  format('No direct edge from ~w to ~w; reasoning not applicable.~n', [X, Y])
       )
    ).

% 5.1) "Left" 
% Generate neighbors sorted to explore the "smaller" ones first.
neighbors_left_first(X, Sorted) :-
    findall(Y, can_move(X, Y), Ys),
    sort(Ys, Sorted).

% Traversal variant
move_leftpref(X, Y, Visited, [Y|Visited]) :-
    can_move(X, Y),
    format('Moving from ~w to ~w.~n', [X, Y]).
move_leftpref(X, Y, Visited, Path) :-
    neighbors_left_first(X, Neighs),
    member(Z, Neighs),
    \+ member(Z, Visited),
    format('Exploring from ~w to ~w...~n', [X, Z]),
    move_leftpref(Z, Y, [Z|Visited], Path).

% 5.3) Performance tracking: number of steps and visited nodes.
% We count one "step" per move between nodes.
find_path_stats(X, Y, Path, Steps, VisitedNodes) :-
    move_stats(X, Y, [X], RevPath, 0, Steps),
    reverse(RevPath, Path),
    sort(RevPath, VisitedSet),
    length(VisitedSet, VisitedNodes).

% Base case with counters: move directly from X to Y (1 step).
move_stats(X, Y, Visited, [Y|Visited], StepsIn, StepsOut) :-
    can_move(X, Y),
    format('Moving from ~w to ~w.~n', [X, Y]),
    StepsOut is StepsIn + 1.

% Recursive case with counters.
move_stats(X, Y, Visited, Path, StepsIn, StepsOut) :-
    can_move(X, Z),
    \+ member(Z, Visited),
    format('Exploring from ~w to ~w...~n', [X, Z]),
    StepsMid is StepsIn + 1,
    move_stats(Z, Y, [Z|Visited], Path, StepsMid, StepsOut).


% ----------------------------------------------------------------------------
% Explanatory paragraph
% ----------------------------------------------------------------------------
% In this solution, reasoning is modeled through logical rules that determine
% the possibility of movement (can_move/2) and explain the status of each
% transition (reason/3). The predicate can_move/2 combines declarative
% knowledge (graph edges and blocking constraints) to derive valid actions,
% while reason/3 justifies those actions with human-readable explanations.
% The recursive traversal (move/4) performs depth-first search, prints decision
% traces at each step, and prevents cycles using a visited list.
% find_path/3 orchestrates the search and returns a valid path; additionally,
% why/2 explains local causes and find_path_stats/5 records metrics (number of
% steps and visited nodes). Altogether, recursion, graphs, and rules are
% integrated to produce both intelligent behavior and its explanation.

% -----------------------------------------------------------------------------
% Answer: Test queries and results
% -----------------------------------------------------------------------------
%
% 1) Path from entrance to exit (with trace)
% ?- find_path(entrance, exit, Path).
% Exploring from entrance to a...
% Exploring from a to b...
% Moving from b to exit.
% Path = [entrance, a, b, exit].
%
% 2) Path with metrics (steps and visited nodes)
% ?- find_path_stats(entrance, exit, Path, Steps, VisitedNodes).
% Exploring from entrance to a...
% Exploring from a to b...
% Moving from b to exit.
% Path = [entrance, a, b, exit],
% Steps = 3,
% VisitedNodes = 4.
%
% 3) Local explanation of the block
% ?- why(a, c).
% From a to c: path is blocked.
% true.
%
% 4) No-solution case towards c
% ?- find_path(entrance, c, Path).
% Exploring from entrance to a...
% Exploring from a to b...
% Exploring from b to exit...
% false.
%
% 5) Show path and accumulated reverse list
% ?- move(entrance, exit, [entrance], Rev), reverse(Rev, Path).
% Exploring from entrance to a...
% Exploring from a to b...
% Moving from b to exit.
% Path = [entrance, a, b, exit],
% Rev = [exit, b, a, entrance].
%
% 6) Allowed move from a to b
% ?- can_move(a, b).
% true.
%
% 7) Blocked move from a to c
% ?- can_move(a, c).
% false.
%
% 8) Reason for a -> b
% ?- reason(a, b, R).
% R = 'path is open'.
%
% 9) Reason for a -> c
% ?- reason(a, c, R).
% R = 'path is blocked'.
%
% 10) Reasons for b -> exit (multiple)
% ?- reason(b, exit, R).
% R = 'path is open' ;
% R = 'destination reached'.
%
% 11) Traversal with "left" (alphabetical) preference
% ?- move_leftpref(entrance, exit, [entrance], Rev), reverse(Rev, Path).
% Exploring from entrance to a...
% Exploring from a to b...
% Moving from b to exit.
% Path = [entrance, a, b, exit],
% Rev = [exit, b, a, entrance].
% -----------------------------------------------------------------------------
