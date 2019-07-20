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
    endmodule: TestModule

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
    endmodule: AaBbCc

    //XxxYyyPkg.sv
    package XxxYyyPkg;
      ...
    endpackage: XxxYyyPkg

b) 若module属于某个电路库，module命名格式：**电路库名称 + '_' + module名称**。

  .. code-block:: verilog

    module ZionCircuitLib_Max
      ...
    endmodule: ZionCircuitLib_Max

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

    endmodule: DemoModule


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
    parameter PARAM_A = 2;
    localparam PARAM_B = 3;
    localparam PARAM_A_LG = $clog2(PARAM_A);
    parameter type type_A = logic [3:0];

    module Demo
    #(PARAM_A = 1,
      PARAM_B = 2,
    parameter type
      type_A = logic [3:0],
    localparam
      PARAM_C = 3
    )(
    );

    endmodule

a) 由于 **参数** 和 **宏** 表示常数，与普通信号不同，因此所有字母全部大写，以便于信号进行区分。只有传递数据类型的参数可以包含小写字母。
b) 单词间用 \'_\' 隔开。
c) 若某参数 **PARAM_A** 是 **PARAM_B** 的对数，可以写成 **PARAM_B_LG**，例如： **PARAM_B_LG = $clog2(PARAM_B)**。
d) 在端口中定义顺序为: **parameter** > **parameter type** > **localparam**。
e) localparam如果不会在端口定义中使用，可以在代码正文中定义。
f) 定义类型以 **'type_'** 作为前缀，类型名以 **大驼峰** 方式命名。

1.2 格式规范
************

1.2.1 文件头
============

每个设计文件都要包含文件头，文件头格式如下：

  .. code-block:: verilog

  ///////////////////////////////////////////////////////////////////////////////
  // Copyright(C) Zion Team. Open source License: MIT.
  // ALL RIGHT RESERVED
  // Filename : Demo.sv
  // Author   : Zion
  // Date     : 2019-06-20
  // Version  : 0.1
  // Description :
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
b) begin 在当前行末尾，不重新开启一行。end 与 else 写在同一行。

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

c) 语句间可以有1个或多个空格。多余一个空格可以方便对齐和查看(便于使用彩虹对齐插件查看代码)。
d) 重要的block，及包含信号定义的block，需要添加 **block name** 。所有 **module** 和 **有名字的block** 主要添加对应的 **ending name**。

  .. code-block:: verilog

    module DemoModule();
      always_comb begin: DemoBlock
        ...
      end: DemoBlock
    endmodule: DemoModule

1.2.2.2 module端口格式
----------------------

  端口格式定义如下：

  .. code-block:: verilog

    module DemoLib_ModuleXxxYyy // 单独一行，前后无空格。
    import DemoAaaPkg::*;       // 引用package，单独一行，前后无空格。
    import DemoBbbPkg::*;       // 多个package写在不同的行中。
    #(PARAM_A = "_",            // 第一个参数以 '#(' 开头，定义在新行中，前后无空格，省略parameter标识符。
      P_B     = "_",            // 其他parameter在新的行中定义，定义前需要 2个空格 进行缩进。
    localparam                  // 若存在local parameter，localparam在新的一行中定义，前后无空格。
      P_B_LG = $clog2(P_B),      // local parameter定义格式与parameter相同。
      PARAM_C = PARAM_A - 1
    )(                          // 在新的行中写 '参数定义右括号' 和 '端口定义左括号'。
      input        clk,rst,     // 端口在新行中定义，2个空格缩进。'clk,rst' 可以写在同一行
      input        iEn,         // 端口定义顺序：input, inout, output。
      input        iDat,        // 同方向端口定义顺序：clock, reset, enable, data。
      inout        bVld,        
      output logic oDat,
    );                          // 端口定义 右括号 及 分号 单独一行，前后无空格。
      ...
    endmodule: DemoLib_ModuleXxxYyy //单独一行，前后无空格。添加 ending name。


    module DemoLib_Aaa
    (                           // 如果没有模块中没有参数，直接在新行中写接口定义左括号。
      input  clk,rst,
      input  iDat,
      output oDat
    );
      ...
    endmodule: DemoLib_Aaa

1.2.2.3 module例化格式
----------------------

a) 模块例化时，只有定义信号类型的参数在例化时传递，其他参数在module结尾统一使用defparam定义。理由如下：

  - 参数化设计中，参数定义数量很多，在module例化时传递大量参数影响代码阅读
  - 大部分参数可以通过已连接的端口用系统函数进行计算($bits,$size,$clog2...)，统一写在module结尾方便脚本进行自动生成。

  示例代码：

  .. code-block:: verilog

    Adder U_Adder(
            .a(a),
            .b(b),
            .o(o)
          );

    Sub #(.type_A(logic [3:0])
          .type_B(logic [3:0]))
        U_Sub(
          .a(a),
          .b(b),
          .o(o)
        );

    defparam U_Addr.WIDTH_A = 4;
    defparam U_Addr.WIDTH_B = 4;


