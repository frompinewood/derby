Definitions.

DIE = d
INT = [0-9]+
MOD = [hl+-]
WS  = [\s\t\r\n]

Rules.

{DIE} : {token, {die, TokenLine, d}}.
{INT} : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
{MOD} : {token, {mod, TokenLine, expand_mod(list_to_atom(TokenChars))}}.
{WS}  : skip_token.

Erlang code.

expand_mod(Mod) ->
    case Mod of
        '+' -> plus;
        '-' -> minus;
        h   -> high;
        l   -> low
    end.
