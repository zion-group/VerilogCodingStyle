##########
1 基础语法
##########

1.1 命名规范
************

1.1.1 文件命名
==============

a) 每个文件中只包含一个module、class、package，文件名与文件内内容名称相同。

  .. code-block:: verilog
  
    module TestModule;
    ...
    endmodule : TestModule

  上述代码保存在 **TestModule.sv** 文件中。

b) 头文件根据需要命名，以vh作为后缀。例如：**StructDef.vh** 。
c) 电路库文件以 **库名 + .sv** 命名。 例如：**ZionCircuitLib.sv** 文件中包含以下内容： 

  .. code-block:: verilog

    module ZionCircuitLib_ModuleAaa
    ...
    module ZionCircuitLib_ModuleBbb
    ...
    module ZionCircuitLib_ModuleCcc
    ...

1.1.2 module、class、package、function、task命名
================================================

a) 以 **大驼峰** 格式命名，package以Pkg结尾。

  .. code-block:: verilog

    //AaBbCc.sv
    module AaBbCc;
      ...
    endmodule : AaBbCc

    //XxxYyyPkg.sv
    package XxxYyyPkg;
      ...
    endpackage : XxxYyyPkg

b) 若module属于某个电路库，module命名格式：**电路库名称 + '_' + module名称**。

  .. code-block:: verilog

    module ZionCircuitLib_Max
      ...
    endmodule : ZionCircuitLib_Max

c) module例化使用前缀：**\'U\_\'** 或 **\'Ux\_\'**。

  .. code-block:: verilog

    Adder U_Adder(...);
    Adder U1_Adder(...);
    Adder U2_Adder(...);

1.1.3 信号命名
==============

1.1.3.1 命名风格
----------------
a) 所有信号采用 **小驼峰** 命名方式。

  .. code-block:: verilog

    logic dat;
    wire  memWrDat;


1.1.3.2 前缀
------------

  .. code-block:: verilog

    module DemoModule
    (
      input  iDat1,
      inout  bDat2,
      output oDat3
    );

      logic dat0,datTemp;
      logic rDat,lDat;

      ...

    endmodule : DemoModule


a) 前缀用于标志信号的特殊用途或特殊含义，以一个小写字母写在信号名前，信号名为大驼峰命名，整个信号为 **小驼峰** 命名。
b) 端口信号：

  - input: **i** (input port)， 例如：**iAaaBbb** 
  - inout: **b** (bi-directional port)， 例如：**bAaaBbb**
  - output: **o** (output port)， 例如：**oAaaBbb**

c) 寄存器：**r** (register) ，例如：**rAaaBbb** 。
d) 锁存器：**l** (latch) ，例如：**lAaaBbb** 。
e) 低有效：**n** (negative)，例如：**nAaaBbb** 。
f) 异步信号：**a** (asynchronous)，例如：**aAaaBbb** 。
g) 前缀顺序：i/b/o > a > n > r，端口信号可以只写方向，不写其他前缀。

1.1.3.3 后缀
-------------

a) 后缀用于在不改变信号名情况下表示信号属性变化，命名方式：**信号名 + \'_\' + 后缀** 。所有前缀都可以用于后缀。例如：

  .. code-block:: verilog

    assign dat = ...;
    always_ff (posedge clk) begin
      dat_r <= dat;
    end

  在上面的示例代码中，dat_r表示保存dat的寄存器的输出信号。使用 \'_\' 前的名称可以在代码中直接找到该信号。

b) 寄存器下一个时钟周期的值：**f** (following)，例如：

  .. code-block:: verilog

    logic [7:0] rWrData,rWrData_f;
    assign rWrData_f = ... ;
    always_ff (posedge clk) begin
      rWrData <= rWrData_f;
    end

c) 信号取反：**i** (invert)，例如：**assign aaaBbbVld_i = ~aaaBbbVld**;
d) 同步后信号：**s** (synchronous)，例如：**aWrEn_s**。

