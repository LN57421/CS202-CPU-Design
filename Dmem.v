`timescale 1ns / 1ps

// 在CPU中用于读写数据存储器，为CPU的指令执行提供必要的数据支持
/*
module dmemoryIO (
    ram_clk_i,
    address,
    ram_dat_i,
    ram_dat_o,
    MemIOtoReg,
    upg_clk_i,
    upg_rst_i,
    upg_wen_i,
    upg_adr_i,
    upg_dat_i,
    upg_done_i
);

  input ram_clk_i;  //时钟信号

  input MemIOtoReg;  // 来自controller，为1'b1时表示要对data-memory做写操作

  input [31:0] address;  //以字节为单位，要读或写的内存地址 从ALU中来
  input [31:0] ram_dat_i;  //向data-memory中写入的数据

  output [31:0] ram_dat_o;  //从data-memory中读出的数据

  input upg_clk_i;
  input upg_rst_i;
  input upg_wen_i;
  input [13:0] upg_adr_i;
  input [31:0] upg_dat_i;
  input upg_done_i;

  reg [31:0] true_save_data;  // 最后应该储存到reg中的数据

  // 产生一个时钟信号，它是时钟符号的反向时钟
  wire ram_clk;
  assign ram_clk = ram_clk_i;

  wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);

  RAM ram (
      .clka (kickOff ? ram_clk : upg_clk_i),
      .wea  (kickOff ? MemIOtoReg : upg_wen_i),
      .addra(kickOff ? address[15:2] : upg_adr_i),
      .dina (kickOff ? true_save_data : upg_dat_i),
      .douta(ram_dat_o)
  );

endmodule
*/

`timescale 1ns / 1ps

// 在CPU中用于读写数据存储器，为CPU的指令执行提供必要的数据支持

module dmemory32 (
    clock,
    memWrite,
    address,
    writeData,
    readData
);
  input clock;  //时钟信号
  input memWrite;  //来自controller，为1'b1时表示要对data-memory做写操作
  input [31:0] address;  //以字节为单位，要读或写的内存地址
  input [31:0] writeData;  //向data-memory中写入的数据
  output [31:0] readData;  //从data-memory中读出的数据


  // 产生一个时钟信号，它是时钟符号的反向时钟
  wire clk;
  assign clk = !clock;

  RAM ram (
      .clka(clk),  // input wire clka
      .wea(memWrite),  // input wire [0 : 0] wea
      .addra(address[15:2]),  // input wire [13 : 0] addra
      .dina(writeData),  // input wire [31 : 0] dina
      .douta(readData)  // output wire [31 : 0] douta
  );

endmodule
