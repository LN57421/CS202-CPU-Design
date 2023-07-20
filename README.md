## 基础部分

## （一）开发者说明

| 小组成员         | 贡献比 |                                                              |
| ---------------- | ------ | ------------------------------------------------------------ |
| 李伟浩 -12110415 | 1/3    | 分频器的实现（timedivider），7段数码管的显示实现（LED），两个测试场景共16个测试用例的mips代码实现 |
| 刘家宝 -12110416 | 1/3    | CPU核心的设计、oj测试、仿真测试、上板测试、最终实现（包括if,  dememory, decoder, ALU, controller, memorio, in, out的实现） |
| 伍福临 -12110411 | 1/3    | 顶层模块的设计（接线），协助完成memorio, in, out模块的实现，uart功能的实现（program_rom的实现，  if模块的改写），VGA功能的实现（VGA） |

## （二）版本修改记录

### 1.开发过程中的版本控制

| 时间      | 版本控制方式                                                 | 相关链接                                                |
| --------- | ------------------------------------------------------------ | ------------------------------------------------------- |
| ~5.8      | 成员个人电脑进行各自部分的版本控制（文件控制法）             | 无                                                      |
| 5.8~5.16  | 使用github进行版本控制（上传了所有相关文件，包括vivado工程项目文件） | https://github.com/LN57421/CS202-Project-CPU-Design.git |
| 5.17~5.24 | 使用github进行版本控制（新建仓库, 只上传.v文件，便于版本控制） | https://github.com/publicclassdemo/CS202ProjectWLL.git  |
| 5.24~     | 使用github进行版本控制（新建仓库,由于上一版本分支处理是出现问题，决定新建，并主要使用主分支 ） | https://github.com/LN57421/CS202-CPU-Design.git         |

### 2.项目整体开发进度

**CPU的实现**

|    相关进程    | 完成时间 |
| :------------: | :------: |
| 基本代码的实现 |   5.5    |
|   OJ测试通过   |   5.13   |
|  仿真波形通过  |   5.27   |
|  上板测试通过  |   5.28   |

**测试场景与测试用例**

|    相关进程    | 完成时间 |
| :------------: | :------: |
| mips代码的实现 |   5.27   |
|  上板测试通过  |   5.28   |

**Bonus的实现**

|                 相关进程                 | 完成时间 |
| :--------------------------------------: | :------: |
|               uart代码实现               |   5.20   |
|             uart上板测试通过             |   5.23   |
|               VGA代码实现                |   5.26   |
|               VGA测试通过                |   5.27   |
| 七段数码显示管（更好的用户体验）代码实现 |   5.25   |
| 七段数码显示管（更好的用户体验）测试通过 |   5.28   |

### 3.项目开发进度（更新点描述）

| 时间      | 更新内容                                                     |
| --------- | ------------------------------------------------------------ |
| 4.25      | 进行小组分工                                                 |
| 4.26-5.5  | 进行CPU框架子模块搭建                                        |
| 5.6-5.13  | 子模块分别进行oj测试 oj全部通过                              |
| 5.14-5.22 | 进行代码整合，未进行顶层模块仿真，直接上板失败；uart代码完成完成 |
| 5.22-5.24 | 对MemIO进行仿真，确定无误；uart上板测试完成                  |
| 5.25-5.27 | 对顶层模块仿真，发现接线错误，并进行改正；VGA代码完成，测试通过 |
| 5.28-5.29 | 进行所有asm文件测试并通过                                    |

## （三）CPU架构设计说明

### 1.CPU特性

#### （1）ISA


- 基本的MIPS32指令集全部实现

- 采用是32个32位宽的寄存器

- 对异常处理的情况

  通过软件形式我们实现了对异常的检测。以加法为例，我们通过检测最高比特位是否改变的形式来检测是否出现溢出情况。当两操作数符号相反，则不可能溢出。当两操作数符号相同，检测运算结果与操作数的符号差别，当运算结果与操作数的符号不相同时，则有溢出发生，当符号相同时，则无溢出发生，通过检测符号位的形式来实现溢出检测功能。除了加法之外，对于有符号数减法，有符号数乘法，有符号数除法等我们均实现了上述方式的溢出检测功能。

#### （2）寻址空间的设计

**哈佛结构**

其中ALU对应**ALU**模块，control unit对应**control**模块，Data Memory 对应**dmemory**模块， Instructins Memory 对应**IFetch**模块，I/O对应**memoryorio、in、out**模块。

**寻址单位为32bit，指令空间和数据空间的大小均为16384bit**

#### （3）对外设IO的支持

*采用单独的访问外设的指令（ 以及相应的指令） 还是M M I O （ 以及相关外设对应的地址） ， 采用轮询还是中*
*断的方式访问I O 。*

采用MMIO来进行外设的访问。

```verilog
0xFF70    选择信号  最右四比特  		  		lw中特定地址，从拨码开关获取数据到寄存器
0xFF74    运算数字1 左拨码		 	   	 lw中特定地址，从拨码开关获取数据到寄存器
0xFF78    运算数字2 右拨码					 lw中特定地址，从拨码开关获取数据到寄存器
0xFF7C    使能信号							   lw中特定地址，从拨码开关获取数据到寄存器
0xFF64    计算结果1 左灯                 sw中特定地址，将寄存器的运算结果传给LED模块
0xFF68    计算结果2 右灯 					  sw中特定地址，将寄存器的运算结果传给LED模块
```

在MIPS代码中，采用轮询方式来不间断监听拨码开关的输入，并且不间断的向LED模块输出最新的运算结果。

在此过程中，整个运算程序以无穷循环的形式不断运行。



#### （4）CPU的CPI

**CPI = 1； 为单周期CPU**； **不支持Pipeline**

### 2.CPU接口

```verilog
module top (
    fpga_rst,     // Reset signal
    fpga_clk,     //Clock signal 100MHz
    switch2N4,    //24 bit DIP switch
    led2N4,       //24-bit LED light 
    led_select,   //Select the bright LED light,and the low level is the bright light, indicating the choice
    signal_display,  //LED tube content
    start_pg, //Enable signal to enter UART communication mode
    rx, 
    tx,
    //uart need
    vga_h,
    vga_v,
    vga_rgb
    //VGA need
);
```

- **`fpga_rst`: **复位信号，与minisys开发板上按钮P5绑定
- **`fpga_clk`**:时钟信号，与minisys开发板上Y18时钟信号绑定，提供100MHz的初始时钟
- **`switch2N4`**：24位输入，与minisys开发板上24位拨码开关绑定
- **`led2N4`**：24位输出，与minisys开发板上24位LED灯绑定
- **`led_select`**：7段数码管的8位使能信号
- **`signal_display`**：7段数码管的8位内容信号
- **`start_pg`**: uart模块使用到的通信使能信号，与minisys开发板上P4按钮进行绑定，按下后进入uart通信模式
- **`rx`**, **`tx`**: uart模块需要与minisys开发板Y19, V18 绑定的发送与接收信号
- **`vga_h`**, **`vga_v`**: VGA模块需要与minisys开发板M21, L21绑定的场扫描信号和行扫描信号
- **`vga_rgb`**： VGA模块需要的与minisys开发板绑定的rgb颜色信号，向开发板传递需要渲染的颜色

### 3.CPU内部结构

#### （1）CPU内部各子模块的接口连接关系图

**清晰的接线图见附件一PDF文件**

#### （2）CPU内部子模块的设计说明

##### a.时钟模块

该模块使用vivado中自带的时钟ip核,用于生成除uart模块使用的15MHz的时钟信号，uart使用的10MHz的时钟信号，VGA使用的25MHz的时钟信号，端口绑定及说明如下：

```verilog
clk_wiz_0 clk (
        .clk_in1 (fpga_clk),
        .clk_out1(clock),
        .clk_out2(upg_clk),
        .clk_out3(vga_clk)
    );
```

- `clk_in1`: 开发板上的100MHz的时钟信号
- `clk_out1`: 除uart模块使用的15MHz的时钟信号
- `clk_out2`: uart使用的10MHz的时钟信号
- `clk_out3`: VGA使用的25MHz的时钟信号

##### b.timedivider模块

该模块用于获得2ms, 1s 和500us的时钟信号，其中clk和reset直接与开发板上的时钟和复位信号绑定。

