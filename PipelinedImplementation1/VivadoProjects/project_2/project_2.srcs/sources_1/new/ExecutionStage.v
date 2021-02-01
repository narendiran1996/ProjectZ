`timescale 1ns / 1ps

module ExecutionStage
                (
                    input wire clk,
                    input wire rst,
                    input wire RegDst_from_ID_EX,
                    input wire [1:0]ALUOp_from_ID_EX,
                    input wire ALUSrc_from_ID_EX,
                    input wire [32-1:0]PCadded4_from_ID_EX,
                    input wire [32-1:0]RFReadData1_from_ID_EX,
                    input wire [32-1:0]RFReadData2_from_ID_EX,
                    input wire [32-1:0]SEIntermediateValue_from_ID_EX,
                    input wire [5-1:0]CI15_11_from_ID_EX,
                    input wire [5-1:0]CI20_16_from_ID_EX,

                    output wire [32-1:0]newPCfromBranching_to_EX_MEM,
                    output wire isZero_to_EX_MEM,
                    output wire [32-1:0]ALUResultsOut_to_EX_MEM,
                    output wire [32-1:0]RFReadData2_to_EX_MEM,
                    output wire [5-1:0]RFWriteRegister_to_EX_MEM
                );

wire [4-1:0]ALUoperations;
ALUcontrol ALU_control_Ins
                (
                    .Funct(SEIntermediateValue_from_ID_EX[5:0]), // see diagram
                    .AluOp(ALUOp_from_ID_EX),
                    .ALUoperations(ALUoperations)
                );

wire [32-1:0]ALUSource2;
MuxTWOxONE32bit ALU_SRC2_MUX_Ins
                (
                    .inp1(RFReadData2_from_ID_EX),
                    .inp2(SEIntermediateValue_from_ID_EX),
                    .selectionLine(ALUSrc_from_ID_EX),
                    .outp(ALUSource2)
                );


ArithmeticLogicUnit ALU_Ins
                (
                    .operend1(RFReadData1_from_ID_EX),
                    .operend2(ALUSource2),
                    .ALUoperations(ALUoperations),
                    .resultOut(ALUResultsOut_to_EX_MEM),
                    .isZero(isZero_to_EX_MEM)
                );


assign RFWriteRegister_to_EX_MEM = (RegDst_from_ID_EX == 0) ? CI20_16_from_ID_EX : CI15_11_from_ID_EX;


assign newPCfromBranching_to_EX_MEM = PCadded4_from_ID_EX + (SEIntermediateValue_from_ID_EX<<2);


assign RFReadData2_to_EX_MEM = RFReadData2_from_ID_EX;

endmodule