b) 有参数例化格式::

    2空格 + module名 + 空格 +  #(第一个参数传递 ，
                                第二个参数传递))
                              实例化名(
                                端口连接...
                              );

c) 无参数例化格式::

    2空格 + module名 + 空格 +  实例化名(
                                端口连接...
                              );

d) **参数传递** 及 **端口连接** 格式

  - 尽量避免使用 **'.*'** 方式连接，容易引起隐藏的Bug。
  - 使用 **'.port(signal)'** 连接信号和端口。
  - 若信号和端口命名相同，可以使用 **'.port'** 方式连接。
  - 连接顺序：input, inout, output。
  - 同方向端口顺序：clock, reset, enable, data。

e) 若需要使用不指定端口，按顺序连接的方式，按照如下格式书写并用注释进行标注：

  .. code-block:: verilog

    ModuleName  U1_ModuleName(signal1,signal2,signal3,signal4,signal5);

    ModuleName  U2_ModuleName(
                  signal1,signal2,  //input
                  signal3,          //inout
                  signal4,signal5   //output 
                );

    ModuleName  U3_ModuleName(
                  signal1,     //port1
                  signal2,     //port2
                  signal3,     //port3
                  signal4,     //port4
                  signal5      //port5
                );

f) 完整示例代码：

  .. code-block:: verilog

    module AaaBbb
    (
      input        [3:0] iDatA,
      input        [3:0] iDatB,
      output logic [4:0][4:0] datSum,
      output logic [7:0] datMult
    ); 
    
      Mult  #(.type_A(logic [3:0]),
              .type_B(logic [3:0]))
            U_Mult(
              .iDatA(iDatA),
              .iDatB(iDatB),
              .oDat(datMult)
            );

      Adder U_Adder(
              .iDatA(iDatA),
              .iDatB(iDatB),
              .oDat(datSum[0])
            );

      Adder U0_Adder(
              .iDatA,
              .iDatB,
              .oDat(datSum[1]));

      Adder U1_Adder(iDatA,iDatB,datSum[2]);

      Adder U2_Adder(
              iDatA,iDatB,//input
              datSum[3]   //output
            );

      Adder U3_Adder(
              iDatA,   //iDatA
              iDatB,   //iDatB
              datSum[4]//oDat
            );

      defparam U_Mult.WIDTH = $bits(datMult);

    endmodule: AaaBbb

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

1.3.2 位宽定义
==============

a) MSB写在左侧，LSB写在右侧。
b) LSB最好从0开始，如果有特殊需求，LSB可以从非零值开始，比如总线对齐：**logic [31:2] BusAddr;**
c) 固定值赋值使用以下方式：

  - 0赋值使用：**'0**，例如：**assign dat = '0;**
  - 全1赋值值使用：**'1**，例如：**assign dat = '1;**
  - 某确定值使用：**位宽 + 'b/d/h/o' + 数值**，例如 **assign dat = 8'd1;**

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
  - $clog22：计算log\ :sub:`2`\(x), 可以使用在端口定义中。
  - $high：获取信号最高位。**使用时需要小心，信号有可能不是第0开始**。
  - $low： 获取信号最低位。

1.3.3 组合逻辑电路设计规范
==========================

a) 在设计中使用data mask写法：**yy = {$bits(xx){en}} & xx;**
  
  - 综合生产的电路简洁高效，Bug少。
  - 可以用来代替三目运算符 ()?: ，实现更好的性能。

  .. code-block:: verilog

    // Use like this.
    assign dat  = {$bits(a){(x==2'd1 && y==2'd1)}} & a;
                  {$bits(b){(x==2'd1 && y==2'd1)}} & b;
                  {$bits(c){(x==2'd1 && y==2'd1)}} & c;
                  {$bits(d){(x==2'd1 && y==2'd1)}} & d;

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
    typedef logic [2:0][7:0] type_dat;
    type_dat b;
    assign b = type_dat'(a);

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

a) 寄存器设计使用：**always_ff**
b) 锁存器设计使用：**always_latch**
c) 寄存器电路赋值使用：**<=**
d) 寄存器设计时，信号顺序遵循：reset > enable > assignment。**信号保持的else不要写**。

  .. code-block:: verilog

    always_ff (posedge clk, negedge rst)
      if(!rst)
        dat <= ...;
      else if(en)
        if(a)
          dat <= ...;
        else
          dat <= ...;
    //else  <---------- Dont write the assignment for data keeping!
    //  dat <= dat; <-- Dont write the assignment for data keeping! 

e) 在IC设计中，使用 **异步低有效** 复位。标准单元对于这种复位方式支持更好。
f) 在FPGA设计中，使用 **同步高有效** 复位。
g) 尽量简化寄存器块中逻辑判断电路的复杂度，需要复杂逻辑的场景中，先使用组合逻辑电路计算寄存器数据，再保存到寄存器中。
h) 推荐使用module对寄存器进行封装，在需要寄存器电路时直接调用。
i) 当设计可能同时用于不同的工艺或器件中时，使用CfgDff进行寄存器电路实现。

1.3.5 例化设计规范
==================

TBD

1.3.6 FSM设计规范
=================

TBD
