/**
 * FLP - Project 2 - Hamiltonian cycle
 *
 * login: xnejed09
 * name: Dominik Nejedly
 * year: 2023
 *
 * Finding all Hamiltonian cycles of a given undirected graph
 */

% Dynamic predicates
% - edge/2            To load input edges into the database.
% - initial_verter/2  To remember initial vertex without passing through parameters.
:- dynamic edge/2, initial_vertex/1.

/**
 * Check if two vertices are connected by an undirected edge.
 *
 * @param  V1  first vertex
 * @param  V2  second vertex
 */
undirected_edge(V1, V2) :- edge(V1, V2); edge(V2, V1).

main :-
    prompt(_, ''),
    load_input_edges,
    setof(V1, V2^undirected_edge(V1, V2), Vs),
    [InitV|_] = Vs, length(Vs, NumOfVs),
    print_unique_cycles(InitV, NumOfVs),
    free_input_edges,
	halt.

/**
 * Read all lines from the standanrd input, parse them
 * and load retrieved edges to the database.
 */
load_input_edges :-
	read_line_without_white(L, C),
	(
        C == end_of_file;
        (
            L = [V1, V2|_],
            char_type(V1, upper),
            char_type(V2, upper),
            \+ undirected_edge(V1, V2) -> (
                assertz(edge(V1, V2)),
                load_input_edges
            ); (
                load_input_edges
            )
        )
	).

/**
 * Free all input edges loaded to the database.
 */
free_input_edges :-
    retractall(edge(_, _)).

/**
 * Read a line from the standard input and remove white spaces from it.
 *
 * @param  L  read line without white spaces
 * @param  C  last read character
 */
read_line_without_white(L, C) :-
	get_char(C),
	(
        is_EOFEOL(C), L = [], !;
        read_line_without_white(LL, _),
        (
            char_type(C, white) -> (
                LL = L
            ); (
                [C|LL] = L
            )
        )
    ).

/**
 * Test a character on EOF or EOL.
 *
 * @param  C  character under test
 */
is_EOFEOL(C) :-
    char_type(C, end_of_file);
    char_type(C, end_of_line).

/**
 * Find and print all unique cycles to the standard output.
 *
 * Sorting is used to filter out duplicate cycles. Each cycle has both the vertices in the edges 
 * and the edges themselves sorted. Duplicate cycles are therefore always identical throughout.
 * Thus, it does not matter in which direction the resulting cycles are found.
 *
 * @param  InitV           vertex from which the search is initiated
 * @param  NumOfVsToCover  number of vertices not covered by the cycle
 */
print_unique_cycles(InitV, NumOfVsToCover) :-
    assertz(initial_vertex(InitV)),
    setof(Cycle, get_cycle(InitV, NumOfVsToCover, [InitV], Cycle), Cycles),
    retract(initial_vertex(_)),
    print_cycles(Cycles).

/**
 * Find a cycle and sort edges in its resulting list.
 *
 * @param  CurrV             currently searched vertex
 * @param  NumOfVsToCover    number of vertices not covered by the searched cycle
 * @param  CoveredVs         list of vertices already covered by the searched cycle
 * @param  Cycle             the resulting cycle (list of sorted edges)
 */
get_cycle(CurrV, NumOfVsToCover, CoveredVs, SortedCycle) :-
    NumOfVsToCover @=< 1, !,
    initial_vertex(InitV),
    undirected_edge(CurrV, InitV),
    format_cycle([InitV|CoveredVs], UnsortedCycle),
    sort(UnsortedCycle, SortedCycle).
get_cycle(CurrV, NumOfVsToCover, CoveredVs, Cycle) :-
    undirected_edge(CurrV, NextV),
    \+ memberchk(NextV, CoveredVs),
    NextNumOfVsToCover is NumOfVsToCover - 1,
    get_cycle(NextV, NextNumOfVsToCover, [NextV|CoveredVs], Cycle).

/**
 * Convert cycle to expected format "<V1>-<V2> <V3>-<V4> ... <Vn-1>-<Vn>".
 * Vertices in each edge are sorted.
 *
 * @param  ListOfVs  list of vertexes to be converted to undirected edges
 * @param  ListOfEs  list of resulting edges
 */
format_cycle([V1, V2], [V1-V2]) :- V1@<V2, !.
format_cycle([V1, V2], [V2-V1]) :- !.
format_cycle([V1, V2|RestOfCycle], [V1-V2|RestOfFormCycle]) :-
    V1@<V2, !, format_cycle([V2|RestOfCycle], RestOfFormCycle).
format_cycle([V1, V2|RestOfCycle], [V2-V1|RestOfFormCycle]) :-
    format_cycle([V2|RestOfCycle], RestOfFormCycle).

/**
 * Print cycles each on a separate line to the standard output.
 *
 * @param  Cycles  list of cycles to be rinted
 */
print_cycles([]) :- !.
print_cycles([Cycle|RestOfCycles]) :-
    print_cycle(Cycle),
    print_cycles(RestOfCycles).

/**
 * Print cycle to standard output.
 *
 * @param  Cycle  cycle to print (list of edges)
 */
print_cycle([LastE]) :-
    writeln(LastE).
print_cycle([E|RestOfEs]) :-
    write(E), write(' '),
    print_cycle(RestOfEs).
