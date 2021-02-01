`timescale 1ns/1ps

module RegisterFile
                (
                    input wire clk,
                    input wire rst,
                    input wire [5-1:0]readRegister1,
                    output reg [32-1:0]readData1,
                    input wire [5-1:0]readRegister2,
                    output reg [32-1:0]readData2,
                    input wire [5-1:0]writeRegister,
                    input wire [32-1:0]writeData,
                    input wire writeEnable
                );

integer it;

reg [32-1:0]regFiles[0:32-1];

always@(posedge clk)
    begin
        if(rst == 1)
            begin
                for(it=0;it<32;it=it+1)
                    regFiles[it] <= 32'h0; 
                readData1 <= 32'h0;
                readData2 <= 32'h0;
            end
        else
            begin
                readData1 <= regFiles[readRegister1];
                readData2 <= regFiles[readRegister2];   
                if(writeEnable == 1)
                    regFiles[writeRegister] <= writeData;
            end        
    end
    

endmodule