###########
3 特殊语法
###########

3.1 基于宏模板的电路设计方法
****************************

在进行电路设计时，很多特定的电路有固定的描述方法。为了提高电路的复用性，可以通过设计电路库的方式提供基础常见的电路模块。但是通用电路模块为了保持通用性，需要引入大量参数，导致电路调用时除了复杂的端口连接，还需要参数传递，而参数传递的笔误很多只会报warning，很难进行debug。通过模板的方式可以简化电路描述中很多代码书写，部分实现自动位宽匹配，比如：例化时指定位宽、可参数化代码中的信号扩展等等。此外可以在可以在电路模板中加入assert用于进行静态验证。

使用宏的设计方法，要注意不要重复定义宏。为了方便定义，需要在一个文件中单独定义错误检验宏: **__DefErr__** 。

  .. code-block:: verilog

      `ifdef __DefErr__
        Macro Define Error: __DefErr__ has already been defined!!
      `else
        `define __DefErr__(Str) Macro Define Error: Str has already been defined!!
      `endif

3.1.1 基于宏的模板例化方法。
===============================

利用Verilog进行电路设计时，大部分参数与可以通过接口连接的信号进行推算。例如：数据位宽、地址对应的memory深度等等。因此在该设计方法中，使用宏作为module模板，减少需要显式传递的参数数量。宏模板定义代码如下：

  .. code-block:: verilog 

    // Macro templete defination for ZionCircuitLib_Adder.
    `ifdef MACRO_TEMPLATE 
      `ifdef ZionCircuitLib_Adder
        `__DefErr__(ZionCircuitLib_Adder)
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

a) 条件编译语句：'**`ifdef MACRO_TEMPLATE**'，通过宏定义指定是否启用全部宏模板。
b) 重定义检查。该写法不符合verilog语法，因此在编译时，无论编译选项如何设置，只要发现重复宏定义就会报Error。
c) 定义宏模板，宏模板定义第一行无空格，结尾直接使用 '**\\**' 换行。
d) 宏对应的module在新一行中缩进2个空格，直接按照例化格式书写。 **此处代码缩进以行首为准，不以上一层define为准，便于EDA工具展开宏后进行代码调试。**
e) 参数中先定义例化名称，再定义type参数，最后定义输入、输出端口。
f) 输入输出端口与端口名称相同，增加 '_MT' 后缀。
g) 完成module定义。
h) 定义module时，参数在两个 '**//**' 间标注计算方法。在后面的 '**//**'后写注释。若某参数与端口无关则不标注计算方法。(该写法用于宏自动生成)
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

3.1.2 基于宏的电路设计方法
==========================

由于目前调用module进行电路设计有诸多限制(不能在interface中使用等等)，而标准中规定的参数化function还有很多EDA不能支持，因此需要使用宏对需要封装的电路进行设计。

3.1.2.1 基于宏的电路模块设计
-------------------------------

  .. code-block:: verilog 

    `ifdef MACRO_TEMPLATE 

      `ifdef ZionCircuitLib_MaskM
        `__DefErr__(ZionCircuitLib_MaskM)
      `else
        `define ZionCircuitLib_MaskM(en,dat) ({$bits(dat){en}} & dat)
      `endif

      `ifdef ZionCircuitLib_OnehotM
        `__DefErr__(ZionCircuitLib_OnehotM)
      `else
        `define ZionCircuitLib_OnehotM(iDat,oDat) \
      always_comb begin: Onehot_``oDat\
        foreach(oDat[i])begin\
          oDat[i] = (iDat==i);\
        end\
      end\
      `endif

    `endif

定义方式与2.1中基于宏的例化相似。定义宏前要检查是否出现重定义错误。若没有重定义，则定义宏电路。宏电路以 **'M'** 作为后缀。其他定义方式与前述相同。**此处电路描述代码缩进以行首为准，不以上一层define为准，便于EDA工具展开宏后进行代码调试。** 只有在 **以下两种情况下** 推荐使用宏定义进行电路设计：

  - **单行宏** ：当前电路需要在一行代码内实现，即要实现类似function中return效果。
  - **多行宏** ：当前电路可能会在interface、function中使用。(interface中不能调用module)

