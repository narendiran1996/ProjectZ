`timescale 1ns / 1ps

module PipilinedStageDataPathConnection
                #
                (
                    parameter INSTRUCTION_MEMFILE="/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/InstructionMemory.mem",
                    parameter INSTRUCTION_DEPTH=10,
                    parameter DATA_MEMFILE="/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/DataMemory.mem",
                    parameter DATA_DEPTH=100
                )
                (
                    input wire clk,
                    input wire rst,
                    output wire [6-1:0]OpCode_to_Controller,

                    input wire RegDst_Regs_from_controller,
                    input wire [1:0]ALUOp_Regs_from_controller,
                    input wire ALUSrc_Regs_from_controller,

                    input wire Branch_Regs_from_controller,
                    input wire MemRead_Regs_from_controller,
                    input wire MemWrite_Regs_from_controller,

                    input wire MemtoReg_Regs_from_controller,
                    input wire RegWrite_Regs_fromController
                );

// forwading
wire [5-1:0]Rs_ID_EX;
wire [5-1:0]Rt_ID_EX;
wire [5-1:0]Rd_ID_EX;

wire [5-1:0]Rd_EX_MEM;

wire  [5-1:0]Rd_MEM_WB;

wire [5-1:0]Rd_WB;


wire RegWrite_EX_MEM, RegWrite_MEM_WB;

wire [1:0]ForwardA;
wire [1:0]ForwardB;

ForwardingUnit FUIns
                (
                    Rs_ID_EX,
                    Rt_ID_EX,
                    Rd_ID_EX,

                    Rd_EX_MEM,

                    Rd_MEM_WB,

                    Rd_WB, //// added for data hazard in third insturction of dependecny

                    RegWrite_EX_MEM,
                    RegWrite_MEM_WB,

                    ForwardA,
                    ForwardB
                );



// Instruction Fetch
wire PCSrc_from_EX_MEM;
wire [32-1:0]newPCfromBranching_from_EX_MEM;
wire [32-1:0]PCadded4_to_IF_ID;
wire [32-1:0]currentInstruction_to_IF_ID;
wire [32-1:0]currentPC_from_IF_ID;
InstructionFetchStage
                 #
                (
                    .INSTRUCTION_MEMFILE(INSTRUCTION_MEMFILE),
                    .INSTRUCTION_DEPTH(INSTRUCTION_DEPTH)
                )
                IFSins
                (
                    clk,
                    rst,
                    PCSrc_from_EX_MEM,
                    newPCfromBranching_from_EX_MEM,
                    PCadded4_to_IF_ID,
                    currentInstruction_to_IF_ID,
                    currentPC_from_IF_ID
                );


wire [32-1:0]PCadded4_Regs_from_IF;
wire [32-1:0]currentInstruction_from_IF;

wire [32-1:0]PCadded4_Regs_to_ID_EX;
wire [32-1:0]currentInstruction_to_ID;

IF_IDRegs IF_IDins
                (
                    clk,
                    rst,
                    PCadded4_Regs_from_IF,
                    currentInstruction_from_IF,

                    PCadded4_Regs_to_ID_EX,
                    currentInstruction_to_ID
                );

assign PCadded4_Regs_from_IF = PCadded4_to_IF_ID;
assign currentInstruction_from_IF = currentInstruction_to_IF_ID;


wire [32-1:0]currentPC;
wire [32-1:0]currentInstruction;
assign currentPC = currentPC_from_IF_ID;
assign currentInstruction = currentInstruction_from_IF;



// Instruction Decode
wire RegWrite_from_MEM_WB;
wire [32-1:0]currentInstruction_from_IF_ID;


wire [32-1:0]RFReadData1_to_ID_EX;
wire [32-1:0]RFReadData2_to_ID_EX;
wire [32-1:0]SEIntermediateValue_to_ID_EX;
wire [5-1:0]CI15_11_to_ID_EX;
wire [5-1:0]CI20_16_to_ID_EX;
wire [5-1:0]CI25_21_to_ID_EX;

wire [5-1:0]RFWriteRegister_from_MEM_WB;
wire [32-1:0]RFWriteData_from_WB;

InstructionDecodeStage IDSins
                (
                    clk,
                    rst,
                    RegWrite_from_MEM_WB,
                    currentInstruction_from_IF_ID,

                    OpCode_to_Controller,
                    RFReadData1_to_ID_EX,
                    RFReadData2_to_ID_EX,
                    SEIntermediateValue_to_ID_EX,
                    CI15_11_to_ID_EX,
                    CI20_16_to_ID_EX,
                    CI25_21_to_ID_EX,

                    RFWriteRegister_from_MEM_WB,
                    RFWriteData_from_WB
                );

assign currentInstruction_from_IF_ID = currentInstruction_to_ID;



wire [32-1:0]PCadded4_Regs_from_IF_ID;
wire [32-1:0]RFReadData1_from_ID;
wire [32-1:0]RFReadData2_from_ID;
wire [32-1:0]SEIntermediateValue_from_ID;
wire [5-1:0]CI15_11_Regs_from_ID;
wire [5-1:0]CI20_16_Regs_from_ID;
wire [5-1:0]CI25_21_Regs_from_ID;


wire RegDst_Regs_to_EX;
wire [1:0]ALUOp_Regs_to_EX;
wire ALUSrc_Regs_to_EX;

wire Branch_Regs_to_EX_MEM;
wire MemRead_Regs_to_EX_MEM;
wire MemWrite_Regs_to_EX_MEM;

wire MemtoReg_Regs_to_EX_MEM;
wire RegWrite_Regs_to_EX_MEM;

wire [32-1:0]PCadded4_Regs_to_EX;
wire [32-1:0]RFReadData1_to_EX;
wire [32-1:0]RFReadData2_to_EX;
wire [32-1:0]SEIntermediateValue_to_EX;
wire [5-1:0]CI15_11_Regs_to_EX;
wire [5-1:0]CI20_16_Regs_to_EX;
wire [5-1:0]CI25_21_Regs_to_EX;


ID_EXRegs ID_EXIns
                (
                    clk,
                    rst,

                    RegDst_Regs_from_controller,
                    ALUOp_Regs_from_controller,
                    ALUSrc_Regs_from_controller,

                    Branch_Regs_from_controller,
                    MemRead_Regs_from_controller,
                    MemWrite_Regs_from_controller,

                    MemtoReg_Regs_from_controller,
                    RegWrite_Regs_fromController,


                    PCadded4_Regs_from_IF_ID,
                    RFReadData1_from_ID,
                    RFReadData2_from_ID,
                    SEIntermediateValue_from_ID,
                    CI15_11_Regs_from_ID,
                    CI20_16_Regs_from_ID, 
                    CI25_21_Regs_from_ID,
                                      

                    RegDst_Regs_to_EX,
                    ALUOp_Regs_to_EX,
                    ALUSrc_Regs_to_EX,

                    Branch_Regs_to_EX_MEM,
                    MemRead_Regs_to_EX_MEM,
                    MemWrite_Regs_to_EX_MEM,

                    MemtoReg_Regs_to_EX_MEM,
                    RegWrite_Regs_to_EX_MEM,

                    PCadded4_Regs_to_EX,
                    RFReadData1_to_EX,
                    RFReadData2_to_EX,
                    SEIntermediateValue_to_EX,
                    CI15_11_Regs_to_EX,
                    CI20_16_Regs_to_EX,
                    Rs_ID_EX,
                    Rt_ID_EX,
                    Rd_ID_EX               
                );


assign PCadded4_Regs_from_IF_ID = PCadded4_Regs_to_ID_EX;
assign RFReadData1_from_ID = RFReadData1_to_ID_EX;
assign RFReadData2_from_ID = RFReadData2_to_ID_EX;
assign SEIntermediateValue_from_ID = SEIntermediateValue_to_ID_EX;
assign CI15_11_Regs_from_ID = CI15_11_to_ID_EX;
assign CI20_16_Regs_from_ID = CI20_16_to_ID_EX;
assign CI25_21_Regs_from_ID = CI25_21_to_ID_EX;


// Execution State
wire RegDst_from_ID_EX;
wire [1:0]ALUOp_from_ID_EX;
wire ALUSrc_from_ID_EX;
wire [32-1:0]PCadded4_from_ID_EX;
wire [32-1:0]RFReadData1_from_ID_EX;
wire [32-1:0]RFReadData2_from_ID_EX;
wire [32-1:0]SEIntermediateValue_from_ID_EX;
wire [5-1:0]CI15_11_from_ID_EX;
wire [5-1:0]CI20_16_from_ID_EX;


wire [32-1:0]newPCfromBranching_to_EX_MEM;
wire isZero_to_EX_MEM;
wire [32-1:0]ALUResultsOut_to_EX_MEM;
wire [32-1:0]ALUSource2_to_EX_MEM;
wire [5-1:0]RFWriteRegister_to_EX_MEM;



ExecutionStage ESins
                (
                    clk,
                    rst,

                    RegDst_from_ID_EX,
                    ALUOp_from_ID_EX,
                    ALUSrc_from_ID_EX,
                    PCadded4_from_ID_EX,
                    RFReadData1_from_ID_EX,
                    RFReadData2_from_ID_EX,
                    SEIntermediateValue_from_ID_EX,
                    CI15_11_from_ID_EX,
                    CI20_16_from_ID_EX,

                    newPCfromBranching_to_EX_MEM,
                    isZero_to_EX_MEM,
                    ALUResultsOut_to_EX_MEM,
                    ALUSource2_to_EX_MEM,
                    RFWriteRegister_to_EX_MEM,


                    ForwardA,
                    ForwardB,

                    ALUResultsOut_from_EX_MEM,
                    RFWriteData_to_ID,
                    WriteBackDataValuetoRF // added for data hazard in third insturction of dependecny
                );

assign RegDst_from_ID_EX = RegDst_Regs_to_EX;
assign ALUOp_from_ID_EX = ALUOp_Regs_to_EX;
assign ALUSrc_from_ID_EX = ALUSrc_Regs_to_EX;
assign PCadded4_from_ID_EX = PCadded4_Regs_to_EX;
assign RFReadData1_from_ID_EX = RFReadData1_to_EX;
assign RFReadData2_from_ID_EX = RFReadData2_to_EX;
assign SEIntermediateValue_from_ID_EX = SEIntermediateValue_to_EX;
assign CI15_11_from_ID_EX = CI15_11_Regs_to_EX;
assign CI20_16_from_ID_EX = CI20_16_Regs_to_EX;


wire [32-1:0]newPCfromBranching_Regs_from_EX;
wire isZero_Regs_from_EX;
wire [32-1:0]ALUResultsOut_Regs_from_EX;
wire [32-1:0]ALUSource2_Regs_from_EX;
wire [5-1:0]RFWriteRegister_Regs_from_EX;

wire Branch_Regs_from_ID_EX;
wire MemRead_Regs_from_ID_EX;
wire MemWrite_Regs_from_ID_EX;

wire MemtoReg_Regs_from_ID_EX;
wire RegWrite_Regs_from_ID_EX;



wire [32-1:0]newPCfromBranching_Regs_to_IF;
wire [32-1:0]ALUResultsOut_Regs_to_MEM;
wire [32-1:0]ALUSource2_Regs_to_MEM;
wire [5-1:0]RFWriteRegister_Regs_to_MEM_WB;
wire isZero_Regs_to_MEM;

wire Branch_Regs_to_MEM;
wire MemRead_Regs_to_MEM;
wire MemWrite_Regs_to_MEM;

wire MemtoReg_Regs_to_MEM;
wire RegWrite_Regs_to_MEM_WB;

EX_MEMRegs EX_MEMins
            (
                clk,
                rst,

                newPCfromBranching_Regs_from_EX,
                isZero_Regs_from_EX,
                ALUResultsOut_Regs_from_EX,
                ALUSource2_Regs_from_EX,
                RFWriteRegister_Regs_from_EX,

                Branch_Regs_from_ID_EX,
                MemRead_Regs_from_ID_EX,
                MemWrite_Regs_from_ID_EX,

                MemtoReg_Regs_from_ID_EX,
                RegWrite_Regs_from_ID_EX,




                newPCfromBranching_Regs_to_IF,
                ALUResultsOut_Regs_to_MEM,
                ALUSource2_Regs_to_MEM,
                RFWriteRegister_Regs_to_MEM_WB,
                isZero_Regs_to_MEM,

                Branch_Regs_to_MEM,
                MemRead_Regs_to_MEM,
                MemWrite_Regs_to_MEM,

                MemtoReg_Regs_to_MEM,
                RegWrite_Regs_to_MEM_WB,

                Rd_EX_MEM,
                RegWrite_EX_MEM
        );

assign newPCfromBranching_Regs_from_EX = newPCfromBranching_to_EX_MEM;
assign isZero_Regs_from_EX = isZero_to_EX_MEM;
assign ALUResultsOut_Regs_from_EX = ALUResultsOut_to_EX_MEM;
assign ALUSource2_Regs_from_EX = ALUSource2_to_EX_MEM;
assign RFWriteRegister_Regs_from_EX = RFWriteRegister_to_EX_MEM;

assign Branch_Regs_from_ID_EX = Branch_Regs_to_EX_MEM;
assign MemRead_Regs_from_ID_EX = MemRead_Regs_to_EX_MEM;
assign MemWrite_Regs_from_ID_EX = MemWrite_Regs_to_EX_MEM;

assign MemtoReg_Regs_from_ID_EX = MemtoReg_Regs_to_EX_MEM;
assign RegWrite_Regs_from_ID_EX = RegWrite_Regs_to_EX_MEM;

assign newPCfromBranching_from_EX_MEM = newPCfromBranching_Regs_to_IF;

// Memory Stage


wire Branch_from_EX_MEM;
wire MemRead_from_EX_MEM;
wire MemWrite_from_EX_MEM;
wire isZero_from_EX_MEM;
wire [32-1:0]ALUResultsOut_from_EX_MEM;
wire [32-1:0]ALUSource2_from_EX_MEM;

wire PCSrc_to_IF_ID;
wire [32-1:0]DMReadData_to_MEM_WB;
wire [32-1:0]ALUResultsOut_to_MEM_WB;

MemoryStage 
                #
                (
                    .DATA_MEMFILE(DATA_MEMFILE),
                    .DATA_DEPTH(DATA_DEPTH)
                )
                MSins
                (
                    clk,
                    rst,
                    Branch_from_EX_MEM,
                    MemRead_from_EX_MEM,
                    MemWrite_from_EX_MEM,
                    isZero_from_EX_MEM,
                    ALUResultsOut_from_EX_MEM,
                    ALUSource2_from_EX_MEM,

                    PCSrc_to_IF_ID,
                    DMReadData_to_MEM_WB,
                    ALUResultsOut_to_MEM_WB
                );


assign Branch_from_EX_MEM = Branch_Regs_to_MEM;
assign MemRead_from_EX_MEM = MemRead_Regs_to_MEM;
assign MemWrite_from_EX_MEM = MemWrite_Regs_to_MEM;
assign isZero_from_EX_MEM = isZero_Regs_to_MEM;
assign ALUResultsOut_from_EX_MEM = ALUResultsOut_Regs_to_MEM;
assign ALUSource2_from_EX_MEM = ALUSource2_Regs_to_MEM;

assign PCSrc_from_EX_MEM  = PCSrc_to_IF_ID;



wire [32-1:0]DMReadData_from_MEM;
wire [32-1:0]ALUResultsOut_Regs_from_MEM;
wire [5-1:0]RFWriteRegister_Regs_from_EX_MEM;

wire RegWrite_Regs_from_EX_MEM;
wire MemtoReg_Regs_from_MEM;

wire [32-1:0]DMReadData_to_WB;
wire [32-1:0]ALUResultsOut_Regs_to_WB;
wire [5-1:0]RFWriteRegister_Regs_to_ID;

wire RegWrite_Regs_to_ID;
wire MemtoReg_Regs_to_WB;

MEM_WBRegs MEM_WBins
                (
                    clk,
                    rst,

                    DMReadData_from_MEM,
                    ALUResultsOut_Regs_from_MEM,
                    RFWriteRegister_Regs_from_EX_MEM,

                    RegWrite_Regs_from_EX_MEM,
                    MemtoReg_Regs_from_MEM,

                    DMReadData_to_WB,
                    ALUResultsOut_Regs_to_WB,
                    RFWriteRegister_Regs_to_ID,

                    RegWrite_Regs_to_ID,
                    MemtoReg_Regs_to_WB,
                    Rd_MEM_WB,
                    RegWrite_MEM_WB
                );


assign DMReadData_from_MEM = DMReadData_to_MEM_WB;
assign ALUResultsOut_Regs_from_MEM = ALUResultsOut_to_MEM_WB;
assign RFWriteRegister_Regs_from_EX_MEM = RFWriteRegister_Regs_to_MEM_WB;
assign RegWrite_Regs_from_EX_MEM = RegWrite_Regs_to_MEM_WB;
assign MemtoReg_Regs_from_MEM = MemtoReg_Regs_to_MEM;


assign RFWriteRegister_from_MEM_WB = RFWriteRegister_Regs_to_ID;
assign RegWrite_from_MEM_WB = RegWrite_Regs_to_ID;


// Writeback stage

wire MemtoReg_from_MEM_WB;
wire [32-1:0]DMReadData_from_MEM_WB;
wire [32-1:0]ALUResultsOut_from_MEM_WB;

wire [32-1:0]RFWriteData_to_ID;

wire [32-1:0]WriteBackDataValuetoRF;

WriteBackStage WBins
                (
                    clk,
                    rst,
                    MemtoReg_from_MEM_WB,
                    DMReadData_from_MEM_WB,
                    ALUResultsOut_from_MEM_WB,

                    RFWriteData_to_ID,
                    // added for data hazard in third insturction of dependecny
                    WriteBackDataValuetoRF,
                    Rd_WB,
                    Rd_MEM_WB
                );

assign MemtoReg_from_MEM_WB = MemtoReg_Regs_to_WB;
assign DMReadData_from_MEM_WB = DMReadData_to_WB;
assign ALUResultsOut_from_MEM_WB = ALUResultsOut_Regs_to_WB;


assign RFWriteData_from_WB = RFWriteData_to_ID;





endmodule