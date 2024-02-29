Nonterminals number roll full_mod full_mods.
Terminals int die mod.
Rootsymbol roll.

roll -> 
    number die number: {roll, '$1', '$3', []}.
roll ->
    number die number full_mods: {roll, '$1', '$3', '$4'}.

full_mods ->
    full_mod : ['$1'].
full_mods ->
    full_mod full_mods : ['$1' | '$2'].

full_mod ->
    mod number : {expand('$1'), '$2'}.

number -> 
    int : expand('$1').

Erlang code.

expand({_,_,N}) -> N.