宏电路设计方法只适用于常用基础电路，复杂电路必须使用module实现。对于所设计的宏电路，必须在文档中明确标识该宏适用于哪种场景。基于宏的电路模块调用方式如下：

  .. code-block:: verilog 
    
    module Test;
    ...

    logic [width-1:0] datOh;
    `ZionCircuitLib_OnehotM(dat,datOh);
    logic [width-1:0] finalDat;
    assign finalDat = `ZionCircuitLib_MaskM(en,datOh);

    endmodule: Test

3.1.2.2 基于模板的信号定义方法
----------------------------------

电路设计中经常会遇到需要使用特定电路(已经设计完毕的通用电路)的情况。此时需要定义信号，例化module(或直接用代码进行电路描述)。在这样的场景中，信号定义和电路描述都有固定的形式，因此可以通过宏模板进行信号定义同时自动实现针对该信号的电路描述。如下所示：

  .. code-block:: verilog

    `ifdef MACRO_TEMPLATE

      `ifdef ZionCircuitLib_type_Onehot
        `__DefErr__(ZionCircuitLib_type_Onehot)
      `else
        `define ZionCircuitLib_type_Onehot(signalName,iDat,width=2**$size(iDat),offset=0) \
      logic [width-1:0] signalName;\
      always_comb begin\
        foreach(signalName[i])begin\
          signalName[i] = (iDat == i + offset);\
        end\
      end\
      `endif

    `endif

模板信号定义方式与前述宏电路定义类似，宏名以 **'type_'**作为前缀，与第一张语法规定中typedef新的数据类型相同。基于电路模板的信号定义调用方式如下：

  .. code-block:: verilog

    module Test;
    ...

    assign dat = ... ;
    `ZionCircuitLib_type_Onehot(datOh,dat);

    endmodule: Test

该设计方法类似于面向对象语言的设计理念，针对一个信号直接引入相应的电路描述，通过该方法可以利用输入信号自动推断输出信号位宽，自动定义信号并描述得到该信号需要的电路。

3.1.3 宏模板设计方法应用注意事项
===============================

由于SystemVerilog语言本身的语法缺失，只能采用宏进行电路设计。利用宏模板设计方法后，设计电路代码看起来很像编程语言中的函数调用。此处必须要注意：**宏模板设计是利用宏在电路中实例化一个标准电路，不是函数调用，与编程语言中的函数调用有本质区别。**

3.2 基于宏电路库的设计方法
****************************

Verilog/SystemVerilog中没有基于库、包的设计方法，也没有对应的库、包管理方法。不利于设计复用。因此我们在宏模板基础上，利用宏进行电路库管理。对于一个设计好的电路库(ZionCircuitLib)，包含三个文件，文件均以电路库名称命名，后缀名不同，所有文件放置在同一个以库名命名的文件夹中：

  - ZionCircuitLib.vh

    头文件：包含该电路库中通用的数据类型、宏等。为了实现类似import的包管理，需要在该文件中定义宏缩写声明。该文件中需要包含当前库需要调用的其他电路库。

  - ZionCircuitLib.vm

    宏电路文件：3.1.2中规定的基于宏的电路设计模块都要在该文件中定义。该文件不是电路库的必须文件。

  - ZionCircuitLib.sv

    标准电路文件：所有package，interface，module都要定义在该文件中。

3.2.1 宏电路文件
================

所有宏电路都定义在同一个宏电路文件中，定义方式与3.1.2中相同。如下示例代码中展示了ZionCircuitLib电路库的宏电路文件(ZionCircuitLib.vm)。该文件中定义了一个MaskM宏，一个type_Onehot模板信号类型。

  .. code-block:: verilog 

    `ifdef MACRO_TEMPLATE

    `ifdef ZionCircuitLib_MaskM
      `__DefErr__(ZionCircuitLib_MaskM)
    `else
      `define ZionCircuitLib_MaskM(en,dat) ({$bits(dat){en}} & dat)
    `endif

    `ifdef ZionCircuitLib_type_Onehot
      `__DefErr__(ZionCircuitLib_type_Onehot)
    `else
      `define ZionCircuitLib_type_Onehot(signalName,iDat,width=2**$size(iDat),offset=0) \
    logic [width-1:0] signalName;\
    always_comb begin\
      foreach(signalName[i])begin\
        signalName[i] = (iDat == i + offset);\
      end\
    end\
    `endif

    `endif

