`timescale 1ns/1ps

module ArithmeticLogicUnit
                (
                    input wire [32-1:0]operend1,
                    input wire [32-1:0]operend2,
                    output reg [32-1:0]resultOut,
                    input wire [3-1:0]ALUoperations,
                    output reg carryOut,
                    output wire isZero                
                );


always@(*)    
    begin
        carryOut = 0;
        case(ALUoperations)
            3'b000: resultOut = operend1 & operend2;
            3'b001: resultOut = operend1 | operend2;
            3'b010: {carryOut, resultOut} = operend1 + operend2;
            3'b110: resultOut = operend1 - operend2;
            3'b111: resultOut = (operend1 < operend2) ? 32'h1 : 32'h0;
            default: begin
                resultOut = 32'h0;
                carryOut = 'hx;
            end
        endcase
    end

assign isZero = (resultOut == 32'h0);
endmodule