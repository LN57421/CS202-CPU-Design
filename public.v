// public.v

`timescale 1ns / 1ps

`define Enable 1'b1
`define Disable 1'b0

// Minisys Parameters
`define ZeroWord 32'h00000000 // 0x0字
`define RegCount 32 // 寄存器数
`define RegCountLog2 5 // 寄存器数Log2
`define RegRange 31:0 // 寄存器数范围
`define RegRangeLog2 4:0 // 寄存器数Log2范围（地址）
`define WordLength 32 // 字长
`define WordRange 31:0 // 字长范围
`define OpRange 31:26 // 指令字中op的范围
`define RsRange 25:21 // 指令字中rs的范围
`define RtRange 20:16 // 指令字中rt的范围
`define RdRange 15:11 // 指令字中rd的范围
`define ShamtRange 10:6 // 指令字中shamt的范围
`define FuncRange 5:0 // 指令字中func的范围
`define ImmedRange 15:0 // 指令字中immediate的范围
`define OffsetRange 15:0 // 指令字中offset的范围
`define AddressRange 25:0 // 指令字中address的范围

// Minisys Instruction Set
// R Type Instructions
`define OP_RTYPE 6'b000000
`define FUNC_ADD 6'b100000
`define FUNC_ADDU 6'b100001
`define FUNC_SUB 6'b100010
`define FUNC_SUBU 6'b100011
`define FUNC_AND 6'b100100
`define FUNC_OR 6'b100101
`define FUNC_XOR 6'b100110
`define FUNC_NOR 6'b100111
`define FUNC_SLT 6'b101010
`define FUNC_SLTU 6'b101011
`define FUNC_SLL 6'b000000
`define FUNC_SRL 6'b000010
`define FUNC_SRA 6'b000011
`define FUNC_SLLV 6'b000100
`define FUNC_SRLV 6'b000110
`define FUNC_SRAV 6'b000111
`define FUNC_JR 6'b001000
// I Type Instructions
`define OP_ADDI 6'b001000
`define OP_ADDIU 6'b001001
`define OP_ANDI 6'b001100
`define OP_ORI 6'b001101
`define OP_XORI 6'b001110
`define OP_LUI 6'b001111
`define OP_LW 6'b100011
`define OP_SW 6'b101011
`define OP_BEQ 6'b000100
`define OP_BNE 6'b000101
`define OP_SLTI 6'b001010
`define OP_SLTIU 6'b001011
// J Type Instructions
`define OP_J 6'b000010
`define OP_JAL 6'b000011
// NOP
`define OP_NOP 6'b000000

//----------------------------ISA Specifications--------------------------------//
`define ISA_WIDTH           32                  // width of a word in the ISA
`define STAGE_CNT           5
`define STAGE_CNT_WIDTH     3                   // stage count width 5 <= 2^3
`define ADDRESS_WIDTH       26                  // address lenth of instructions for j and jal extension
`define SHIFT_AMOUNT_WIDTH  5
`define JAL_REG_IDX         31
`define IMMEDIATE_WIDTH     16
`define REG_FILE_ADDR_WIDTH 5                   // width of register address(idx)
`define OP_CODE_WIDTH       6                   // width of oepration code
`define FUNC_CODE_WIDTH     6                   // width of function code
//------------------------------------------------------------------------------//

//---------------------------------Memory---------------------------------------//
`define RAM_DEPTH           14                  // ram size = 2^RAM_DEPTH words
`define ROM_DEPTH           14                  // rom size = 2^ROM_DEPTH words
`define PC_MAX_VALUE        16_383              // ((1 << (`DEFAULT_ROM_DEPTH + 2)) - 1)

`define MEM_WRITE_BIT       0                   // bit for determining memory write enable
`define MEM_READ_BIT        1                   // bit for determining memory read enable

`define IO_START_BIT        10                  // lowest bit of memory_mapped IO address
`define IO_END_BIT          31                  // highest bit of memory-mapped IO address
`define IO_TYPE_BIT         4                   // bit for determining IO type
//------------------------------------------------------------------------------//

//---------------------------------Control--------------------------------------//
`define OP_CODE_WIDTH       6                   // width of oepration code
`define FUNC_CODE_WIDTH     6                   // width of function code

`define OP_SLL              6'b00_0000
`define OP_SRL              6'b00_0010
`define OP_SLLV             6'b00_0100
`define OP_SRLV             6'b00_0110
`define OP_SRA              6'b00_0011
`define OP_SRAV             6'b00_0111
//------------------------------------------------------------------------------//

//---------------------------------Hazard---------------------------------------//
// signals for the stage registers (hazard_control)
`define HAZD_CTL_WIDTH      2                   // width of hazard control signal
`define HAZD_CTL_NORMAL     2'b00               // normal execution state
`define HAZD_CTL_RETRY      2'b01               // deny values from pervious stage only
`define HAZD_CTL_NO_OP      2'b11               // deny values from previous stage and no_op the next stage
// `define HAZD_CTL_RESUME     2'b10               // no hold and do not accept no_op signal from previous stage

// values of issue_type 
`define ISSUE_TYPE_WIDTH    3
`define ISSUE_NONE          3'b000
`define ISSUE_DATA          3'b001
`define ISSUE_CONTROL       3'b010              // not handled by hazard_unit (determined after negedge with pc_abnormal in if_id_reg)
`define ISSUE_UART          3'b011              // during uart transmission only
`define ISSUE_PAUSE         3'b100
`define ISSUE_VGA           3'b101              // not handled by hazard_unit (as this typically holds only for a few cycles)
`define ISSUE_KEYPAD        3'b110
`define ISSUE_FALLTHROUGH   3'b111              // the next instruction address exceeds `PC_MAX_VALUE 
//------------------------------------------------------------------------------//

`define VGA_BIT_DEPTH       12                  // VGA color depth

// VGA display parameters
`define DISPLAY_WIDTH       640
`define DISPLAY_HEIGHT      480
`define COORDINATE_WIDTH    10                  // width of coordinate value
`define LEFT_BORDER         48
`define RIGHT_BORDER        16
`define TOP_BORDER          33
`define BOTTOM_BORDER       10
`define HORIZONTAL_GAP      96                  // horizontal gap duration
`define VERTICAL_GAP        2                   // vertical gap duration

// VGA colors
`define BG_COLOR            12'b110111011101    // light gray
`define DIGITS_BOX_BG_COLOR 12'b110011001100    // dark gray

// VGA display asset parameters
`define DIGITS_BOX_WIDTH    492
`define DIGITS_BOX_HEIGHT   40
`define DIGITS_BOX_X        74
`define DIGITS_BOX_Y        215

`define DIGITS_WIDTH        468
`define DIGITS_W_WIDTH      9                   // width of width 468 <= 2^9
`define DIGITS_HEIGHT       16
`define DIGITS_X            86
`define DIGITS_Y            227
`define DIGITS_IDX_WIDTH    6                   // number of digits 39 + 7 <= 2^6

`define DIGIT_WIDTH         12
`define DIGIT_W_WIDTH       4                   // width of width 12 <= 2^4
`define DIGIT_H_WIDTH       4                   // width of height 16 <= 2^4

`define STATUS_WIDTH        88
`define STATUS_W_WIDTH      7                   // width of width 88 <= 2^7
`define STATUS_HEIGHT       22
`define STATUS_H_WIDTH      5                   // width of height 22 <= 2^5
`define STATUS_X            291
`define STATUS_Y            180
//------------------------------------------------------------------------------//