1.1.4 参数、宏命名
==================

  .. code-block:: verilog
  
    `define DEMO_MACRO 1
    parameter  P_PARAM_A    = 2;
    localparam P_PARAM_B    = 3;
    localparam P_PARAM_A_LG = $clog2(PARAM_A);
    parameter  type type_A  = logic [3:0];

    module Demo
    #(P_PARAM_A = 1,
      P_PARAM_B = 2,
    parameter type
      type_A = logic [3:0],
    localparam
      P_PARAM_C = 3
    )(
    );

    endmodule : Demo

a) 由于 **参数** 和 **宏** 表示常数，与普通信号不同，因此所有字母全部大写(因为全大写字符串在编辑器中高亮与普通字符串不同)，以便于信号进行区分。只有传递数据类型的参数可以包含小写字母。除type参数意外以外，其他参数定义(parameter和localparam)以 **\'P_\'** 开始。
b) 单词间用 \'_\' 隔开。
c) 若某参数 **P_PARAM_A** 是 **P_PARAM_B** 的对数，可以写成 **P_PARAM_B_LG**，例如： **P_PARAM_B_LG = $clog2(P_PARAM_B)**。
d) 在端口中定义顺序为: **parameter** > **parameter type** > **localparam**。
e) **localparam** 如果不会在端口定义中使用，可以在代码正文中定义。
f) 定义类型以 **'type_'** 作为前缀，类型名以 **大驼峰** 方式命名。

1.1.4 特殊注释命名
==================

文件中如果有待实现功能或待完善的注释，使用 **TODO** 标注。如果有BUG，使用 **FIXME** 标注。编辑器中有插件可以列出文档中所有标注的位置。

1.2 格式规范
************

1.2.1 文件头
============

每个设计文件都要包含文件头，端口处定义的参数和IO的完整注释要写在文件头中（防止代码中多行注释影响代码可读性），代码中可添加简要注释。在一个电路库文件中若包含多个单元，每个单元需要一个单独的文件头。文件头格式如下：

  .. code-block:: verilog

    ///////////////////////////////////////////////////////////////////////////////
    // Copyright(C) Zion Team. Open source License: MIT.
    // ALL RIGHT RESERVED
    // File name   : Demo.sv
    // Author      : Zion
    // Date        : 2019-06-20
    // Version     : 0.1
    // Description :
    //    ...
    //    ...
    // Parameter   :
    //    ...
    //    ...
    // IO Port     :
    //    ...
    //    ...
    // Modification History:
    //   Date   |   Author   |   Version   |   Change Description         
    //==============================================================================
    // 19-06-02 |    Zion    |     0.1     | Original Version
    // ...
    //////////////////////////////////////////////////////////////////////////////// 

1.2.2 代码格式
==================

1.2.2.1 通用格式
----------------

a) 代码缩进 **禁止使用Tab** ，一律使用 **2空格** 。
b) begin 在当前行末尾，不重新开启一行, begin前添加一个空格。end 与 else 写在同一行。

  .. code-block:: verilog

    always_comb begin
      if(...) begin
        ...
      end else if(...) begin
        ...
      end else begin
        ...
      end
    end

c) 语句间可以有1个或多个空格。多余一个空格可以方便对齐和查看(便于使用对齐插件查看代码)。例如下面的代码中, code 2 的定义在开启对其插件的情况下有更好的可读性，因为在wire之后多插入一个空格可以令下一行信号定义正确的对齐。

  .. code-block:: verilog

    // code 1
      wire testWire_1, testWire_2, testWire_3,
           testWire_4, testWire_5, testWire_6;
    // code 2
      wire  testWire_1, testWire_2, testWire_3,
            testWire_4, testWire_5, testWire_6;




d) 重要的block，及包含信号定义的block，需要添加 **block name** 。所有 **module**， **interface**， **package** 和 **有名字的block** 主要添加对应的 **ending name**。**block name** 和 **ending name** 之前的 **\':\'** 前后都需要添加空格。

  .. code-block:: verilog

    module DemoModule();
      always_comb begin : DemoBlock
        ...
      end : DemoBlock
    endmodule : DemoModule

1.2.2.2 module端口格式
----------------------

  端口格式定义如下：

  .. code-block:: verilog

    module DemoLib_ModuleXxxYyy // 单独一行，前后无空格。
    import DemoAaaPkg::*;       // 引用package，单独一行，前后无空格。
    import DemoBbbPkg::*;       // 多个package写在不同的行中。
    #(P_A = "_",                // 第一个参数以 '#(' 开头，定义在新行中，前后无空格，省略parameter标识符。
      P_B = "_",                // 其他parameter在新的行中定义，定义前需要 2个空格 进行缩进。
    localparam                  // 若存在local parameter，localparam在新的一行中定义，前后无空格。
      P_B_LG = $clog2(P_B),     // local parameter定义格式与parameter相同。
      P_C = P_A - 1
    )(                          // 在新的行中写 '参数定义右括号' 和 '端口定义左括号'。
      input        clk,rst ,    // 端口在新行中定义，2个空格缩进。'clk,rst' 可以写在同一行。
      input        iEn     ,    // 端口定义顺序：input, inout, output。
      input        iDat    ,    // 同方向端口定义顺序：clock, reset, enable, data。
      inout        bVld    ,    // 端口和参数定义结尾的逗号分隔符可以对齐也可以不对齐。      
      output logic oDat         // 代码中端口部分参数和信号后可添加简要注释，完整注释在文件头中添加。
    );                          // 端口定义 右括号 及 分号 单独一行，前后无空格。
      ...
    endmodule : DemoLib_ModuleXxxYyy //单独一行，前后无空格。添加 ending name。':' 前后各有一个空格。


    module DemoLib_Aaa
    (                           // 如果没有模块中没有参数，直接在新行中写接口定义左括号。
      input  clk,rst,
      input  iDat,
      output oDat
    );
      ...
    endmodule : DemoLib_Aaa

  如果模块端口较多，且不同端口连接模块不同，可以按照连接关系对端口进行分组：

  .. code-block:: verilog

    module DemoGroupIO
    (
      // function A IO
      input  a1,
      input  a2,
      output a3,
      // function B IO
      input  b1,
      output b2,
      // function C IO
      input c1,
      input c2
    );
      ......
    endmodule : DemoGroupIO

1.2.2.3 module例化格式
----------------------

a) 模块例化时，参数在例化时通过 **'#()'** 直接传递，尽量避免使用 **defparam**，因为在最新的标准中，已经不推荐使用defparam定义参数。模块例化可以在同一行完成，也可以分多行完成。示例代码：

  .. code-block:: verilog

    Adder 
      U_Adder(
        .a(a),
        .b(b),
        .o(o)
      );

    Sub#(
        .type_A(logic [3:0]),
        .type_B(logic [3:0]))
      U_Sub(
        .a(a),
        .b(b),
        .o(o)
      );
    
    And#(.width(8)) U_And(.a(a),.b(b),.o(o));
    And#(8) U_And(a,b,o);

b) 单行例化格式::
   
    2空格 + module名 + #( + 参数列表 + ) + 1空格 + 实例化名 + ( + 端口列表 +);
   
c) 有参数例化格式::

    2空格 + module名 + #(
    6空格 +       第一个参数 ，
                  ...
    6空格 +       第N个参数))
    4空格 +    实例化名(
    6空格          端口连接...
    4空格 +    );

d) 无参数例化格式::

    2空格 + module名  
    4空格 +    实例化名(
    6空格 +       端口连接...
    4空格 +    );

e) **参数传递** 及 **端口连接** 格式

  - 尽量避免使用 **'.*'** 方式连接，容易引起隐藏的Bug。如果对代码非常熟悉，且很有必要的情况下可以使用 '.*' 进行端口连接，使用这种方式需要在注释中说明连接了哪些端口。
  - 使用 **'.port(signal)'** 连接信号和端口。
  - 若信号和端口命名相同，可以使用 **'.port'** 方式连接。比如：带有寄存器的模块连接时，时钟和复位端口连接可使用 '.clk,.rst,'。
  - 连接顺序：input, inout, output。
  - 同方向端口顺序：clock, reset, clear, enable, data。

f) 若需要使用不指定端口，按顺序连接的方式，按照如下格式书写并用注释进行标注：

  .. code-block:: verilog

    // Instantiation in a single line.
    ModuleName#(parameter_1)  U1_ModuleName(signal_1,signal_2,signal_3,signal_4,signal_5);

    // Instantiation in multiple lines. 
    // Ports are defined in different lines according to their direction.
    ModuleName#(
        P_A)
      U2_ModuleName(
        signal_1,signal_2,  //input
        signal_3,           //inout
        signal_4,signal_5   //output 
      );

    // Instantiation in multiple lines.
    // Each port is defined in its own line. 
    ModuleName  
      U3_ModuleName(
        signal_1, //port_1
        signal_2, //port_2
        signal_3, //port_3
        signal_4, //port_4
        signal_5  //port_5
      );

g) 完整示例代码：

  .. code-block:: verilog

    module DemoModule
    (
      input        [3:0] iDatA,
      input        [3:0] iDatB,
      output logic [4:0][4:0] oDatSum,
      output logic [7:0] oDatMult
    ); 
    
      Mult#(
          .type_A(logic [3:0]),
          .type_B(logic [3:0]),
          .WIDTH($bits(datMult)))
        U_Mult(
          .iDatA(iDatA),
          .iDatB(iDatB),
          .oDat(oDatMult)
        );

      Adder 
        U_Adder(
          .iDatA(iDatA),
          .iDatB(iDatB),
          .oDat(oDatSum[0])
        );

      Adder 
        U0_Adder(
          .iDatA,
          .iDatB,
          .oDat(oDatSum[1])
        );

      Adder U1_Adder(iDatA,iDatB,oDatSum[2]);

      Adder 
        U2_Adder(
          iDatA,iDatB,//input
          oDatSum[3]   //output
        );

      Adder 
        U3_Adder(
          iDatA,   //iDatA
          iDatB,   //iDatB
          oDatSum[4]//oDat
        );

    endmodule : DemoModule

1.3 设计规范
************

1.3.1 信号定义
==============

  .. code-block:: verilog

    logic [3:0] wrDat;   
    logic [3:0] rWrDat;
    wire  [3:0] oWrDat = wrDat;
    assign wrDat = ...;
    always_ff(posedge clk)begin
      rWrDat <= wrDat;
    end

a) 所有信号使用 **logic** 定义。
b) 在定义时直接赋值的信号使用wire类型。因为logic不支持定义时赋值。
c) 组合逻辑电路表达式中包含function，使用always_comb赋值。因为assign赋值时，使用function可能引起仿真器bug。
d) 同向结构化信号，尽量使用struct定义。struct类型可以通过 **parameter type** 在不同模块间传递。

1.3.2 位宽定义及固定值赋值
==============

a) MSB写在左侧，LSB写在右侧。
b) LSB最好从0开始，如果有特殊需求，LSB可以从非零值开始，比如总线对齐：**logic [31:2] BusAddr;**
c) 固定值赋值使用以下方式：

  - 0赋值使用：**'0**，例如：**assign dat = '0;**
  - 全1赋值值使用：**'1**，例如：**assign dat = '1;**
  - 某确定值使用：**位宽 + 'b/d/h/o + 数值**，例如：**assign dat = 8'd1;**
  - 使用cast操作符 **'()** 进行参数化信号赋值：**参数 + '(带格式数值)**，例如：
    
    **assign dat = WIDHT'('d3);** 或 **assign dat = $bits(dat)'(3'b101);**

d) 当两个信号位宽有相关性，使用$bits()代替parameter定义信号位宽，这样可以使电路更利于复用，减少位宽对应参数变化引起的问题。

  .. code-block:: verilog

    logic             en;
    logic [WIDTH-1:0] xx;
    // Use like this.
    logic [$bits(xx)*2-1:0] yy; 
    assign yy[$bits(xx)-1:0] = {$bits(xx){en}} & xx;

    // Dont use like this!!
    logic [WIDTH*2-1:0] yy; 
    assign yy[WIDTH-1:0] = {WIDTH{en}} & xx;

e) 尽量使用 **[位置+:位宽]** 或 **[位置-:位宽]** 方式赋值。

  .. code-block:: verilog

    // Use like this.
    assign xx = dat[16+:8];
    assign yy = dat[16-:8];

    // Dont use like this!!
    assign xx = dat[23:16];
    assign yy = dat[15:8];

f) 使用packed方式定义多维向量信号。例如：**logic [2:0][7:0] dat;**
g) 使用系统函数进行位宽相关计算。

  - $bits：计算向量信号或struct信号的位宽。
  - $size：计算当前向量中一共有多少组信号。
  - $signed/$unsigned：有符号/无符号位宽扩展
  - $clog2：计算log\ :sub:`2`\(x), 可以使用在端口定义中。
  - $high：获取信号最高位。**使用时需要小心，信号有可能不是第0位开始**。
  - $low： 获取信号最低位。

h) 如果定义MSB在左侧，LSB在右侧，从0开始的信号，比如：[7:0] 或 [31:0]，推荐使用预定义的宏进行位宽定义，可以增强可读性，降低bug出现几率。

  - `w()：`define w(__width__)  (__width__):0
  
    用 **参数**、**宏定义** 或 **计算式** 定义信号位宽。
    
  - `b()：`define b(__signal__) (__signal__):0
  
    根据一个已知信号的定义相同位宽的信号。
  
  .. code-block:: verilog
  
    `define w(__width__)  (__width__):0
    `define b(__signal__) (__signal__):0
    
    logic [`w(P_WIDTH)] datA;
    logic [`w(P_WIDTH)]['b(datA)] datB;

1.3.3 组合逻辑电路设计规范
==========================

a) 在设计中使用data mask写法：**yy = {$bits(xx){en}} & xx;**
  
  - 综合生产的电路简洁高效，Bug少。配合Onehot信号使用，效果极好。
  - 可以用来代替三目运算符 ()?: ，实现更好的性能。

  .. code-block:: verilog

    // Use like this.
    assign dat  = {$bits(a){(x==2'd1 && y==2'd1)}} & a;
                  {$bits(b){(x==2'd2 && y==2'd2)}} & b;
                  {$bits(c){(x==2'd3 && y==2'd3)}} & c;
                  {$bits(d){(x==2'd4 && y==2'd4)}} & d;

    // Dont use like this!!
    assign dat  = (x==2'd1 && y==2'd1)? a :
                  (x==2'd2 && y==2'd2)? b :
                  (x==2'd3 && y==2'd3)? c : d;

b) 使用操作符：**inside**。

  .. code-block:: verilog

    assign datEn = dat inside {2'd1, 2'd3};

c) 使用操作符：**{<<N{Signal}}** 或 **{>>N{Signal}}** 。

  .. code-block:: verilog

    assign a = {<<2{b}}; 
    assign b = {>>2{c}};

d) 使用操作符：**==?** 或 **!=?**。

  .. code-block:: verilog

    assign datEn = (a ==? 3'b1?1) & (b !=? 3'b??1);

e) 使用操作符：**'( )**。

  .. code-block:: verilog

    logic [7:0][2:0] a;
    typedef logic [2:0][7:0] type_Dat;
    type_Dat b;
    assign b = type_Dat'(a);

f) 使用操作符：**>>>**。**该操作符必须对signed类型信号是用，否则计算结果错误**。

  .. code-block:: verilog

    logic signed [7:0] a,b;
    assign a = b >>> 4;

g) 组合逻辑使用 **assign** 和 **always_comb** 块。在always_comb块中，使用 **'='** 赋值。
h) 在组合逻辑中，if只与else搭配， **不允许使用else if** 。如果有多判断条件存在，使用case语句。简单的 if()...else... 语句综合生成无优先级电路。而 if()... else if()... else... 语句在大多数情况下会综合出带优先级逻辑。为避免过度使用else if引入不必要的逻辑路径，禁止在逻辑电路中使用该语法。

  .. code-block:: verilog

    always_comb begin
      if(...)begin
        ...
      end else begin // no else if(..) !!
        ...
      end
    end

i) case 语句用法规范。

  - case条件如果互斥，使用：**unique case(xxx) inside** 或 **unique case(1'b1)**
  - case条件若非互斥，使用：**priority case(xxx) inside** 或 **priority case(1'b1)**
  - 设计中，尽量使用 **unique case** 。综合后生成无优先级电路，priority生成带优先级电路。
  - case条件复杂，需要在判断条件后添加注释说明判断条件含义。
  - default规范:
    
    - 若有一个固定默认值，则default为固定值。
    - 若case条件已经是full case，则default替换为：'**// full case**'。注意在full case的情况下，不要写default，不然综合器会发现无法进入该条件，报warning。
    - 若不存在default，则禁止使用case语句。这种情况使用case有可能造成后仿与前仿行为不一致。

  - case最多允许嵌套2层。
  - 尽量避免使用太长的case语句。如果逻辑过于复杂，建议拆分逻辑实现。

  .. code-block:: verilog

    always_comb
      unique case(xx) inside
        2'b00: dat0 = ...;
        2'b01: dat0 = ...;
        2'b10: dat0 = ...;
        2'b11: dat0 = ...;
        // full case
      endcase

    always_comb
      priority case(xx) inside
        2'b0?: dat1 = ...;
        2'b10: dat1 = ...;
        default: dat1 = '0;
      endcase

    always_comb
      unique case(1'b1)
        a==2'b00 && b==2'b00: begin // Add comments for case 1 condition!
          dat2 = ...;
        end
        a==2'b11 && b==2'b11: begin // Add comments for case 2 condition!
          dat2 = ...;
        end
        default: dat2 = '0;
      endcase

j) 在always块中对多个信号进行条件赋值时，必须在所有条件下对每个信号赋值。设计时可采用下一方法中任意一种：
  - 在条件赋值前给信号默认值，在条件赋值时对部分信号赋值。
  - 在所有条件分支中写明所有信号赋值。

  .. code-block:: verilog

    // Assignment with default value
    always_comb begin
      a = '0;
      b = '0;
      if(x) begin
        a = '1;
      end else begin
        b = '1;
      end
    end

    // Assign value to all signals in each condition
    always_comb begin
      if(x) begin
        c = '1;
        d = '0;
      end else begin
        c = '0;
        d = '1;
      end
    end

    // Code write as below is wrong. It will generate latches.
    always_comb begin
      if(x) begin
        m = '1;
      end else begin
        n = '1;
      end
    end

1.3.4 时序电路设计规范
======================

a) 寄存器设计使用：**always_ff**， 赋值符号：**<=**
b) 锁存器设计使用：**always_latch**， 赋值符号：**=**
c) 寄存器设计时，信号顺序遵循：reset > enable > assignment。**信号保持的else不要写**。

  .. code-block:: verilog

    always_ff (posedge clk, negedge rst)
      if(!rst)
        dat <= P_INI_DAT;
      else 
        if(clr)
          dat <= P_INI_DAT;
        else
          if(en)
            if(a)
              dat <= datA;
            else
              dat <= datB;
          //else  <---------- Dont write the assignment for data keeping!
          //  dat <= dat; <-- Dont write the assignment for data keeping! 

d) 在IC设计中，使用 **异步低有效** 复位。标准单元对于这种复位方式支持更好。
e) 在FPGA设计中，使用 **同步高有效** 复位。
f) 尽量简化寄存器块中逻辑判断电路的复杂度，需要复杂逻辑的场景中，先使用组合逻辑电路计算寄存器数据，再保存到寄存器中。
g) 推荐使用module对寄存器进行封装，在需要寄存器电路时直接调用。

1.3.5 参数定义规范
====================

a) 只有可能在例化时传递的参数才可以定义为parameter，其他模块内部的信号都要定义为localparam。
b) localparam可以定义在端口处，也可以在代码内有需要的地方再定义。
c) 如果一个信号类型在模块端口或内部多次使用，则可以在module起始位置定义信号的type。
d) verilog支持参数矩阵，定义时要把参数 **显式定义为int类型**。不然默认为 1bit 的 logic 信号。
e) 如果需要定义动态参数矩阵，需要先定义矩阵维度参数。设计过程中注意不要超出参数范围。代码如下所示：

  .. code-block:: verilog

    module TestAaa
    #(NUM = 4,
      int ADDRS = {0,1,2,3}
    )(
    ...
    );
    ...
    endmodule : TestAaa

    module tb;
      TestAaa U_TestAaa(...);
      defparam U_TestAaa.NUM = 8;
      defparam U_TestAaa.ADDRS = {0,1,2,3,4,5,6,7};
      ...
    endmodule : tb

1.3.6 例化设计规范
==================

TODO

1.3.7 FSM设计规范
=================

TODO

1.4 仿真规范
************

1.4.1 信息打印规范
==================

a) 参数检查等功能可以放置在initial块中。发现代码错误的情况使用 **$error**, 不使用'$display',因为$error在打印信息时可以提示错误位置。添加宏定义控制变量 **CHECK_ERR_EXIT**。开启该宏后，发生错误时可以停止仿真。
  .. code-block:: verilog
    module Dff
    #(WIDTH_IN  = "_", // width of input data
      WIDTH_OUT = "_"  // width of output data
    )(
      input                        clk,
      input        [WIDTH_IN -1:0] iDat,
      output logic [WIDTH_OUT-1:0] oDat
    );

      always_ff@(posedge clk)
        oDat <= iDat;

      // parameter check, if the width of input data and output data are not equal, print error.
      initial begin
        if(WIDTH_IN != WIDTH_OUT) begin
          $error("Parameter Err: Dff IO width mismatch!!");
          `ifdef CHECK_ERR_EXIT
            $finish;
          `endif
        end
      end

    endmodule : Dff

TODO: 多等级打印
