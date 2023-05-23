`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 15:40:26
// Design Name: 
// Module Name: Led
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


module TestOutput(clk, rst, LEDCtrl, ALU_addr, LEDData, LEDOutput);
input clk;
input rst;
input LEDCtrl;
input [7:0]ALU_addr;
input [15:0] LEDData;
output reg [23:0] LEDOutput;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        LEDOutput <= 24'h0;
    end
    else begin
        if (LEDCtrl) begin //将LED分成三组
            if (ALU_addr == 8'h60) begin
                LEDOutput <= {LEDOutput[23:8], LEDData[3:0],4'b0000};
            end
            else if(ALU_addr == 8'h64) begin
                LEDOutput <= {LEDOutput[23:16], LEDData[7:0], LEDOutput[7:0]};
            end
            else if(ALU_addr == 8'h68) begin
                LEDOutput <= {LEDData[7:0], LEDOutput[15:0]};
            end
        end
    end
end

endmodule
