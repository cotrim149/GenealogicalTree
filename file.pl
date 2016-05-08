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
