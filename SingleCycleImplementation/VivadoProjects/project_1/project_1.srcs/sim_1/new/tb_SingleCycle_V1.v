`timescale 1ns / 1ps


module tb_SingleCycle_V1();

parameter INSTRUCTION_DEPTH = 18;
reg clk, rst, processNext;

always
    begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

SingleCycle_V1 #
                (
                    .INSTRUCTION_DEPTH(INSTRUCTION_DEPTH)
                )
                DUT
                (
                    clk,
                    rst,
                    processNext
                );

integer it;
initial
    begin
        rst = 1;
        processNext = 0;
        #47;
        rst = 0;
        #35
        for(it=0;it<25-1;it=it+1)
            begin
                @(negedge clk);
                processNext = 1;
                @(negedge clk);
                processNext = 0;
                #50;
            end
        
        
        #50;
        $finish;

    end
                
endmodule
