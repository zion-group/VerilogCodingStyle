###########
3 特殊语法
###########

3.1 基于宏定义的模板例化方法。
******************************

利用Verilog进行电路设计时，大部分参数与可以通过接口连接的信号进行推算。例如：数据位宽、地址对应的memory深度等等。因此在该设计方法中，使用宏作为module模板，减少需要显式传递的参数数量。宏模板定义代码如下：

  .. code-block:: verilog 

    `define __DefErr__(Str) Macro Define Error: Str has already been defined!! 
    // __DefErr__() is defined in the library. 

    // Macro templete defination for ZionCircuitLib_Adder.
    `ifdef MACRO_TEMPLETE 
      `ifdef ZionCircuitLib_Adder
        __DefErr__(ZionCircuitLib_Adder)
      `else
        `define ZionCircuitLib_Adder(UnitName,TypeB_MT,iDatA_MT,iDatB_MT,oDat_MT)\
      ZionCircuitLib_Adder  #(.WIDTH_A($bits(iDatA_MT)), \
                              .WIDTH_O($bits(oDat_MT)),  \
                              .TypeB(TypeB_MT))          \
                            UnitName(                    \
                              .iDatA(iDatA_MT),          \
                              .iDatB(iDatB_MT),          \
                              .oDat(oDat_MT)             \
                            )
      `endif
    `endif
    module ZionCircuitLib_Adder
    #(WIDTH_A = "_",  //$bits(iDatA)//
      WIDTH_O = "_",  //$bits(oDat)//
    parameter type
      TypeB = "_"
    )(
      input  [WIDTH_A-1:0] iDatA,
      input  [WIDTH_B-1:0] iDatB,
      output [WIDTH_O-1:0] oDat
    );
      assign oDat = iDatA + iDatB;
    endmodule: ZionCircuitLib_Adder

按照规范设计module。在module定义上声明宏模板。宏模板格式：

a) 条件编译语句：'**`ifdef MACRO_TEMPLETE**'，通过宏定义指定是否启用全部宏模板。
b) 重定义检查。'**__DefErr__()**' 是库中已经定义好的宏。
c) 定义宏模板，宏模板定义第一行无空格，结尾直接使用 '**\\**' 换行。
d) 宏对应的module在新一行中缩进2个空格，直接按照例化格式书写。
e) 参数中先定义例化名称，再定义type参数，最后定义输入、输出端口。
f) 输入输出端口与端口名称相同，增加 '_MT' 后缀。
g) 完成module定义。
h) 定义module时，参数在两个 '**//**' 间标注计算方法。在后面的 '**//**'后写注释。若某参数与端口无关则不标注计算方法。(改写法用于宏自动生成)
i) 除最后一行外，其他行宏以 '**\\**' 结尾。(多行宏定义标准写法)
j) 结束条件编译。

宏模板例化代码如下：

  .. code-block:: verilog 

    `ZionCircuitLib_Adder (UnitName,TypeB,InA,InB,Out);

    `ZionCircuitLib_Adder (UnitName,
                            TypeB,   //TypeB
                                
                            InA,InB, //input
                            Out      //output
                          );

    `ZionCircuitLib_Adder (UnitName, 
                            TypeB,  //TypeB
                            
                            InA,    //iDatA
                            InB,    //iDatB
                            Out     //oDat
                          );

宏模板例化时可参考无端口声明module例化方式。

- 单行例化

  按照顺序填写 **例化名**、 **type参数** 和 **输入、输出端口**。

- 多行例化

  1. 宏module名与例化名写在同一行
  2. 若有type参数，在新行中填写type参数。从 '**(**' 缩进两个空格。
  3. 最后一个type参数后空行，按序填写输入输出端口。
  4. 端口填写完毕后，在新行中写 '**);**' , 与 '**(**' 对齐。

3.2 基于宏的电路库的设计方法
******************************

Verilog/SystemVerilog中没有基于库、包的设计方法，也没有对应的库、包管理方法。不利于设计复用。因此我们在宏模板基础上，利用宏进行电路库管理。假设已经存在基于宏模板设计的模块：

- \`ZionCircuitLib_Adder(UnitName,iDatA_MT,iDatB_MT,oDat_MT)
- \`ZionCircuitLib_Sub(UnitName,iDatA_MT,iDatB_MT,oDat_MT)

这两个模块都属于 ZionCircuitLib 电路库。电路库头文件 ZionCircuitLib.vh 定义代码如下：

  .. code-block:: verilog 

    // Code shown as below is defined in another Header file.
    // It is used by all Macro Library Header file.
    `ifdef MACRO_CIRCUIT_LIB
    `define MacroLibDef(LibName,ImportName,ModuleName)         \
      `ifdef ImportName``ModuleName                            \
        `__DefErr__(ImportName``ModuleName);                   \
      `else                                                    \
        `define ImportName``ModuleName `LibName``_``ModuleName \
      `endif
    `endif
    
    // This is the Library Header.
    `ifdef MACRO_CIRCUIT_LIB
    `define Use_ZionCircuitLib(ImportName)           \
      `MacroLibDef(ZionCircuitLib,ImportName,Adder)  \
      `MacroLibDef(ZionCircuitLib,ImportName,Sub)


    `define Unuse_ZionCircuitLib(ImportName) \
      `undef ImportName``Adder               \
      `undef ImportName``Sub

    `endif

a) 条件编译语句，通过定义 **MACRO_CIRCUIT_LIB** 宏启用宏库设计方法。
b) 定义 ZionCircuitLib 宏库使用命令，定义格式：**Use_ZionCircuitLib(ImportName)**。

  - ZionCircuitLib 为库名称。
  - ImportName为在module内调用时使用的缩写。当一个module内使用多个库时，该缩写可以用于找到电路库名称。

c) 使用 **MacroLibDef** 宏定义每一个module。
d) 由于宏定义是全局有效，为了避免互相干扰，需要在宏库使用完毕后将已定义的宏进行undefine。因此用相同的方法定义Unuse宏。

宏库的调用代码如下：

  .. code-block:: verilog 

    module Aaa
    (
      ...
    );

      `Use_ZionCircuitLib(z)
      
      `zAdder (U_Adder,
                a,  //iDatA
                b,  //iDatB
                x   //oDat
              );
      `zSub (U_Sub,a,b,y);

      `Unuse_ZionCircuitLib(z)

    endmodule

    module Bbb
    `Use_ZionCircuitLib(z)
    (
      ...
    );

      `zAdder (U_Adder,a,b,x);
      `zSub (U_Sub,a,b,y);

      `Unuse_ZionCircuitLib(z)

    endmodule


    `Use_ZionCircuitLib(z)

    module Ccc
    (
      ...
    );

      `zAdder (U_Adder,a,b,x);
      `zSub (U_Sub,a,b,y);

    endmodule

    `Unuse_ZionCircuitLib(z)


a) 显示声明使用宏库：Use_MacroLibraryName(ImportName)。结尾无分号。
b) 用import name进行设计。
c) 显示声明关闭宏库：Unuse_MacroLibraryName(ImportName)。结尾无分号。
d) 宏库声明的位置与 import 用法相同。可以用于文件，或单个module。