```verilog
module TimeDivider (
    clk,
    reset,
    clk_out_2ms,
    clk_out_1s,
    clk_out_500us
);
  input wire clk;
  input wire reset;
  output reg clk_out_2ms;
  output reg clk_out_1s;
  output reg clk_out_500us;

  parameter period_500us = 50_000;
  parameter period_2ms = 2_000_00;
  parameter period_1s = 1_00_000_000;

  reg [21:0] cnt_20ms;
  reg [28:0] cnt_1s;
  reg [28:0] cnt_500us;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      cnt_1s <= 0;
      cnt_20ms <= 0;
      cnt_500us <= 0;
      clk_out_1s <= 0;
      clk_out_2ms <= 0;
      clk_out_500us <= 0;
    end else begin
      if (cnt_20ms == (period_2ms >> 1) - 1) begin
        clk_out_2ms <= ~clk_out_2ms;
        cnt_20ms    <= 0;
      end else begin
        cnt_20ms <= cnt_20ms + 1;
      end

      if (cnt_1s == (period_1s >> 1) - 1) begin
        clk_out_1s <= ~clk_out_1s;
        cnt_1s     <= 0;
      end else begin
        cnt_1s <= cnt_1s + 1;
      end

      if (cnt_500us == (period_500us >> 1) - 1) begin
        clk_out_500us <= ~clk_out_500us;
        cnt_500us     <= 0;
      end else begin
        cnt_500us <= cnt_500us + 1;
      end
    end
  end

endmodule
```

##### c.uart

*(在bonus部分uart模块详细说明，此处不赘述)*

##### d.programrom

*(在bonus部分uart模块详细说明，此处不赘述)*

##### e.ifetch模块

用于从指令存储器中读取指令，并为CPU的指令执行提供必要的支持。

在 `Ifetc32` 模块中，通过组合逻辑和时序逻辑实现指令的处理和 PC 的更新。

`always @(*)` 块中的逻辑根据当前指令类型和条件，更新下一条指令的地址 `Next_PC`。当指令是 jr 类型时，`Next_PC` 被设置为 `Read_data_1`；当指令是 beq 或 bne 类型且 Zero 为真时，`Next_PC` 被设置为 `Addr_result`；其他情况下，`Next_PC` 被设置为 `PC + 4`，即当前指令的下一条指令。

`always @(negedge clock or posedge reset)` 块中的逻辑根据时钟和复位信号更新 PC 寄存器。当复位信号为高电平时，PC 被重置为初始值；当指令是 j 或 jal 类型时，PC 被更新为拼接后的值，同时 `link_addr_reg` 被设置为 `PC + 4`；其他情况下，PC 被更新为 `Next_PC`。

最后，通过 `assign` 语句，将一些中间结果输出，包括 `branch_base_addr` 和 `link_addr`。

```verilog
  output [31:0] Instruction;  // The instructions obtained from this module are output to other modules
  output [31:0] branch_base_addr;  // sed for beq, bne instructions, (pc+4) output to ALU
  output [31:0] link_addr;  // For JAL instructions, (PC+4) output to the decoder
  output [13:0] addr_o;

  input [31:0] Addr_result;  // The address calculated in the ALU
  input [31:0] Read_data_1;  // jr command to update the address used to update the PC
  input Branch;  // When Branch is 1, it means that the current instruction is beq
  input nBranch;  // When nBranch is 1, it means that the current instruction is bnq
  input Jmp;  // When the JMP is 1, it means that the current instruction is jump
  input Jal;  // When JAL is 1, it means that the current instruction is JAL
  input Jr;  // When Jr is 1, it means that the current instruction is jr
  input Zero;  // When Zero is 1, it means that the ALU result result is 0
  input        clock,reset;           // Clock and reset (synchronous reset signal, active high, reset when reset=1.)
  input [31:0]       Instruction_i;

 assign Instruction = Instruction_i;


   reg [31:0] PC, Next_PC;  // Current Instruction: PC Next Instruction: Next_PC
  reg [31:0] link_addr_reg;  // For JAL instructions, (PC+4) output to the decoder

  assign addr_o = PC[15:2];
    
  always @(*) begin
    // jr
    if (Jr == 1'b1) begin
      Next_PC = Read_data_1;
    end  // beq, bne
    else if (((Branch == 1'b1) && (Zero == 1'b1)) || ((nBranch == 1'b1) && (Zero == 1'b0))) begin
      Next_PC = Addr_result;
    end  // PC + 4
    else begin
      Next_PC = PC + 4;
    end
  end

  always @(negedge clock or posedge reset) begin
    if (reset == 1'b1) begin
      PC <= 32'h0000_0000;
    end else begin
      // j or jal
      if ((Jmp == 1'b1) || (Jal == 1'b1)) begin
        PC <= {PC[31:28], Instruction[25:0], 2'b00};  // The 26-bit instruction shifts two digits to the left and then increments 0
        link_addr_reg <= PC + 4;  // jal instruction, (PC+4) output to the decoder
      end  // Other normal update PC
      else begin
        PC <= Next_PC;
      end
    end
  end

  assign branch_base_addr = PC + 4;  // Branch from PC + 4
  assign link_addr = link_addr_reg;  // jal instruction, (PC+4) output to the decoder
```

```verilog
Ifetc32 ifetch (
        .clock(clock),
        .reset(rst),
        .Addr_result(addr_result),
        .Zero(Zero),
        .Read_data_1(read_dat_1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Instruction(instruction),
        .branch_base_addr(branch_base_addr),
        .link_addr(link_addr),
        .Instruction_i(instruction_o),
        .addr_o(addr_o)
    );
```

- `Addr_result`：ALU 计算得到的地址。
- `Read_data_1`：来自decoder， 给到ALU，用于更新 PC 的地址（在 jr 指令中使用）。
- `Branch`、`nBranch`、`Jmp`、`Jal`、`Jr`、`Zero`：来自controller, 用于指示当前指令类型的信号。
- `clock`、`reset`：非uart模块的15MHz时钟和经过处理后的` assign rst = fpga_rst | !upg_rst;`复位信号。
- `Instruction_i`：来自programrom, 输入的指令。
- `Instruction`：从该模块获取的指令输出到其他模块。
- `branch_base_addr`：用于 beq 和 bne 指令的分支基地址，输出到 ALU。
- `link_addr`：用于 JAL 指令的链接地址，输出到decoder。
- `addr_o`：地址输出。

##### f.dememory模块

实现了一个模块 `dmemory32`，用于在CPU中读写数据存储器，为CPU指令执行提供必要的数据支持。

```verilog
input clock;  //Clock signal
  input memWrite;  //From the controller, 1'b1 indicates that you want to write to data-memory
  input [31:0] address;  //The memory address, in bytes, to read or write
  input [31:0] writeData;  //Data written to data-memory
  output [31:0] readData;  //Data read from data-memory

   // Produces a clock signal, which is the reverse clock of the clock symbol
  wire clk;
  assign clk = !clock;

  input upg_rst_i; // UPG reset (Active High)
  input upg_clk_i; // UPG ram_clk_i (10MHz)
  input upg_wen_i; // UPG write enable
  input [13:0] upg_adr_i; // UPG write address
  input [31:0] upg_dat_i; // UPG write data
  input upg_done_i; // 1 if programming is finished

  wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);

  RAM ram (
    .clka (kickOff ? clk : upg_clk_i),
    .wea (kickOff ? memWrite : upg_wen_i),
    .addra (kickOff ? address[15:2] : upg_adr_i),
    .dina (kickOff ? writeData : upg_dat_i),
    .douta (readData)
  );
```

```verilog
 dmemory32 dmemory32 (
        .clock(clock),
        .memWrite(MemWrite),
        .address(addr_out),
        .writeData(m_wdata),
        .readData(ram_dat_o),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o)
    );
```

模块的输入包括：

- `clock`：非uart模块的15MHz时钟。
- `memWrite`：来自controller的信号，当为 1 时表示要向数据存储器写入数据。
- `address`：要读取或写入的内存地址，以字节为单位。
- `writeData`：来自memorio, 要写入数据存储器的数据。
- `upg_rst_i`：来自uart, UPG 复位信号（高电平有效）。
- `upg_clk_i`：来自uart, UPG 内存时钟信号（10MHz）。
- `upg_wen_i`：来自uart, UPG 写使能信号。
- `upg_adr_i`：来自uart, UPG 写地址。
- `upg_dat_i`：来自uart, UPG 写数据。
- `upg_done_i`：来自uart, 如果串口通信完成，则为 1。

模块的输出包括：

- `readData`：从数据存储器读取的数据。

在 `dmemory32` 模块中，使用一个 RAM ip核（`RAM ram`）来实现数据存储器的功能。

根据输入的控制信号 `upg_rst_i` 和 `upg_done_i`，以及时钟信号 `clock`，通过一个辅助信号 `kickOff`，生成一个时钟信号 `clk`。当 `upg_rst_i` 为高电平或 `upg_done_i` 为真时，使用 `clk` 信号作为时钟信号；否则，使用 `upg_clk_i` 作为时钟信号。

RAM 组件的输入和输出通过连接到 `dmemory32` 模块的输入和输出信号。具体地：

