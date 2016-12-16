% We want this to get all_different
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- dynamic switch_off_lights/1, switch_on_lights/1, teleport_to/1.

%%%%%%%%%%%%%%%%%%%%
% Initial conditions
lights_on(0).
shoots(assasin, 5).

current_time(6).
visited(6).


%%%%%%%%%%%%%%%%%%%%%%%%%
% Define what things are

% Actors
actor(president).
actor(assassin).
actor(me).

% Times
t(1).
t(2).
t(3).
t(4).
t(5).
t(6).

room(hall).

% Define actions
action(switch_on_lights(T)) :- t(T).
action(switch_off_lights(T)) :- t(T).
action(teleport_to(T)) :- t(T).


action(junk(T)) :- t(T).
action(junk2(T)) :- t(T).
action(junk3(T)) :- t(T).
action(junk4(T)) :- t(T).

%%%%%%%%%%%%%%%%
% Action effects
%
% teleport_to(T) :-
%   retract(current_time(_)),
%   asserta(current_time(T)).
%

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Holds after simulates doing hypothetical checks by asserting
% facts into the database and retracting them afterwards.
holds_after(C, [A]) :-
  action(A), assert(A), C, retract(A).
holds_after(_, [A]) :-
  action(A), retract(A), fail.

holds_after(C, [A|AS]) :-
  action(A), assert(A), holds_after(C, AS).
holds_after(_, [A|_]) :-
  action(A), retract(A), fail.

% Checks to see whether a condition is ever true
holds_once(C, _) :-
  C.
holds_once(C, [A|AS]) :-
  action(A), assert(A), holds_once(C, AS), retract(A).
holds_once(_, [A|_]) :-
  action(A), retract(A), fail.

% is_safe(Action) :-
%   action(Action),
%   holds_after(safe,[Action]).
% is_safe(A,B) :-
%   holds_after(safe,[A,B]),
%   is_set([A,B]).
is_safe(A,B,C,D,E) :-
  is_set([A,B,C,D,E]),
  valid_actions([A,B,C,D,E], 1, 5),
  holds_after(safe,[A,B,C,D,E]).
is_safe(Actions, N) :-
  valid_actions(Actions, 1, N),
  length(Actions, N),
  is_set(Actions),
  holds_after(safe, Actions).

% valid_actions takes a list of actions and a starting time and returns if that's
% a valid list of actions. This code needs to be improved.
%
% No actions are valid from any time
valid_actions([], _, 0) :-
  true.
% The "teleport to" action is valid at any time
valid_actions([A], _, 1) :-
  action(A),
  t(NewTime),
  A == teleport_to(NewTime).
% Any single action taking place at the current time
valid_actions([A], CurrentTime, 1) :-
  action(A),
  % set Time to the 1st argument of A
  arg(1, A, Time),
  Time == CurrentTime.
valid_actions([A|AS], _, N) :-
  N > 1,
  action(A),
  t(NewTime),
  A == teleport_to(NewTime),
  Nm1 is N-1,
  valid_actions(AS, NewTime, Nm1),
  is_set([A|AS]).
valid_actions([A|AS], CurrentTime, N) :-
  N > 1,
  action(A),
  arg(1, A, Time),
  Time == CurrentTime,
  Nm1 is N-1,
  valid_actions(AS, CurrentTime, Nm1),
  is_set([A|AS]).
