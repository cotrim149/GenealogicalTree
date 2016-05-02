:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

server(Port) :- http_server(http_dispatch, [port(Port)]).
stopServer(Port) :- http_stop_server(Port, []).

% make routes
% route localhost:port/
:- http_handler(root(.), say_hi, []).

% route localhost:port/bye
:- http_handler(root(bye), say_bye, []).

% route localhost:port/foo/bar
:- http_handler(root('foo/bar'), say_foo_bar(cotrim), []).

% handler for every route
say_hi(_Request) :-
  format('Content-type: text/plain~n~n'),
  format('Hello World!~n').

say_bye(_Request) :-
  format('Content-type: text/plain~n~n'),
  format('Bye Bye!~n').

say_foo_bar(Name,_Request) :-
  format('Content-type: text/plain~n~n'),
  format('Foo Bar!~n'),
  format(Name).