- `clka` 输入连接到生成的时钟信号 `clk` 或 `upg_clk_i`。
- `wea` 输入连接到 `memWrite` 信号或 `upg_wen_i`。
- `addra` 输入连接到 `address` 的低 14 位或 `upg_adr_i`。
- `dina` 输入连接到 `writeData` 或 `upg_dat_i`。
- `douta` 输出连接到 `readData`, 从RAM里读取数据

##### g.controller模块

实现了controller 的模块，用于根据指令的操作码和功能码生成控制信号，用于控制CPU中的其他模块。

```verilog
	input[23:0]  Alu_resultHigh;
    input[5:0]   Opcode;            // instruction[31..26] - the high 6 bits of the instruction from the IFetch module
    input[5:0]   Function_opcode;  	// instructions[5..0] - the low 6 bits of the instruction from the IFetch module, used to distinguish instructions in r-type
    output       Jr;         	 // 1 if the current instruction is jr, 0 otherwise
    output       RegDST;          // 1 if the destination register is rd, 0 if the destination register is rt
    output       ALUSrc;          // 1 if the second operand (Binput in ALU) is an immediate value (except for beq, bne), otherwise the second operand comes from the register
     // 1 if data written to register is read from memory or I/O, 0 if data written to register is the output of ALU module
    output       RegWrite;   	  // 1 if the instruction needs to write to register, 0 otherwise
    //output       Memwrite;       //  1 if the instruction needs to write to memory, 0 otherwise
    output       Branch;        //  1 if the current instruction is beq, 0 otherwise
    output       nBranch;       //  1 if the current instruction is bne, 0 otherwise
    output       Jmp;            //  1 if the current instruction is j, 0 otherwise
    output       Jal;            //  1 if the current instruction is jal, 0 otherwise
    output       I_format;      //  1 if the instruction is I-type except for beq, bne, lw and sw; 0 otherwise
    output       Sftmd;         //  1 if the instruction is a shift instruction, 0 otherwise
    output[1:0]  ALUOp;        // if the instruction is R-type or I_format, ALUOp's higher bit is 1, 0 otherwise; if the instruction is “beq? or “bne?, ALUOp's lower bit is 1, 0 otherwise

    output MemWrite;
    output MemRead;
    output IOWrite;
    output IORead;
    output MemIOtoReg; 
    
    // Indicates whether the instruction is R-type?
    wire R_format; 
    assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;

    // Indicates whether the instruction is an lw directive
    wire Lw; 
    assign Lw = (Opcode==6'b100011)? 1'b1:1'b0;
    wire Sw;
    assign Sw = (Opcode==6'b101011) ? 1'b1:1'b0;

    // Indicates whether the instruction is of type I-(except for beq, bne, lw, sw  immediate number instructions
    assign I_format = (Opcode[5:3]==3'b001)? 1'b1:1'b0;

    // Decide to jump the command
    assign Jr       = ((Function_opcode==6'b001000) && (Opcode==6'b000000)) ? 1'b1:1'b0;
    assign Jmp      = (Opcode==6'b000010) ? 1'b1:1'b0;
    assign Jal      = (Opcode==6'b000011) ? 1'b1:1'b0;
    assign Branch   = (Opcode==6'b000100) ? 1'b1:1'b0;
    assign nBranch  = (Opcode==6'b000101) ? 1'b1:1'b0;

    // decision control signal
    assign RegDST = R_format;
    assign MemtoReg = Lw; // lw
    assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);
    
    
    assign ALUSrc = I_format || Lw || Sw;
    assign Sftmd = (((Function_opcode==6'b000000)||(Function_opcode==6'b000010)||(Function_opcode==6'b000011)||(Function_opcode==6'b000100)||(Function_opcode==6'b000110)||(Function_opcode==6'b000111))&& R_format)? 1'b1:1'b0;

    assign ALUOp = {(R_format || I_format),(Branch || nBranch)};
    
    assign MemWrite = ((Sw==1'b1) && (Alu_resultHigh != 24'hFFFFFF)) ? 1'b1 : 1'b0; 
    assign MemRead = ((Lw==1'b1) && (Alu_resultHigh != 24'hFFFFFF)) ? 1'b1 : 1'b0;
    
    assign IOWrite = ((Sw==1'b1)&&(Alu_resultHigh == 24'hFFFFFF)) ?1'b1 : 1'b0;
    assign IORead = ((Lw==1'b1) && (Alu_resultHigh == 24'hFFFFFF)) ? 1'b1 : 1'b0;

    assign MemIOtoReg = IORead || MemRead; 
```

```verilog
control32 controller (
        .Alu_resultHigh(ALU_result[31:8]),
        .Opcode(instruction[31:26]),
        .Function_opcode(instruction[5:0]),
        .Jr(Jr),
        .Jmp(Jmp),
        .Jal(Jal),
        .Branch(Branch),
        .nBranch(nBranch),
        .RegDST(RegDst),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .I_format(I_format),
        .Sftmd(sftmd),
        .ALUOp(ALU_Op),
        .MemRead(MemRead),
        .IOWrite(IOWrite),
        .IORead(IORead),
        .MemIOtoReg(MemIOtoReg)
    );
```

输入：

- `Alu_resultHigh`：来自ALU模块的高位结果，用于确定存储器写入操作的条件。
- `Opcode`：指令的操作码（高6位），来自IFetch模块。
- `Function_opcode`：指令的功能码（低6位），用于区分R型指令, 来自IFetch模块。

输出：

- `Jr`：如果当前指令是`jr`指令，则为1；否则为0。
- `RegDST`：如果目标寄存器是`rd`，则为1；如果目标寄存器是`rt`，则为0。
- `ALUSrc`：如果第二个操作数（ALU的Binput）是立即数（除了`beq`和`bne`），则为1；否则，第二个操作数来自寄存器。
- `RegWrite`：如果指令需要写入寄存器，则为1；否则为0。
- `MemWrite`：如果指令需要写入内存，则为1；否则为0。
- `Branch`：如果当前指令是`beq`指令，则为1；否则为0。
- `nBranch`：如果当前指令是`bne`指令，则为1；否则为0。
- `Jmp`：如果当前指令是`j`指令，则为1；否则为0。
- `Jal`：如果当前指令是`jal`指令，则为1；否则为0。
- `I_format`：如果指令是I型指令（除了`beq`、`bne`、`lw`和`sw`），则为1；否则为0。
- `Sftmd`：如果指令是移位指令，则为1；否则为0。
- `ALUOp`：如果指令是R型或I型指令，`ALUOp`的高位为1，否则为0；如果指令是`beq`或`bne`，`ALUOp`的低位为1，否则为0。
- `MemRead`：如果指令需要从内存中读取数据，则为1；否则为0。
- `IOWrite`：如果指令需要向I/O设备写入数据，则为1；否则为0。
- `IORead`：如果指令需要从I/O设备读取数据，则为1；否则为0。
- `MemIOtoReg`：如果数据写入寄存器来自内存或I/O，则为1；否则为0。

##### h.decoder模块

实现 `decode32` 的模块，用于对指令进行解码并执行相应的操作。

模块内部包括：

- 定义了一个32位的寄存器文件 `Registers`，用于存储和读取寄存器数据。
- 使用连续赋值语句，根据指令的位域提取操作码、立即数、源寄存器和目标寄存器等信息。
- 根据指令类型和控制信号，对寄存器进行读取和写入操作。
- 使用时钟信号和复位信号来控制寄存器的重置和写入操作。

在时钟上升沿或复位信号为低电平时，根据不同的情况对寄存器进行操作：

- 在复位状态下，将所有寄存器重置为零。
- 当 `Jal` 信号为高电平时，将PC+4的值写入寄存器31。
- 当 `RegWrite` 信号为高电平时，根据指令类型和控制信号进行寄存器写入操作，包括lw指令和R型指令和I型指令。

