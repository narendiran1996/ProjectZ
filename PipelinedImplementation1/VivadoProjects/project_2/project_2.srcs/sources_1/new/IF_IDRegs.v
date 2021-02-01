`timescale 1ns / 1ps

module IF_IDRegs
                (
                    input wire clk,
                    input wire rst,
                    input wire [32-1:0]PCadded4_Regs_from_IF,
                    input wire [32-1:0]currentInstruction_from_IF,

                    output reg [32-1:0]PCadded4_Regs_to_ID_EX,
                    output wire [32-1:0]currentInstruction_to_ID
                );



assign currentInstruction_to_ID = currentInstruction_from_IF;


always@(posedge clk)
    begin
        if(rst == 1)
            PCadded4_Regs_to_ID_EX <= 32'h0;
        else
            PCadded4_Regs_to_ID_EX <= PCadded4_Regs_from_IF;

    end

endmodule