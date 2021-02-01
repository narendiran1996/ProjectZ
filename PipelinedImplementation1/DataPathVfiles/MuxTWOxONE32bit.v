`timescale 1ns/1ps

module MuxTWOxONE32bit
                (
                    input wire [32-1:0]inp1,
                    input wire [32-1:0]inp2,
                    input wire selectionLine,
                    output wire [32-1:0]outp
                );

assign outp = (selectionLine == 0) ? inp1 : inp2;

endmodule