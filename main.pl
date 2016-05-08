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
:- dynamic male/1.
:- dynamic female/1.
:- dynamic parent/2.

father(NameFather, NameTwo) :- male(NameFather), parent(NameFather, NameTwo).
mother(NameMother, NameTwo) :- female(NameMother), parent(NameMother, NameTwo).

full_siblings(NameOne, NameTwo) :-
  parent(Father, NameOne), parent(Father, NameTwo),
  parent(Mother, NameOne), parent(Mother, NameTwo),
  NameOne \= NameTwo, Father \= Mother.

sister(X, Y) :-
  full_siblings(X, Y),
  female(X).

brother(X, Y) :-
  full_siblings(X, Y),
  male(X).

half_sibling(X, Y) :-
  parent(Z, X),
  parent(Z, Y),
  X \= Y.

uncle(Uncle, Person) :-
  male(Uncle), parent(Brother, Person), brother(Uncle, Brother).

aunt(Aunt, Person) :-
  female(Aunt), parent(Brother, Person), sister(Aunt, Brother).

uncleNotSameBlood(Uncle, Person) :-
  female(Uncle), spouse(Uncle, Spouse), full_siblings(Brother, Parent), parent(Parent, Person).

auntNotSameBlood(Aunt, Person) :-
  female(Aunt), spouse(Aunt, Spouse), full_siblings(Brother, Parent), parent(Parent, Person).

grandparent(C,D) :- parent(C,E), parent(E,D).

% Database defining rules

definePerson(Name, Gender) :-
  (Gender = male, assert(male(Name)));
  (Gender = female, assert(female(Name))).

defineMother(Name, Son) :-
  (male(Son); female(Son)),
  assert(female(Name)),
  assert(parent(Name, Son)).

defineFather(Name, Son) :-
  (male(Son); female(Son)),
  assert(male(Name)),
  assert(parent(Name, Son)).

defineNotSameBloodAunt(NameOne, NameTwo) :-
  (male(NameTwo); female(NameTwo)),
  assert(female(NameOne)),
  assert(spouse(NameOne, NameTwo)).

defineNotSameBloodUncle(NameOne, NameTwo) :-
  (male(NameTwo); female(NameTwo)),
  assert(male(NameOne)),
  assert(spouse(NameOne, NameTwo)).

% Saving the dynamic database with all predicates

save_data:-
  tell('genealogicalData.txt'),
  listing(male),
  listing(female),
  listing(parent),
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
