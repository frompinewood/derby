-module(derby).
-export([parse/1, query/1, roll/1, roll/2]).
-export([modify/2]).

-type times() :: non_neg_integer().
-type size()  :: non_neg_integer().
-type roll()  :: {roll, times(), size()} 
               | {roll, times(), size(), list()}.
-type modifier() :: high | low | plus | minus.
-type mod()   :: {modifier(), integer()}.
-type result():: {result, integer(), list(), list(), integer()}.

-spec parse(string()) -> roll().
parse(Str) ->
    {ok, Tokens, _} = derby_lexer:string(Str),
    {ok, Roll} = derby_parser:parse(Tokens),
    Roll.

-spec query(string()) -> result().
query(Query) ->
    {roll, Times, Size, Mods} = parse(Query),
    roll([Size || _ <- lists:seq(1, Times)], Mods).

-spec roll(list()) -> result().
roll(Dice) ->
    Result = lists:map(fun rand:uniform/1, Dice),
    {result, lists:sum(Result), Result, Result, 0}.

-spec roll(list(), list()) -> result().
roll(Dice, Mods) ->
    lists:foldl(fun modify/2, roll(Dice), Mods).

-spec modify(result(), mod()) -> result().
modify({Mod, ModVal}, {result, _Total, Result, Orig, Bonus}) ->
    {NewResult, NewBonus} = case Mod of
        high ->
            {lists:sublist(lists:reverse(lists:sort(Result)), ModVal), Bonus};
        low ->
            {lists:sublist(lists:sort(Result), ModVal), Bonus};
        plus ->
            {Result, Bonus + ModVal};
        minus ->
            {Result, Bonus - ModVal}
    end,
    {result, lists:sum(NewResult) + NewBonus, NewResult, Orig, NewBonus}.

