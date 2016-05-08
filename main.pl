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

uncle(X,Y) :-
  parent(Z,Y), brother(X,Z).

aunt(X,Y) :-
  parent(Z,Y), sister(X,Z).

aunt(X, Y) :- female(X), sibling(X, Z), parent(Z, Y).
aunt(X, Y) :- female(X), spouse(X, W), sibling(W, Z), parent(Z, Y).

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

% Saving the dynamic database with all predicates

save_data:-
  tell('genealogicalData.txt'),
  listing(male),
  listing(female),
  listing(parent),
  told.

% Load data to a dynamic database
readFile(File,_):-
  read(File,Line),
  (
    ( % if Head of List splitted are ":" than do nothing
      format(atom(FormattedLine),"~w",Line),
      split_string(FormattedLine,' -','',[Head|Tail]),
      Head = ":"
    );
    ( % else load data into assert with line information
      asserta(Line)
    )
  ),
  (
    (Line \= end_of_file, readFile(File,Line));
    (Line = end_of_file)
  ),!.

load_data:-
  open('genealogicalData.txt',read,File),
  readFile(File,_),nl,
  write('File load with success!'),
  close(File).

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
