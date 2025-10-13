% Lab03: Graph Traversal in Prolog
% Author: Christopher Alejandro Ortiz Bustillos
% Date: 2025-10-13

% -----------------------------------------------------------------------------
% 1. GRAPH DESCRIPTION AND REPRESENTATION
% -----------------------------------------------------------------------------
% The directed graph is specified using the link/2 fact.
% link(X, Y) means there is a directed edge from X to Y.

link(nodeA, nodeB).
link(nodeB, nodeC).
link(nodeA, nodeD).
link(nodeD, nodeC).

% -----------------------------------------------------------------------------
% 2. PATH DEFINITION (RECURSIVE)
% -----------------------------------------------------------------------------
% simple_path(Start, End): true if there is a direct or indirect path.
simple_path(Start, End) :- link(Start, End).
simple_path(Start, End) :- 
    link(Start, Middle),
    simple_path(Middle, End).

% -----------------------------------------------------------------------------
% 3. HANDLING CYCLES (VISITED LIST)
% -----------------------------------------------------------------------------
% To avoid infinite loops in graphs with cycles, keep a list of visited nodes.
% no_cycle_path(Start, End, Visited): true if there is a path from Start to End
% without visiting any node twice. Initial call: no_cycle_path(X, Y, []).

no_cycle_path(Start, End, Visited) :- 
    link(Start, End),
    \+ member(End, Visited).
no_cycle_path(Start, End, Visited) :-
    link(Start, Next),
    \+ member(Next, Visited),
    no_cycle_path(Next, End, [Start|Visited]).

% -----------------------------------------------------------------------------
% 4. FINDING ALL PATHS (findall/3)
% -----------------------------------------------------------------------------
% To get all possible paths from nodeA to nodeC (avoiding cycles):
% Example query: ?- findall(R, full_route(nodeA, nodeC, R), Routes).
% The following rule collects routes as lists of nodes:

full_route(Start, End, Path) :-
    walk(Start, End, [Start], RevPath),
    reverse(RevPath, Path).

% walk(Node, Goal, CurrentPath, FinalPath)
% CurrentPath accumulates visited nodes (in reverse order).
walk(Node, Goal, PathSoFar, [Goal|PathSoFar]) :-
    link(Node, Goal),
    \+ member(Goal, PathSoFar).
walk(Node, Goal, PathSoFar, Path) :-
    link(Node, Next),
    \+ member(Next, PathSoFar),
    walk(Next, Goal, [Next|PathSoFar], Path).

% -----------------------------------------------------------------------------
% 5. CYCLE EXAMPLE
% -----------------------------------------------------------------------------
% To test cycle handling, activate the following line:
% link(nodeC, nodeA).

% -----------------------------------------------------------------------------
% 6. EXTENSION: MAZE EXAMPLE
% -----------------------------------------------------------------------------
% A maze can be represented as a graph: rooms are nodes, doors are links.

% Maze map:
% room1 -- room2 -- room3
%   |                |
% room4 ----------- room5

link(room1, room2).
link(room2, room3).
link(room1, room4).
link(room4, room5).
link(room5, room3).

% Query to check if a path exists from room1 to room3 without cycles:
% ?- no_cycle_path(room1, room3, []).

% To get the route as a list of rooms:
% ?- full_route(room1, room3, Path).
% Path = [room1, room2, room3] ;
% Path = [room1, room4, room5, room3].

% -----------------------------------------------------------------------------
% 7. EXAMPLE QUERIES
% -----------------------------------------------------------------------------
% Main graph:
% ?- simple_path(nodeA, nodeC).
% true.
%
% ?- simple_path(nodeB, nodeA).
% false.
%
% ?- findall(P, full_route(nodeA, node
