module Mux4x1Nbits 
                #
                (
                    parameter Nbits = 32
                )
                (
                    input wire [Nbits-1:0]inp1,
                    input wire [Nbits-1:0]inp2,
                    input wire [Nbits-1:0]inp3,
                    input wire [Nbits-1:0]inp4,
                    input wire [1:0]sel,
                    output reg [Nbits-1:0]outp
                );

always @(*) 
    begin
        case (sel)
            2'd0:
                begin
                    outp = inp1;
                end      
            2'd1:
                begin
                    outp = inp2;
                end   
            2'd2:
                begin
                    outp = inp3;
                end   
            2'd3:
                begin
                    outp = inp4;
                end   
            default:
                begin
                    outp = 'hx;
                end     
        endcase
    end


    
endmodule