`define gen_if   if
`define gen_elif else if
`define gen_else else

`define MACRO_TEMPLATE
`define LIB_PARAMETER_ERROR_STOP

`ifdef __DefErr__
  Macro Define Error: __DefErr__ has already been defined!!
`else
  `define __DefErr__(Str) Macro Define Error: Str has already been defined!!
`endif

