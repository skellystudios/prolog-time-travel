# Time Traveller's Log

This is a (work in progress) engine for a game in which you use time travel to try to save the president/queen/religious figure from being assassinated.

The aim is to plug in a set of complex, intertwining rules and then have Prolog help to come up with a set of initial conditions such that there's only one set of actions that can save him.


Note to Me:
- use `listing` to show currently asserted rules.
- To clear any accidental assertions: `action(A), retract(A).`
