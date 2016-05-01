woman(eliane).
woman(fernanda).

man(albino).
man(cotrim).
man(nicolas).
man(gustavo).

progenitor(albino,cotrim).
progenitor(albino,fernanda).

progenitor(eliane,cotrim).
progenitor(eliane,nicolas).
progenitor(eliane,gustavo).


mother(Mother,Son):- woman(Mother),progenitor(Mother,Son).
father(Father,Son):- man(Father),progenitor(Father,Son).

brother(Man1,Man2):- man(Man1), man(Man2),
  progenitor(Progenitor,Man1) , progenitor(Progenitor,Man2),
  (man(Progenitor); woman(Progenitor)).

sister(Woman,Man):- woman(Woman), man(Man),
  progenitor(Progenitor,Woman) , progenitor(Progenitor,Man),
  (man(Progenitor); woman(Progenitor)).
