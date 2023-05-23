`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 10:47:27
// Design Name: 
// Module Name: cpu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:helloworld
// 
////////////////////////////////////////////////////////////////////////////////

module cpu_top (
    fpga_rst,       // ??????????
    fpga_clk,       //????
    switch2N4,      //24????????????
    led2N4,         //24???LED?? 
    led_select,     //??????????
    signal_display,  //????
    clock,
    addr_out, //alu?
    m_wdata, //?mem
    r_wdata, //reg?
    SwitchData, //?reg??
    LEDCtrl, 
    SwitchCtrl,
    MemIOtoReg, //controller to dmem
    MemWrite,
    MemRead,
    IOWrite,
    IORead,
    read_dat_1,  //???read_dat_1, from decoder to ALU
    read_dat_2, //reg2
    instruction, //?IF??????????, from IF to decoder
    ALU_result,  //ALU??????????
    addr_result,  //??????
    branch_base_addr,  //from IF to ALU
    link_addr,  //from IF t //IF???? from IF to programrom
    Zero,
    Branch, nBranch, Jmp, Jal, Jr,
    sftmd, //??
    I_format,
    imme_extend,  //????
    ALU_Op,
    ALUSrc,
    RegWrite,  //????????
    RegDst,
    select, //leselect
    AluResult0, //led
    AluResult1,//led
    ram_dat_i,
    ram_dat_o,
    
    
    clk_out_2ms
    // clk_out_1s,
    // clk_out_500us

);
input         fpga_rst;       // ??????????
input         fpga_clk;       //????
input  [23:0] switch2N4; 
output [23:0] led2N4;         //24???LED?? 
output [ 7:0] led_select;     //??????????
output [ 7:0] signal_display;  //????
  //////////////////////////////////////////////////////////////////////////////
output  wire clock;  //??clk
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  // IO ??????????????
output wire [31:0] addr_out;
 output  wire [31:0] m_wdata;
 output wire [31:0] r_wdata;

 output wire [15:0] SwitchData;
 output wire LEDCtrl;
 output wire SwitchCtrl;

  //Controller ???????IO???????
 output wire MemIOtoReg;  //controller to dmem
 output wire MemWrite;
 output wire MemRead;
 output wire IOWrite;
 output wire IORead;


  /////////////////////////////////////////////////////////////////////////////
  // ?CPU????
 output wire [31:0] ram_dat_i;  //????????????32????from decoder to dmem
 output wire [31:0] ram_dat_o;  //???????????????? from dmem to decoder

 output wire [31:0] read_dat_1;  //???read_dat_1, from decoder to ALU
 output wire [31:0] read_dat_2;  //???read_dat_2, from decoder to ALU

assign ram_dat_i = read_dat_2;


output  wire [31:0] instruction;  //?IF??????????, from IF to decoder
 output wire [31:0] ALU_result;  //ALU??????????
output  wire [31:0] addr_result;  //??????
 output wire [31:0] branch_base_addr;  //from IF to ALU
 output wire [31:0] link_addr;  //from IF to Decoder


  // ?????????????
output  wire Zero;
 output wire Branch, nBranch, Jmp, Jal, Jr;
 output wire sftmd;  //??
 output wire I_format;
 output wire [31:0] imme_extend;  //????
 output wire [1:0] ALU_Op;
 output wire ALUSrc;
 output wire RegWrite;  //????????
 output wire RegDst;

  /////////////////////////////////////////////////////////////////////////////
  // LED
 output wire [3:0] select;
 output wire [31:0] AluResult0;
 output wire [31:0] AluResult1;
  output wire clk_out_2ms;
  wire clk_out_1s;
  wire clk_out_500us;


  clk_wiz_0 clk (
      .clk_in1 (fpga_clk),
      .clk_out1(clock)
  );

  dmemory32 dmemory32 (
      .clock(clock),
      .memWrite(MemWrite),
      .address(addr_out),
      .writeData(ram_dat_i),
      .readData(ram_dat_o)
  );

  Ifetc32 ifetch (
      .clock(clock),
      .reset(fpga_rst),
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
      .link_addr(link_addr)
  );

  ALU alu (
      .Read_data_1(read_dat_1),
      .Read_data_2(read_dat_2),
      .Imme_extend(imme_extend),
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

  decode32 decoder (
      .Instruction(instruction),
      .mem_data(r_wdata),
      .ALU_result(ALU_result),
      .Jal(Jal),
      .RegWrite(RegWrite),
      .MemtoReg(MemIOtoReg),
      .RegDst(RegDst),
      .clock(clock),
      .reset(fpga_rst),
      .opcplus4(link_addr),
      .read_data_1(read_dat_1),
      .read_data_2(read_dat_2),
      .Sign_extend(imme_extend)
  );

  TimeDivider timeDivider (
      .clk(fpga_clk),
      .reset(fpga_rst),
      .clk_out_2ms(clk_out_2ms),
      .clk_out_1s(clk_out_1s),
      .clk_out_500us(clk_out_500us)
  );

//   led LED(
//      .reset(fpga_rst),
//      .clk_2ms(clk_out_2ms),
//      .modeSelect(select),
//      .AluResult0(AluResult0),
//      .AluResult1(AluResult1),
//      .led_select(led_select),
//      .signal_display(signal_display)
//  );

  MemOrIO MemOrIO (
      .mRead(MemRead),
      .mWrite(MemWrite),
      .ioRead(IORead),
      .ioWrite(IOWrite),
      .addr_in(addr_result),
      .addr_out(addr_out),

      .m_rdata (ram_dat_o),
      .m_wdata (m_wdata),
      .io_rdata(SwitchData),
      .r_wdata (r_wdata),
      .r_rdata (ram_dat_i),

      .LEDCtrl(LEDCtrl),
      .SwitchCtrl(SwitchCtrl)
  );

  In In (
      .clk(clock),
      .rst(fpga_rst),
      .SwitchCtrl(SwitchCtrl),
      .SwitchInput(switch2N4),
      .ALU_addr(ALU_result[7:0]),
      .SwitchData(SwitchData)
  );

  Out Out (
      .clk(clock),
      .rst(fpga_rst),
      .LEDCtrl(LEDCtrl),
      .ALU_addr(ALU_result[7:0]),
      .OutData(m_wdata[15:0]),
      .modeSelect(select),
      .AluResult0(AluResult0),
      .AluResult1(AluResult1)
  );

//  TestOutput Led32(
//     .clk(clock), 
//     .rst(fpga_rst), 
//     .LEDCtrl(LEDCtrl), 
//     .ALU_addr(ALU_result[7:0]), 
//     .LEDData(m_wdata), 
//     .LEDOutput(led2N4)
//   );
    LED LED(
    .clk_2ms(clk_out_2ms), 
    .reset(fpga_rst), 
    .modeSelect(select),
    .AluResult0(AluResult0),
    .AluResult1(AluResult1),
    .led_select(led_select),
    .signal_display(signal_display)
    );

endmodule
