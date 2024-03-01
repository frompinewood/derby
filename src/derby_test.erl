-module(derby_test).
-export([test/0]).

test() -> 
    test_parse(),
    test_roll().

test_parse() ->
    {roll, [20], 0, []} = derby:parse("1d20"),
    {roll, [20], 0, [{high, 1}]} = derby:parse("1d20h1"),
    {roll, [20], 0, [{high, 1}, {low, 1}]} = derby:parse("1d20h1l1"), 
    {roll, [20], 1, []} = derby:parse("1d20+1"),
    {roll, [6,6,6], 0, [{high, 3}]} = derby:parse("3d6h3").

test_roll() ->
    {result, 4, [1,1,1], [1,1,1,1],  1} = derby:query("4d1h3+1"),
    {result, 2, [1,1,1], [1,1,1,1], -1} = derby:query("4d1l3-1").

