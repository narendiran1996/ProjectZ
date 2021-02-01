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
                    output wire [32-1:0]ALUSource2_to_EX_MEM,
                    output wire [5-1:0]RFWriteRegister_to_EX_MEM,


                    input wire [1:0]ForwardA,
                    input wire [1:0]ForwardB,

                    input wire [32-1:0]ALUResultsOut_from_EX_MEM,
                    input wire [32-1:0]RFWriteData_to_ID,
                    input wire [32-1:0]WriteBackDataValuetoRF // added for data hazard in third insturction of dependecny
                );

wire [4-1:0]ALUoperations;
ALUcontrol ALU_control_Ins
                (
                    .Funct(SEIntermediateValue_from_ID_EX[5:0]), // see diagram
                    .AluOp(ALUOp_from_ID_EX),
                    .ALUoperations(ALUoperations)
                );


wire [32-1:0]ALUSource1;
wire [32-1:0]ALUSource2;

MuxFOURxONE32bit ALUselectionSRC1
                (
                    .inp1(RFReadData1_from_ID_EX),
                    .inp2(RFWriteData_to_ID),
                    .inp3(ALUResultsOut_from_EX_MEM),
                    .inp4(WriteBackDataValuetoRF),
                    .selectionLine(ForwardA),
                    .outp(ALUSource1)
                );

MuxFOURxONE32bit ALUselectionSRC2
                (
                    .inp1(RFReadData2_from_ID_EX),
                    .inp2(RFWriteData_to_ID),
                    .inp3(ALUResultsOut_from_EX_MEM),
                    .inp4(WriteBackDataValuetoRF),
                    .selectionLine(ForwardB),
                    .outp(ALUSource2)
                );



wire [32-1:0]interSource2;
MuxTWOxONE32bit ALU_Inter_MUX_Ins
                (
                    .inp1(ALUSource2),
                    .inp2(SEIntermediateValue_from_ID_EX),
                    .selectionLine(ALUSrc_from_ID_EX),
                    .outp(interSource2)
                );




ArithmeticLogicUnit ALU_Ins
                (
                    .operend1(ALUSource1),
                    .operend2(interSource2),
                    .ALUoperations(ALUoperations),
                    .resultOut(ALUResultsOut_to_EX_MEM),
                    .isZero(isZero_to_EX_MEM)
                );


assign RFWriteRegister_to_EX_MEM = (RegDst_from_ID_EX == 0) ? CI20_16_from_ID_EX : CI15_11_from_ID_EX;


assign newPCfromBranching_to_EX_MEM = PCadded4_from_ID_EX + (SEIntermediateValue_from_ID_EX<<2);

assign ALUSource2_to_EX_MEM = ALUSource2;

endmodule