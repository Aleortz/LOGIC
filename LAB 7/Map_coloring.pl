% map_coloring.pl
% Map coloring lab using CLP(FD)
% - Uses maplist for applying constraints
% - Pretty-printing by region

:- use_module(library(clpfd)).

% -----------------------------------------------------------------------------
% Color name mapping
% color_name(Code, Name).
% -----------------------------------------------------------------------------
color_name(1, red).
color_name(2, green).
color_name(3, blue).
color_name(4, yellow).

% Alternative mapping list if preferred:
color_names([1-red, 2-green, 3-blue, 4-yellow]).

% -----------------------------------------------------------------------------
% PART A: Australia
% regions_au/1 and edges_au/1 return the list of regions and adjacencies.
% Edges are represented as A-B (undirected; each pair recorded once).
% -----------------------------------------------------------------------------
regions_au([wa, nt, sa, q, nsw, v, t]).

edges_au([
    wa-nt, wa-sa,
    nt-sa, nt-q,
    sa-q, sa-nsw, sa-v,
    q-nsw,
    nsw-v
]).

% -----------------------------------------------------------------------------
% PART B: South America
% Definition of regions and border edges (land borders).
% -----------------------------------------------------------------------------
regions_sa([ar, bo, br, cl, co, ec, gy, gfr, py, pe, su, uy, ve]).

edges_sa([
    ar-bo, ar-br, ar-cl, ar-py, ar-uy,
    bo-br, bo-cl, bo-py, bo-pe,
    br-co, br-gy, br-pe, br-py, br-su, br-uy, br-ve,
    cl-pe,
    co-ec, co-pe, co-ve,
    ec-pe,
    gy-gfr, gy-su, gy-ve,
    gfr-su,
    py-br, py-ar,
    pe-bo, pe-br, pe-cl, pe-co, pe-ec,
    su-br, su-gy, su-gfr,
    uy-ar, uy-br,
    ve-br, ve-co, ve-gy
]).

% -----------------------------------------------------------------------------
% General model predicate: map_color(Regions, Edges, K, Vars)
% - Regions: list of region atoms
% - Edges: list of pairs A-B representing adjacencies
% - K: number of colors (integers 1..K)
% - Vars: list of variables (colors) in the same order as Regions
% -----------------------------------------------------------------------------
map_color(Regions, Edges, K, Vars) :-
    length(Regions, N),
    length(Vars, N),
    % set domain for all region color variables
    Vars ins 1..K,
    % enforce inequality constraint for each edge
    maplist(constrain_edge(Regions, Vars), Edges).

constrain_edge(Regions, Vars, A-B) :-
    nth0(IndexA, Regions, A),
    nth0(IndexB, Regions, B),
    nth0(IndexA, Vars, ColorA),
    nth0(IndexB, Vars, ColorB),
    ColorA #\= ColorB.

% -----------------------------------------------------------------------------
% Wrappers to run the model and label variables
% Labeling strategy can be changed to test different heuristics.
% -----------------------------------------------------------------------------
colorize_au(K, Vars) :-
    regions_au(Regions),
    edges_au(Edges),
    map_color(Regions, Edges, K, Vars),
    labeling([ff], Vars).

colorize_sa(K, Vars) :-
    regions_sa(Regions),
    edges_sa(Edges),
    map_color(Regions, Edges, K, Vars),
    labeling([ff], Vars).

% -----------------------------------------------------------------------------
% Pretty-printing by region: pretty_color_by_region(Regions, Vars)
% -----------------------------------------------------------------------------
pretty_color_by_region([], []).
pretty_color_by_region([R|Rs], [C|Cs]) :-
    (   color_name(C, Name)
    ->  format('~w = ~w~n', [R, Name])
    ;   format('~w = color_~w (no name)~n', [R, C])
    ),
    pretty_color_by_region(Rs, Cs).

% Convenience printers for the specific maps
pretty_color_au :-
    colorize_au(3, Vars),
    regions_au(Regions),
    writeln('AUSTRALIA MAP COLORING (3 colors)'),
    pretty_color_by_region(Regions, Vars).

pretty_color_au_4 :-
    colorize_au(4, Vars),
    regions_au(Regions),
    writeln('AUSTRALIA MAP COLORING (4 colors)'),
    pretty_color_by_region(Regions, Vars).

pretty_color_sa(K) :-
    colorize_sa(K, Vars),
    regions_sa(Regions),
    format('SOUTH AMERICA MAP COLORING (~w colors)~n', [K]),
    pretty_color_by_region(Regions, Vars).

% -----------------------------------------------------------------------------
% Run all tests required by the lab: AU K=3, AU K=4, SA K=3, SA K=4
% -----------------------------------------------------------------------------
test_all :-
    pretty_color_au, nl,
    pretty_color_au_4, nl,
    pretty_color_sa(3), nl,
    pretty_color_sa(4).

% Example queries:
% ?- colorize_au(3, Vars), writeln(Vars).
% ?- regions_au(Rs), edges_au(Es), map_color(Rs, Es, 3, Vs), labeling([ff], Vs), pretty_color_by_region(Rs, Vs).
% ?- pretty_color_sa(4).
