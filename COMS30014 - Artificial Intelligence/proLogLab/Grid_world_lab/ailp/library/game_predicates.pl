/*
 * game_predicates.pl
 *
 * Do not call the exported predicates directly, but access them via http through oscar_library.pl!
 *
 */

:- module(game_predicates,
  [ agent_current_position/2, 
    get_agent_position/2,
    agent_current_energy/2,
    get_agent_energy/2,
    internal_ask_oracle/4,
    agent_ask_oracle/4,
    internal_check_oracle/2,
    agent_check_oracle/2,
    internal_agent_do_moves/2,
    agent_do_moves/2,
    internal_poss_step/4,
    internal_leave_game/1,
    internal_join_game/1,
    internal_lookup_pos/2,
    lookup_pos/2,
    game_status/1,
    internal_start_game/0,
    ailp_reset/0,
    map_adjacent/3,
    map_distance/3
  ]
).

:- use_module('../command_channel.pl').
:- use_module('oscar_library.pl',[query_world/2]).

% Dynamic predicates to store internal information 
:- dynamic
  ailp_internal/1,
  ailp_seen/1,
  available_colours/1.

%%%%%%%%%% Changeable Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Available colours in the game, There must be at least as many as the number of players
:- assert(available_colours([purple, blue, beige, white, gray, pink, indianred, khaki, lavender, lightsalmon, mediumaquamarine])).

% There is ALWAYS 1 non playable player, which is used to send some commands
% so X = 11 implies that only 10 real players can join
max_players(X) :-
  X = 2.


internal_grid_size(X) :- 
  ( part_module(0) -> X = 10
  ; part_module(101) -> X = 10
  ; otherwise      -> X = 20).  

ailp_grid_size(X) :- internal_grid_size(X).

get_num(oracle, X) :-
  internal_grid_size(N),
  ( part_module(0)    -> X = 0
  ; part_module(100)  -> X = 1
  ; part_module(101)  -> X = 1
  ; part_module(test) -> X = N/2
  ; otherwise -> fail
  ).
get_num(charging_station, X) :-
  internal_grid_size(N),
  ( part_module(0)    -> X = 0
  ; part_module(100)    -> X = 4
  ; part_module(101)    -> X = 0
  ; part_module(test) -> X = N/10
  ; otherwise -> fail
  ).
% 'thing' = wall
get_num(thing, X) :-
  internal_grid_size(N),
  ( part_module(0)    -> X = 0
  ; part_module(100)    -> X = 80
  ; part_module(101)    -> X = 25
  ; part_module(test) -> X = N*N/4
  ; otherwise -> fail
  ).

%%% End of changeable parameters %%%

%%%%%%%%%% Setup predicates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%randomly generate an unique id for a new agent
new_agent_id(Max,Id) :-
  random(1, Max, PossId),
  ( agent_current_energy(PossId,_) -> new_agent_id(Max,Id)
  ; otherwise                      -> Id = PossId
  ).

colour_agent_position([A,_,_,X,Y]) :-
  agent_colour_path( A,Cpath),
  do_command([A, colour, X,Y,Cpath]),
  atomic_list_concat(['starts at p(',X,',',Y,')'], Message),
  do_command([A,console,Message]).

game_status(S) :-
  ailp_internal(game_status(S)).

% assign drawable features to the agent
% DrawableA has format [AgentId, Shape(n sides), Colour, initialX, initialY]
drawable_agent(A , DrawableA) :-
  random(3, 10, S), % Number of sides
  available_colours(Colours),
  random_member(C, Colours),!,
  select(C,Colours,Colours1),
  retract(available_colours(Colours)),
  assert(available_colours(Colours1)),
  Cpath = C,
  assert(ailp_internal(agent_colour_path(A, Cpath))),
  ( part_module(0) -> X=1, Y=1
  ; part_module(100) -> X=1, Y=1
  ; otherwise      -> random_free_pos(p(X,Y))
  ),
  assert(ailp_internal(agent_position(A, p(X,Y)))),
  internal_topup(Emax),
  assert(ailp_internal(agent_energy(A, Emax))),
  DrawableA = [A,S,C,X,Y].

