Nonterminals number roll full_mod full_mods.
Terminals int die mod.
Rootsymbol roll.

roll -> 
    number die number: {roll, expand_roll('$1', '$3'), 0, []}.
roll ->
    number die number full_mods: {roll, 
                                expand_roll('$1', '$3'), 
                                bonus_sum('$4'), filter_mod('$4')}.

full_mods ->
    full_mod : ['$1'].
full_mods ->
    full_mod full_mods : ['$1' | '$2'].

full_mod ->
    mod number : {strip_token('$1'), '$2'}.

number -> 
    int : strip_token('$1').

Erlang code.

expand_roll(Times, Size) ->
    [Size || _ <- lists:seq(1, Times)].

filter_mod(Mods) ->
    lists:filter(fun ({high,_}) -> true;
                     ({low,_})  -> true;
                     (_)    -> false end, Mods).

bonus_sum(Mods) ->
    bonus_sum(Mods, 0).
bonus_sum(   [], Acc) -> Acc;
bonus_sum([{M,V}|T], Acc) ->
    case M of
        plus -> bonus_sum(T, Acc + V);
        minus -> bonus_sum(T, Acc - V);
        _     -> bonus_sum(T, Acc)
    end.
    
strip_token({_,_,N}) -> N.

