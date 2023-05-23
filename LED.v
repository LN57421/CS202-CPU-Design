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
    input clk_2ms,  //????
    input [3:0] modeSelect,  //????
    input [31:0] AluResult0,  //????0
    input [31:0] AluResult1,  //????1


    output [7:0] led_select,  //????Led???????????????
    output [7:0] signal_display,  //???????
    output [23:0] led_display    //led????
);
  //-------????--------------------------------------------------------
  parameter zero = 8'b1100_0000; //????????0??????????????????A-P??
  parameter one  = 8'b1111_1001; //????????1??????????????????A-P??
  parameter two  = 8'b1010_0100; //????????2??????????????????A-P??
  parameter three= 8'b1011_0000; //????????3??????????????????A-P??
  parameter four = 8'b1001_1001; //????????4??????????????????A-P??
  parameter five = 8'b1001_0010; //????????5??????????????????A-P??
  parameter six  = 8'b1000_0010; //????????6??????????????????A-P??
  parameter seven= 8'b1111_1000; //????????7??????????????????A-P??
  parameter eight= 8'b1000_0000; //????????8??????????????????A-P??
  parameter nine = 8'b1001_0000; //????????9??????????????????A-P??
  parameter point= 8'b0111_1111; //????????.??????????????????A-P??
  parameter dim = 8'b1111_1111;  //?????????,?????????????????A-P??
  //--------????-Part1-------------------------------------------------
  reg [7:0] signal_display_tmp;  //??????
  reg [7:0] led_select_tmp;  //??????????
  reg [23:0] led_display_tmp;  //??????

  //--------????-Part2-------------------------------------------------
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
            led_display_tmp = 24'b0000_0000_1111_1111_0000_0000;
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          8'b0000_0001: begin
            led_display_tmp = 24'b1111_1111_0000_0000_0000_0000;
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
      4'b 0001:begin
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
            led_display_tmp = 24'b0000_0000_1111_1111_0000_0000;
            led_R_0_Content = dim;
            led_R_1_Content = dim;
            led_R_2_Content = dim;
            led_R_3_Content = dim;
          end
          8'b0000_0001: begin
            led_display_tmp = 24'b1111_1111_0000_0000_0000_0000;
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
