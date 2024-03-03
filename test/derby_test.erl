-module(derby_test).
-include_lib("eunit/include/eunit.hrl").

parse_test() ->
    ?assertEqual({roll, [20], 0, []}, derby:parse("1d20")).

parse_high_test() ->
    ?assertEqual({roll, [20], 0, [{high, 1}]}, derby:parse("1d20h1")).

parse_high_low_test() ->
    ?assertEqual({roll, [20], 0, [{high, 1}, {low, 1}]}, derby:parse("1d20h1l1")). 

parse_bonus_test() ->
    ?assertEqual({roll, [20], 1, []}, derby:parse("1d20+1")).

parse_multi_high_test() ->
    ?assertEqual({roll, [6,6,6], 0, [{high, 3}]}, derby:parse("3d6h3")).

query_plus_test() ->
    ?assertEqual({result, 4, [1,1,1], [1,1,1,1],  1}, derby:query("4d1h3+1")).

query_minus_test() ->
    ?assertEqual({result, 2, [1,1,1], [1,1,1,1], -1}, derby:query("4d1l3-1")).

chance_test() ->
    ?assertEqual(1/400, derby:chance(derby:parse("2d20l1"), 20)).