% assigns a unique numerical id for a new agent
internal_join_game(Agent) :-
  \+game_status(running),
  max_players(Max),
  new_agent_id(Max, Agent),!,
  assert(ailp_internal(agent_energy(Agent, 0))), %temp assert so that ids can be retrieved by ailp_reset
  retractall(ailp_internal(game_status(ready))),
  atomic_list_concat(['Agent ',Agent,' joined game'], Message),
  do_command([Agent,console,Message]).
  
internal_leave_game(Agent) :-
  retract(ailp_internal(agent_position(Agent,_))),
  retract(ailp_internal(agent_energy(Agent,_))),
  retract(ailp_internal(agent_colour_path(Agent,_))),
  do_command([Agent,leave]).

%reset and draw the grid map
ailp_reset :-
  internal_grid_size(N),
  findall(A, (ailp_internal(agent_energy(A,_))), Agents),
  retractall(ailp_internal(_)),
  retractall(ailp_seen(_)),
  retractall(my_agent(_)),
  get_num(charging_station, NC),
  init_things(charging_station,NC),
  get_num(oracle, NO),
  init_things(oracle,NO),
  get_num(thing, NT),
  init_things(thing,NT),
  wp:init_identity,  % defined in wp.pl
  maplist( drawable_agent, Agents, DrawableAgents),
  append( DrawableAgents, [[dyna, 0,red, 1,1]], AllAgents), % adds a dummy agent to use in do_command predicate
  ( part_module(100) -> true
  ; otherwise      -> reset([grid_size=N, cells=[[green,1,1,N,N]], agents=AllAgents]),
                      maplist( colour_agent_position, DrawableAgents),
                      internal_colour_map  % make objects visible at the start
  ),
  assert(ailp_internal(game_status(ready))).

% change game status from ready to running
internal_start_game :-
  % check if map is drawn/updated
  ( \+game_status(ready) -> atomic_list_concat(['Reset the map before starting the game.'], Message),
                            do_command([dyna,console,Message]), fail
  ; otherwise            -> retract(ailp_internal(game_status(_))),
                            assert(ailp_internal(game_status(running)))
  ).
%%%%%%%%%% Map predicates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% internal_lookup_pos(+Pos, ?OID)
% OID = (object at Pos) (Saves using map_adj to map positions)
internal_lookup_pos(Pos, OID) :-
  ground(Pos),
  ( internal_off_board(Pos)                               -> fail
  ; bagof( A, ailp_internal(agent_position(A, Pos)), _As) -> OID = agent
  ; internal_object(O,Pos,_)              -> OID = O
  ; otherwise                                             -> OID = empty
  ).

lookup_pos(Pos,OID) :- 
  query_world(internal_lookup_pos,[Pos,OID]).

% map_adjacent(+Pos, ?AdjPos, ?Occ)
% Occ = empty / agent / c(X) / o(X)  - charging station / oracle and ids
map_adjacent(Pos, AdjPos, OID) :-
  nonvar(Pos),
  internal_poss_step(Pos, _M, AdjPos, 1),
  query_world( internal_lookup_pos, [AdjPos, OID]).

% map_distance(+Pos1, +Pos2, ?Distance)
% Manhattan distance between two grid squares
map_distance(p(X,Y),p(X1,Y1), D) :-
  D is abs(X - X1) + abs(Y - Y1).

random_free_pos(P) :-
  internal_grid_size(N),
  random(1,N,X),
  random(1,N,Y),
  ( check_pos(p(X,Y), empty) -> (P = p(X,Y),!)
  ; otherwise                -> random_free_pos(P)
  ).

map_adj(Pos, AdjPos, OID) :-
  nonvar(Pos),
  internal_poss_step(Pos, _M, AdjPos, 1),
  check_pos(AdjPos, OID).

%%%%%%%%%% Agent predicates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% agent_current_energy(+Agent, -Energy)
agent_current_energy(Agent, Energy) :-
  nonvar(Agent),
  var(Energy),
  ailp_internal(agent_energy(Agent,Energy)),
  atomic_list_concat(['Current energy:',Energy],' ',_A).
  %do_command([Agent,console,A]).

% Exported predicate used by agent
get_agent_energy(Agent,Energy) :-
  query_world(agent_current_energy,[Agent,Energy]).

