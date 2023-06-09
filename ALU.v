`timescale 1ns / 1ps


module ALU(Read_data_1,Read_data_2,Sign_extend,Function_opcode,opcode,ALUOp,
           Shamt,ALUSrc,I_format,Zero,Jr,Sftmd,ALU_Result,Addr_Result,PC_plus_4
    );
    // from decoder
    input[31:0]  Read_data_1;	   //      氲ピ?  Read_data_1    
    input[31:0]  Read_data_2;      //      氲ピ?  Read_data_2    
    input[31:0]  Sign_extend;      //      氲ピ?      展         
    
    //from IFetch
    input[5:0]   Function_opcode;  // 取指  元    r-    指 罟?    ,r-form instructions[5:0]
    input[5:0]   opcode;       // 取指  元   牟     
    input[4:0]   Shamt;            //     取指  元  instruction[10:6]  指    位    
    input[31:0]  PC_plus_4;        //     取指  元  PC+4
    
    //from Controller
    input[1:0]   ALUOp;            //    钥  频 元      指    票   
    input        ALUSrc;           //    钥  频 元       诙                   beq  bne   猓?
    input        I_format;         //    钥  频 元       浅 beq, bne, LW, SW之   I-    指  
    input        Sftmd;            //    钥  频 元 模         位指  
    input        Jr;               //    钥  频 元        JR指  
    
    //outputs
    output       Zero;             // 为1        值为0 
    output reg [31:0] ALU_Result;  //         萁  
    output[31:0] Addr_Result;      //     牡 址           
    
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
        3'b101: ALU_output_mux = ~(Ainput | Binput);                        //nor                         
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
    
endmodule