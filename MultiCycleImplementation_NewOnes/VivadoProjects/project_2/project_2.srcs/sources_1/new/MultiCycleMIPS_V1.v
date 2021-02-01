`timescale 1ns / 1ps


module MultiCycleMIPS_V1
                #
                (
                    parameter INSTDEPTH = 30,
                    parameter INSTMEMFILE = "",
                    parameter DATADEPTH = 100,
                    parameter DATAMEMFILE = ""
                )
                (
                    input wire clk,
                    input wire rst
                );
wire IorD;
wire MemWrite;
wire IRWrite;

wire [32-1:0]currentInstruction;

wire RegDst;
wire MemtoReg;
wire RegWrite;
wire [1:0]ALUSrcA;
wire [1:0]ALUSrcB;
wire [3-1:0]ALUControl;
wire Branch;
wire [1:0]PCSrc;
wire PCWrite;



OverallDataPath
                #
                (
                    .INSTMEMFILE(INSTMEMFILE), 
                    .INSTDEPTH(INSTDEPTH),
                    .DATADEPTH(DATADEPTH),
                    .DATAMEMFILE(DATAMEMFILE)
                ) 
                DataPath_Ins
                (
                    clk,
                    rst,

                    IorD,
                    MemWrite,
                    IRWrite,

                    currentInstruction,

                    RegDst,
                    MemtoReg,
                    RegWrite, 
                    ALUSrcA,
                    ALUSrcB,
                    ALUControl,
                    Branch,
                    PCSrc,
                    PCWrite                    
                );


Controller Controller_Ins
                (
                    clk,
                    rst,
                    
                    IorD,
                    MemWrite,
                    IRWrite,

                    currentInstruction,

                    RegDst,
                    MemtoReg,
                    RegWrite, 
                    ALUSrcA,
                    ALUSrcB,
                    ALUControl,
                    Branch,
                    PCSrc,
                    PCWrite                          
                );
    
endmodule