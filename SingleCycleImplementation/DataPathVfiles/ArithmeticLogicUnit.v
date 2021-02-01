`timescale 1ns/1ps

module ArithmeticLogicUnit
                (
                    input wire [32-1:0]operend1,
                    input wire [32-1:0]operend2,
                    output reg [32-1:0]resultOut,
                    input wire [4-1:0]ALUoperations,
                    output reg carryOut,
                    output wire isZero                
                );


always@(*)
    begin
        case(ALUoperations)
            4'b0000: resultOut <= operend1 & operend2;
            4'b0001: resultOut <= operend1 | operend2;
            4'b0010: {carryOut, resultOut} <= operend1 + operend2;
            4'b0110: resultOut <= operend1 - operend2;
            4'b0111: resultOut <= (operend1 < operend2) ? 32'h1 : 32'h0;
            4'b1100: resultOut <= ~(operend1 | operend2);
            default: resultOut <= 32'h0;
        endcase
    end

assign isZero = (resultOut == 32'h0);
endmodule