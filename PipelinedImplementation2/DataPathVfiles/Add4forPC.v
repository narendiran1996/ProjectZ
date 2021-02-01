`timescale 1ns/1ps

module Add4ForPC
                (
                    input wire [32-1:0]currentPC,
                    output wire [32-1:0]PCadded4
                );

assign PCadded4 = currentPC + 4;
endmodule