`timescale 1ns/1ps

module MuxFOURxONE32bit
                (
                    input wire [32-1:0]inp1,
                    input wire [32-1:0]inp2,
                    input wire [32-1:0]inp3,
                    input wire [32-1:0]inp4,
                    input wire [1:0]selectionLine,
                    output reg [32-1:0]outp
                );

always@(*)
    begin
        case(selectionLine)
            2'b00:
                begin
                    outp <= inp1;
                end
            2'b01:
                begin
                    outp <= inp2;
                end
            2'b10:
                begin
                    outp <= inp3;
                end
            2'b11:
                begin
                    outp <= inp4;
                end
            default:
                begin
                    outp <= 32'hxxxxxxxx;
                end
        endcase
    end

endmodule