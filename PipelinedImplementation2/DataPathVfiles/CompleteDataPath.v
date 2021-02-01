`timescale 1ns/1ps

// see figure 4.15 (page 263)
module CompleteDataPath
                #
                (
                    parameter INSTRUCTION_MEMFILE="/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/InstructionMemory.mem",
                    parameter INSTRUCTION_DEPTH=10,
                    parameter DATA_MEMFILE="/home/narendiran/Desktop/ProjectZ/PipelinedImplementation1/MemFiles/DataMemory.mem",
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
//                    input wire updatePC,
                    

                    output wire [6-1:0]OpCode,

                    output wire isZero
                );


wire [32-1:0]currentPC, newPC, PCadded4;
reg [32-1:0]PCatStage1;
PCRegister PC_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newPC(newPC),
//                    .updatePC(updatePC),
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
                    .clk(clk),
                    .rst(rst),
                    .readAddress(currentPC>>2),
                    .instructionData(currentInstruction)
                );

always@(posedge clk)
    begin
        if(rst == 1)
            PCatStage1 <= 0;
        else
            PCatStage1 <= PCadded4;
    end

assign OpCode = currentInstruction[31:26];

reg RegWrite3;
reg [5-1:0]writeRegisterMuxOut_Reg2;

wire [32-1:0]RFWriteData, RFReadData1, RFReadData2;

RegisterFile Registers_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .readRegister1(currentInstruction[25:21]),
                    .readRegister2(currentInstruction[20:16]),
                    .readData1(RFReadData1),
                    .readData2(RFReadData2),
                    .writeRegister(writeRegisterMuxOut_Reg2),
                    .RegWrite(RegWrite3),
                    .writeData(RFWriteData)                    
                );

wire [32-1:0]SEIntermediateValue;
SignExtender Signextend_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .inp(currentInstruction[15:0]),
                    .outp(SEIntermediateValue)
                );
                

reg [5-1:0]cI20_16, cI15_11;
reg  MemtoReg1, Branch1, MemWrite1, MemRead1, ALUSrc1, RegDst1, RegWrite1;
reg [1:0]ALUOp1;
reg [32-1:0]PCatStage2;

always@(posedge clk)
    begin
        if(rst == 1)
            begin
               cI20_16 <= 0;
               cI15_11 <= 0;
               PCatStage2 <= 0;
               {RegWrite1, MemtoReg1, Branch1, MemWrite1, MemRead1, ALUSrc1, RegDst1, ALUOp1} <= 9'd0;
            end
        else
            begin
               cI20_16 <=  currentInstruction[20:16];
               cI15_11 <= currentInstruction[15:11];
               PCatStage2 <= PCatStage1;
               {RegWrite1, MemtoReg1, Branch1, MemWrite1, MemRead1, ALUSrc1, RegDst1, ALUOp1} <= {RegWrite, MemtoReg, Branch, MemWrite, MemRead, ALUSrc, RegDst, ALUOp};
            end
    end

        

wire [4-1:0]ALUoperations;
ALUcontrol ALU_control_Ins
                (
                    .Funct(SEIntermediateValue[5:0]), // see diagram
                    .AluOp(ALUOp1),
                    .ALUoperations(ALUoperations)
                );

wire [32-1:0]ALUSource2;
MuxTWOxONE32bit ALU_SRC2_MUX_Ins
                (
                    .inp1(RFReadData2),
                    .inp2(SEIntermediateValue),
                    .selectionLine(ALUSrc1),
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

wire [32-1:0]newPCofBranch;

assign newPCofBranch = PCadded4 + (SEIntermediateValue<<2);


wire [5-1:0]writeRegisterMuxOut;


assign writeRegisterMuxOut = (RegDst1 == 0) ? cI20_16 : cI15_11;

reg isZero_Reg;
reg [32-1:0]ALUResultsOut_Reg1;
reg [5-1:0]writeRegisterMuxOut_Reg1;
reg [32-1:0]RFReadData2_Reg, PCatStage3;
reg RegWrite2, MemtoReg2, Branch2, MemWrite2, MemRead2;
always@(posedge clk)
    begin
        if(rst == 1)
            begin
                isZero_Reg <= 0;
                ALUResultsOut_Reg1 <= 32'h0;
                writeRegisterMuxOut_Reg1 <= 0;
                RFReadData2_Reg <= 32'h0;
                PCatStage3 <= 0;
                {RegWrite2, MemtoReg2, Branch2, MemWrite2, MemRead2} <= 5'd0;
            end
        else
            begin
                isZero_Reg <= isZero;
                ALUResultsOut_Reg1 <= ALUResultsOut;
                writeRegisterMuxOut_Reg1 <= writeRegisterMuxOut;
                RFReadData2_Reg <= RFReadData2;
                PCatStage3 <= newPCofBranch;
                {RegWrite2, MemtoReg2, Branch2, MemWrite2, MemRead2} <= {RegWrite1, MemtoReg1, Branch1, MemWrite1, MemRead1};
            end
    end


wire [32-1:0]DMReadDataOut;
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
                    .address(ALUResultsOut_Reg1>>2), // because of 4 bytes
                    .writeData(RFReadData2_Reg),
                    .readData(DMReadDataOut),
                    .MemRead(MemRead2),
                    .MemWrite(MemWrite2)
                );
                
reg [32-1:0]ALUResultsOut_Reg2;
reg MemtoReg3;

always@(posedge clk)
    if(rst == 1)
        begin
            writeRegisterMuxOut_Reg2 <= 0;
            ALUResultsOut_Reg2 <=  0;
            MemtoReg3 <= 0;
            RegWrite3 <= 0;
        end
    else
        begin
            writeRegisterMuxOut_Reg2 = writeRegisterMuxOut_Reg1;
            ALUResultsOut_Reg2 <=  ALUResultsOut_Reg1;
            MemtoReg3 <= MemtoReg2;
            RegWrite3 <= RegWrite2;
        end

MuxTWOxONE32bit RF_WriteSource_Mux_Ins
                (
                    .inp1(ALUResultsOut_Reg2),
                    .inp2(DMReadDataOut),
                    .selectionLine(MemtoReg3),
                    .outp(RFWriteData)
                );


wire PCSrc;
assign PCSrc = Branch2 & isZero_Reg;

// for pc 
assign newPC = (PCSrc == 1) ? PCatStage3 : PCadded4;

endmodule