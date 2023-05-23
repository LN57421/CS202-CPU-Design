`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//???????????
//////////////////////////////////////////////////////////////////////////////////


module TimeDivider (
    clk,
    reset,
    clk_out_2ms,
    clk_out_1s,
    clk_out_500us
);
  input wire clk;
  input wire reset;
  output reg clk_out_2ms;
  output reg clk_out_1s;
  output reg clk_out_500us;

  parameter period_500us = 50;
  parameter period_2ms = 200;
  parameter period_1s = 1_00;

  reg [21:0] cnt_20ms;
  reg [28:0] cnt_1s;
  reg [28:0] cnt_500us;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      cnt_1s <= 0;
      cnt_20ms <= 0;
      cnt_500us <= 0;
      clk_out_1s <= 0;
      clk_out_2ms <= 0;
      clk_out_500us <= 0;
    end else begin
      if (cnt_20ms == (period_2ms >> 1) - 1) begin
        clk_out_2ms <= ~clk_out_2ms;
        cnt_20ms    <= 0;
      end else begin
        cnt_20ms <= cnt_20ms + 1;
      end

      if (cnt_1s == (period_1s >> 1) - 1) begin
        clk_out_1s <= ~clk_out_1s;
        cnt_1s     <= 0;
      end else begin
        cnt_1s <= cnt_1s + 1;
      end

      if (cnt_500us == (period_500us >> 1) - 1) begin
        clk_out_500us <= ~clk_out_500us;
        cnt_500us     <= 0;
      end else begin
        cnt_500us <= cnt_500us + 1;
      end
    end
  end

endmodule
