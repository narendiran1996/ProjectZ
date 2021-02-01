`timescale 1ns / 1ps

module ID_EXRegs
                (
                    input wire clk,
                    input wire rst,

                    input wire RegDst_Regs_from_controller,
                    input wire [1:0]ALUOp_Regs_from_controller,
                    input wire ALUSrc_Regs_from_controller,

                    input wire Branch_Regs_from_controller,
                    input wire MemRead_Regs_from_controller,
                    input wire MemWrite_Regs_from_controller,

                    input wire MemtoReg_Regs_from_controller,
                    input wire RegWrite_Regs_fromController,



                    input wire [32-1:0]PCadded4_Regs_from_IF_ID,
                    input wire [32-1:0]RFReadData1_from_ID,
                    input wire [32-1:0]RFReadData2_from_ID,
                    input wire [32-1:0]SEIntermediateValue_from_ID,
                    input wire [5-1:0]CI15_11_Regs_from_ID,
                    input wire [5-1:0]CI20_16_Regs_from_ID,
                    



                    output reg RegDst_Regs_to_EX,
                    output reg [1:0]ALUOp_Regs_to_EX,
                    output reg ALUSrc_Regs_to_EX,

                    output reg Branch_Regs_to_EX_MEM,
                    output reg MemRead_Regs_to_EX_MEM,
                    output reg MemWrite_Regs_to_EX_MEM,

                    output reg MemtoReg_Regs_to_EX_MEM,
                    output reg RegWrite_Regs_to_EX_MEM,

                    output reg [32-1:0]PCadded4_Regs_to_EX,
                    output wire [32-1:0]RFReadData1_to_EX,
                    output wire [32-1:0]RFReadData2_to_EX,
                    output wire [32-1:0]SEIntermediateValue_to_EX,
                    output reg [5-1:0]CI15_11_Regs_to_EX,
                    output reg [5-1:0]CI20_16_Regs_to_EX

                );




always@(posedge clk)
    begin
        if(rst == 1)
            begin
                PCadded4_Regs_to_EX <= 0;
                CI15_11_Regs_to_EX <= 0;
                CI20_16_Regs_to_EX <= 0;
                {RegDst_Regs_to_EX, ALUOp_Regs_to_EX, ALUSrc_Regs_to_EX, Branch_Regs_to_EX_MEM, MemRead_Regs_to_EX_MEM, MemWrite_Regs_to_EX_MEM, MemtoReg_Regs_to_EX_MEM, RegWrite_Regs_to_EX_MEM} <= 0;
            end 
        else
            begin
                PCadded4_Regs_to_EX <= PCadded4_Regs_from_IF_ID;
                CI15_11_Regs_to_EX <= CI15_11_Regs_from_ID;
                CI20_16_Regs_to_EX <= CI20_16_Regs_from_ID;
                {RegDst_Regs_to_EX, ALUOp_Regs_to_EX, ALUSrc_Regs_to_EX, Branch_Regs_to_EX_MEM, MemRead_Regs_to_EX_MEM, MemWrite_Regs_to_EX_MEM, MemtoReg_Regs_to_EX_MEM, RegWrite_Regs_to_EX_MEM} <= {RegDst_Regs_from_controller, ALUOp_Regs_from_controller, ALUSrc_Regs_from_controller, Branch_Regs_from_controller, MemRead_Regs_from_controller, MemWrite_Regs_from_controller, MemtoReg_Regs_from_controller, RegWrite_Regs_fromController};
            end
    end

assign RFReadData1_to_EX = RFReadData1_from_ID;
assign RFReadData2_to_EX = RFReadData2_from_ID;
assign SEIntermediateValue_to_EX = SEIntermediateValue_from_ID;

endmodule