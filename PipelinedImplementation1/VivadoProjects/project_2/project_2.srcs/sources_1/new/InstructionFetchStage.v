`timescale 1ns / 1ps

module InstructionFetchStage
                 #
                (
                    parameter INSTRUCTION_MEMFILE="/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/InstructionMemory.mem",
                    parameter INSTRUCTION_DEPTH=10
                )
                (
                    input wire clk,
                    input wire rst,
                    input wire PCSrc_from_MEM,
                    input wire [32-1:0]newPCfromBranching_from_EX_MEM,
                    output wire [32-1:0]PCadded4_to_IF_ID,
                    output wire [32-1:0]currentInstruction_to_IF_ID,

                    output wire [32-1:0]currentPC_from_IF_ID
                );

wire [32-1:0]currentPC, newPC;
assign currentPC_from_IF_ID = currentPC;
MuxTWOxONE32bit MUX_PC_selection_INS
                (
                    .inp1(PCadded4_to_IF_ID),
                    .inp2(newPCfromBranching_from_EX_MEM),
                    .selectionLine(PCSrc_from_MEM),
                    .outp(newPC)
                );


PCRegister PC_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newPC(newPC),
                    .currentPC(currentPC)
                );


Add4ForPC PC4_ADDED_Ins
                (
                    .currentPC(currentPC),
                    .PCadded4(PCadded4_to_IF_ID)
                );


InstructionMemory
                #
                (                 
                    .INSTRUCTION_MEMFILE(INSTRUCTION_MEMFILE),
                    .DEPTH(INSTRUCTION_DEPTH)   
                )
                Instruction_Memory_Ins                
                (
                    .clk(clk),
                    .rst(rst),
                    .readAddress(currentPC>>2),
                    .instructionData(currentInstruction_to_IF_ID)
                );


endmodule
