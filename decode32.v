`include "public.v"

module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
            Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
    output[31:0] read_data_1;               // 输出的第一操作数
    output[31:0] read_data_2;               // 输出的第二操作数
    input[31:0]  Instruction;               // The instruction fetched 
    input[31:0]  mem_data;   				// DATA taken from the DATA RAM or I/O port for writing data to a specified register
    input[31:0]  ALU_result;   				// The result of an operation from the Arithmetic logic unit ALU used to write data to a specified register
    input        Jal;                       // From the control unit Controller, when the value is 1, it indicates that it is a JAL instruction
    input        RegWrite;                  // From the control unit Controller, when the value is 1, do register write; When the value is 0, no write is performed
    input        MemtoReg;                  // From the control unit Controller, indicating that DATA is written to a register after it is removed from the DATA RAM
    input        RegDst;                    //Control write to which specified register in instructions. when RegDst is 1, write to the target register, such as R type Rd; Is 0, writes the second register, such as I type is Rt
    output[31:0] Sign_extend;               // 扩展后的32位立即数
    input		 clock;                     //Clock signal
    input 		 reset;                     //Reset signal, active high level and clear all registers. Writing is not allowed here.
    input[31:0]  opcplus4;                  // The JAL instruction is used to write the return address to the $ra register, what we have got here is PC + 4

    reg[31:0] register[0:31];           // 寄存器组共32个32位寄存器
    reg[4:0] write_register_address;    // 最后决定要写的寄存器
    reg[31:0] write_data;               // 最后决定要写的数据
    reg[4:0] read_register_1_address;  // rs
    reg[4:0] read_register_2_address;  // rt
    reg[4:0] write_register_address_1; // rd r-form
    reg[4:0] write_register_address_0; // rt i-form
    reg[15:0] Instruction_immediate_value; // immediate
    reg[5:0] opcode; // op
    reg sign;


    integer k;
    initial begin
        for (k = 0; k < 31; k = k + 1) begin
            register[k] = 0;
        end
        register[31] = 32'hFFFFF000;
    end



    always @(*) begin
        // 填充上面的一系列参数
        read_register_1_address = Instruction[`RsRange];
        read_register_2_address = Instruction[`RtRange];

        write_register_address_0 = Instruction[`RtRange];
        write_register_address_1 = Instruction[`RdRange];
        
        Instruction_immediate_value = Instruction[`ImmedRange];
        opcode = Instruction[`OpRange];

        sign = Instruction_immediate_value[15];
    end

    assign read_data_1 = register[read_register_1_address];
    assign read_data_2 = register[read_register_2_address];

    assign Sign_extend = 
    (opcode == `OP_ANDI || opcode == `OP_ORI || opcode == `OP_XORI || opcode == `OP_SLTIU) 
    ? {16'd0, Instruction_immediate_value[15:0]} 
    : {{16{sign}}, Instruction_immediate_value[15:0]};

    always @(*) begin   // 这个进程指定不同指令下的目标寄存器
        if (Jal == `Enable) begin
            write_register_address = 5'b11111; // Jal指令写$ra（31号）寄存器
        end else if (RegDst == `Enable) begin // 为1说明目标寄存器是rd，否则是rt
            write_register_address = write_register_address_1;
        end else begin
            write_register_address= write_register_address_0;     
        end
    end
    
    always @(*) begin  // 这个进程基本上是实现结构图中右下的多路选择器,准备要写的数据
        if (Jal == `Enable) begin
            write_data = opcplus4; // 保存当前PC
        end else if (MemtoReg == `Disable) begin
            write_data = ALU_result; // 来源是ALU运算结果，而非MEM
        end else begin
            write_data = mem_data; // 来源是MEM
        end
    end
    
    integer i;
    always @(posedge clock) begin       // 本进程写目标寄存器
        if (reset == `Enable) begin              // 初始化寄存器组
            for (i = 0; i < 31; i = i + 1) register[i] <= 0;    // register[0] = 0
            register[31] = 32'hFFFFF000;
        end else if (RegWrite == `Enable) begin  // 注意寄存器0恒等于0
            if (write_register_address != 5'b00000) begin // don't write to register 0
                register[write_register_address] <= write_data;
            end
        end
    end
endmodule
