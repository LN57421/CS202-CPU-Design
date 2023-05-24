`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Li Weihao
// 
// Create Date: 2023/05/13 23:33:28
// Design Name: 
// Module Name: LED
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


  //--------clk-flash-----------------------------------------------------
  always @(posedge clk_2ms, posedge reset) begin
    if (reset) begin
      signal_display_tmp <= point;
      led_select_tmp <= 8'b1111_1110;
    end else begin
      led_select_tmp = {led_select_tmp[0], led_select_tmp[7:1]};
      case (led_select_tmp)
        8'b1111_1110: signal_display_tmp <= led_R_0_Content;  //led_R_0_Content;
        8'b1111_1101: signal_display_tmp <= led_R_1_Content;  //led_R_1_Content;
        8'b1111_1011: signal_display_tmp <= led_R_2_Content;  //led_R_2_Content;
        8'b1111_0111: signal_display_tmp <= led_R_3_Content;  //led_R_3_Content;
        8'b1110_1111: signal_display_tmp <= led_L_0_Content;  //led_L_0_Content;
        8'b1101_1111: signal_display_tmp <= led_L_1_Content;  //led_L_1_Content;
        8'b1011_1111: signal_display_tmp <= led_L_2_Content;  //led_L_2_Content;
        8'b0111_1111: signal_display_tmp <= led_L_3_Content;  //led_L_3_Content;
        default: signal_display_tmp = dim;
      endcase
    end
  end


  always @(*) begin
    casex (modeSelect)

//----------------------pull-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


      4'b0000: begin
        casex (AluResult0[7:0])
          8'b0000_0000: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0001: begin led_L_0_Content = one; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0010: begin led_L_0_Content = two; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_0011: begin led_L_0_Content = three; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0100: begin led_L_0_Content = four; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0101: begin led_L_0_Content = five; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0110: begin led_L_0_Content = six; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_0111: begin led_L_0_Content = seven; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1000: begin led_L_0_Content = eight; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1001: begin led_L_0_Content = nine; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_1010: begin led_L_0_Content = zero; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_1011: begin led_L_0_Content = one; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1100: begin led_L_0_Content = two; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1101: begin led_L_0_Content = three; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0000_1110: begin led_L_0_Content = four; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_1111: begin led_L_0_Content = five; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_0000: begin led_L_0_Content = six; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ; end
          8'b0001_0001: begin led_L_0_Content = seven; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_0010: begin led_L_0_Content = eight; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_0011: begin led_L_0_Content = nine; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0100: begin led_L_0_Content = zero; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0101: begin led_L_0_Content = one; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0110: begin led_L_0_Content = two; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0111: begin led_L_0_Content = three; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1000: begin led_L_0_Content = four; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1001: begin led_L_0_Content = five; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1010: begin led_L_0_Content = six; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_1011: begin led_L_0_Content = seven; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_1100: begin led_L_0_Content = eight; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1101: begin led_L_0_Content = nine; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_1110: begin led_L_0_Content = zero; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0001_1111: begin led_L_0_Content = one; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_0000: begin led_L_0_Content = two; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0001: begin led_L_0_Content = three; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0010: begin led_L_0_Content = four; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0011: begin led_L_0_Content = five; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0100: begin led_L_0_Content = six; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0101: begin led_L_0_Content = seven; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0110: begin led_L_0_Content = eight; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;  end
          8'b0010_0111: begin led_L_0_Content = nine; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1000: begin led_L_0_Content = zero; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_1001: begin led_L_0_Content = one; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1010: begin led_L_0_Content = two; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1011: begin led_L_0_Content = three; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1100: begin led_L_0_Content = four; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1101: begin led_L_0_Content = five; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1110: begin led_L_0_Content = six; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1111: begin led_L_0_Content = seven; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0000: begin led_L_0_Content = eight; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0001: begin led_L_0_Content = nine; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0011_0010: begin led_L_0_Content = zero; led_L_1_Content = five; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
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


//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


      4'b0001:begin
         casex (AluResult0[7:0])
          8'b0000_0000: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0001: begin led_L_0_Content = one; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0010: begin led_L_0_Content = two; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_0011: begin led_L_0_Content = three; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0100: begin led_L_0_Content = four; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0101: begin led_L_0_Content = five; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0110: begin led_L_0_Content = six; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_0111: begin led_L_0_Content = seven; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1000: begin led_L_0_Content = eight; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1001: begin led_L_0_Content = nine; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_1010: begin led_L_0_Content = zero; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_1011: begin led_L_0_Content = one; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1100: begin led_L_0_Content = two; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1101: begin led_L_0_Content = three; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0000_1110: begin led_L_0_Content = four; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_1111: begin led_L_0_Content = five; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_0000: begin led_L_0_Content = six; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ; end
          8'b0001_0001: begin led_L_0_Content = seven; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_0010: begin led_L_0_Content = eight; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_0011: begin led_L_0_Content = nine; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0100: begin led_L_0_Content = zero; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0101: begin led_L_0_Content = one; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0110: begin led_L_0_Content = two; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0111: begin led_L_0_Content = three; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1000: begin led_L_0_Content = four; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1001: begin led_L_0_Content = five; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1010: begin led_L_0_Content = six; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_1011: begin led_L_0_Content = seven; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_1100: begin led_L_0_Content = eight; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1101: begin led_L_0_Content = nine; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_1110: begin led_L_0_Content = zero; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0001_1111: begin led_L_0_Content = one; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_0000: begin led_L_0_Content = two; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0001: begin led_L_0_Content = three; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0010: begin led_L_0_Content = four; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0011: begin led_L_0_Content = five; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0100: begin led_L_0_Content = six; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0101: begin led_L_0_Content = seven; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0110: begin led_L_0_Content = eight; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;  end
          8'b0010_0111: begin led_L_0_Content = nine; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1000: begin led_L_0_Content = zero; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_1001: begin led_L_0_Content = one; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1010: begin led_L_0_Content = two; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1011: begin led_L_0_Content = three; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1100: begin led_L_0_Content = four; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1101: begin led_L_0_Content = five; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1110: begin led_L_0_Content = six; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1111: begin led_L_0_Content = seven; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0000: begin led_L_0_Content = eight; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0001: begin led_L_0_Content = nine; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0011_0010: begin led_L_0_Content = zero; led_L_1_Content = five; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
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

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


      4'b0010:
      begin
          casex (AluResult0[7:0])
          8'b0000_0000: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0001: begin led_L_0_Content = one; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0010: begin led_L_0_Content = two; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_0011: begin led_L_0_Content = three; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0100: begin led_L_0_Content = four; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0101: begin led_L_0_Content = five; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0110: begin led_L_0_Content = six; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_0111: begin led_L_0_Content = seven; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1000: begin led_L_0_Content = eight; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1001: begin led_L_0_Content = nine; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_1010: begin led_L_0_Content = zero; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_1011: begin led_L_0_Content = one; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1100: begin led_L_0_Content = two; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1101: begin led_L_0_Content = three; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0000_1110: begin led_L_0_Content = four; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_1111: begin led_L_0_Content = five; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_0000: begin led_L_0_Content = six; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ; end
          8'b0001_0001: begin led_L_0_Content = seven; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_0010: begin led_L_0_Content = eight; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_0011: begin led_L_0_Content = nine; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0100: begin led_L_0_Content = zero; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0101: begin led_L_0_Content = one; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0110: begin led_L_0_Content = two; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0111: begin led_L_0_Content = three; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1000: begin led_L_0_Content = four; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1001: begin led_L_0_Content = five; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1010: begin led_L_0_Content = six; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_1011: begin led_L_0_Content = seven; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_1100: begin led_L_0_Content = eight; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1101: begin led_L_0_Content = nine; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_1110: begin led_L_0_Content = zero; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0001_1111: begin led_L_0_Content = one; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_0000: begin led_L_0_Content = two; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0001: begin led_L_0_Content = three; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0010: begin led_L_0_Content = four; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0011: begin led_L_0_Content = five; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0100: begin led_L_0_Content = six; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0101: begin led_L_0_Content = seven; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0110: begin led_L_0_Content = eight; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;  end
          8'b0010_0111: begin led_L_0_Content = nine; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1000: begin led_L_0_Content = zero; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_1001: begin led_L_0_Content = one; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1010: begin led_L_0_Content = two; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1011: begin led_L_0_Content = three; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1100: begin led_L_0_Content = four; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1101: begin led_L_0_Content = five; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1110: begin led_L_0_Content = six; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1111: begin led_L_0_Content = seven; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0000: begin led_L_0_Content = eight; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0001: begin led_L_0_Content = nine; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0011_0010: begin led_L_0_Content = zero; led_L_1_Content = five; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          default: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero       ;   end
          endcase

          
        casex (AluResult1[7:0])
          8'b0000_0000: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;            
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          default: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;            
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
        endcase
      end

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


      4'b0011:
      begin
          casex (AluResult0[7:0])
          8'b0000_0000: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0001: begin led_L_0_Content = one; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0010: begin led_L_0_Content = two; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_0011: begin led_L_0_Content = three; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0100: begin led_L_0_Content = four; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0101: begin led_L_0_Content = five; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0110: begin led_L_0_Content = six; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_0111: begin led_L_0_Content = seven; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1000: begin led_L_0_Content = eight; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1001: begin led_L_0_Content = nine; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_1010: begin led_L_0_Content = zero; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_1011: begin led_L_0_Content = one; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1100: begin led_L_0_Content = two; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1101: begin led_L_0_Content = three; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0000_1110: begin led_L_0_Content = four; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_1111: begin led_L_0_Content = five; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_0000: begin led_L_0_Content = six; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ; end
          8'b0001_0001: begin led_L_0_Content = seven; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_0010: begin led_L_0_Content = eight; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_0011: begin led_L_0_Content = nine; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0100: begin led_L_0_Content = zero; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0101: begin led_L_0_Content = one; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0110: begin led_L_0_Content = two; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0111: begin led_L_0_Content = three; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1000: begin led_L_0_Content = four; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1001: begin led_L_0_Content = five; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1010: begin led_L_0_Content = six; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_1011: begin led_L_0_Content = seven; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_1100: begin led_L_0_Content = eight; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1101: begin led_L_0_Content = nine; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_1110: begin led_L_0_Content = zero; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0001_1111: begin led_L_0_Content = one; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_0000: begin led_L_0_Content = two; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0001: begin led_L_0_Content = three; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0010: begin led_L_0_Content = four; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0011: begin led_L_0_Content = five; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0100: begin led_L_0_Content = six; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0101: begin led_L_0_Content = seven; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0110: begin led_L_0_Content = eight; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;  end
          8'b0010_0111: begin led_L_0_Content = nine; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1000: begin led_L_0_Content = zero; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_1001: begin led_L_0_Content = one; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1010: begin led_L_0_Content = two; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1011: begin led_L_0_Content = three; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1100: begin led_L_0_Content = four; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1101: begin led_L_0_Content = five; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1110: begin led_L_0_Content = six; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1111: begin led_L_0_Content = seven; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0000: begin led_L_0_Content = eight; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0001: begin led_L_0_Content = nine; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0011_0010: begin led_L_0_Content = zero; led_L_1_Content = five; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          default: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero       ;   end
          endcase

        casex (AluResult1[7:0])
          8'b0000_0000: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;            
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          default: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;            
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
        endcase
      end

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


      4'b0100:
      begin
          casex (AluResult0[7:0])
          8'b0000_0000: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0001: begin led_L_0_Content = one; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0010: begin led_L_0_Content = two; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_0011: begin led_L_0_Content = three; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0100: begin led_L_0_Content = four; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0101: begin led_L_0_Content = five; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0110: begin led_L_0_Content = six; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_0111: begin led_L_0_Content = seven; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1000: begin led_L_0_Content = eight; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1001: begin led_L_0_Content = nine; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_1010: begin led_L_0_Content = zero; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_1011: begin led_L_0_Content = one; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1100: begin led_L_0_Content = two; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1101: begin led_L_0_Content = three; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0000_1110: begin led_L_0_Content = four; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_1111: begin led_L_0_Content = five; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_0000: begin led_L_0_Content = six; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ; end
          8'b0001_0001: begin led_L_0_Content = seven; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_0010: begin led_L_0_Content = eight; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_0011: begin led_L_0_Content = nine; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0100: begin led_L_0_Content = zero; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0101: begin led_L_0_Content = one; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0110: begin led_L_0_Content = two; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0111: begin led_L_0_Content = three; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1000: begin led_L_0_Content = four; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1001: begin led_L_0_Content = five; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1010: begin led_L_0_Content = six; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_1011: begin led_L_0_Content = seven; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_1100: begin led_L_0_Content = eight; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1101: begin led_L_0_Content = nine; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_1110: begin led_L_0_Content = zero; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0001_1111: begin led_L_0_Content = one; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_0000: begin led_L_0_Content = two; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0001: begin led_L_0_Content = three; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0010: begin led_L_0_Content = four; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0011: begin led_L_0_Content = five; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0100: begin led_L_0_Content = six; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0101: begin led_L_0_Content = seven; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0110: begin led_L_0_Content = eight; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;  end
          8'b0010_0111: begin led_L_0_Content = nine; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1000: begin led_L_0_Content = zero; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_1001: begin led_L_0_Content = one; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1010: begin led_L_0_Content = two; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1011: begin led_L_0_Content = three; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1100: begin led_L_0_Content = four; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1101: begin led_L_0_Content = five; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1110: begin led_L_0_Content = six; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1111: begin led_L_0_Content = seven; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0000: begin led_L_0_Content = eight; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0001: begin led_L_0_Content = nine; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0011_0010: begin led_L_0_Content = zero; led_L_1_Content = five; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          default: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero       ;   end
          endcase

        casex (AluResult1[7:0])
          8'b0000_0000: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;            
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          default: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;            
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
        endcase
      end

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


      4'b0101:
      begin
        casex (AluResult1[7:0])
          8'b0000_0001: begin
            led_display_tmp = 24'b1111_1111_1111_1111_1111_1111;           
            led_L_0_Content = dim;
            led_L_1_Content = dim;
            led_L_2_Content = dim;
            led_L_3_Content = dim; 
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          default: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;       
            led_L_0_Content = dim;
            led_L_1_Content = dim;
            led_L_2_Content = dim;
            led_L_3_Content = dim; 
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;     
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
        endcase
      end

      4'b0110:
      begin
          casex (AluResult1[7:0])
          8'b0000_0001: begin
            led_display_tmp = 24'b1111_1111_1111_1111_1111_1111;           
            led_L_0_Content = dim;
            led_L_1_Content = dim;
            led_L_2_Content = dim;
            led_L_3_Content = dim; 
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          default: begin
            led_display_tmp = 24'b0000_0000_0000_0000_0000_0000;       
            led_L_0_Content = dim;
            led_L_1_Content = dim;
            led_L_2_Content = dim;
            led_L_3_Content = dim; 
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;     
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          endcase
      end

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

      4'b0111:
      begin
           casex (AluResult0[7:0])
          8'b0000_0000: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0001: begin led_L_0_Content = one; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0010: begin led_L_0_Content = two; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_0011: begin led_L_0_Content = three; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_0100: begin led_L_0_Content = four; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;   end
          8'b0000_0101: begin led_L_0_Content = five; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_0110: begin led_L_0_Content = six; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_0111: begin led_L_0_Content = seven; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1000: begin led_L_0_Content = eight; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0000_1001: begin led_L_0_Content = nine; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0000_1010: begin led_L_0_Content = zero; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;  end
          8'b0000_1011: begin led_L_0_Content = one; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1100: begin led_L_0_Content = two; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ;  end
          8'b0000_1101: begin led_L_0_Content = three; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0000_1110: begin led_L_0_Content = four; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0000_1111: begin led_L_0_Content = five; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_0000: begin led_L_0_Content = six; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero    ; end
          8'b0001_0001: begin led_L_0_Content = seven; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_0010: begin led_L_0_Content = eight; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_0011: begin led_L_0_Content = nine; led_L_1_Content = one; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0100: begin led_L_0_Content = zero; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_0101: begin led_L_0_Content = one; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0110: begin led_L_0_Content = two; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_0111: begin led_L_0_Content = three; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1000: begin led_L_0_Content = four; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1001: begin led_L_0_Content = five; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ;end
          8'b0001_1010: begin led_L_0_Content = six; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero    ;end
          8'b0001_1011: begin led_L_0_Content = seven; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0001_1100: begin led_L_0_Content = eight; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0001_1101: begin led_L_0_Content = nine; led_L_1_Content = two; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0001_1110: begin led_L_0_Content = zero; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0001_1111: begin led_L_0_Content = one; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_0000: begin led_L_0_Content = two; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0001: begin led_L_0_Content = three; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0010: begin led_L_0_Content = four; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0011: begin led_L_0_Content = five; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0010_0100: begin led_L_0_Content = six; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_0101: begin led_L_0_Content = seven; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;   end
          8'b0010_0110: begin led_L_0_Content = eight; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero;  end
          8'b0010_0111: begin led_L_0_Content = nine; led_L_1_Content = three; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1000: begin led_L_0_Content = zero; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0010_1001: begin led_L_0_Content = one; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1010: begin led_L_0_Content = two; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1011: begin led_L_0_Content = three; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ; end
          8'b0010_1100: begin led_L_0_Content = four; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1101: begin led_L_0_Content = five; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ; end
          8'b0010_1110: begin led_L_0_Content = six; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero   ; end
          8'b0010_1111: begin led_L_0_Content = seven; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0000: begin led_L_0_Content = eight; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero ;  end
          8'b0011_0001: begin led_L_0_Content = nine; led_L_1_Content = four; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          8'b0011_0010: begin led_L_0_Content = zero; led_L_1_Content = five; led_L_2_Content = zero; led_L_3_Content = zero  ;  end
          default: begin led_L_0_Content = zero; led_L_1_Content = zero; led_L_2_Content = zero; led_L_3_Content = zero       ;   end
          endcase


           casex (AluResult1[7:0])
          8'b0000_0000: begin led_R_0_Content = zero; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0000_0001: begin led_R_0_Content = one; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0000_0010: begin led_R_0_Content = two; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero   ;  end
          8'b0000_0011: begin led_R_0_Content = three; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0000_0100: begin led_R_0_Content = four; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero  ;   end
          8'b0000_0101: begin led_R_0_Content = five; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0000_0110: begin led_R_0_Content = six; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0000_0111: begin led_R_0_Content = seven; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0000_1000: begin led_R_0_Content = eight; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0000_1001: begin led_R_0_Content = nine; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0000_1010: begin led_R_0_Content = zero; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero   ;  end
          8'b0000_1011: begin led_R_0_Content = one; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero    ;  end
          8'b0000_1100: begin led_R_0_Content = two; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero    ;  end
          8'b0000_1101: begin led_R_0_Content = three; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero  ; end
          8'b0000_1110: begin led_R_0_Content = four; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0000_1111: begin led_R_0_Content = five; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero   ;end
          8'b0001_0000: begin led_R_0_Content = six; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero    ; end
          8'b0001_0001: begin led_R_0_Content = seven; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero  ; end
          8'b0001_0010: begin led_R_0_Content = eight; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0001_0011: begin led_R_0_Content = nine; led_R_1_Content = one; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0001_0100: begin led_R_0_Content = zero; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0001_0101: begin led_R_0_Content = one; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero    ;end
          8'b0001_0110: begin led_R_0_Content = two; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero    ;end
          8'b0001_0111: begin led_R_0_Content = three; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0001_1000: begin led_R_0_Content = four; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero   ;end
          8'b0001_1001: begin led_R_0_Content = five; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero   ;end
          8'b0001_1010: begin led_R_0_Content = six; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero    ;end
          8'b0001_1011: begin led_R_0_Content = seven; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero  ; end
          8'b0001_1100: begin led_R_0_Content = eight; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0001_1101: begin led_R_0_Content = nine; led_R_1_Content = two; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0001_1110: begin led_R_0_Content = zero; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0001_1111: begin led_R_0_Content = one; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0010_0000: begin led_R_0_Content = two; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero  ; end
          8'b0010_0001: begin led_R_0_Content = three; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero;   end
          8'b0010_0010: begin led_R_0_Content = four; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0010_0011: begin led_R_0_Content = five; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0010_0100: begin led_R_0_Content = six; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero  ; end
          8'b0010_0101: begin led_R_0_Content = seven; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero;   end
          8'b0010_0110: begin led_R_0_Content = eight; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero;  end
          8'b0010_0111: begin led_R_0_Content = nine; led_R_1_Content = three; led_R_2_Content = zero; led_R_3_Content = zero ; end
          8'b0010_1000: begin led_R_0_Content = zero; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0010_1001: begin led_R_0_Content = one; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0010_1010: begin led_R_0_Content = two; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0010_1011: begin led_R_0_Content = three; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero ; end
          8'b0010_1100: begin led_R_0_Content = four; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero  ; end
          8'b0010_1101: begin led_R_0_Content = five; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero  ; end
          8'b0010_1110: begin led_R_0_Content = six; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero   ; end
          8'b0010_1111: begin led_R_0_Content = seven; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0011_0000: begin led_R_0_Content = eight; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero ;  end
          8'b0011_0001: begin led_R_0_Content = nine; led_R_1_Content = four; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          8'b0011_0010: begin led_R_0_Content = zero; led_R_1_Content = five; led_R_2_Content = zero; led_R_3_Content = zero  ;  end
          default: begin led_R_0_Content = zero; led_R_1_Content = zero; led_R_2_Content = zero; led_R_3_Content = zero       ;   end
          endcase
      end
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

      default: begin
        led_R_0_Content = one;
        led_R_1_Content = one;
        led_R_2_Content = one;
        led_R_3_Content = one;
        led_L_0_Content = one;
        led_L_1_Content = one;
        led_L_2_Content = one;
        led_L_3_Content = one;
      end


//------------------------------end-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    endcase
  end
endmodule
