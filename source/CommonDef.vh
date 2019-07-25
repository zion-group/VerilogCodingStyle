`define gen_if   if
`define gen_elif else if
`define gen_else else

`defineMACRO_TEMPLATE

`ifdef __DefErr__
  Macro Define Error: __DefErr__ has already been defined!!
`else
  `define __DefErr__(Str) Macro Define Error: Str has already been defined!!
`endif

