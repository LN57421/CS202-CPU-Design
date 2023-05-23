`timescale 1ns / 1ps

module MemOrIO(
    mRead, 
    mWrite, 
    ioRead, 
    ioWrite,
    addr_in, 
    addr_out, 
    
    m_rdata, //
    io_rdata, //
    r_wdata, //
    r_rdata, //
    m_wdata, //

    LEDCtrl, 
    SwitchCtrl);
//读写信号
input mRead; // 控制器发出读内存指令
input mWrite; // 控制器发出写内存指令
input ioRead; // 是否进行IO读
input ioWrite; // 是否进行IO写
//地址
input[31:0] addr_in; // ALU计算得到的取数memory位置
output[31:0] addr_out; // 传输到Memory里的地址
//数据
input[31:0] m_rdata; // 从memory里读到的数据
input[15:0] io_rdata; // 从拨码开关读进来的数据
input[31:0] r_rdata; // 从decode里读到的数据
output reg[31:0] m_wdata; // 送进IO或mem的数据
output reg [31:0] r_wdata; // 输入到decode里的数据
//控制
output LEDCtrl; // LED控制
output SwitchCtrl; // 开关控制

assign addr_out = addr_in;
assign LEDCtrl = ioWrite;
assign SwitchCtrl = ioRead;

always @(*) begin
    if((mWrite==1'b1)||(ioWrite==1'b1))
        if (ioWrite) begin
            m_wdata = {16'h0000, r_rdata[15:0]};
        end
        else begin
            m_wdata = r_rdata;
        end
    else
        m_wdata = 32'hZZZZZZZZ;
end

always @(*) begin
    if ((mRead == 1'b1) || (ioRead == 1'b1)) begin
        if (ioRead == 1'b1) begin
            r_wdata = {16'h0000, io_rdata};
        end
        else begin
            r_wdata = m_rdata;
        end
    end
    else
        r_wdata = 32'hZZZZZZZZ;
end



endmodule
