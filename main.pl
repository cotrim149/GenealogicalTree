woman(eliane).
woman(fernanda).
woman(ester).
woman(terezinha).

man(albino).
man(cotrim).
man(nicolas).
man(gustavo).
man(elias).

progenitor(albino,cotrim).
progenitor(albino,fernanda).

progenitor(eliane,cotrim).
progenitor(eliane,nicolas).
progenitor(eliane,gustavo).

progenitor(terezinha,ester).
progenitor(terezinha,eliane).
progenitor(terezinha,elias).

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
