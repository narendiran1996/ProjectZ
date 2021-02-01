`timescale 1ns/1ps

module SignExtender
                (
                    input wire [16-1:0]inp,
                    output wire [32-1:0]outp
                );

assign outp = {{16{inp[16-1]}}, inp};

endmodule