:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).

server(Port) :- http_server(http_dispatch, [port(Port)]).
stopServer(Port) :- http_stop_server(Port, []).

% make routes
:- http_handler(/, say_hi, []).

% handler for every route
say_hi(_Request) :-
        format('Content-type: text/plain~n~n'),
        format('Hello World!~n').
