`timescale 1ns / 1ps

module Out(
    clk, 
    rst, 
    LEDCtrl,
    ALU_addr, 
    OutData, 
    modeSelect, 
    AluResult0, 
    AluResult1);
input clk;
input rst;
input LEDCtrl;
input [7:0]ALU_addr;
input [15:0] OutData;

output [3:0] modeSelect;
output [31:0] AluResult0;
output [31:0] AluResult1;


reg [3:0] modeSelect_reg;
reg [31:0] AluResult0_reg;
reg [31:0] AluResult1_reg;

assign modeSelect = modeSelect_reg;
assign AluResult0 = AluResult0_reg;
assign AluResult1 = AluResult1_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        modeSelect_reg <= 0;
        AluResult0_reg <= 0;
        AluResult1_reg <= 0;
    end
    else begin
        if (LEDCtrl) begin 
            if (ALU_addr == 8'h60) begin
               modeSelect_reg <= OutData[3:0];
            end
            else if(ALU_addr == 8'h64) begin
                AluResult0_reg <= {24'h000000, OutData[7:0]};
            end
            else if(ALU_addr == 8'h68) begin
                AluResult1_reg <= {24'h000000, OutData[7:0]};
            end
        end
    end
end

endmodule
