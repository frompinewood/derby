searchData={"items":[{"type":"module","title":"derby","doc":null,"ref":"derby.html"},{"type":"function","title":"derby.chance/2","doc":null,"ref":"derby.html#chance/2"},{"type":"function","title":"derby.parse/1","doc":null,"ref":"derby.html#parse/1"},{"type":"function","title":"derby.possible/1","doc":null,"ref":"derby.html#possible/1"},{"type":"function","title":"derby.query/1","doc":null,"ref":"derby.html#query/1"},{"type":"function","title":"derby.roll/1","doc":null,"ref":"derby.html#roll/1"},{"type":"type","title":"derby.mod/0","doc":null,"ref":"derby.html#t:mod/0"},{"type":"type","title":"derby.modifier/0","doc":null,"ref":"derby.html#t:modifier/0"},{"type":"type","title":"derby.result/0","doc":null,"ref":"derby.html#t:result/0"},{"type":"type","title":"derby.roll/0","doc":null,"ref":"derby.html#t:roll/0"},{"type":"module","title":"derby_lexer","doc":null,"ref":"derby_lexer.html"},{"type":"function","title":"derby_lexer.format_error/1","doc":null,"ref":"derby_lexer.html#format_error/1"},{"type":"function","title":"derby_lexer.string/1","doc":null,"ref":"derby_lexer.html#string/1"},{"type":"function","title":"derby_lexer.string/2","doc":null,"ref":"derby_lexer.html#string/2"},{"type":"function","title":"derby_lexer.token/2","doc":null,"ref":"derby_lexer.html#token/2"},{"type":"function","title":"derby_lexer.token/3","doc":null,"ref":"derby_lexer.html#token/3"},{"type":"function","title":"derby_lexer.tokens/2","doc":null,"ref":"derby_lexer.html#tokens/2"},{"type":"function","title":"derby_lexer.tokens/3","doc":null,"ref":"derby_lexer.html#tokens/3"},{"type":"module","title":"derby_parser","doc":null,"ref":"derby_parser.html"},{"type":"function","title":"derby_parser.format_error/1","doc":null,"ref":"derby_parser.html#format_error/1"},{"type":"function","title":"derby_parser.parse/1","doc":null,"ref":"derby_parser.html#parse/1"},{"type":"function","title":"derby_parser.parse_and_scan/1","doc":null,"ref":"derby_parser.html#parse_and_scan/1"},{"type":"type","title":"derby_parser.yecc_ret/0","doc":null,"ref":"derby_parser.html#t:yecc_ret/0"},{"type":"module","title":"derby_test","doc":null,"ref":"derby_test.html"},{"type":"function","title":"derby_test.test/0","doc":null,"ref":"derby_test.html#test/0"},{"type":"extras","title":"derby","doc":"# derby\n\nErlang dice rolling library using leex and yecc.","ref":"readme.html"},{"type":"extras","title":"Examples - derby","doc":"```erlang\n1> derby:query(\"4d6h3\").\n{result,14,[6,4,4],[4,4,6,2],0}\n\n2> derby:parse(\"4d6h3\").\n{roll,[6,6,6,6],0,[{high,3}]}\n\n3> derby:roll({roll,[20,20],3,[{high, 1}]}).\n{result,16,[13],[13,12],3}\n\n4> derby:chance(derby:parse(\"2d20l1\"),20).\n0.0025\n```","ref":"readme.html#examples"},{"type":"extras","title":"LICENSE","doc":"MIT License\n\nCopyright (c) 2024 Micaiah Parker \n\nPermission is hereby granted, free of charge, to any person obtaining a copy\nof this software and associated documentation files (the \"Software\"), to deal\nin the Software without restriction, including without limitation the rights\nto use, copy, modify, merge, publish, distribute, sublicense, and/or sell\ncopies of the Software, and to permit persons to whom the Software is\nfurnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all\ncopies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE\nSOFTWARE.","ref":"license.html"}],"content_type":"text/plain"}