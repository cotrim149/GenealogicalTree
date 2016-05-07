% woman(eliane).
% woman(fernanda).
% woman(ester).
% woman(terezinha).
%
% man(albino).
% man(cotrim).
% man(nicolas).
% man(gustavo).
% man(elias).
%
% progenitor(albino,cotrim).
% progenitor(albino,fernanda).
%
% progenitor(eliane,cotrim).
% progenitor(eliane,nicolas).
% progenitor(eliane,gustavo).
%
% progenitor(terezinha,ester).
% progenitor(terezinha,eliane).
% progenitor(terezinha,elias).
:- dynamic man/1.
:- dynamic woman/1.
:- dynamic progenitor/2.

mother(Mother,Son):- woman(Mother),progenitor(Mother,Son).
father(Father,Son):- man(Father),progenitor(Father,Son).

brother(Man1,Man2):- man(Man1),
  progenitor(Progenitor,Man1) , progenitor(Progenitor,Man2),
  (man(Progenitor); woman(Progenitor)).

sister(Woman,Person):- woman(Woman),
  progenitor(Progenitor,Woman) , progenitor(Progenitor,Person),
  (man(Progenitor); woman(Progenitor)).

aunt(Woman,Person):- woman(Woman),
  (
    mother(Mother,Person),sister(Woman,Mother)
  );
  (
    father(Father,Person),sister(Woman,Father)
  ).

uncle(Man,Person):- man(Man),
(
  mother(Mother,Person),brother(Man,Mother)
);
(
  father(Father,Person),brother(Man,Father)
).

% Database defining rules

definePerson(Name,Gender):-
  (Gender = man , assert(man(Name)));
  (Gender = woman , assert(woman(Name))).

defineMother(Name,Son):-
  (man(Son);woman(Son)),
  assert(woman(Name)),
  assert(progenitor(Name,Son)).

defineFather(Name,Son):-
  (man(Son);woman(Son)),
  assert(man(Name)),
  assert(progenitor(Name,Son)).

defineAunt(Name,Nephew):-
  (man(Nephew);woman(Nephew)),
  assert(woman(name)),
  assert(progenitor()).

% Saving the dynamic database with all predicates

save_data:-
  tell('genealogicalData.txt'),
  listing(man),
  listing(woman),
  listing(progenitor),
  told.

% Saving the dynamic database with lists

save_data_as_list:-
  tell('genealogicalDataLists.txt'),
  do_savings,
  told.

do_savings:-
  ( ( mother(A,B)=..X,mother(A,B) )
  ),
  decision(A,B),
  PRED=..X,
  write(X),write('.'),nl,
  fail.
do_savings.

decision(_,_).
