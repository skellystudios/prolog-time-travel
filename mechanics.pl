:- module(mechanics, [holds_after/2, is_safe/2, valid_actions/3, holds_after_actions/3, make_safe/0]).
:- dynamic switch_off_lights/1, switch_on_lights/1, teleport_to/1.

% So I think I might be able to stop doing all this asserting shit by
% using dynamic modules http://www.swi-prolog.org/pldoc/man?section=dynamic-modules

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Holds after simulates doing hypothetical checks by asserting
% facts into the database and user:retracting them afterwards.
holds_after(C, [A]) :-
  action(A), user:assert(A), user:C, user:retract(A).
holds_after(_, [A]) :-
  action(A), user:retract(A), fail.

holds_after(C, [A|AS]) :-
  action(A), user:assert(A), holds_after(C, AS).
holds_after(_, [A|_]) :-
  action(A), user:retract(A), fail.

% Checks to see whether a condition is ever true
holds_once(C, _) :-
  C.
holds_once(C, [A|AS]) :-
  action(A), user:assert(A), holds_once(C, AS), user:retract(A).
holds_once(_, [A|_]) :-
  action(A), user:retract(A), fail.

% is_safe(Action) :-
%   action(Action),
%   holds_after(safe,[Action]).
% is_safe(A,B) :-
%   holds_after(safe,[A,B]),
%   is_set([A,B]).
% is_safe(A,B,C,D,E) :-
%   is_set([A,B,C,D,E]),
%   valid_actions([A,B,C,D,E], 1, 5),
%   holds_after(safe,[A,B,C,D,E]).

is_safe(Actions, N) :-
  valid_actions(Actions, 1, N),
  length(Actions, N),
  is_set(Actions),
  holds_after(safe, Actions).

holds_after_actions(Predicate, Actions, N) :-
  valid_actions(Actions, 1, N),
  length(Actions, N),
  is_set(Actions),
  holds_after(Predicate, Actions).


make_safe :-
  user:assert(switch_off_lights(3)), user:safe.

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
