`timescale 1ns / 1ps


module tbMCMIPS_V1();
reg clk, rst;

MultiCycleMIPS_V1 
                #
                (
                    .INSTMEMFILE("/home/narendiran/Desktop/ProjectZ/MultiCycleImplementation_NewOnes/MemFiles/InstructionMemory.mem"), 
                    .INSTDEPTH(30),
                    .DATADEPTH(200),
                    .DATAMEMFILE("/home/narendiran/Desktop/ProjectZ/MultiCycleImplementation_NewOnes/MemFiles/DataMemory.mem")
                ) 
                DUT
                (
                    clk,
                    rst
                );


always
    begin
        clk = 1;
        #5;
        clk = 0;
        #5;
    end

initial
    begin
        rst = 1;
        #77;
        rst = 0;
    end

endmodule