```verilog
	output[31:0] read_data_1;               
    output[31:0] read_data_2;               
    input[31:0]  Instruction;               
    input[31:0]  mem_data;   				
    input[31:0]  ALU_result;   				
    input        Jal;                       
    input        RegWrite;                 
    input        MemtoReg;              
    input        RegDst;               
    output[31:0] Sign_extend;               
    input		 clock,reset;             
    input[31:0]  opcplus4;               

    
    // 32-bit register file
    reg[31:0] Registers[0:31];

    
    // R-type : rd = rs + rt
    // I-type : rt = rs + (sign-extended) immediate
    // J-type : jal: reg[31] = opcplus4 
    wire [15:0]immediate;
    wire [4:0] rs, rt, rd;
    wire [5:0] opcode;
    
    assign opcode = Instruction[31:26];
    assign immediate = Instruction[15:0];
    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];
    
    // sign extend  --> zero_extended     other instructions: sign_extended
//    assign Sign_extend = (opcode == 6'b001111) ? {immediate,{16{1'b0}}} : 
//                         ((opcode == 6'b001001 || opcode == 6'b001100 || opcode == 6'b001101 || opcode == 6'b001110 || opcode == 6'b001011) ? 
//                         {{16{1'b0}}, immediate} : {{16{immediate[15]}}, immediate});
    assign Sign_extend = (6'b001100 == opcode || 6'b001101 == opcode)?{{16{1'b0}},immediate}:{{16{Instruction[15]}},immediate};
    // read register
    assign read_data_1 = Registers[rs];
    assign read_data_2 = Registers[rt];
    
    // reset 
    wire rst;
    assign rst = ~reset;
     
    // write register
    always @ (posedge clock or negedge rst) begin
        if (~rst) begin
            Registers[0] <= 32'b0;
            ...//初始化寄存器          
        end
        else begin
            if (Jal) begin
                Registers[31] <= opcplus4;
            end
            else if (RegWrite) begin
                // lw
                if (MemtoReg && rt != 0)  begin
                    Registers[rt] <= mem_data;
                end
                else begin
                    // R-format 
                    if (RegDst && rd != 0) begin
                        Registers[rd] <= ALU_result;
                    end
                    // I-format
                    else if (~RegDst && rt != 0) begin
                        Registers[rt] <= ALU_result;
                    end
                end
            end
        end
    end
```

```verilog
decode32 decoder (
        .Instruction(instruction),
        .mem_data(r_wdata),
        .ALU_result(ALU_result),
        .Jal(Jal),
        .RegWrite(RegWrite),
        .MemtoReg(MemIOtoReg),
        .RegDst(RegDst),
        .clock(clock),
        .reset(rst),
        .opcplus4(link_addr),
        .read_data_1(read_dat_1),
        .read_data_2(read_dat_2),
        .Sign_extend(imme_extend)
    );
```

输入：

- `read_data_1`：读取的寄存器数据1
- `read_data_2`：读取的寄存器数据2
- `Instruction`：32位指令,来自ifetch
- `mem_data`：从内存读取的数据， 来自dmemory
- `ALU_result`：ALU计算的结果, 来自ALU
- `Jal`：JAL信号，表示是否执行跳转并将PC+4写入寄存器。
- `RegWrite`：寄存器写入使能信号。
- `MemtoReg`：指示是否将内存数据写入寄存器。
- `RegDst`：目标寄存器选择信号。
- `Sign_extend`：符号扩展的立即数。
- `clock`：非uart模块的15MHz时钟。
- `reset`：经过处理后的` assign rst = fpga_rst | !upg_rst;`复位信号
- `opcplus4`：PC+4的值。

输出：

- `read_data_1`：读取的寄存器数据1。
- `read_data_2`：读取的寄存器数据2。
- `Sign_extend`：符号扩展的立即数。

##### i.ALU模块

实现了ALU模块，用于执行算术逻辑单元（ALU）的计算和操作

根据输入的指令类型和控制信号，执行ALU的算术逻辑计算、位移操作等，并生成相应的输出信号。这些操作用于执行指令的执行阶段，并更新ALU的计算结果和相关的控制信号。

```verilog
input[31:0]  Read_data_1;	     
    input[31:0]  Read_data_2;          
    input[31:0]  Sign_extend;            
    
    //from IFetch
    input[5:0]   Function_opcode;  //r-form instructions[5:0]
    input[5:0]   opcode;          
    input[4:0]   Shamt;            // instruction[10:6] for shift instructions   
    input[31:0]  PC_plus_4;        // the address of the next instruction
    
    //from Controller
    input[1:0]   ALUOp;              
    input        ALUSrc;          
    input        I_format;         
    input        Sftmd;           
    input        Jr;               
    
    //outputs
    output       Zero;             
    output reg [31:0] ALU_Result;  
    output[31:0] Addr_Result;            
    
    //wires
    wire[31:0] Ainput,Binput;     // the ALU calculation result
    
    wire[5:0]  Exe_code;          // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : {3'b000, Opcode[2:0]}
    wire[2:0]  ALU_ctl;           // the ontrol signals which affact operation in ALU directly
    
    wire[2:0]  Sftm;              // identify the types of shift instruction, equals to Function_opcode[2:0]
    reg[31:0]  Shift_Result;      // the result of shift operation
    
    reg[31:0]  ALU_output_mux;    // the result of arithmetic or logic calculation
    
    wire[32:0] Branch_Addr;       // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]
    
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];
    
    assign Exe_code = (I_format==0) ? Function_opcode : {3'b000, opcode[2:0]};
    
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ((!Exe_code[2] | (!ALUOp[1])));
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
    
    //arithmatic and logic calculation
    always@(ALU_ctl or Ainput or Binput)
    begin
    case(ALU_ctl)
        3'b000: ALU_output_mux = Ainput & Binput;                             //and,andi
        3'b001: ALU_output_mux = Ainput | Binput;                             //or,ori
        3'b010: ALU_output_mux = $signed(Ainput) + $signed(Binput);           //add,addi
        3'b011: ALU_output_mux = Ainput + Binput;                             //addu,addiu
        3'b100: ALU_output_mux = Ainput ^ Binput;                             //xor,xori
        3'b101: ALU_output_mux = ~(Ainput | Binput);                      
        3'b110: ALU_output_mux = $signed(Ainput) - $signed(Binput);           //sub,slti,beq,bne
        3'b111: ALU_output_mux = Ainput - Binput;                             //subu,sltiu,slt,sltu
        default: ALU_output_mux = 32'h0000_0000;
    endcase
    end
    
    //shift operation
    assign Sftm = Function_opcode[2:0];
    always@(*) begin
    if(Sftmd)
        case(Sftm[2:0])
            3'b000: Shift_Result = Binput << Shamt;             //Sll rd,rt,shamt 00000
            3'b010: Shift_Result = Binput >> Shamt;             //Srl rd,rt,shamt 00010
            3'b100: Shift_Result = Binput << Ainput;            //Sllv rd,rt,rs   00100
            3'b110: Shift_Result = Binput >> Ainput;            //Srlv rd,rt,rs   00110
            3'b011: Shift_Result = $signed(Binput) >>> Shamt;   //Sra rd,rt,shamt 00011
            3'b111: Shift_Result = $signed(Binput) >>> Ainput;  //Srav rd,rt,rs   00111
            default: Shift_Result = Binput;
        endcase
    else
        Shift_Result = Binput;
    end
    
    //Determine output "ALU_Result"
    always @(*) begin
    //set type operation(slt,slti,sltu,sltiu)
    if( ((ALU_ctl==3'b111) && (Exe_code[3]==1)) || ((ALU_ctl[2:1]==2'b11) && (I_format==1'b1)))
//        ALU_Result = (Ainput-Binput<0)?1:0;
        ALU_Result = ALU_output_mux[31]==1? 1:0;
    //lui operation
    else if((ALU_ctl==3'b101) && (I_format==1'b1))
        ALU_Result[31:0] = {Binput[15:0], {16{1'b0}}}; //{16{1'b0}}??
    //shift operation
    else if(Sftmd==1)
        ALU_Result = Shift_Result;
    //other types of operation in ALU (arithmatic or logic calculation)
    else
        ALU_Result = ALU_output_mux[31:0];
    end
    
    //determine the output "Addr_result" and "Zero"
    assign Zero = (ALU_output_mux == 32'h0000_0000) ? 1'b1 : 1'b0;
    assign Addr_Result = PC_plus_4 + (Sign_extend << 2);
```

```verilog
ALU alu (
        .Read_data_1(read_dat_1),
        .Read_data_2(read_dat_2),
        .Sign_extend(imme_extend),
        .Function_opcode(instruction[5:0]),
        .opcode(instruction[31:26]),
        .Shamt(instruction[10:6]),
        .PC_plus_4(branch_base_addr),
        .ALUOp(ALU_Op),
        .ALUSrc(ALUSrc),
        .I_format(I_format),
        .Sftmd(sftmd),
        .Jr(Jr),
        .Zero(Zero),
        .ALU_Result(ALU_result),
        .Addr_Result(addr_result)
    );
```

输入：

- `Read_data_1`：读取的数据1。
- `Read_data_2`：读取的数据2。
- `Sign_extend`：符号扩展的立即数。
- `Function_opcode`：函数操作码，用于R型指令。
- `opcode`：操作码。
- `Shamt`：位移操作的位移值。
- `PC_plus_4`：下一条指令的地址。
- `ALUOp`：ALU操作控制信号。
- `ALUSrc`：ALU操作的源选择信号。
- `I_format`：指示是否为I型指令的信号。
- `Sftmd`：位移操作类型。
- `Jr`：指示是否为JR指令的信号。

