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


    output [7:0] led_select,  //选择亮的Led灯，低电平的为亮的灯，表示�?�择
    output [7:0] signal_display  //亮灯的内容信�?
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
  parameter dim = 8'b1111_1111;  //使七段数码管不显�?,从低比特位到高比特位，从低到高控制A-P引脚
  //--------中间变量-Part1-------------------------------------------------
  reg [7:0] signal_display_tmp;  //左边显示内容
  reg [7:0] led_select_tmp;  //右边选择亮的某一个灯

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
        default: signal_display_tmp = eight;
      endcase
    end
  end


  always @(*) begin
    casex (modeSelect)
      4'b0000: begin
        casex (AluResult0[7:0])
          8'b0000_0000: led_L_0_Content = zero;
          8'b0000_0001: led_L_0_Content = one;
          8'b0000_0010: led_L_0_Content = two;
          8'b0000_0011: led_L_0_Content = three;
          8'b0000_0100: led_L_0_Content = four;
          8'b0000_0101: led_L_0_Content = five;
          8'b0000_0110: led_L_0_Content = six;
          8'b0000_0111: led_L_0_Content = seven;
          8'b0000_1000: led_L_0_Content = eight;
          8'b0000_1001: led_L_0_Content = nine;
          default: led_L_0_Content = point;
        endcase
        casex (AluResult0[15:8])
          8'b0000_0000: led_L_1_Content = zero;
          8'b0000_0001: led_L_1_Content = one;
          8'b0000_0010: led_L_1_Content = two;
          8'b0000_0011: led_L_1_Content = three;
          8'b0000_0100: led_L_1_Content = four;
          8'b0000_0101: led_L_1_Content = five;
          8'b0000_0110: led_L_1_Content = six;
          8'b0000_0111: led_L_1_Content = seven;
          8'b0000_1000: led_L_1_Content = eight;
          8'b0000_1001: led_L_1_Content = nine;
          default: led_L_1_Content = point;
        endcase
        casex (AluResult0[23:16])
          8'b0000_0000: led_L_2_Content = zero;
          8'b0000_0001: led_L_2_Content = one;
          8'b0000_0010: led_L_2_Content = two;
          8'b0000_0011: led_L_2_Content = three;
          8'b0000_0100: led_L_2_Content = four;
          8'b0000_0101: led_L_2_Content = five;
          8'b0000_0110: led_L_2_Content = six;
          8'b0000_0111: led_L_2_Content = seven;
          8'b0000_1000: led_L_2_Content = eight;
          8'b0000_1001: led_L_2_Content = nine;
          default: led_L_2_Content = point;
        endcase
        casex (AluResult0[31:24])
          8'b0000_0000: led_L_3_Content = zero;
          8'b0000_0001: led_L_3_Content = one;
          8'b0000_0010: led_L_3_Content = two;
          8'b0000_0011: led_L_3_Content = three;
          8'b0000_0100: led_L_3_Content = four;
          8'b0000_0101: led_L_3_Content = five;
          8'b0000_0110: led_L_3_Content = six;
          8'b0000_0111: led_L_3_Content = seven;
          8'b0000_1000: led_L_3_Content = eight;
          8'b0000_1001: led_L_3_Content = nine;
          default: led_L_2_Content = point;
        endcase
        casex (AluResult1[7:0])
          8'b0000_0000: begin
            led_R_0_Content = zero;
            led_R_1_Content = zero;
            led_R_2_Content = zero;
            led_R_3_Content = zero;
          end
          8'b0000_0001: begin
            led_R_0_Content = one;
            led_R_1_Content = zero;
            led_R_2_Content = zero;
            led_R_3_Content = zero;
          end
          default: begin
            led_R_0_Content = point;
            led_R_1_Content = point;
            led_R_2_Content = point;
            led_R_3_Content = point;
          end
        endcase
      end
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
    endcase
  end
endmodule
