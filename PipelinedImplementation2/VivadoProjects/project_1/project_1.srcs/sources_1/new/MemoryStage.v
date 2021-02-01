`timescale 1ns/1ps

module MemoryStage
                #
                (
                    parameter DATA_MEMFILE="/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/DataMemory.mem",
                    parameter DATA_DEPTH=100
                )
                (
                    input wire clk,
                    input wire rst,
                    input wire Branch_from_EX_MEM,
                    input wire MemRead_from_EX_MEM,
                    input wire MemWrite_from_EX_MEM,
                    input wire isZero_from_EX_MEM,
                    input wire [32-1:0]ALUResultsOut_from_EX_MEM,
                    input wire [32-1:0]RFReadData2_from_EX_MEM,

                    output wire PCSrc_to_IF,
                    output wire [32-1:0]DMReadData_to_MEM_WB,
                    output wire [32-1:0]ALUResultsOut_to_MEM_WB
                );

and(PCSrc_to_IF, Branch_from_EX_MEM, isZero_from_EX_MEM);

DataMemory 
                #
                (                 
                    .DATA_MEMFILE(DATA_MEMFILE),
                    .DEPTH(DATA_DEPTH)
                )
                Data_Memory_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .address(ALUResultsOut_from_EX_MEM>>2), // because of 4 bytes
                    .writeData(RFReadData2_from_EX_MEM),
                    .readData(DMReadData_to_MEM_WB),
                    .MemRead(MemRead_from_EX_MEM),
                    .MemWrite(MemWrite_from_EX_MEM)
                );


assign ALUResultsOut_to_MEM_WB =  ALUResultsOut_from_EX_MEM;

endmodule