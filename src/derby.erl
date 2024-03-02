-module(derby).
-export([parse/1, possible/1, query/1, roll/1, chance/2]).

-type roll()  :: {roll, list(integer()), integer(), list(modifier())} | string().
-type modifier() :: high 
                  | low 
                  | plus 
                  | minus.
-type mod()   :: {modifier(), integer()}.
-type result():: {result, integer(), list(), list(), integer()}.

-spec parse(string()) -> roll().
parse(Str) ->
    {ok, Tokens, _} = derby_lexer:string(Str),
    {ok, Roll} = derby_parser:parse(Tokens),
    Roll.

-spec query(string()) -> result().
query(Query) ->
    roll(parse(Query)).

-spec roll(roll()) -> result().
roll(Roll) when is_list(Roll) ->
    roll(parse(Roll));
roll({roll, Dice, Bonus, Mods}) ->
    DiceResult = lists:map(fun rand:uniform/1, Dice),
    ModdedResult = lists:foldl(fun modify/2, DiceResult, Mods),
    {result, lists:sum(ModdedResult) + Bonus, ModdedResult, DiceResult, Bonus}.

-spec modify(result(), mod()) -> result().
modify({Mod, ModVal}, Result) ->
    case Mod of
        high ->
            lists:sublist(lists:reverse(lists:sort(Result)), ModVal);
        low ->
            lists:sublist(lists:sort(Result), ModVal) 
    end.

-spec possible(roll()) -> list(integer()).
possible(Roll) when is_list(Roll) ->
    possible(parse(Roll));
possible({roll, Dice, Bonus, Mods}) ->
    Possible = possible(Dice),
    lists:map(fun (L) -> lists:sum(L) + Bonus end,
      lists:map(fun (P) -> lists:foldl(fun modify/2, P, Mods) end, Possible));
possible([H|T]) -> 
    possible([[X] || X <- lists:seq(1, H)], T).
possible(Acc, []) -> Acc;
possible(Acc, [H|T]) ->
    possible([X++[Y] || X <- Acc, Y <- lists:seq(1, H)], T).

-spec chance(roll(), integer()) -> float().
chance(Roll, Target) when is_list(Roll) ->
    chance(parse(Roll), Target);
chance(Roll, Target) ->
    P = possible(Roll),
    S = lists:filter(fun (X) -> X >= Target end, P),
    length(S)/length(P).
