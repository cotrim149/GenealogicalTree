:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- consult('main.pl').

server(Port) :- http_server(http_dispatch, [port(Port)]).
stopServer(Port) :- http_stop_server(Port, []).

% make routes
% route localhost:port/
:- http_handler(root(.), say_hi, []).

% route localhost:port/bye
:- http_handler(root(bye), say_bye, []).

% route localhost:port/foo/bar
:- http_handler(root('foo/bar'), say_foo_bar(cotrim), []).

% route localhost:port/tree
:- http_handler(root(tree), genealogicalTree, []).

header(ContentType) :-
  format('Content-type: ~w~n~n',ContentType).
% handler for every route
say_hi(_Request) :-
  header(text/plain),
  format('Hello World!~n').

say_bye(_Request) :-
  header(text/plain),
  format('Bye Bye!~n').

say_foo_bar(Name,_Request) :-
  header(text/plain),
  format('Foo Bar ~w!~n',[Name]),
  format(Name).

genealogicalTree(_Request) :-
  header(text/plain),
  mother(Mother,cotrim),
  format(Mother).
