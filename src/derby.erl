-module(derby).
-export([parse/1, possible/1, query/1, roll/1, chance/2, format/2]).
-include_lib("eunit/include/eunit.hrl").

%% TODO: rewrite to make these records or maps
-type mod_type() :: high 
                  | low 
                  | plus 
                  | minus.
-type mod()    :: {mod_type(), integer()}.
-type roll()   :: {roll, list(integer()), integer(), list(mod_type())}. 
-type rolls()  :: list(roll()).
-type result() :: {result, integer(), list(), list(), integer()}.

-spec parse(string()) -> rolls().
parse(Str) ->
    maybe
	    {ok, Tokens, _} ?= derby_lexer:string(Str),
	    {ok, Roll} ?= derby_parser:parse(Tokens),
	    Roll
    else
        _ -> {error, "Bad expression: " ++ Str}
    end.

-spec query(string()) -> result().
query(Query) ->
    roll(parse(Query)).

-spec roll(roll()) -> result().
roll({error, _} = Error) -> Error;
roll({roll, Dice, Bonus, Mods}) ->
    DiceResult = lists:map(fun rand:uniform/1, Dice),
    ModdedResult = lists:foldl(fun modify/2, DiceResult, Mods),
    {result, lists:sum(ModdedResult) + Bonus, ModdedResult, DiceResult, Bonus};
roll(Rolls) ->
    lists:map(fun roll/1, Rolls).

-spec modify(result(), mod()) -> result().
modify({Mod, ModVal}, Result) ->
    case Mod of
        high ->
            lists:sublist(lists:reverse(lists:sort(Result)), ModVal);
        low ->
            lists:sublist(lists:sort(Result), ModVal) 
    end.

%% TODO: this scales terribly, learn calculus and make this faster
-spec possible(roll()) -> list(integer()).
possible({roll, Dice, Bonus, Mods}) ->
    Possible = possible(Dice),
    lists:map(fun (L) -> 
          lists:sum(L) + Bonus end,
      lists:map(fun (P) -> 
            lists:foldl(fun modify/2, P, Mods) end, Possible));

possible([{roll, _, _, _} = _|_] = Rolls) ->
    sum_permutations(lists:map(fun possible/1, Rolls));
possible([H|T]) -> 
    possible([[X] || X <- lists:seq(1, H)], T).

possible(Acc, []) -> Acc;
possible(Acc, [H|T]) ->
    possible([[Y|X] || X <- Acc, Y <- lists:seq(1, H)], T).

-spec chance(rolls(), integer()) -> float().
chance(Rolls, Target) when is_list(Rolls) ->
    P = possible(Rolls),
    S = lists:filter(fun (X) -> X >= Target end, P),
    length(S)/length(P).

-spec format(string(), rolls()) -> string().
format(String, Rolls) ->
    lists:flatten(io_lib:format(String, lists:flatten(lists:map(fun reduce_value/1, Rolls)))).

reduce_value({result, Total, _, _, _}) -> Total;
reduce_value({roll, _, _, _} = Roll) -> 
    reduce_value(roll(Roll));
reduce_value(Str) -> lists:map(fun reduce_value/1, parse(Str)).

sum_permutations(List) ->
    sum_permutations(List, []).

sum_permutations([], Acc) ->
    Acc;
sum_permutations([H|T], []) ->
    sum_permutations(T, H);
sum_permutations([H|T], Acc) ->
    sum_permutations(T, [X + Y || X <- H, Y <- Acc]).

parse_test() ->
    ?assertEqual([{roll, [20], 0, []}], derby:parse("1d20")).

parse_high_test() ->
    ?assertEqual([{roll, [20], 0, [{high, 1}]}], derby:parse("1d20h1")).

parse_high_low_test() ->
    ?assertEqual([{roll, [20], 0, [{high, 1}, {low, 1}]}], derby:parse("1d20h1l1")). 

parse_bonus_test() ->
    ?assertEqual([{roll, [20], 1, []}], derby:parse("1d20+1")).

parse_multi_high_test() ->
    ?assertEqual([{roll, [6,6,6], 0, [{high, 3}]}], derby:parse("3d6h3")).

query_plus_test() ->
    ?assertEqual([{result, 4, [1,1,1], [1,1,1,1],  1}], derby:query("4d1h3+1")).

query_minus_test() ->
    ?assertEqual([{result, 2, [1,1,1], [1,1,1,1], -1}], derby:query("4d1l3-1")).

chance_test() ->
    Rolls = derby:parse("2d20l1"),
    ?assertEqual(1/400, derby:chance(Rolls, 20)).

format_simple_test() ->
    ?assertEqual("I do 15 damage!", derby:format("I do ~p damage!", [{result, 15, [6,6,3],[6,6,3],0}])).

format_compound_test() ->
    derby:format("My two attacks do ~p and ~p damage!", ["3d6+3","4d4+3"]).

bad_query_test() ->
    {error, _} = derby:query("1d").
