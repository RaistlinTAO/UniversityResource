/*
 *  oscar_library.pl
 *  Only use predicates exported in module heading in your code!
 */

:- module(oscar_library,
  [ 
    %%% map predicates %%% re-exported from game_predicates %%%
    map_adjacent/3,           % ?-map_adjacent(p(1,5),Pos,O).
    agent_adjacent/3,         % ?-agent_adjacent(A,Pos,O)
    map_distance/3,           % ?-map_distance(p(1,5),p(2,3),D).
    ailp_grid_size/1,
    %%% oscar predicates %%%
    say/2,
    %%% assignment part %%%
    part_module/1,
    %%% moved from oscar.pl file %%%
    shell/0,                  % interactive shell for the grid world
    %%% re-exported from command_channel.pl %%%
    start/0,
    stop/0,
    %%% querying the world %%%
    query_world/2,
    possible_query/2,
    my_agent/1,
    leave_game/0,
    join_game/1,
    start_game/0,
    reset_game/0
  ]
).

:- use_module(library(http/http_client), [http_post/4]).
:- use_module(game_predicates, [map_adjacent/3,ailp_grid_size/1,agent_adjacent/3,map_distance/3]).
:- use_module('../command_channel.pl').
:- set_homepage('oscar.html').

:- dynamic
   part_module/1,
   ailp_internal/1.

% Define part of the assignment
part_module(1).

/*
 *  API 4
 * Contains predicates which allow the communication between the agent/client and the server through http post requests.
 * All predicates allowed to be sent to the server are indicated by possible_query/2.
 *
 * Only use predicates exported in module heading in your code!
 */
referee_queries_path('http://127.0.0.1:8000/agent/queries').

query_world(Pred, Args):-
  possible_query(Pred,Args),
  referee_queries_path(Path),
  term_to_atom(Args, NewArgs),
  http_post(Path,
    form_data([ pred = Pred,
          args = NewArgs
          ]),
    Reply, []),
  term_to_atom(TermReply,Reply),
  ( TermReply = fail -> fail
  ; otherwise-> Args = TermReply
  ).

possible_query(agent_current_energy, [_Agent,_Energy]).
possible_query(agent_current_position, [_Agent,_P]).            % ( agent_current_position, [oscar,P]).
possible_query(internal_lookup_pos, [_Pos, _OID]).              % ( internal_lookup_pos, [p(1,2), empty])
possible_query(internal_check_oracle, [_Agent, _Oracle]).       % ( internal_check_oracle, [9, o(1)]).
possible_query(internal_ask_oracle, [_Agent,_OID,_Q,_L]).       % ( internal_ask_oracle, [4, o(3), link, L)
possible_query(internal_agent_do_moves, [_Agent, _Path]).       % ( internal_agent_do_moves, [ 1, Path]).
possible_query(internal_leave_game, [_Agent]).                  % ( internal_leave_game, [ 2]).
possible_query(internal_join_game, [_Agent]).                   % ( agent_join_game, [Agent]).
possible_query(game_status, [_Status]).                         % ( game_status, [stopped]).
% These do not need to be queried by you and are only used internally
possible_query(internal_start_game, []).
possible_query(ailp_reset, []).


join_game(Agent):-
  ( \+query_world(game_status,[running]) ->
    ( my_agent(Agent) -> format('Your agent has already joined the game')
    ; otherwise       -> query_world(internal_join_game, [Agent]),
                         assert(ailp_internal(agent(Agent)))
    )
  ; otherwise                            -> format('Cannot join! Game has already started')
  ).


leave_game:-
  my_agent(Agent),
  retract(ailp_internal(agent(Agent))),
  query_world(internal_leave_game, [Agent]).

start_game:-
  query_world(internal_start_game, []).

% Returns an agent belonging to the terminal 
my_agent(Agent):-
  ailp_internal(agent(Agent)),!.

reset_game:-
  query_world(ailp_reset, []).

/*
 *  Moved from oscar.pl
 */
%%%%%%%%%% command shell %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

shell :-
  get_input(Input),( Input=stop -> true ; handle_input(Input),shell ).

handle_input(Input) :-
  ( Input = help           -> forall(shell2query(S,Q,_R),(numbervars((S,Q)),writes([S,' -- ',Q])))
  ; Input = demo           -> shell_demo(D),handle_input(D)
  ; Input = [H|T]          -> writes(['? ',H]),handle_input(H),write('<return> to continue'),get_single_char(_),nl,handle_input(T)
  ; Input = []             -> true
  ; shell2query(Input,G,R) -> ( show_response(query(G)),call(G) -> show_response(R) ; show_response('This failed.') )
  ; otherwise              -> show_response('Unknown command, please try again.')
  ).

shell_demo([reset,find(o(1)),ask(o(1),'What is the meaning of life, the universe and everything?'),go(p(7,7)),energy,position,go(p(19,9)),energy,position,call(map_adjacent(p(19,9),_P,_O)),topup(c(3)),energy,go(p(10,10)),energy]).

% get input from user
get_input(Input) :-
  prompt(_,'? '),
  read(Input).

% show answer to user
show_response(R) :-
  ( R=shell(Response)   -> writes(['! ',Response])
  ; R=query(Response)   -> \+ \+ (numbervars(Response),writes([': ',Response]))
  ; R=console(Response) -> my_agent(Agent),term_to_atom(Response,A),do_command([Agent,console,A])
  ; R=both(Response)    -> show_response(shell(Response)),show_response(console(Response))
  ; R=agent(Response)   -> my_agent(Agent),term_to_atom(Response,A),do_command([Agent,say,A])
  ; R=[H|T]             -> show_response(H),show_response(T)
  ; R=[]                -> true
  ; otherwise           -> writes(['! ',R])
  ).

writes(A) :-
  ( A=[]      -> nl
  ; A=nl      -> nl
  ; A=[H|T]   -> writes(H),writes(T)
  ; A=term(T) -> write(T)
  ; otherwise -> write(A)
  ).

% shell2query(+Command, +Goal, ?Response)
shell2query(setup,(join_game(_A),reset_game,start_game),ok).
shell2query(reset,(reset_game,start_game),ok).
shell2query(status,query_world(game_status,[S]),game_status(S)).
shell2query(whoami,my_agent(A),my_agent(A)).
shell2query(position,(my_agent(Agent),get_agent_position(Agent,P)),both(current_position(P))).
shell2query(search,search_bf,ok).
shell2query(ask(S,Q),(my_agent(Agent),agent_ask_oracle(Agent,S,Q,A)),A).
shell2query(call(G),findall(G,call(G),L),L).

 %% Extra predicates
say(Message, Agent) :-
  do_command([Agent, say, Message]).
