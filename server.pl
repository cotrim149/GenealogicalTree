:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- consult('main.pl').

server(Port) :- http_server(http_dispatch, [port(Port)]).
stopServer(Port) :- http_stop_server(Port, []).

% make routes
% route localhost:port/
:- http_handler(root(.), say_hi, []).

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

say_foo_bar(Name,_Request) :-
  header(text/plain),
  format('Foo Bar ~w!~n',[Name]),
  format(Name).

genealogicalTree(_Request) :-
  header(text/plain),
  mother(Mother,cotrim),
  format(Mother).


% JSON support
:- use_module(library(http/json)).
% convert prolog terms to json
:- use_module(library(http/json_convert)).
% make HTTP client and server
:- use_module(library(http/http_json)).
% enable json use
:- multifile http_json/1.

:- use_module(library(http/http_header)).

% adding mime types
http_json:json_type('application/x-javascript').
http_json:json_type('text/javascript').
http_json:json_type('text/x-javascript').
http_json:json_type('text/x-json').

% make object type for json use
:- json_object coord(x:float, y:float).
:- json_object circle(center:coord/2).
:- json_object point(x:integer, y:integer) + [type=point].

% route localhost:port/tree
:- http_handler(root(json_test), jsonHandle, []).

jsonHandle(_Request):-
  prolog_to_json(circle(coord(3.4, 5.6)), JSON_Object),
  reply_json(JSON_Object).
  % http_reply_file('main.pl', [], []).
  % http_post([ protocol(http),
  %           host(Host),
  %           port(8000),
  %           path(ActionPath)
  %         ],
  %         form_data([ repository = Repository,
  %                     dataFormat = DataFormat,
  %                     baseURI    = BaseURI,
  %                     verifyData = Verify,
  %                     data       = file(File)
  %                   ]),
  %         _Reply,
  %         []).

% json tests
test(JSON_Object):-
  prolog_to_json(circle(coord(3.4, 5.6)), JSON_Object),
  format(user_output, '~w', JSON_Object).

pointTest(Json):-
  prolog_to_json(point(3,4),Json).
