`timescale 1ns / 1ps

module InstructionDecodeStage
                (
                    input wire clk,
                    input wire rst,
                    input wire RegWrite_from_MEM_WB,
                    input wire [32-1:0]currentInstruction_from_IF_ID,

                    output wire [6-1:0]OpCode_to_Controller,
                    output wire [32-1:0]RFReadData1_to_ID_EX,
                    output wire [32-1:0]RFReadData2_to_ID_EX,
                    output wire [32-1:0]SEIntermediateValue_to_ID_EX,
                    output wire [5-1:0]CI15_11_to_ID_EX,
                    output wire [5-1:0]CI20_16_to_ID_EX,
                    output wire [5-1:0]CI25_21_to_ID_EX,

                    input wire [5-1:0]RFWriteRegister_from_MEM_WB,
                    input wire [32-1:0]RFWriteData_from_WB
                );


assign OpCode_to_Controller = currentInstruction_from_IF_ID[31:26];


RegisterFile Registers_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .readRegister1(currentInstruction_from_IF_ID[25:21]),
                    .readRegister2(currentInstruction_from_IF_ID[20:16]),
                    .readData1(RFReadData1_to_ID_EX),
                    .readData2(RFReadData2_to_ID_EX),
                    .writeRegister(RFWriteRegister_from_MEM_WB),
                    .RegWrite(RegWrite_from_MEM_WB),
                    .writeData(RFWriteData_from_WB)                    
                );


SignExtender Signextend_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .inp(currentInstruction_from_IF_ID[15:0]),
                    .outp(SEIntermediateValue_to_ID_EX)
                );


assign CI20_16_to_ID_EX =  currentInstruction_from_IF_ID[20:16];
assign CI15_11_to_ID_EX = currentInstruction_from_IF_ID[15:11];
assign CI25_21_to_ID_EX = currentInstruction_from_IF_ID[25:21];


endmodule