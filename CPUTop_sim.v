`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/15 08:50:28
// Design Name: 
// Module Name: CPUTop_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPUTop_sim();
reg fpga_clk;
reg fpga_rst;
reg [23:0] switch2N4;
wire [23:0] led2N4;
wire clk;

wire [31:0] addr_result;
wire Zero;
wire [31:0] read_dat_1;
wire Branch, nBranch, Jmp, Jal, Jr;

wire RegDst, MemIOtoReg, RegWrite, MemWrite;
wire ALUSrc, I_format, sftmd;
wire [1:0] ALU_Op;
wire MemRead, IORead, IOWrite;

wire [31:0] instruction;
wire [31:0] branch_base_addr;
wire [31:0] link_addr;

wire [31:0] AluResult0,AluResult1,ALU_result;
wire [31:0] read_dat_2,ram_dat_i,ram_dat_o;
wire [31:0] imme_extend;

wire [31:0] addr_out;
wire [31:0] m_rdata;
wire [31:0] read_data_mem; 
wire [31:0] r_wdata;
wire [31:0] m_wdata;
wire [15:0] switch2N4Data;
wire switch2N4Ctrl;
wire LEDCtrl;
wire [7:0] led_select;
wire [7:0] signal_display;
wire [3:0] select;
wire clk_2ms;
cpu_top_test cpu(    
fpga_rst,       // �ߵ�ƽ��Ч�ĸ�λ�ź�
fpga_clk,       //ʱ���ź�
switch2N4,      //24λ���������??????
led2N4,         //24λ���LED�ź� 
led_select,     //�߶�����??????
signal_display,  //�����ź�
clk,
addr_out, //alu?
m_wdata, //��mem
r_wdata, //regд
switch2N4Data, //��reg����
LEDCtrl, 
switch2N4Ctrl,
MemIOtoReg, //controller to dmem
MemWrite,
MemRead,
IOWrite,
IORead,
read_dat_1,  //��ȡ��read_dat_1, from decoder to ALU
read_dat_2, //reg2
instruction, //��IF�õ���ָ??????, from IF to decoder
ALU_result,  //ALU�ļ����??????
addr_result,  //ָ�������
branch_base_addr,  //from IF to ALU
link_addr,  //from IF t //IF�õ���ַ from IF to programrom
Zero,
Branch, nBranch, Jmp, Jal, Jr,
sftmd, //��λ
I_format,
imme_extend,  //��չ����
ALU_Op,
ALUSrc,
RegWrite,  //�Ĵ�����дʹ����
RegDst,
select, //leselect
AluResult0, //led
AluResult1,//led
ram_dat_i,
ram_dat_o,
 clk_2ms
);
initial fork
fpga_rst <= 1'b0;
fpga_clk <= 0;
switch2N4 <= 24'b000000000000_000000000000;
#5000
fpga_rst <= 1'b1;
#5100
fpga_rst <= 0;
//switch2N4[15:0] <= 16'h0001;
//switch2N4[23:16] <= 8'h01;
#5120
switch2N4 <= 24'b0001_00000101_00000110_0000;
#5140
switch2N4 <= 24'b0001_00000000_00000110_0000;
//#6000
//switch2N4[15:0] <= 16'h1000;
//switch2N4[23:16] <= 8'h10;
//#8000
//switch2N4[15:0] <= 16'h1000;
//switch2N4[23:16] <= 8'h01;
forever
#5 fpga_clk = ~fpga_clk;
join
endmodule
