`timescale 1ns / 1ps

// 该模块用于从指令存储器中读取指令，为CPU的指令执行提供必要的指令支持
module Ifetc32 (
    Instruction,
    branch_base_addr,
    Addr_result,
    Read_data_1,
    Branch,
    nBranch,
    Jmp,
    Jal,
    Jr,
    Zero,
    clock,
    reset,
    link_addr
);
  output [31:0] Instruction;  // 从这个模块获取到的指令，输出到其他模�?
  output [31:0] branch_base_addr;  // 用于beq,bne指令�?(pc+4)输出到ALU
  output [31:0] link_addr;  // 用于jal指令�?(pc+4)输出到解码器

  input [31:0] Addr_result;  // ALU中计算出的地�?
  input [31:0] Read_data_1;  // jr指令更新PC时用的地�?
  input Branch;  // 当Branch�?1时，表示当前指令是beq
  input nBranch;  // 当nBranch�?1时，表示当前指令为bnq
  input Jmp;  // 当Jmp�?1时，表示当前指令为jump
  input Jal;  // 当Jal�?1时，表示当前指令为jal
  input Jr;  // 当Jr�?1时，表示当前指令为jr
  input Zero;  // 当Zero�?1时，表示ALUresult�?0
  input        clock,reset;           // 时钟与复位（同步复位信号，高电平有效，当reset=1时，PC赋�?�为0�?


  reg [31:0] PC, Next_PC;  // 当前指令：PC 下一条指令：Next_PC
  reg [31:0] link_addr_reg;  // 用于jal指令�?(pc+4)输出到解码器

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
        PC <= {PC[31:28], Instruction[25:0], 2'b00};  // 26位的指令左移两位，然后补0
        link_addr_reg <= PC + 4;  // jal指令�?(pc+4)输出到解码器
      end  // 其它的正常更新PC
      else begin
        PC <= Next_PC;
      end
    end
  end


  assign branch_base_addr = PC + 4;  // 从pc + 4进行branch
  assign link_addr = link_addr_reg;  // jal指令�?(pc+4)输出到解码器


  prgrom instmem (
      .clka(clock),  // input wire clka
      .addra(PC[15:2]),  // input wire [13 : 0] addra
      .douta(Instruction)  // output wire [31 : 0] douta
  );


endmodule
