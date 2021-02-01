`timescale 1ns / 1ps

module tb_Pipelined_V1();


parameter INSTRUCTION_DEPTH = 22;
reg clk, rst;

always
    begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

Pipelined_V1 #
                (
                    .INSTRUCTION_DEPTH(INSTRUCTION_DEPTH)
                )
                DUT
                (
                    clk,
                    rst
                );

integer it;
initial
    begin
        rst = 1;
        #47;
        rst = 0;
        #35       
        
        #50;
//        $finish;

    end
                
endmodule
