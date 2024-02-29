-module(derby).
-export([parse/1, query/1, roll/1, roll/2]).

-type times() :: non_neg_integer().
-type size()  :: non_neg_integer().
-type roll()  :: {roll, times(), size()} 
               | {roll, times(), size(), list()}.
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
    {result, lists:sum(Result), Result, 0}.

-spec roll(list(), list()) -> result().
roll(Dice, Mods) ->
    {result, _, Result, 0} = roll(Dice),
    {NewResult, Bonus} = lists:foldl(
                  fun ({Mod, N}, {Acc, B}) -> 
                          case Mod of
                              high -> 
                                  {lists:sublist(lists:reverse(lists:sort(Acc)), N), B};
                              low  -> 
                                  {lists:sublist(lists:sort(Acc), N), B};
                              plus ->
                                  {Acc, B + N};
                              minus ->
                                  {Acc, B - N}
                          end
                  end, {Result, 0}, Mods),
    {result, lists:sum(NewResult) + Bonus, NewResult, Result, Bonus}.
