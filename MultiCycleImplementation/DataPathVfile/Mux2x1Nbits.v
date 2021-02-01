module Mux2x1Nbits 
                #
                (
                    parameter Nbits = 32
                )
                (
                    input wire [Nbits-1:0]inp1,
                    input wire [Nbits-1:0]inp2,
                    input wire sel,
                    output wire [Nbits-1:0]outp
                );


assign outp = (sel==1) ? inp2 :  inp1;

endmodule