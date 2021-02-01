`timescale 1ns / 1ps

module MEM_WBRegs
                (
                    input wire clk,
                    input wire rst,

                    input wire [32-1:0]DMReadData_from_MEM,
                    input wire [32-1:0]ALUResultsOut_Regs_from_MEM,
                    input wire [5-1:0]RFWriteRegister_Regs_from_EX_MEM,

                    input wire RegWrite_Regs_from_MEM,
                    input wire MemtoReg_Regs_from_MEM,

                    output wire [32-1:0]DMReadData_to_WB,
                    output reg [32-1:0]ALUResultsOut_Regs_to_WB,
                    output reg [5-1:0]RFWriteRegister_Regs_to_ID,

                    output reg RegWrite_Regs_to_ID,
                    output reg MemtoReg_Regs_to_WB,
                    output wire [5-1:0]Rd_MEM_WB,
                    output wire  RegWrite_MEM_WB
                );


assign DMReadData_to_WB = DMReadData_from_MEM;

always@(posedge clk)
    begin
        if(rst == 1)
            begin
                ALUResultsOut_Regs_to_WB <= 0;
                RFWriteRegister_Regs_to_ID <= 0;
                RegWrite_Regs_to_ID <= 0;
                MemtoReg_Regs_to_WB <= 0;
            end 
        else
            begin
                ALUResultsOut_Regs_to_WB <= ALUResultsOut_Regs_from_MEM;
                RFWriteRegister_Regs_to_ID <= RFWriteRegister_Regs_from_EX_MEM;
                RegWrite_Regs_to_ID <= RegWrite_Regs_from_MEM;
                MemtoReg_Regs_to_WB <= MemtoReg_Regs_from_MEM;
            end
    end


assign Rd_MEM_WB = RFWriteRegister_Regs_to_ID;
assign RegWrite_MEM_WB = RegWrite_Regs_to_ID;
endmodule