// FIGURE 4.56 The datapath modifi ed to resolve hazards via forwarding.
// FIGURE 4.57 A close-up of the datapath in Figure 4.54 shows a 2:1 multiplexor, which has been added to select the
//signed immediate as an ALU input.
module MIPS_ProcesserV2
                #
                (
                parameter INSTRUCTION_DEPTH = 10
                )
                (
                    input wire clk,
                    input wire rst
                );

wire [6-1:0]OpCode_to_Controller;

wire RegDst_Regs_from_controller;
wire [1:0]ALUOp_Regs_from_controller;
wire ALUSrc_Regs_from_controller;

wire Branch_Regs_from_controller;
wire MemRead_Regs_from_controller;
wire MemWrite_Regs_from_controller;

wire MemtoReg_Regs_from_controller;
wire RegWrite_Regs_fromController;

wire Jump;

PipilinedStageDataPathConnection
                #
                (
                    .INSTRUCTION_MEMFILE("/home/narendiran/Desktop/ProjectZ/PipelinedImplementation2/MemFiles/InstructionMemory.mem"),
                    .INSTRUCTION_DEPTH(INSTRUCTION_DEPTH),
                    .DATA_MEMFILE("/home/narendiran/Desktop/ProjectZ/PipelinedImplementation2/MemFiles/DataMemory.mem"),
                    .DATA_DEPTH(100)
                )
                V2PiplinedIns
                (
                    clk,
                    rst,
                    OpCode_to_Controller,

                    RegDst_Regs_from_controller,
                    ALUOp_Regs_from_controller,
                    ALUSrc_Regs_from_controller,

                    Branch_Regs_from_controller,
                    MemRead_Regs_from_controller,
                    MemWrite_Regs_from_controller,

                    MemtoReg_Regs_from_controller,
                    RegWrite_Regs_fromController
                );


ControlUnit CUins
                (
                    rst,
                    OpCode_to_Controller,
                    RegDst_Regs_from_controller,
                    MemRead_Regs_from_controller,
                    MemtoReg_Regs_from_controller,
                    ALUOp_Regs_from_controller,
                    MemWrite_Regs_from_controller,
                    ALUSrc_Regs_from_controller,
                    RegWrite_Regs_fromController,
                    Branch_Regs_from_controller,
                    Jump
                );

endmodule