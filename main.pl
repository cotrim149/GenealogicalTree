woman(eliane).
man(albino).
progenitor(eliane,cotrim).
progenitor(albino,cotrim).

mother(Mother,Son):- woman(Mother),progenitor(Mother,Son).
father(Father,Son):- man(Father),progenitor(Father,Son).
