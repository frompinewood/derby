-module(derby).
-export([parse/1, possible/1, query/1, roll/1, chance/2, format/2]).

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
    {ok, Tokens, _} = derby_lexer:string(Str),
    {ok, Roll} = derby_parser:parse(Tokens),
    Roll.

-spec query(string()) -> result().
query(Query) ->
    roll(parse(Query)).

-spec roll(roll()) -> result().
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
    lists:map(fun possible/1, Rolls);
possible([H|T]) -> 
    possible([[X] || X <- lists:seq(1, H)], T).

possible(Acc, []) -> Acc;
possible(Acc, [H|T]) ->
    possible([[Y|X] || X <- Acc, Y <- lists:seq(1, H)], T).

-spec chance(rolls(), integer()) -> float().
chance({roll, _, _, _} = Roll, Target) ->
    P = possible(Roll),
    S = lists:filter(fun (X) -> X >= Target end, P),
    length(S)/length(P).

-spec format(string(), rolls()) -> string().
format(String, Rolls) ->
    lists:flatten(io_lib:format(String, lists:flatten(lists:map(fun reduce_value/1, Rolls)))).

reduce_value({result, Total, _, _, _}) -> Total;
reduce_value({roll, _, _, _} = Roll) -> 
    reduce_value(roll(Roll));
reduce_value(Str) -> lists:map(fun reduce_value/1, parse(Str)).
