`timescale 1ns / 1ps


module OverallDataPath
                #
                (
                    parameter INSTDEPTH = 30,
                    parameter INSTMEMFILE = "",
                    parameter DATADEPTH = 100,
                    parameter DATAMEMFILE = ""
                )
                (
                    input wire clk,
                    input wire rst,

                    input wire IorD,
                    input wire MemWrite,
                    input wire IRWrite,

                    output wire [32-1:0]currentInstruction,

                    input wire RegDst,
                    input wire MemtoReg,
                    input wire RegWrite, 
                    input wire [1:0]ALUSrcA,
                    input wire [1:0]ALUSrcB,
                    input wire [3-1:0]ALUControl,
                    input wire Branch_EQ,
                    input wire Branch_NEQ,
                    input wire [1:0]PCSrc,
                    input wire PCWrite                    
                );

wire PCEn;
wire [32-1:0]ALUOut_Registered;
wire [32-1:0]RD2_Registered;

// Instruction Fetch Stage
wire [32-1:0]newPC;
wire [32-1:0]currentPC;

RegisterNbits #(.Nbits(32)) Register_PC_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newVal(newPC),
                    .Enable(PCEn),
                    .RegOUT(currentPC)
                );


wire [32-1:0]AddrToMemory;

Mux2x1Nbits #(.Nbits(32)) Mux_AddrMemory_Ins
                (
                    .inp1(currentPC),
                    .inp2(ALUOut_Registered),
                    .sel(IorD),
                    .outp(AddrToMemory)
                );


wire [32-1:0]ReadDataOutFromMemory, ReadInstructionOutFromMemory;
wire [32-1:0]correctAddressToMemory;
assign correctAddressToMemory = AddrToMemory>>2;

InstructionAndDataMemory 
                #
                (
                    .INSTMEMFILE(INSTMEMFILE), 
                    .INSTDEPTH(INSTDEPTH),
                    .DATADEPTH(DATADEPTH),
                    .DATAMEMFILE(DATAMEMFILE)
                ) 
                Memory_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .addr(correctAddressToMemory[$clog2(DATADEPTH)-1:0]), // divide by 4 
                    .writeDataIn(RD2_Registered),
                    .writeEnable(MemWrite),
                    .readDataOut_DM(ReadDataOutFromMemory),
                    .readDataOut_IM(ReadInstructionOutFromMemory),
                    .IorD(IorD)
                );


RegisterNbits #(.Nbits(32)) Register_Instruction_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newVal(ReadInstructionOutFromMemory),
                    .Enable(IRWrite),
                    .RegOUT(currentInstruction)
                ); 

wire [32-1:0] DataOutFromMemoryRegistered;
// RegisterNbits #(.Nbits(32)) Register_Data_Ins
//                 (
//                     .clk(clk),
//                     .rst(rst),
//                     .newVal(ReadDataOutFromMemory),
//                     .Enable(1'b1),
//                     .RegOUT(DataOutFromMemoryRegistered)
//                 ); 

// replaceing register with wire
assign DataOutFromMemoryRegistered = ReadDataOutFromMemory;


// Instruction Decode
wire [5-1:0]WriteAddrToRF;

Mux2x1Nbits #(.Nbits(5)) Mux_WriteAddrToRF_Ins
                (
                    .inp1(currentInstruction[20:16]),
                    .inp2(currentInstruction[15:11]),
                    .sel(RegDst),
                    .outp(WriteAddrToRF)
                );

wire [32-1:0]WriteDataToRF;
Mux2x1Nbits #(.Nbits(32)) Mux_WriteDataToRF_Ins
                (
                    .inp1(ALUOut_Registered),
                    .inp2(DataOutFromMemoryRegistered),
                    .sel(MemtoReg),
                    .outp(WriteDataToRF)
                ); 

wire [32-1:0]RFReadData1, RFReadData2;
RegisterFile RF_ins
                (
                    .clk(clk),
                    .rst(rst),
                    .readRegister1(currentInstruction[25:21]),
                    .readData1(RFReadData1),
                    .readRegister2(currentInstruction[20:16]),
                    .readData2(RFReadData2),
                    .writeRegister(WriteAddrToRF),
                    .writeData(WriteDataToRF),
                    .writeEnable(RegWrite)
                );

wire [32-1:0]RD1_Registered;
RegisterNbits #(.Nbits(32)) Register_RFData1_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newVal(RFReadData1),
                    .Enable(1'b1),
                    .RegOUT(RD1_Registered)
                ); 

RegisterNbits #(.Nbits(32)) Register_RFData2_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newVal(RFReadData2),
                    .Enable(1'b1),
                    .RegOUT(RD2_Registered)
                ); 

wire [32-1:0]SignImm;
SignExtender SignExtender_Ins
                (
                    .inp(currentInstruction[15:0]),
                    .outp(SignImm)
                );

// Execuction Stage

wire [32-1:0]SrcAForALU;
Mux4x1Nbits #(.Nbits(32))Mux_SrcA_Ins
                (
                    .inp1(currentPC),
                    .inp2(RFReadData1),
                    .inp3({27'd0,currentInstruction[10:6]}),
                    .inp4(0),
                    .sel(ALUSrcA),
                    .outp(SrcAForALU)
                );

wire [32-1:0]SrcBForALU;
Mux4x1Nbits #(.Nbits(32))Mux_SrcB_Ins
                (
                    .inp1(RFReadData2),
                    .inp2(32'h4),
                    .inp3(SignImm),
                    .inp4(SignImm<<2),
                    .sel(ALUSrcB),
                    .outp(SrcBForALU)
                );

wire [32-1:0]ALUResults;
wire isZero;
ArithmeticLogicUnit ALU_Ins
                (
                    .operend1(SrcAForALU),
                    .operend2(SrcBForALU),
                    .resultOut(ALUResults),
                    .ALUoperations(ALUControl),
                    .isZero(isZero)           
                );

wire t1, t2;
and(t1, Branch_EQ, isZero);
and(t2, Branch_NEQ, ~isZero);

or(PCEn, PCWrite, t1, t2);


RegisterNbits #(.Nbits(32)) Reg_ALUResults_Ins
                (
                    .clk(clk),
                    .rst(rst),
                    .newVal(ALUResults),
                    .Enable(1'b1),
                    .RegOUT(ALUOut_Registered)
                ); 


// adding support for jump instruction

wire [32-1:0]PCValueToJump;

assign PCValueToJump = {currentPC[31:28], (currentInstruction[25:0]<<2)};

Mux4x1Nbits #(.Nbits(32))Mux_PCSrc_Ins
                (
                    .inp1(ALUResults),
                    .inp2(ALUOut_Registered),
                    .inp3(PCValueToJump),
                    .inp4(0),
                    .sel(PCSrc),
                    .outp(newPC)
                );

endmodule
