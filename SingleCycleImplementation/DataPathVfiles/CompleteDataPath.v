`timescale 1ns/1ps

// see figure 4.15 (page 263)
module CompleteDataPath
                #
                (
                    parameter INSTRUCTION_MEMFILE="",
                    parameter INSTRUCTION_DEPTH=10,
                    parameter DATA_MEMFILE="",
                    parameter DATA_DEPTH=10
                )
                (
                    input wire clk,
                    input wire rst,

                    input wire RegDst,
                    input wire RegWrite,
                    input wire [1:0]ALUOp,
                    input wire ALUSrc,
                    input wire MemRead,
                    input wire MemWrite,
                    input wire MemtoReg,
                    input wire Branch,
                    input wire Jump,
                    input wire updatePC,
                    

                    output wire [6-1:0]OpCode,

                    output wire isZero
                );


wire [32-1:0]currentPC, newPC, PCadded4;
PCRegister PC_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newPC(newPC),
                    .updatePC(updatePC),
                    .currentPC(currentPC)
                );

Add4ForPC PC4_ADDED_Ins
                (
                    .currentPC(currentPC),
                    .PCadded4(PCadded4)
                );

wire [32-1:0]currentInstruction;
InstructionMemory
                #
                (                 
                    .INSTRUCTION_MEMFILE(INSTRUCTION_MEMFILE),
                    .DEPTH(INSTRUCTION_DEPTH)   
                )
                Instruction_Memory_Ins                
                (
                    .readAddress(currentPC>>2),
                    .instructionData(currentInstruction)
                );

assign OpCode = currentInstruction[31:26];

wire [5-1:0]writeRegisterMuxOut;
assign writeRegisterMuxOut = (RegDst == 0) ? currentInstruction[20:16] : currentInstruction[15:11];

wire [32-1:0]RFWriteData, RFReadData1, RFReadData2;

RegisterFile Registers_Ins
                (
                    .clk(clk),
                    .readRegister1(currentInstruction[25:21]),
                    .readRegister2(currentInstruction[20:16]),
                    .readData1(RFReadData1),
                    .readData2(RFReadData2),
                    .writeRegister(writeRegisterMuxOut),
                    .RegWrite(RegWrite),
                    .writeData(RFWriteData)                    
                );


wire [32-1:0]SEIntermediateValue;
SignExtender Signextend_Ins
                (
                    .inp(currentInstruction[15:0]),
                    .outp(SEIntermediateValue)
                );


wire [4-1:0]ALUoperations;
ALUcontrol ALU_control_Ins
                (
                    .Funct(currentInstruction[5:0]),
                    .AluOp(ALUOp),
                    .ALUoperations(ALUoperations)
                );

wire [32-1:0]ALUSource2;
MuxTWOxONE32bit ALU_SRC2_MUX_Ins
                (
                    .inp1(RFReadData2),
                    .inp2(SEIntermediateValue),
                    .selectionLine(ALUSrc),
                    .outp(ALUSource2)
                );

wire [32-1:0]ALUResultsOut;
ArithmeticLogicUnit ALU_Ins
                (
                    .operend1(RFReadData1),
                    .operend2(ALUSource2),
                    .ALUoperations(ALUoperations),
                    .resultOut(ALUResultsOut),
                    .isZero(isZero)
                );

wire [32-1:0]DMReadDataOut;
DataMemory 
                #
                (                 
                    .DATA_MEMFILE(DATA_MEMFILE),
                    .DEPTH(DATA_DEPTH)
                )
                Data_Memory_Ins
                (
                    .address(ALUResultsOut>>2), // because of 4 bytes
                    .writeData(RFReadData2),
                    .readData(DMReadDataOut),
                    .MemRead(MemRead),
                    .MemWrite(MemWrite)
                );


MuxTWOxONE32bit RF_WriteSource_Mux_Ins
                (
                    .inp1(ALUResultsOut),
                    .inp2(DMReadDataOut),
                    .selectionLine(MemtoReg),
                    .outp(RFWriteData)
                );


// PC part - beq
wire canBranch;
assign canBranch = Branch &  isZero; 


wire [32-1:0]newPCofBranch, newPCofBranch2;

assign newPCofBranch = PCadded4 + (SEIntermediateValue<<2);

assign newPCofBranch2 = (canBranch == 1) ? newPCofBranch : PCadded4;

//PC part - j


wire [32-1:0]newPCofJump;

assign newPCofJump = {PCadded4[31:28], (currentInstruction[25:0])<<2};

assign newPC = (Jump == 1) ? newPCofJump : newPCofBranch2;





endmodule