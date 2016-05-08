:- dynamic male/1.
:- dynamic female/1.
:- dynamic parent/2.
:- consult('file.pl').

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

grandMother(GrandMother,Person) :-
  female(GrandMother),
  (female(Person);male(Person)),
  grandparent(GrandMother,Person).

grandFather(GrandFather,Person) :-
  male(GrandFather),
  (female(Person);male(Person)),
  grandparent(GrandFather,Person).

% Database defining rules

definePerson(Name, Gender) :-
  ( % if Name is alredy in Database just verify
    (
      (male(Name);female(Name)),
      write('Person alredy defined!'),nl
    );
    % else Name is not, add it to Database
    (
      (Gender = male, assert(male(Name)));
      (Gender = female, assert(female(Name))),
      write('Person defined!'),nl
    )
  ),!.

defineParent(Parent,Son):-
  (
    (
      parent(Parent,Son),
      write('Parent alredy defined!'),nl
    );
    (
      assert(parent(Parent, Son)),
      write('Parent defined!'),nl
    )
  ),!.

defineMother(Name, Son) :-
  (male(Son); female(Son)),
  definePerson(Name,female),
  defineParent(Name,Son),!.

defineFather(Name, Son) :-
  (male(Son); female(Son)),
  definePerson(Name,male),
  defineParent(Name,Son),!.

defineNotSameBloodAunt(NameOne, NameTwo) :-
  (male(NameTwo); female(NameTwo)),
  assert(female(NameOne)),
  assert(spouse(NameOne, NameTwo)).

defineNotSameBloodUncle(NameOne, NameTwo) :-
  (male(NameTwo); female(NameTwo)),
  assert(male(NameOne)),
  assert(spouse(NameOne, NameTwo)).
