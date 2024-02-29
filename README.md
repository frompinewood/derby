# derby

Erlang dice rolling library using leex and yecc.

Use `make` to build lexer and parser `erl` files.

## Examples
```
1> derby:query("4d6h3").
{result,14,[6,4,4],[4,4,6,2],0}
2> derby:parse("4d6h4").
{roll,4,6,[{high,3}]}
3> derby:roll({roll, 2, 20, [{high, 1}, {plus, 3}]}).
{result, 16, [13],[13,12],3}
```


