`timescale 1ns/1ps

module InstructionMemory
                #
                (
                    parameter INSTRUCTION_MEMFILE="",
                    parameter DEPTH=10
                )
                (
                    input wire clk,
                    input wire rst,
                    input wire [32-1:0]readAddress,
                    output reg [32-1:0]instructionData
                );

reg [32-1:0]instructionMemory[0:DEPTH-1];

initial
    begin
        $readmemh(INSTRUCTION_MEMFILE, instructionMemory);
    end


always@(posedge clk)
    begin
        if(rst == 1)
            instructionData <= 0;
        else
            instructionData <= instructionMemory[readAddress];
    end

endmodule