% agent_current_position(+Agent, -Pos)
agent_current_position(Agent, Pos) :-
  nonvar(Agent),
  var(Pos),
  ailp_internal(agent_position(Agent,Pos)).

% Exported predicate used by agent
get_agent_position(Agent,Pos) :-
  query_world(agent_current_position,[Agent,Pos]).

% internal_ask_oracle(+Agent, +OID, +Question, -Answer)
% Agent's position needs to be map_adj to oracle identified by OID
% fails if oracle already visited by Agent
internal_ask_oracle(Agent, OID, Question, Answer) :-
  nonvar(Agent),
  nonvar(OID),
  ( part_module(100) -> true
  ; otherwise      -> ( game_status(running) -> true
                      ; otherwise            -> do_command([Agent, console, 'start the game first']), fail
                      ),
                      \+ ailp_internal(agent_visited_oracle(Agent, OID))
  ),
  nonvar(Question),
  var(Answer),
  ( part_module(100) -> OID = o(_),
                      internal_object(OID, _AdjPos, Options),
                      member(question(Q)/answer(A),Options),
                      ( Question=Q -> Answer=A ; Answer='I do not know' )
  ; otherwise      -> internal_topup(Emax),
                      Cost is ceiling(Emax/10),
                      ailp_internal(agent_energy(Agent,Energy)),
                      ( Energy>=Cost -> agent_current_position(Agent,Pos),
                                       map_adj(Pos, AdjPos, OID),
                                       OID = o(_),
                                       internal_object(OID, AdjPos, Options),
                                       member( question(Q)/answer(A),Options),
                                       ( Question=Q -> Answer=A ; Answer='42' ),
                                       atomic_list_concat( [Question,Answer],': ',AA),
                                       internal_use_energy( Agent,Cost),
                                       assert( ailp_internal(agent_visited_oracle(Agent, OID)))
                      ; otherwise -> Answer='Sorry, not enough energy',AA=Answer
                      ),
                      do_command([Agent,console,AA])
  ).

agent_ask_oracle(Agent, OID, Question, Answer) :-
  (part_module(100) -> internal_ask_oracle(Agent,OID,Question,Answer)
  ;otherwise -> query_world(internal_ask_oracle,[Agent, OID, Question, Answer])).

% agent_colour_path(+Agent, ?ColourPath)
agent_colour_path(Agent, ColourPath) :-
  nonvar(Agent),
  ailp_internal(agent_colour_path(Agent, ColourPath)).

% internal_check_oracle(+Agent, +OID)
% checks whether oracle already visited by Agent
internal_check_oracle(Agent, OID) :-
  nonvar(Agent),
  nonvar(OID),
  ailp_internal(agent_visited_oracle(Agent, OID)).

agent_check_oracle(Agent,OID) :-
  query_world(internal_check_oracle,[Agent,OID]).

% internal_agent_do_moves(+Agent, +ListOfMoves)
% seperate into individual commands  
internal_agent_do_moves(_, []).
internal_agent_do_moves(Agent, [H|T]) :-
  agent_do_move(Agent, H,Command),
  do_command(Command,_),
  internal_agent_do_moves(Agent,T).

agent_do_moves(A,Moves) :-
  query_world(internal_agent_do_moves,[A,Moves]).

% agent_do_move(+Agent, +To)
% Has constraint that To is map_adj to Agent's current position
% Reduces energy by 1 if step is valid
agent_do_move(Agent,To,Commands) :-
  nonvar(Agent),
  nonvar(To),
  game_status(running),
  agent_current_energy(Agent, F),
  F>0,
  %% check p(X,Y) if To is map_adj to current position and free
  agent_current_position(Agent,Pos),
  map_adj(Pos, To, Obj),
  Obj = empty,!,
  %% send move to server
  p(X,Y) = To,
  agent_colour_path(Agent,Cpath),
  Commands = [[Agent, move, X, Y],[Agent, colour, X, Y, Cpath]],
  %% move was successful so decrease agent energy
  internal_use_energy(Agent,1),
  retract(ailp_internal(agent_position(Agent, _))),
  assert(ailp_internal(agent_position(Agent, To))).
  
