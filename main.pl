:- use_module(inventory).
:- use_module(mechanics).

:- use_module(library(clpfd)). % We want this to get all_different
:- use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%
% Initial conditions
lights_on(0).
shoots(assasin, 5).

current_time(6).
visited(6).

is_switched :-
  switch_off_lights(3).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Production rules for the scenario

safe :-
  \+ shot.

shot :-
  shoots(_,T),
  \+ dark(T).

dark(T) :-
  t(T),
  \+ lights_on(T).


lights_on(T) :-
  t(T),
  Tm1 is T-1,
  switch_on_lights(Tm1).
lights_on(T) :-
   t(T),
   Tm1 is T-1,
   lights_on(Tm1),
   \+ switch_off_lights(Tm1).
