`timescale 1ns/1ps

module PCRegister
                (
                    input wire clk,
                    input wire rst,
                    input wire [32-1:0]newPC,
//                     input wire updatePC,
                    output wire [32-1:0]currentPC
                );

reg [32-1:0]PCValue;

always@(posedge clk)
    begin
         if(rst == 1)
             PCValue <= 0;
         else
            //  if(updatePC)
            PCValue = newPC;
    end

assign currentPC = PCValue;
endmodule