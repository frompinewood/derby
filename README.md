# derby

Erlang dice rolling library using leex and yecc.

## Examples
```erlang
1> derby:query("4d6h3").
[{result,14,[6,4,4],[4,4,6,2],0}]

2> derby:parse("4d6h3").
[{roll,[6,6,6,6],0,[{high,3}]}]

3> derby:roll({roll,[20,20],3,[{high, 1}]}).
[{result,16,[13],[13,12],3}]

5> [Roll] = derby:parse("2d20l1", 20),
4> derby:chance(Roll,20).
0.0025
```