3.2.2 标准电路文件
==================

所有package、interface和module都定义在标准电路文件中。在文件内定义顺序为 **package > interface > module** , 同优先级下，按首字母排序,由于package内部可能有依赖关系，若存在依赖关系，以依赖关系为准。若是几个module(package、interface)有一定相关性(属于同一类型不同配置 或 一同构成一个大IP)，可以在库内分成不同的section。示例代码如下：

  .. code-block:: verilog 

    //section: DemoSection++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // package

    package ZionCircuitLib_DemoPkg;
      typedef logic [3:0] type_Dat;
    endpackage: ZionCircuitLib_DemoPkg

    // interface

    interface ZionCircuitLib_InvOutItf;
      logic [3:0] dat;
    endinterface: ZionCircuitLib_InvOutItf

    // module
    ///////////////////////////////////////////////////////////////////////////////
    // Module name : ZionCircuitLib_Inv
    // Author      : Zion
    // Date        : 2019-06-20
    // Version     : 0.1
    // Description :
    //    ...
    //    ...
    // Modification History:
    //   Date   |   Author   |   Version   |   Change Description         
    //==============================================================================
    // 19-06-02 |    Zion    |     0.1     | Original Version
    // ...
    //////////////////////////////////////////////////////////////////////////////// 
    `ifndef Disable_ZionCircuitLib_Inv
    `ifdef MACRO_TEMPLATE 
    `ifdef ZionCircuitLib_Inv
      `__DefErr__(ZionCircuitLib_Inv)
    `else
      `define ZionCircuitLib_Inv(UnitName,iDat_MT,oDat_MT) \
      ZionCircuitLib_Inv  #(.WIDTH($bits(iDat_MT)))        \
                            UnitName(                      \
                              .iDat(iDat_MT),              \
                              .oDat(oDat_MT)               \
                            )
    `endif
    `endif
    module ZionCircuitLib_Inv
    #(WIDTH = "_"  //$bits(iDat)//
    )(
      input  [WIDTH-1:0] iDat,
      output [WIDTH-1:0] oDat
    );
      assign oDat = ~iDat;
    endmodule: ZionCircuitLib_Inv
    `endif

    //endsection: DemoSection+++++++++++++++++++++++++++++++++++++++++++++++++++++++

标准电路文件中，电路代码规范与文档中其他部分介绍相同。由于所有module都定义在同一个文件中，为了方便电路改动，增加模块编译开关。在示例代码中，ZionCircuitLib_Inv模块定义前增加编译开关：**\`ifndef Disable_ZionCircuitLib_Inv** 。在工程中如果需要自己重新实现该模块，可以使用该宏命令屏蔽此模块，用重新设计的代码进行替换。

给每一个宏、package、interface、module增加 **注释头** (类似文件头), demo中为了简化代码，只定义了ZionCircuitLib_Inv模块的注释头。定义格式与文件头类似。

section定义方式：
  
  - 起始：'//' + 'section: '   + SectionName + '+++++++...+++++'
  - 结束：'//' + 'endsection:' + SectionName + '+++++++...+++++'

3.2.3 头文件
=============

宏库头文件书写格式如下所示。

  .. code-block:: verilog 

    // import DemoLib

    `ifdef MACRO_TEMPLATE 

    `define ZionCircuitLib_MacroDef(ImportName, DefName)                      \
      `ifdef ImportName``DefName                                              \
        Macro Define Error: ImportName``DefName has already been defined!!    \
      `else                                                                   \
        `define ImportName``DefName `ZionCircuitLib_``DefName                 \
      `endif                                                                  
    `define ZionCircuitLib_PackageDef(ImportName, DefName)                    \
      `ifdef ImportName``DefName                                              \
        Macro Define Error: ImportName``DefName has already been defined!!    \
      `else                                                                   \
        `define ImportName``DefName ZionCircuitLib_``DefName                  \
      `endif                                                                  
    `define ZionCircuitLib_InterfaceDef(ImportName, DefName)                  \
      `ifdef ImportName``DefName                                              \
        Macro Define Error: ImportName``DefName has already been defined!!    \
      `else                                                                   \
        `define ImportName``DefName ZionCircuitLib_``DefName                  \
      `endif                                                                  
    `define ZionCircuitLib_ModuleDef(ImportName, DefName)                     \
      `ifdef ImportName``DefName                                              \
        Macro Define Error: ImportName``DefName has already been defined!!    \
      `else                                                                   \
        `define ImportName``DefName `ZionCircuitLib_``DefName                 \
      `endif
    ////////////////////////////////////////////////////////////////////////////////////////

    `define Use_ZionCircuitLib(ImportName)                 \
      `ZionCircuitLib_MacroDef(ImportName, MaskM)          \
      `ZionCircuitLib_MacroDef(ImportName, type_Onehot)    \
      `ZionCircuitLib_PackageDef(ImportName, DemoPkg)      \
      `ZionCircuitLib_InterfaceDef(ImportName, InvOutItf)  \
      `ZionCircuitLib_ModuleDef(ImportName, Inv)

    `define Unuse_ZionCircuitLib(ImportName) \
      `undef ImportName``MaskM               \
      `undef ImportName``typeOnehot          \
      `undef ImportName``DemoPkg             \
      `undef ImportName``InvOutItf           \
      `undef ImportName``Inv

    ////////////////////////////////////////////////////////////////////////////////////////
    `endif

a) 只有定义 **`ifdef MACRO_TEMPLATE** 才会启用头文件。文件分为两部分。
b) 第一部分为通用宏定义，可以用宏直接定义不同的module等。
  
  - ZionCircuitLib_MacroDef：用于定义 **宏** 和 **模板类型**。
  - ZionCircuitLib_PackageDef：用于定义 package。
  - ZionCircuitLib_InterfaceDef：用于定义 interface。
  - ZionCircuitLib_ModuleDef：用于定义module。
  - 这四个定义宏中，公共部分为电路库名称，建立新库是，需要将该部分内所有 **ZionCircuitLib** 替换为新库名称。

