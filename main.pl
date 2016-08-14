% We want this to get all_different
:- use_module(library(clpfd)).
:- dynamic switch_off_lights/1, switch_on_lights/1.

% Initial conditions
switch_on_lights(0).
shoots(assasin, 5).

% Define what things are

t(1).
t(2).
t(3).
t(4).
t(5).

action(switch_off_lights(T)) :- t(T).
action(switch_on_lights(T)) :- t(T).


% Production rules for the scenario

safe :-
  \+ shot.

shot :-
  shoots(_,T),
  \+ dark(T).

dark(T) :-
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


% Holds after simulates doing hypothetical checks by asserting
% facts into the database and retracting them afterwards.s
holds_after(C, [A]) :-
  action(A), assert(A), C, retract(A).
holds_after(_, [A]) :-
  action(A), retract(A), fail.

holds_after(C, [A|AS]) :-
  action(A), assert(A), holds_after(C, AS).
holds_after(_, [A|_]) :-
  action(A), retract(A), fail.

is_safe(Action) :-
  holds_after(safe,[Action])
is_safe(A,B,C,D,E) :-
  holds_after(safe,[A,B,C,D,E]),
  all_different([A,B,C,D,E]).
