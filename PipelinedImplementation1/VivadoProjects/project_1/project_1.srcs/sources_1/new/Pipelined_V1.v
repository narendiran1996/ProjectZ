`timescale 1ns / 1ps


module Pipelined_V1#
                (
                parameter INSTRUCTION_DEPTH = 13
                )
                (
                    input wire clk,
                    input wire rst
                );

wire RegDst, RegWrite, ALUSrc, MemRead, MemWrite, MemtoReg, Branch, Jump;
wire isZero;

wire [1:0]ALUOp;
wire [6-1:0]OpCode;

CompleteDataPath
                #
                (
                    .INSTRUCTION_MEMFILE("/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/InstructionMemory.mem"),
                    .INSTRUCTION_DEPTH(INSTRUCTION_DEPTH),
                    .DATA_MEMFILE("/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/DataMemory.mem"),
                    .DATA_DEPTH(100)
                )
                CDP
                (
                    clk,
                    rst,

                    RegDst,
                    RegWrite,
                    ALUOp,
                    ALUSrc,
                    MemRead,
                    MemWrite,
                    MemtoReg,
                    Branch,
                    Jump,
//                    updatePC,
                    OpCode,
                    

                    isZero
                );


ControlUnit CU
                (
                    clk,
                    rst,
                    OpCode,
                    RegDst,
                    MemRead,
                    MemtoReg,
                    ALUOp,
                    MemWrite,
                    ALUSrc,
                    RegWrite,
                    Branch,
                    Jump
                );
endmodule