c) 第二部分为宏库的具体定义。

  - 定义格式：**Use_ZionCircuitLib(ImportName)**。
  - ZionCircuitLib 为库名称。
  - ImportName为在module内调用时使用的缩写。当一个module内使用多个库时，该缩写可以用于找到电路库名称。
  - 由于宏定义是全局有效，为了避免互相干扰，需要在宏库使用完毕后将已定义的宏进行undefine。因此用相同的方法定义Unuse宏。

3.2.4 宏库使用方法
==================

假设已经存在 ZionCircuitLib 电路库中的相关文件。库的使用方式如下：

  .. code-block:: verilog 

    module TestModule
    `Use_ZionCircuitLib(z)
    import `zDemoPkg::*;
    (
      input               en,
      input  type_Dat     iDat,
      output logic [15:0] oDat
    );

      `zInvOutItf datOut();
      `zInv(U_Inv,iDat,datOut.dat);

      `ztype_Onehot(datOutOh,datOut.dat);
      assign oDat = `zMaskM(en,datOutOh);

    `Unuse_ZionCircuitLib(z)
    endmodule: TestModule

a) 在module下一行import之前引用宏库：`Use_ZionCircuitLib(z)

  - 该语句结尾无 **;** 。
  - 括号内 **z** 为宏库名缩写，与 python 中 import ... as 类似。
  - 此时，库内任意元素的调用，以 **z** 开头。
  - 若当前module只使用了一个宏库，则括号内可以指定缩写也 **可以为空** ，此时直接调用元素即可。
  - 无论缩写内容是什么，宏都会扩展为全名，比如：**`zInv -> ZionCircuitLib_Inv**，因此在仿真、综合中相关内容都是以该库元素全名显示。
  - 在endmodule前 **Unuse* 相应的库：**`Unuse_ZionCircuitLib(z)** 。