%%%%%%%%%% Internal predicates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
internal_topup(Emax) :-
  (part_module(0) -> Emax is 999999
  ;part_module(101) -> Emax is 999999
  ;otherwise      -> (internal_grid_size(N),Emax is ceiling(N*N/4))
  ).
  

compute_step(p(X,Y), M, p(X1,Y1), I) :-
  ( M = s -> X1 =  X,    Y1 is Y+I
  ; M = e -> X1 is X+I,  Y1 =  Y
  ; M = n -> X1 =  X,    Y1 is Y-I
  ; M = w -> X1 is X-I,  Y1 =  Y
  ).

internal_poss_step(P0, M, PossPosition, I) :-
  member(M, [s,e,n,w]), % try moves in this order
  compute_step( P0, M, PossPosition, I).

internal_poss_step(P0, M, PossMoves, PossPosition, I) :-
  random_member(M, PossMoves), % moves randomly to any possible direction
  compute_step(P0, M, PossPosition, I).

% Internal predicate that will always have access to the ground truth
% check_pos(+Pos, ?OID)
check_pos(Pos, OID) :-
  nonvar(Pos),
  ( internal_off_board(Pos)                               -> fail
  ; bagof( A, ailp_internal(agent_position(A, Pos)), _As) -> OID = agent
  ; internal_object(O,Pos,_)                             -> OID = O
  ; otherwise                                             -> OID = empty
  ).

internal_off_board(p(X,Y)) :-
  internal_grid_size(N),
  ( X < 1
  ; X > N
  ; Y < 1
  ; Y > N
  ).

internal_use_energy(Agent,Cost) :-
  nonvar(Agent),
  retract(ailp_internal(agent_energy(Agent, E))),
  E>0, E1 is E - Cost,
  assert(ailp_internal(agent_energy(Agent,E1))),
  ( E1 < 20 -> atomic_list_concat(['WARNING -- Low energy:',E1],' ',A),
               do_command([Agent,console,A])
  ; true
  ).

%% The position and number of these objects changes every time ailp_reset/0 is called
internal_object(c(I),Pos,[]) :-
  ailp_internal(charging_station(I,Pos)).
%% Oracles that have information
internal_object(o(I),Pos,[question(link)/answer(Link)]):-
  ailp_internal(oracle(I,Pos)),
  wp:ailp_identity(A),
  wp:random_link(A,Link).
%% Obstacles (things)
internal_object(t(I),Pos,[]) :-
  ailp_internal(thing(I,Pos)).

% Finds a command that will colour Pos according to Object
% internal_colour_loc(+Object,+Pos,-Command)
internal_colour_loc(O,p(X,Y),Command) :-
  ( O=t(_) -> Colour=black   % obstacle
  ; O=c(_) -> Colour=orange  % charging station
  ; O=o(_) -> Colour=red     % oracle
  ),
  Command = [dyna,colour,X,Y,Colour].

% Creates a queue of commands using internal_colour_loc to shade the grid
internal_colour_map :-
  findall(Command,
  (internal_object(O,Loc,_),
  internal_colour_loc(O,Loc,Command)),
  CommandQueue
  ),
  do_commands(CommandQueue,_).

init_things(Label,Exp) :-
  K is ceiling(Exp),   % round up if Exp evaluates to a fraction
  KK = 99999,
  randset(K,KK,S),
  internal_grid_size(N),
  internal_things(S,N,Label,1).
  
internal_things([],_N,_L,_M).
internal_things([Z|Zs],N,Label,M) :-
  internal_number2pos(Z,N,Pos),
  Fact =.. [Label,M,Pos],
  ( check_pos(Pos, empty) -> assert(ailp_internal(Fact))
  ; otherwise             -> true
  ),
  M1 is M+1,
  internal_things(Zs,N,Label,M1).

% Convert a number to a valid board position 
internal_number2pos(Z,N,p(X,Y)) :-
  K is ceiling(N*N/5),  % roughly one in five cells is an obstacle
  Z1 is mod(Z,K),
  Z2 is (Z-Z1)/K,
  X is mod(Z1,N) + 1,
  Y is mod(Z2,N) + 1.