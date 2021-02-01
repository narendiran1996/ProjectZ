`timescale 1ns / 1ps

module EX_MEMRegs
            (
                input wire clk,
                input wire rst,

                input wire [32-1:0]newPCfromBranching_Regs_from_EX,
                input wire isZero_Regs_from_EX,
                input wire [32-1:0]ALUResultsOut_Regs_from_EX,
                input wire [32-1:0]RFReadData2_Regs_from_EX,
                input wire [5-1:0]RFWriteRegister_Regs_from_EX,

                input wire Branch_Regs_from_ID_EX,
                input wire MemRead_Regs_from_ID_EX,
                input wire MemWrite_Regs_from_ID_EX,

                input wire MemtoReg_Regs_from_ID_EX,
                input wire  RegWrite_Regs_from_ID_EX,



                output reg [32-1:0]newPCfromBranching_Regs_to_IF,
                output reg [32-1:0]ALUResultsOut_Regs_to_MEM,
                output reg [32-1:0]RFReadData2_Regs_to_MEM,
                output reg [5-1:0]RFWriteRegister_Regs_to_MEM_WB,
                output reg isZero_Regs_to_MEM,

                output reg Branch_Regs_to_MEM,
                output reg MemRead_Regs_to_MEM,
                output reg MemWrite_Regs_to_MEM,

                output reg MemtoReg_Regs_to_MEM,
                output reg RegWrite_Regs_to_MEM
        );



always@(posedge clk)
    begin
        if(rst == 1)
            begin
                newPCfromBranching_Regs_to_IF <= 0;
                isZero_Regs_to_MEM <= 0;
                ALUResultsOut_Regs_to_MEM <= 0;
                RFReadData2_Regs_to_MEM <=  0;
                RFWriteRegister_Regs_to_MEM_WB <= 0;
                {Branch_Regs_to_MEM, MemRead_Regs_to_MEM, MemWrite_Regs_to_MEM, MemtoReg_Regs_to_MEM, RegWrite_Regs_to_MEM} <= 0;
            end
        else
            begin
                newPCfromBranching_Regs_to_IF <= newPCfromBranching_Regs_from_EX;
                isZero_Regs_to_MEM <= isZero_Regs_from_EX;
                ALUResultsOut_Regs_to_MEM <= ALUResultsOut_Regs_from_EX;
                RFReadData2_Regs_to_MEM <=  RFReadData2_Regs_from_EX;
                RFWriteRegister_Regs_to_MEM_WB <= RFWriteRegister_Regs_from_EX;
                {Branch_Regs_to_MEM, MemRead_Regs_to_MEM, MemWrite_Regs_to_MEM, MemtoReg_Regs_to_MEM, RegWrite_Regs_to_MEM} <= {Branch_Regs_from_ID_EX, MemRead_Regs_from_ID_EX, MemWrite_Regs_from_ID_EX, MemtoReg_Regs_from_ID_EX, RegWrite_Regs_from_ID_EX};
            end
    end



endmodule