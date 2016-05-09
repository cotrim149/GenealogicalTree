:- dynamic male/1.
:- dynamic female/1.
:- dynamic parent/2.
:- dynamic spouse/2.
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

cousin(Cousin,Person):-
  (male(Person);female(Person)),
  (
    ( % brother of my father
      father(Uncle,Cousin),
      (brother(Uncle,Dad);brother(Dad,Uncle)),
      father(Dad,Person)

    );
    ( % sister of my father
      mother(Aunt,Cousin),
      (sister(Aunt,Dad);brother(Dad,Aunt)),
      father(Dad,Person)
    )
  );
  (
    ( % brother of my mother
      father(Uncle,Cousin),
      (brother(Uncle,Mother);sister(Mother,Uncle)),
      mother(Mother,Person)

    );
    ( % sister of my mother
      mother(Aunt,Cousin),
      (sister(Aunt,Mother);sister(Mother,Aunt)),
      mother(Mother,Person)
    )
  ),!.
% Database defining rules

definePerson(Name, Gender) :-
  ( % if Name is alredy in Database just verify
    (
      (male(Name);female(Name)),
      write(Name),write(' alredy defined!'),nl
    );
    % else Name is not, add it to Database
    (
      (Gender = male, assert(male(Name)));
      (Gender = female, assert(female(Name))),
      write(Name),write(' defined!'),nl
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

defineSpouse(NameOne,NameTwo):-
  (
    spouse(NameOne,NameTwo),
    write(NameOne),write(' alredy have spouse:'),write(NameTwo),nl
  );
  (
    assert(spouse(NameOne, NameTwo)),
    write(NameOne),write(' maried with: '), write(NameTwo),nl
  ).

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
  definePerson(NameOne,female),
  defineSpouse(NameOne,NameTwo),!.

defineNotSameBloodUncle(NameOne, NameTwo) :-
  (male(NameTwo); female(NameTwo)),
  definePerson(NameOne,male),
  defineSpouse(NameOne,NameTwo),!.
