#!/usr/bin/env swipl
/*
 *  ailp.pl
 *
 *  AI and Logic Programming assignment runner.
 *  Loads and runs specified assignmentN_library.pl file from
 *  assignmentN folder.
 */

% A predicate that checks that links can be gathered for each actor. 
% It is extremely unlikely you will need to use this.
test_wiki_links :-
  bagof(A, wp:actor(A), As),
  test_wiki_link(As).
test_wiki_link([A|As]) :-
  ( wp:actor_links(A, _) -> write(A), write(' OK\n')
  ; otherwise            -> write(A), write(' not working\n')
  ), test_wiki_link(As).
test_wiki_link([]) :- halt.

% Find the appropriate file for the given assingment
find_submission(Assignment, Submission) :-
  directory_files('./', Files),
  ( Assignment='grid' -> find_file('lab_grid_', Files, Submission)
  ; Assignment='identity' -> find_file('lab_identity_',Files, Submission)
  ; Assignment='search'   -> find_file('lab_search_',Files, Submission)
  ).

% Find a file from a list of files matching a prefix
find_file(_, [], _) :- fail.
find_file(Prefix, [F|Files], Submission) :-
  ( check_file(Prefix, F) -> F=Submission
  ; otherwise -> find_file(Prefix, Files, Submission)
  ).

% True if File = Prefix + a number + '.pl'
check_file(Prefix, File) :-
  atom_concat(Basename, '.pl', File),
  atom_concat(Prefix, Candidate, Basename),
  atom_number(Candidate, _).

% Retrieve the assignment name and the part number
translate_input_options(Args, Assignment_name, Part) :-
  ( Args=['lab','grid'|[]]         -> Assignment_name='grid',Part=0
  ; Args=['test_wiki_links'|[]]     -> Assignment_name='oscar',Part=99
  ; Args=['lab','identity'|[]] -> Assignment_name='identity',Part=100
  ; Args=['lab','search'|[]]  -> Assignment_name='search', Part=101
  ; otherwise                       -> fail
  ).

% The initial prompt that opens when you start
read_in_choice(Assignment_name, Part) :-
  nl, write('Please input `> assignment_name [assignment_part]`'),nl,
  write('  e.g. `lab identity` or `lab grid`'),nl,
  write('> '), read_line_to_codes(user_input, InputCodes),
  atom_codes(InputAtom, InputCodes),
  atomic_list_concat(InputList, ' ', InputAtom),
  ( translate_input_options(InputList, Assignment_name, Part) -> true
  ; read_in_choice(Assignment_name, Part)
  ).

:- dynamic
     user:prolog_file_type/2,
     user:file_search_path/2.

:- multifile
     user:prolog_file_type/2,
     user:file_search_path/2.

:-  % parse command line arguments
    current_prolog_flag(argv, Args),
    % take first argument to be the name of the assignment folder
    ( translate_input_options(Args, Assignment_name, Part) -> true
    ; % missing argument, so display syntax and halt
       nl,
       write('Syntax:'),nl,
       nl,
       write('  ./ailp.pl <assignment_name> [part]'),nl,
       write('e.g. ./ailp.pl lab identity'),nl,
       write('or'),nl,
       write('e.g. ./ailp.pl lab grid'),nl,
       nl,
       write('~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+~+'),nl,
       nl,
       read_in_choice(Assignment_name, Part)
    ),
    assert(assignment(Assignment_name)),
    assert(sub_assignment(Part)).

get_assignment_details :- 
    assignment(Assignment_name),
    sub_assignment(Assignment_part),
    
    % define a module path assignment_root(./)
    prolog_load_context(directory, Sys),
    (\+ user:file_search_path(assignment_root, Sys)
    ->  asserta(user:file_search_path(assignment_root, Sys))
    ),
    
    % define our own ailp path assignment_ailp(./ailp)
    atom_concat(Sys, '/ailp', Ailp),
    (\+ user:file_search_path(assignment_ailp, Ailp)
    ->  asserta(user:file_search_path(assignment_ailp, Ailp))
    ),
    
    % define our own Library path assignment_library(./ailp/library)
    atom_concat(Ailp, '/library', Lib),
    (\+ user:file_search_path(assignment_library, Lib)
    ->  asserta(user:file_search_path(assignment_library, Lib))
    ),
    
    % find candidate submission
    find_submission(Assignment_name, Submission),
    
    % load files
    load_files(
      [ 
        assignment_root(Submission)
      ],
      [ silent(true)
      ]
    ),
    
    % load part specific files
    ( Assignment_part=0  ->use_module(assignment_library('wp_library')),
                           use_module(assignment_library('oscar_library'), [part_module/1,shell/0,start/0,stop/0,
                                                                            my_agent/1,
                                                                            leave_game/0,join_game/1,start_game/0, ailp_grid_size/1,
                                                                            reset_game/0,say/2
                                                                                    ]
                                     ),
                           use_module(assignment_library('game_predicates'), [lookup_pos/2,get_agent_position/2,agent_do_moves/2]),
                           find_submission('grid',GridSubmission),
                           load_files([assignment_root(GridSubmission)],[silent(true)]),
                           retract(part_module(1)), assertz(part_module(0))
    ; Assignment_part=99 -> use_module(assignment_library('wp_library')),test_wiki_links
    ; Assignment_part=100 -> use_module(assignment_library('wp_library')),
                           use_module(assignment_library('oscar_library'), [part_module/1]),
                           use_module(assignment_library('game_predicates'), [agent_ask_oracle/4]),
                           retract(part_module(1)), assertz(part_module(100)),
                           game_predicates:ailp_reset
    ; Assignment_part=101 -> use_module(assignment_library('wp_library')),
                           use_module(assignment_library('oscar_library'), [part_module/1,shell/0,start/0,stop/0,
                                                                            my_agent/1, map_adjacent/3,
                                                                            leave_game/0,join_game/1,start_game/0, ailp_grid_size/1,
                                                                            reset_game/0,say/2
                                                                                    ]
                                     ),
                           use_module(assignment_library('game_predicates'), [lookup_pos/2,get_agent_position/2,agent_do_moves/2]),
                           find_submission('search',SearchSubmission),
                           load_files([assignment_root(SearchSubmission)],[silent(true)]),
                           retract(part_module(1)), assertz(part_module(101))

    ; otherwise         -> true
    ).

:-get_assignment_details.
