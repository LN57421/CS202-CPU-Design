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
//��д�ź�
input mRead; // �������������ڴ�ָ��
input mWrite; // ����������д�ڴ�ָ��
input ioRead; // �Ƿ����IO��
input ioWrite; // �Ƿ����IOд
//��ַ
input[31:0] addr_in; // ALU����õ���ȡ��memoryλ��
output[31:0] addr_out; // ���䵽Memory��ĵ�ַ
//����
input[31:0] m_rdata; // ��memory�����������
input[15:0] io_rdata; // �Ӳ��뿪�ض�����������
input[31:0] r_rdata; // ��decode�����������
output reg[31:0] m_wdata; // �ͽ�IO��mem������
output reg [31:0] r_wdata; // ���뵽decode�������
//����
output LEDCtrl; // LED����
output SwitchCtrl; // ���ؿ���

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