输出：

- `Zero`：零信号。
- `ALU_Result`：ALU计算的数值结果。
- `Addr_Result`：计算出的地址结果。

##### j.Memorio模块

<img src="image-20230601212940961.png" alt="image-20230601212940961" style="zoom: 50%;" />

这个模块主要功能是处理输入输出，顾名思义，memorio进行了一个判断，判断了从decoder返回的值应该直接通过io设备输出还是写会到内存里，同时也判断了decoder的数据来源是dmemory还是外设io的输入设备

```verilog
input mRead; // The controller issues a read memory instruction
input mWrite; // The controller issues write memory instructions
input ioRead; // Whether to perform IO reads
input ioWrite; // Whether to perform IO writes
//address
input[31:0] addr_in; // The memory position calculated by the ALU
output[31:0] addr_out; // Transfer to the address in Memory
//data
input[31:0] m_rdata; // Data read from memory
input[15:0] io_rdata; // Data read in from the DIP switch
input[31:0] r_rdata; // Data read from decode
output reg[31:0] m_wdata; // Data sent to IO or mem
output reg [31:0] r_wdata; // Data entered into decode
//control
output LEDCtrl; // LED control
output SwitchCtrl; // switch control

assign addr_out = addr_in;
assign LEDCtrl = ioWrite;
assign SwitchCtrl = ioRead;

always @(*) begin
    if((mWrite==1'b1)||(ioWrite==1'b1))
        if (ioWrite) begin
            m_wdata = {16'h0000, r_rdata[15:0]};
        end
        else begin
            m_wdata = r_rdata;
        end
    else
        m_wdata = 32'hZZZZZZZZ;
end

always @(*) begin
    if ((mRead == 1'b1) || (ioRead == 1'b1)) begin
        if (ioRead == 1'b1) begin
            r_wdata = {16'h0000, io_rdata};
        end
        else begin
            r_wdata = m_rdata;
        end
    end
    else
        r_wdata = 32'hZZZZZZZZ;
end
```

```
MemOrIO MemOrIO (
        .mRead(MemRead),
        .mWrite(MemWrite),
        .ioRead(IORead),
        .ioWrite(IOWrite),
        .addr_in(ALU_result),
        .addr_out(addr_out),

        .m_rdata (ram_dat_o),
        .m_wdata (m_wdata),
        .io_rdata(SwitchData),
        .r_wdata (r_wdata),
        .r_rdata (ram_dat_i),

        .LEDCtrl(LEDCtrl),
        .SwitchCtrl(SwitchCtrl)
    );
```

输入：

- `MemRead`：代表指令要进行内存的读取
- `MemWrite`：代表指令要进行内存的写操作
- `ioRead`：代表指令要进行外部的输入
- `IOWrite`：代表指令要进行外部输出
- `ALU_result`：ALU计算得到的地址
- `ram_dat_o`：从内存中读取到的数据
- `SwitchData`：根据地址选择的部分外部开关的输入
- `ram_dat_i`：从寄存器读取的数据
- `address_in`：即从ALU中得到的地址

输出：

- `r_wdata`：向寄存器写入的数据
- `m_wdata`：向内存中写入的数据
- `addr_out`：等同于address_in，即从ALU中得到的地址
- `LEDCtrl`：代表要进行外部的输出
- `SwitchCtrl`：代表要进行外部的输入

##### k.In模块

这个模块主要用来处理24个开关输入，如果当前asm操作的lw指令存在特殊地址（高比特全1，最低八比特分别为0x70,0x78,0x74,0x7C），使得controller控制的SwitchCtrl变为1，这代表输入应该来自与开关，将开关对应的输入放入寄存器

```verilog
input clk;
input rst;
input SwitchCtrl; 
input [23:0] SwitchInput; 
input[7:0] ALU_addr; 
output[15:0] SwitchData; 


reg [15:0] SwitchData_reg;
assign SwitchData = SwitchData_reg;

always @(negedge clk or posedge rst) begin
    if (rst) begin
        SwitchData_reg <= 16'h0000;
    end
    else begin
        if (SwitchCtrl) begin
            if (ALU_addr == 8'h70) begin
                SwitchData_reg <= {12'h000 ,SwitchInput[3:0]};
            end
            else if(ALU_addr == 8'h78) begin
                SwitchData_reg <= {8'h00 ,SwitchInput[11:4]};
            end
            else if (ALU_addr == 8'h74) begin
                SwitchData_reg <= {8'h00, SwitchInput[19:12]};
            end
            else if (ALU_addr == 8'h7C) begin
                SwitchData_reg <= {15'b0000_0000_0000_000, SwitchInput[20:20]};
            end
            else 
                SwitchData_reg <= SwitchData_reg;
    end    
    end

end
```

```verilog
 In In (
        .clk(clock),
        .rst(rst),
        .SwitchCtrl(SwitchCtrl),
        .SwitchInput(switch2N4),
        .ALU_addr(ALU_result[7:0]),
        .SwitchData(SwitchData)
    );
```

输入：

- `clock`：时钟信号
- `rst`：reset信号
- `SwitchCtrl`：代表指令要进行外部的输入
- `switch2N4`：24bit的开关输入
- `ALU_result[7:0]`：ALU计算得到的地址的最低8bit
- `ram_dat_o`：从内存中读取到的数据

输出：

- `SwitchData`：具体要存入寄存器的数据

##### l.Out模块

这个模块主要用来处理寄存器输出，如果当前asm操作的sw指令存在特殊地址（高比特全1，最低八比特分别为0x60,0x64,0x68），使得controller控制的LEDCtrl变为1，这代表我们不应当将输出放入寄存器，而是应该放入我们提前准备好代表选择信号，以及两个结果的output中，这三个output将被接给LED或者VGA模块进行进一步的判断输出

```verilog
input clk;
input rst;
input LEDCtrl;
input [7:0]ALU_addr;
input [31:0] OutData;

output [3:0] modeSelect;
output [31:0] AluResult0;
output [31:0] AluResult1;


reg [3:0] modeSelect_reg;
reg [31:0] AluResult0_reg;
reg [31:0] AluResult1_reg;

assign modeSelect = modeSelect_reg;
assign AluResult0 = AluResult0_reg;
assign AluResult1 = AluResult1_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        modeSelect_reg <= 0;
        AluResult0_reg <= 0;
        AluResult1_reg <= 0;
    end
    else begin
        if (LEDCtrl) begin 
            if (ALU_addr == 8'h60) begin
                modeSelect_reg <= OutData[3:0];
            end
            else if(ALU_addr == 8'h64) begin
                AluResult0_reg <= OutData[31:0];
            end
            else if(ALU_addr == 8'h68) begin
                AluResult1_reg <= OutData[31:0];
            end
            else begin
                modeSelect_reg <= modeSelect_reg;
                AluResult0_reg <= AluResult0_reg;
                AluResult1_reg <= AluResult1_reg;
            end    
        end
    end
end
```

```verilog
Out Out (
        .clk(clock),
        .rst(rst),
        .LEDCtrl(LEDCtrl),
        .ALU_addr(ALU_result[7:0]),
        .OutData(m_wdata[15:0]),
        .modeSelect(select),
        .AluResult0(AluResult0),
        .AluResult1(AluResult1)
    );
```

输入：

- `clock`：时钟信号
- `rst`：reset信号
- `LEDCtrl`：代表指令要进行外部的输出
- `m_wdata[15:0]`：寄存器中储存的16bit数
- `ALU_result[7:0]`：ALU计算得到的地址的最低8bit

输出：

- `select`：模式选择信号
- `AluResult0`：第一个io结果
- `AluResult1：第二个io结果

##### m.LED模块

*（在bonus里更好的用户体验详细说明，此处不赘述）*

##### n.VGA模块

*(在bonus里VGA详细说明，此处不赘述)*

## （四）测试说明

用户输入在拨码开关处实现。

最右四比特： 表示输入模式，例如0000,表示场景一，样例0， 1000表示场景二， 样例0

从右至左 5-12 比特， 表示输入数字二， 当需要输入两个数字时， 便将第二个参数在此输入。

从右至左 13-20 比特， 表示输入数字一， 当需要输入两个数字时， 便将第一个参数在此输入。
																				当只需要输入一个数字时，在此输入参数。

从右至左 21 比特， 表示CPU是否开始进行有效运算，当输入1，CPU开始运算， 当输入0， CPU停止运算，此时所										  有得运算不经过处理，相关显示也不会变， 因此需要计算时，记得打开运算拨码。



```verilog
******************************场景一****************************************
case000:
    左灯显示左侧拨码输入数字的值
    右侧不显示
    左侧显示数值为2的幂时,led为右侧绿灯全亮,否则左侧红灯全亮(默认情况左灯全零,右灯全熄灭,led不显示)


