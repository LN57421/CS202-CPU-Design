`timescale 1ns / 1ps

module In(
    clk, 
    rst, 
    SwitchCtrl, 
    SwitchInput, 
    ALU_addr, 
    SwitchData);

input clk;
input rst;
input SwitchCtrl; 
input [23:0] SwitchInput; 
input[7:0] ALU_addr; 
output[15:0] SwitchData; 


reg [15:0] SwitchData_reg;
assign SwitchData = SwitchData_reg;

always @(negedge clk or posedge rst) begin
    if (rst) begin
        SwitchData_reg <= 16'h0000;
    end
    else begin
        if (SwitchCtrl) begin
            if (ALU_addr == 8'h70) begin
                SwitchData_reg <= {12'h000 ,SwitchInput[3:0]};
            end
            else if(ALU_addr == 8'h78) begin
                SwitchData_reg <= {8'h00 ,SwitchInput[11:4]};
            end
            else if (ALU_addr == 8'h74) begin
                SwitchData_reg <= {8'h00, SwitchInput[19:12]};
            end
            else if (ALU_addr == 8'h7C) begin
                SwitchData_reg <= {15'b0000_0000_0000_000, SwitchInput[20:20]};
            end
            else
                SwitchData_reg <=  16'h0000;
    end    
    end

end
    
endmodule
