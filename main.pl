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

uncle(X,Y) :-
  parent(Z,Y), brother(X,Z).

aunt(X,Y) :-
  parent(Z,Y), sister(X,Z).

aunt(X, Y) :- female(X), sibling(X, Z), parent(Z, Y).
aunt(X, Y) :- female(X), spouse(X, W), sibling(W, Z), parent(Z, Y).

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
  nl,
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