case001:
    左灯显示左侧拨码输入数字的值
    右侧不显示
    左侧显示数值为奇数时,led为右侧绿灯全亮,否则左侧红灯全亮(默认情况:左灯全显示0,右灯全熄灭,led为右侧绿灯全亮)     

case010:
    左灯显示按位或运算结果,右灯不显示,led不显示(默认情况:左灯全显示0,右灯全熄灭,led全熄灭)

case011:
    左灯显示按位或非运算结果,右灯不显示,led不显示(默认情况:左灯全显示0,右灯全熄灭,led全熄灭)

case100:
    左灯显示按位异或运算结果,右灯不显示,led不显示(默认情况:左灯全显示0,右灯全熄灭,led全熄灭)


case101:
    左右灯全部熄灭
    执行有符比较运算,若a(左侧拨码数)<b(右侧拨码数),则led灯全亮，否则不亮(默认情况)


case110:
    左右灯全部熄灭
    执行无符比较运算,若a(左侧拨码数)<b(右侧拨码数),则led灯全亮，否则不亮(默认情况)

case111:
    左右等分别显示左右拨码数，led灯不亮(默认情况:左右灯全为0,led全熄灭)


******************************场景二****************************************
case000:
    输出结果为左拨码输入数的累加和，左拨码视为有符号数
    根据左侧拨码数值使其左灯亮，右灯熄灭(AluResult0[7:0],确认显示的数值，至于负数闪烁灯通过cpu来计算进行确定)
    若为负数，则左灯量，数值显示0，led闪烁
case001:
    输出结果为左拨码输入数对应的累加和对应的出入栈总数。

case010:
    输出结果为左拨码输入数对应的累加和对应的出入栈参数。
    每隔2~3秒进行刷新，显示最新的入栈参数。

case011:
    输出结果为左拨码输入数对应的累加和对应的出出栈参数。
    每隔2~3秒进行刷新，显示最新的出栈参数。  

case100:
    当输出结果为正数,则左拨码亮起,右拨码恒不亮
    当输出结果为负数,则左拨码亮起,右拨码恒不亮
    当输出结果发生溢出,则红灯全部亮起,否则不亮


case101:
    当输出结果为正数,则左拨码亮起,右拨码恒不亮
    当输出结果为负数,则左拨码熄灭,右拨码恒不亮,led的最右八位亮起
    当输出结果发生溢出,则红灯全部亮起,否则不亮


case110:
    只有led的最右端16bit亮
    最右的16比特即为运算结果

case111:
    只有led的最右端16bit亮
    最右的16比特即为运算结果

```





## Bonus部分

### [1] uart

#### 实现思路

- 串口通信工作流程图如下：

uart模块是通过串口通信获得数据后通过ip核往指令空间和数据空间里写数据。

- 首先通过**MinisysAv.2.0**汇编asm文件,得到指令相关的coe文件和数据相关的coe文件，通过GenUBit_Minisys3.0获得txt文件，最后通过**UartAssist**发送数据到minisys开发板。

- 具体实现：参考PPT上的代码，添加IP核，进行接线、测试，注意到这时候原来CPU里的ifetch模块里的ROM要放在programrom里，并且改用RAM，这是因为需要通过串口通信往指令空间里写数据。

#### 代码详解

##### uart模块

在这个模块例化uart, 使得可以进行串口通信。端口绑定及说明如下：

```verilog
uart_bmpg_0 uart(
        .upg_clk_i(upg_clk),
        .upg_rst_i(upg_rst),
        .upg_rx_i(rx),
        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen_o),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o),
        .upg_tx_o(tx)
    );
```

- `upg_clk_i`: 10MHz的时钟信号，由ip核得到。
- `upg_rst_i`: 

```verilog
input start_pg;
wire spg_bufg;
    BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter
    reg upg_rst; 
    always @ (posedge fpga_clk) begin
        if (spg_bufg) upg_rst = 0;
        if (fpga_rst) upg_rst = 1;
    end
```

这里进行了一个防抖操作，uart的复位信号从这个防抖的部分接出

- `upg_rx_i`：串口通信发送信号，直接与开发板绑定(rx)

- `upg_clk_o`：由uart得到的时钟信号，给programrom和dmemory模块

- `upg_wen_o`：uart的写使能信号

- `upg_adr_o`， `upg_dat_o`：从uart模块获取的地址信息和数据信息，即往dmemory32和programrom模块对应的地址写相应的数据，这个地方需要注意的是，upg_adr_o是一个15bit位宽的数，其中的14bit即[13:0]是直接给到dememory和programrom的upg_dat_i， 最高位是用来判断往dememory里写还是往programrom里写的。

  在dememory模块中，写使能信号upg_wen_i是由**`upg_wen_o & upg_adr_o[14]`**共同作用的，在programrom中，写使能信号upg_wen_i是由**`upg_wen_o & ！upg_adr_o[14]`**共同作用的。

  也就是说，当upg_adr_o[14]为1且uart的写使能信号upg_wen_o为1时是往dememory里写数据（数据空间），而当当upg_adr_o[14]为0且uart的写使能信号upg_wen_o为1时往programrom里写数据（指令空间）。

- `upg_done_o`：串口通信的结束信号，给dmemory32和programrom模块

- `upg_tx_o`：串口通信接收信号，直接与开发板绑定（tx）

##### programrom模块

在这个模块里有一个RAM ip核，用来存储指令信息，可以通过uart模块对其写入，也可以通过ifetch模块读出指令

```verilog
module programrom(
    // Program ROM Pinouts
    input rom_clk_i, // ROM clock
    input[13:0] rom_adr_i, // From IFetch
    output [31:0] Instruction_o, // To IFetch
    // UART Programmer Pinouts
    input upg_rst_i, // UPG reset (Active High)
    input upg_clk_i, // UPG clock (10MHz)
    input upg_wen_i, // UPG write enable
    input[13:0] upg_adr_i, // UPG write address
    input[31:0] upg_dat_i, // UPG write data
    input upg_done_i // 1 if program finished
    );
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i );
    //if kickOff is 1 means CPU work on normal mode, otherwise CPU work on Uart communication mode
    programRAM IFRAM (
        .clka (kickOff ? rom_clk_i : upg_clk_i),
        .wea (kickOff ? 1'b0 : upg_wen_i ),
        .addra (kickOff ? rom_adr_i : upg_adr_i ),
        .dina (kickOff ? 32'h00000000 : upg_dat_i ),
        .douta (Instruction_o)
    );
endmodule
```

```verilog
programrom program(
        .rom_clk_i(clock),
        .rom_adr_i(addr_o),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen_o & !upg_adr_o[14]),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o),
        .Instruction_o(instruction_o)
    );
