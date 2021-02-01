`timescale 1ns/1ps

module DataMemory
                #
                (
                parameter DATA_MEMFILE="",
                parameter DEPTH=10
                )
                (          
                    input wire clk,
                    input wire rst,         
                    input wire [32-1:0]address,
                    output reg [32-1:0]readData,
                    input wire MemRead,
                    input wire [32-1:0]writeData,
                    input wire MemWrite
                );

reg [32-1:0]dataMemory[0:DEPTH-1];

initial
    begin
        $readmemh(DATA_MEMFILE, dataMemory);
    end


always@(posedge clk)
    begin
        if(rst == 1)
            readData <= 0;
        else
            begin
                if(MemRead == 1)
                    readData <= dataMemory[address];
                if(MemWrite == 1)
                    dataMemory[address] <= writeData;    
            end    
    end

endmodule