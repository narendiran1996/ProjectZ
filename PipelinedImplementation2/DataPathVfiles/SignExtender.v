`timescale 1ns/1ps

module SignExtender
                (
                    input wire clk,
                    input wire rst,
                    input wire [16-1:0]inp,
                    output reg [32-1:0]outp
                );

always@(posedge clk)
    begin
        if(rst == 1)
            outp <= 0;
        else
            outp = {{16{inp[16-1]}}, inp};
    end

endmodule