```

- `rom_clk_i`: 系统15MHz时钟
- `rom_adr_i`: 从IFetch模块获取需要读取那个地址的数据
- `Instrution_o`: 从指令空间读出的数据
- `upg_rst_i`: uart模块传来的复位信号
- `upg_clk_i`: uart模块传来的时钟信号
- `upg_wen_i`: 串口通信的写使能信号，在b.uart模块已经阐述如何接线
- `upg_adr_i`: uart模块传出的地址，表示在哪个地方写数据
- `upg_dat_i`：从uart模块获取的要写的数据
- `upg_done_i`: 串口通信的结束信号

*`kickOff`是用来判断当前工作模式是CPU正常工作还是串口通信模式*

### [2] VGA

#### 实现思路

**工作原理概述：**

基本概念：

1. 分辨率和刷新率：VGA使用水平像素数和垂直行数来定义显示的分辨率。例如，常见的VGA分辨率是640x480，其中有640个水平像素和480个垂直行。刷新率指每秒刷新屏幕的次数，常见的VGA刷新率为60Hz。
2. 同步信号：VGA使用同步信号来同步显示器和计算机之间的数据传输。同步信号包括水平同步（HSync）和垂直同步（VSync）。水平同步信号表示每一行的开始和结束，垂直同步信号表示每个帧的开始和结束。
3. 像素数据：VGA通过将像素数据发送到显示器来生成图像。每个像素由红、绿和蓝三个颜色通道组成，每个通道通常使用8位表示，因此可以有256种不同的颜色。
4. 时序控制：为了生成正确的VGA信号，需要根据特定的时序参数来控制同步信号和像素数据的生成。时序参数包括水平同步周期、水平后廊、水平活动像素、水平前廊、垂直同步周期、垂直后廊、垂直活动行和垂直前廊等。

简而言之，当行扫描和场扫描进到有效周期时，根据自己的需求向VGA发送RGB信号，实现渲染

#### 代码详解

```verilog
wire[31:0] value;
    assign value = {result_value[15:8], 16'b0, result_value[7:0]};

    parameter 
    H_SYNC    =   10'd96  ,   //行同步时钟周期数           
    H_BACK    =   10'd40  ,   //行时序后沿           
    H_LEFT    =   10'd8   ,   //行时序左边框           
    H_VALID   =   10'd640 ,   //行有效数据           
    H_RIGHT   =   10'd8   ,   //行时序右边框           
    H_FRONT   =   10'd8   ,   //行时序前沿           
    H_TOTAL   =   10'd800 ;   //行扫描周期 
    
    parameter 
    V_SYNC    =   10'd2   ,   //场同步           
    V_BACK    =   10'd25  ,   //场时序后沿     
    V_TOP     =   10'd8   ,   //场时序上边框       
    V_VALID   =   10'd480 ,   //场有效数据
    V_BOTTOM  =   10'd8   ,   //场时序下边框    
    V_FRONT   =   10'd2   ,   //场时序前沿       
    V_TOTAL   =   10'd525 ;   //场扫描周期

    parameter   
    RED     =   12'b1111_0000_0000,   //红色            
    YELLOW  =   12'b1111_1111_0000,   //黄色
    GREEN   =   12'b0000_1111_0000,   //绿色 
    CYAN    =   12'b0000_1111_1111,   //青色 
    BLUE    =   12'b0000_0000_1111,   //蓝色  
    BLACK   =   12'b0000_0000_0000,   //黑色 
    WHITE   =   12'b1111_1111_1111;   //白色 

    reg [9:0] cnt_h;
    reg [9:0] cnt_v;
    reg rgb_valid;

    
    always @(posedge clk or negedge reset) begin
        if(reset)
            cnt_h <= 0;
        else begin
            if(cnt_h == H_TOTAL - 1)
                cnt_h <= 0;
            else
                cnt_h <= cnt_h + 1;
        end
    end

    assign vga_h = cnt_h <= H_SYNC - 1 ? 1 : 0;
    
    always @(posedge clk, negedge reset) begin
        if(reset)
            cnt_v <= 0;
        else begin
            if(cnt_h == H_TOTAL - 1) begin
                if(cnt_v == V_TOTAL)
                    cnt_v <= 0;
                else
                    cnt_v <= cnt_v + 1;
            end
            else
                cnt_v <= cnt_v;
        end
    end
    
    assign vga_v = cnt_v <= V_SYNC - 1 ? 1 : 0;

    always @(posedge clk, negedge reset) begin
    if (reset) begin
        rgb_valid <= 0;
    end 
    else begin
        rgb_valid <= ((cnt_h >= H_SYNC + H_BACK + H_LEFT)
            && (cnt_h < H_SYNC + H_BACK + H_LEFT + H_VALID)
            && (cnt_v >= V_SYNC + V_BACK + V_TOP)                     
            && (cnt_v < V_SYNC + V_BACK + V_TOP + V_VALID))     
            ? 1'b1 : 1'b0;
    end
end
```

首先声明需要准备的参数，通过时钟信号和复位信号对行扫描计数器和场扫描计数器进行操作；当进入场扫描和行扫描有效区域内时，让rgb_valid生效，通过下面的语句渲染图像：

```verilog
if (cnt_v > 267 && cnt_v <= 283) begin
                    if (cnt_h > 152 && cnt_h <= 164) begin
                        if (cnt_h > 152 && cnt_h <= 156) begin
                            vga_rgb <= BLACK;
                        end 
                        else if (cnt_h > 156 && cnt_h <= 160) begin
                            if (!value[31]) begin
                                if ((cnt_v > 267 && cnt_v <= 271) || (cnt_v > 279 && cnt_v <= 283)) begin
                                    vga_rgb <= BLACK;
                                end
                                else begin
                                    vga_rgb <= WHITE;
                                end
                            end
                            else begin
                                vga_rgb <= WHITE;
                            end
                        end 
                        else begin
                            if (!value[31]) begin
                                vga_rgb <= BLACK;
                            end 
                            else begin
                                vga_rgb <= WHITE;
                            end
                        end
                    end 
```

上面是一个简单的例子，是32bit中的1bit的渲染。

首先无论是0还是1，我们设置最左边的竖线是一直存在的，我们让rgb为黑色；当对竖线右边的部分渲染时，通过传入的信号来判断是将0补齐还是保持1不变。

### [3] 更好的用户体验（LED）

#### 实现思路

用户在输入相关参数以及运算模式之后，CPU负责对相关运算的操作，但是由于CPU的运算结果比较抽象，用户很难直观的获得计算结果，因此需要LED模块部分来将运算结果进行转换，根据不同情况，选择不同的方式进行输出。

例如在测试场景Ⅰ的测试用例7，需要将用户的输入数字显示，此时选择将其处理之后，用七段数码管按照十进制数字输出显得就比较友好，因此便选择七段数码管进行结果输出。在测试场景Ⅰ的测试用例1，需要来判断用户输入输入是否为二的幂，此时使用七段数码管来将用户的输入输出，同时使用红绿LED等来显示判断结果便显得比较友好，因此选择七段数码管结合LED灯进行输出。

#### 代码详解

LED灯的实现的整体思路较为简单，更多的实现是在于写代码以及设计相关输出以及整个模块的架构。

```verilog
module LED (
    input reset,
    input clk_2ms,  //时钟信号
    input [3:0] modeSelect,  //输出模式
    input [31:0] AluResult0,  //运算结果0
    input [31:0] AluResult1,  //运算结果1


    output [7:0] led_select,  //选择亮的Led灯，低电平的为亮的灯，表示选择
    output [7:0] signal_display,  //亮灯的内容信号
    output [23:0] led_display    //led灯管内容
);
```

LED模块的输入输出如上， `AluResult0` ` AluResult1`为CPU的运算结果， 在显示方面，整个模块选择使用由分频器获得的2ms的时钟信号。输出信号有三个`led_select`为七段数码管的使能信号, `signal_display`为七段数码管的显示信号,`led_display`为led灯管的显示信号.



```verilog
 //-------参数部分--------------------------------------------------------
  parameter zero = 8'b1100_0000; //使七段数码管显示0，从低比特位到高比特位，从低到高控制A-P引脚
  parameter one  = 8'b1111_1001; //使七段数码管显示1，从低比特位到高比特位，从低到高控制A-P引脚
  parameter two  = 8'b1010_0100; //使七段数码管显示2，从低比特位到高比特位，从低到高控制A-P引脚
  parameter three= 8'b1011_0000; //使七段数码管显示3，从低比特位到高比特位，从低到高控制A-P引脚
  parameter four = 8'b1001_1001; //使七段数码管显示4，从低比特位到高比特位，从低到高控制A-P引脚
  parameter five = 8'b1001_0010; //使七段数码管显示5，从低比特位到高比特位，从低到高控制A-P引脚
  parameter six  = 8'b1000_0010; //使七段数码管显示6，从低比特位到高比特位，从低到高控制A-P引脚
  parameter seven= 8'b1111_1000; //使七段数码管显示7，从低比特位到高比特位，从低到高控制A-P引脚
  parameter eight= 8'b1000_0000; //使七段数码管显示8，从低比特位到高比特位，从低到高控制A-P引脚
  parameter nine = 8'b1001_0000; //使七段数码管显示9，从低比特位到高比特位，从低到高控制A-P引脚
  parameter point= 8'b0111_1111; //使七段数码管显示.，从低比特位到高比特位，从低到高控制A-P引脚
  parameter dim = 8'b1111_1111;  //使七段数码管不显示,从低比特位到高比特位，从低到高控制A-P引脚
  parameter neg = 8'b1111_1101;  //使七段数码管显示-,从低比特位到高比特位，从低到高控制A-P引脚
```

参数部分,因为七段数码管的显示内容并不直观, 而每次的输入也容易使代码出现错误, 因此针对七段数码管, 预先定义了显示参数, 用来控制七段数码管的显示内容, 这样大大降低了出现Bug的概率, 方便了操作.

```verilog
 //--------中间变量-Part1-------------------------------------------------
  reg [7:0] signal_display_tmp;  //左边显示内容
  reg [7:0] led_select_tmp;  //右边选择亮的某一个灯
  reg [23:0] led_display_tmp;  //右边显示内容

  //--------中间变量-Part2-------------------------------------------------
  reg [7:0] led_R_0_Content;
  reg [7:0] led_R_1_Content;
  reg [7:0] led_R_2_Content;
  reg [7:0] led_R_3_Content;
  reg [7:0] led_L_0_Content;
  reg [7:0] led_L_1_Content;
  reg [7:0] led_L_2_Content;
  reg [7:0] led_L_3_Content;

  //--------assign-Part---------------------------------------------------
  assign signal_display = signal_display_tmp;
  assign led_select = led_select_tmp;
  assign led_display = led_display_tmp;

```

由于wire和reg的性质, 为了方便操作, 在模块内部增加了一些reg变量,之后再通过assign操作来将中间变量与输出相连接, 方便了模块内部的有关实现.

```verilog
      4'b1110:
      begin
          led_display_tmp[15:0] = AluResult0[15:0];
          led_display_tmp[23:16] = 8'b0000_0000;
          led_L_0_Content        = dim;
          led_L_1_Content        = dim;
          led_L_2_Content        = dim;
          led_L_3_Content        = dim;
          led_R_0_Content        = dim;
          led_R_1_Content        = dim;
          led_R_2_Content        = dim;
          led_R_3_Content        = dim;
      end      
```

上述代码为测试场景二中测试样例110所对应的LED内部内代码. 当确定模式为上述模块, 便根据该样例预设的输出模式,使得七段数码管全部显示零, 同时使得LED显示CPU所计算出的运算结果 .



```verilog
      4'b0000: begin
        casex (AluResult0[7:0])
          8'b0000_0000: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;    end
          8'b0000_0001: begin led_L_0_Content = one; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;    end
          8'b0000_0010: begin led_L_0_Content = two; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;   end
          8'b0000_0011: begin led_L_0_Content = three; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;   end
          8'b0000_0100: begin led_L_0_Content = four; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0101: begin led_L_0_Content = five; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0110: begin led_L_0_Content = six; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;   end
          8'b0000_0111: begin led_L_0_Content = seven; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;   end
          8'b0000_1000: begin led_L_0_Content = eight; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;   end
          8'b0000_1001: begin led_L_0_Content = nine; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_1010: begin led_L_0_Content = zero; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;   end
         ............................................
         ............................................
         ............................................
         ............................................
         ............................................
         ............................................
         ............................................
          default: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero       ;   end
        endcase
       
        casex (AluResult1[7:0])
          8'b0000_0000: begin
            led_display_tmp = 24'b1111_1111_0000_0000_0000_0000;            
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          8'b0000_0001: begin
            led_display_tmp = 24'b0000_0000_0000_0000_1111_1111;
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          default: begin
            led_display_tmp = 24'b1111_1111_1111_1111_1111_1111;
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
        endcase
      end

```

上述代码为测试场景一中测试样例000所对应的LED内部内代码. 若当确定模式为上述模式, 便根据该样例预设的输出模式, 首先, 根据CPU得运算结果, 将其转化为七段数码管上能够显示得十进制数字来显示, 之后根据六外的运算结果, 将判断结果转化为相应得LED输出,进行显示. 上述操作得关键在于需要根据MIPS代码写好得预设来设计LED模块, 因此该部分需要将MIPS代码实现与LED灯部分结合实现.



## 感悟

- 刘家宝：    

  在本次项目中，我主要负责整个CPU模块以及IO模块，这对我来说是一种很大的挑战，尽管说老师在理论和实验课上已经把模块怎么去写讲的十分细致，具体到某个模块的实现和测试，对我一个人而言还是有很大压力。经过了一周多的测试，oj终于全部通过，但是第一次上板测试的时候，什么都显示不出来，我十分痛苦，好在我向他人寻求了帮助，幸运的是我也得到了很友善的回应，对方告诉我写测试床测试的方法，然后我一点点测试，最终不断的找到bug。在这个过程中，我发现最令我难受的bug是top模块的接线问题，而这恰恰也是我自己思路不清晰导致的，这说明我们在接线之前如果没有十足的把握，需要对于知识进一步的理解，或者跟其他人讨论一下，得到正确的思路再进行写代码，不然还是会制造出很多bug，而且对于写代码的人而言这些bug是很难找到的，也会凭空浪费很多时间。最后，我还是要感谢我的队友在这个过程中给予我的信任，在我情绪波动的时候给予我的支持，以及帮我找出了关键bug的同学，没有他们我不可能完成整个项目的大框架。总而言之，这门课程的项目对我而言收获颇多，我将吸取这次项目的经验，在将来的项目中好好运用。

- 伍福临：

  在本次项目中，我主要负责顶层模块的设计和uart、VGA bonus的实现。总体上说，感觉最大的问题是和队友的沟通没有到位，没有主动和队友保持积极的联系，这导致后面出现bug的时候不是很清楚是哪个地方的问题（是接线有问题还是内部逻辑有问题？）。可能队友看到了你的问题直接修改但没有告诉你(最好是遇到问题都记录下来，好好利用github)，但这个问题却不止出现在一个地方，而你并不知道出了问题，就会觉得自己的模块没有问题。这样人人都觉得自己的模块没有问题，不容易de出bug，需要反复细致的检查。所以应该主动地找队友沟通，队友也有自己忙的事情，如果不主动沟通，他也会忘记告诉你；主动沟通也可以更好地了解项目的进度，什么时候准备bonus，什么时候之前必须完成上板。比如说uart要在测试用例前通过上板。主动沟通也是给队友省事，告知队友你的进度，免得队友还得对你的模块操心。

  另外，写bonus的过程中有些痛苦，因为bonus基本上和队友的代码是分离的，队友没法直接帮助你，同时其他组别的人不是很熟或者没有写这个bonus或者也没有实现,这就需要自己一点点的解决。印象最深刻的是uart有两个信号接到两个不同的模块，他们的表达式几乎一样，但是有一个得取反，而当时忽视了，这就导致一直de不出来，后面一点点的检查了两遍才找到问题所在。VGA部分基本上是上学期数字逻辑的内容，弄清楚原理的话写起来是非常快的；这也告诉我实现一个东西不能为了实现而实现，一定要搞清楚原理，否则再次遇到还是得重新学习。

  最后感谢我的队友，分工上我们比较明确，会存在某些队友干得多某些干的少的问题，但大家都没有怨言；遇到bug的时候，虽然队友不是和自己写的东西相关，但还是积极地给出建议；项目进行过程中，有些队友在某短时间忙，其他事情不多的队友也会上手帮忙；感谢队友的包容和理解。

- 李伟浩

  在本次项目中，我主要负责项目中的LED模块和MIPS代码的实现。在这个过程中，我遇到了很多问题和挑战，但也学到了很多经验和技巧。

  在实现灯光控制逻辑时，我发现自己对硬件描述语言的理解还不够深入，导致代码出现了许多错误。为了解决这些问题，我重新学习硬件描述语言的原理，同时向他人请教，最终在反复试验和修改后顺利完成了任务。同时，我发现对于模块的设计和实现，需要提前对整个模块得实现预先做好充分得构思, 之后在构思完成之后, 检验框架得正确性, 之后再逐步得实现其余部分, 这样能够减少后期得重构得繁琐和引起得BUG。另外，对于模块的测试也非常重要，需要编写充分的测试用例，并对于测试结果进行仔细的分析和比对，才能发现模块中可能存在的问题和bug。

  在实现MIPS代码的过程中，我发现编程的过程中，对于每个指令的含义和作用都需要非常清晰地了解，否则在编写代码的过程中很容易出现问题, 同时一定要注意MIPS与Minisys指令集得差异, 否则后期更改指令集得任务会非常大。在编写汇编代码时，我也发现自己对MIPS指令集的掌握还不够熟练，导致代码中出现了许多错误, 同时汇编得编写对程序整体思路的构思要求较高, 它并没有抽象化的int, double等, 直接对寄存器的操作也要求写代码一定要写充分得注释, 这样才能够保持清晰思路. 另外, MPIS得编程也有许许多多需要注意得点, 例如使用 jal之前一定要注意ra寄存器的保存等,否则程序总会有各种奇怪得bug, 而在长达千行得汇编debug时候, 找错误是十分困难得.另外，对于MIPS代码的调试也非常重要，需要使用调试工具MARS进行分析和定位问题，以便更快地解决问题。

  在整个项目的过程中，我也意识到了沟通的重要性。和队友保持良好的沟通和协作，可以有效地避免出现一些不必要的问题和误解, 因为MIPS代码实现与CPU得实现紧密相关。因此，在项目的过程中，我主动和队友沟通，及时向队友汇报自己的进度和问题，以便更好地协作完成任务。同时，也要及时向队友寻求帮助和建议，以便更快地解决问题。

  最后，我要感谢我的队友，在整个项目的过程中，他们给予了我很大的支持和帮助。在我遇到问题时，他们总是能够及时地给我提供帮助和建议，让我能够更快地解决问题。大家都能够积极地完成自己的部分，并及时地检查和修改代码，最终成功地完成了整个项目。

  总而言之，这次项目对我来说是一次非常有收获和意义的经历，我学到了很多关于计算机系统和硬件设计的知识，相信这些经验和技能在我的未来学习和工作中也会有很大的用处。
