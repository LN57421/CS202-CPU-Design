`timescale 1ns / 1ps
/*
    Opcode：一�? 6 位的输入信号，表�? MIPS 指令的操作码�?
    Function_opcode：一�? 6 位的输入信号，表�? MIPS 指令的功能码�?
    Jr：一个输出信号，表示当前指令是否�? jr 指令�?
    Jmp：一个输出信号，表示当前指令是否�? j 指令�?
    Jal：一个输出信号，表示当前指令是否�? jal 指令�?
    Branch：一个输出信号，表示当前指令是否�? beq 指令�?
    nBranch：一个输出信号，表示当前指令是否�? bne 指令�?
    RegDST：一个输出信号，用于选择写寄存器的目标寄存器，如果当前指令为 R 型指令，�? RegDST �? 1，否则为 0�?
    MemtoReg：一个输出信号，用于选择写寄存器的数据来源，如果当前指令�? lw 指令，则 MemtoReg �? 1，否则为 0�?
    RegWrite：一个输出信号，用于控制寄存器堆写使能，如果当前指令�? R 型指令�?�lw 指令、jal 指令或立即数指令，则 RegWrite �? 1，否则为 0。同时，如果当前指令�? jr 指令，则 RegWrite �? 0�?
    MemWrite：一个输出信号，用于控制写内存的使能，如果当前指令为 sw 指令，则 MemWrite �? 1，否则为 0�?
    ALUSrc：一个输出信号，用于选择 ALU 的第二个操作数，如果当前指令为立即数指令、lw 指令�? sw 指令，则 ALUSrc �? 1，否则为 0�?
    I_format：一个输出信号，用于表示当前指令是否�? I-类型指令（除�? beq、bne、lw、sw 指令）�??
    Sftmd：一个输出信号，用于表示当前指令是否�? shift 指令�?
    ALUOp：一�? 2 位的输出信号，用于指�? ALU 操作的类型，用于支持不同的指令类型�??
    R_format：一个中间信号，表示当前指令是否�? R 型指令�??
    Lw：一个中间信号，表示当前指令是否�? lw 指令�?
    Sw：一个中间信号，表示当前指令是否�? sw 指令�?
*/
module control32(Alu_resultHigh, Opcode, Function_opcode, Jr, RegDST, ALUSrc, RegWrite, MemWrite, Branch, nBranch, Jmp, Jal, I_format, Sftmd, ALUOp, MemRead,IOWrite, IORead, MemIOtoReg);
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
    output[1:0]  ALUOp;        // if the instruction is R-type or I_format, ALUOp's higher bit is 1, 0 otherwise; if the instruction is “beq�? or “bne�?, ALUOp's lower bit is 1, 0 otherwise

    output MemWrite;
    output MemRead;
    output IOWrite;
    output IORead;
    output MemIOtoReg; 
    
    // 如果指令�? R-type �? I_format = 1, ALUOp = 2'b10;
    // 如果指令�? beq �? bne, ALUOp = 2'b01;
    // 如果指令�? lw �? sw, ALUOP = 2'b00;

    // 表示指令是否�? R 型指�?
    wire R_format; 
    assign R_format = (Opcode==6'b000000)? 1'b1:1'b0;

    // 表示指令是否�? lw 指令
    wire Lw; 
    assign Lw = (Opcode==6'b100011)? 1'b1:1'b0;
    wire Sw;
    assign Sw = (Opcode==6'b101011) ? 1'b1:1'b0;

    // 表示指令是否�? I-类型（除了beq、bne、lw、sw�? 立即数指�?
    assign I_format = (Opcode[5:3]==3'b001)? 1'b1:1'b0;

    // 决定跳转指令
    assign Jr       = ((Function_opcode==6'b001000) && (Opcode==6'b000000)) ? 1'b1:1'b0;
    assign Jmp      = (Opcode==6'b000010) ? 1'b1:1'b0;
    assign Jal      = (Opcode==6'b000011) ? 1'b1:1'b0;
    assign Branch   = (Opcode==6'b000100) ? 1'b1:1'b0;
    assign nBranch  = (Opcode==6'b000101) ? 1'b1:1'b0;

    // 决定控制信号
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

endmodule