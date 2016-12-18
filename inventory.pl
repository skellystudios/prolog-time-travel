:- module(inventory, [actor/1, t/1, room/1, action/1, switch_off_lights/1, switch_on_lights/1, teleport_to/1]).
:- dynamic switch_off_lights/1, switch_on_lights/1, teleport_to/1.


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
