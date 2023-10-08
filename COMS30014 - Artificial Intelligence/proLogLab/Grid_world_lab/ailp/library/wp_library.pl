/*
 *  wp.pl
 *  Wikipedia stuff
 */

:- module(wp,
  [ wp/1,
    wp/2,
    wt_link/2,
    actor/1,
    link/1,
    init_identity/0,
    test/0
  ]
).

:- use_module(library(http/http_open)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_client)).
:- use_module(library(http/json)).
:- use_module(library(www_browser)).

% Used to cache all Wikipedia pages fetched during one Prolog session
:- dynamic wp_cache/2.

%%%%%%%%%% Wikipedia interaction %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Issue query Q to Wikipedia and return the page in wikitext format
% wp(+Query, -WikiText)
wp(Q,WT) :-
  wp_cache(Q,WT),!.
wp(Q,WT) :-
  wp_query2URL(Q,URL),
  http_open(URL, R, []),
  json_read(R, RR, []),
  close(R),
  %http_get(URL,R,[]),
  %atom_json_term(R,RR,[]),
  wt_get(RR,WT0),
  ( atomic_list_concat1(_L,'#REDIRECT',WT0) -> wt_link(WT0,QQ),wp(QQ,WT)
  ; otherwise -> WT=WT0
  ),
  assert(wp_cache(Q,WT)).

% Issue query Q to Wikipedia and write the page in wikitext format to stdout
% wp(+Query)
wp(Q) :-
  wp(Q,WT),
  atomic_list_concat(L,'\n',WT),  % split text T into segments separated by newlines
  writelns(L).  % write the list of segments

% Issue query Q to Wikipedia and return the person's persondata
% wppd(+Query, -PersonData)
wppd(Q,PD) :-
  wp(Q,WT),
  wt_persondata(WT,PD).

% assemble query Q into a URL to retrieve the page in JSON format
wp_query2URL(Q,URL) :-
  atomic_list_concat(QW,' ',Q),  % split query Q into words QW
  atomic_list_concat(QW,'%20',QQ),  % reassemble query QQ with '%20' between words from QW
  atomic_list_concat([
    'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=',
    QQ,
    '&prop=revisions&rvprop=content&rvslots=main&rawcontinue'
    ],URL).

%%%%%%%%%% JSON operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% decompose JSON Prolog term T until wikitext component is located
wt_get(J,Text) :-
  ( J = ('*'=Text) -> true
  ; J = (json(L)) -> wt_get(L,Text)
  ; J = (_=json(L)) -> wt_get(L,Text)
  ; J = (_=L) -> wt_get(L,Text)
  ; J = [H|T] -> ( wt_get(H,Text) ; wt_get(T,Text) )
  ).

% find bracketed elements; only works if unnested
wt_element(WT,Begin,End,Element) :-
  atomic_list_concat1(Ls,Begin,WT),
  member(X,Ls),
  atomic_list_concat1([Element|_],End,X),
  Element \= ''.

wt_link(WT,Link) :-
  wt_link(WT,Link,_Anchor,_WT_Link).

wt_link(WT,Link,Anchor,WT_Link) :-
  wt_element(WT,'[[',']]',Link0),
  ( atomic_list_concat1([Link,Anchor],'|',Link0) -> true
  ; otherwise -> Link=Link0, Anchor=Link0
  ),
  atomic_list_concat(['[[',Link0,']]'],WT_Link).

wt_template(WT,Template,WT_Template) :-
  wt_element(WT,'{{','}}',Template),
  atomic_list_concat(['{{',Template,'}}'],WT_Template).

wt_ref(WT,Ref,WT_Ref) :-
  wt_element(WT,'<ref>','</ref>',Ref),
  atomic_list_concat(['<ref>',Ref,'</ref>'],WT_Ref).

wt_persondata(WT,PD) :-
  wt_template(WT,Template,_WT_Template),
  ( atomic_list_concat(['',PD0],'Persondata',Template) -> atomic_list_concat(PD1,'|',PD0)
  ; atomic_list_concat(['',_,PD0],'Persondata',Template) -> atomic_list_concat(PD1,'|',PD0)
  ),get_persondata(PD1,PD).

get_persondata([],[]).
get_persondata([X|Xs],Out) :-
  ( atomic_list_concat1(L,=,X) ->
    ( L = [_A,'\n'] -> Out = Ys
    ; L = [_A,' ']  -> Out = Ys
    ; L = [A,B]     -> Out = [A=B|Ys]
    )
  ; otherwise -> Out = Ys  % skip X if it doesn't contain =
  ),
  get_persondata(Xs,Ys).

%%%%%%%%%% Utilities %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write a list of items with a newline after each
writelns([]) :- nl.
writelns([H|T]) :-
  write(H),nl,
  writelns(T).

% version of atomic_list_concat/3 that fails if separator doesn't occur
atomic_list_concat1(L, S, A) :-
  atomic_list_concatN(N, L, S, A),
  N>0.

atomic_list_concatN(N, L, S, A) :-
  atomic_list_concat(L, S, A),
  length(L,N0), N is N0-1.


%%%%%%%%%% Actors and links %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
actor('Billy Bob Thornton').
actor('Frances McDormand'). % edited Wikipedia page on 15/10/2021 to add reference in passing to her uncredited cameo in Barton Fink!
actor('Gabriel Byrne').
actor('George Clooney').
actor('Holly Hunter').
actor('Jeff Bridges').
actor('John Goodman').
actor('John Turturro').
actor('Julianne Moore').
actor('Scarlett Johansson').
actor('Steve Buscemi').
actor('Tom Hanks').
actor('William H. Macy').

link('Barack Obama').
link('Barton Fink'). 
link('Coen brothers').
%link('Golden Globe Award for Best Supporting Actor - Motion Picture'). 
link('Hollywood Walk of Fame').
link('Inside the Actors Studio').
link('Manhattan').
link('Miller\'s Crossing'). 
%link('New York City').
link('O Brother, Where Art Thou?'). 
link('Rotten Tomatoes').
link('Saturday Night Live').
link('Screen Actors Guild Award').
link('The Big Lebowski'). 
%link('The New York Times').
link('Tony Award').
link('Los Angeles').
link('Angelina Jolie'). 

random_actor(A) :-
  findall(A,actor(A),L),
  random_member(A,L).

random_link(A,L) :-
  actor(A),
  actor_links(A,Ls),
  random_member(L,Ls).

actor_links(A,Ls):-
  actor(A),
  setof(L,(link(L),wp(A,WT),wt_link(WT,L)),Ls).

subset_links(A1,A2):-
  actor_links(A1,Ls1),
  actor_links(A2,Ls2),
  A1 \= A2,
  forall(member(L,Ls1),member(L,Ls2)).


%%%%%%%%%% Testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- dynamic ailp_identity/1.

% asserts a random actor identity
init_identity :-
  random_actor(A),
  init_identity(A).

% can be used to backtrack over all actor identities
init_identity(A) :-
  actor(A),
  retractall(ailp_identity(_)),
  assert(ailp_identity(A)).

:- init_identity.

% failure-driven loop to test all identities
test :-
  init_identity(_A),  % initialise; don't reveal identity
  user:find_identity(A),  % program under test
  ailp_identity(I),
  ( A==I -> writeln('I am':A)
  ; otherwise -> writeln('Wrong answer':A)
  ),fail.
test.
