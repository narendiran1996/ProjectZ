`timescale 1ns/1ps
// see figure 4.12 (page 260)
module ALUcontrol
                (
                    input wire [6-1:0]Funct,
                    input wire [1:0]AluOp,
                    output reg [4-1:0]ALUoperations
                );

always@(*)
    begin
        case(AluOp)
            2'b00: ALUoperations = 4'b0010;
            2'b01: ALUoperations = 4'b0110;
            2'b10:
                begin
                    case(Funct)
                        6'b100000: ALUoperations = 4'b0010;
                        6'b100010: ALUoperations = 4'b0110;
                        6'b100100: ALUoperations = 4'b0000;
                        6'b100101: ALUoperations = 4'b0001;
                        6'b101010: ALUoperations = 4'b0111;
                        default: ALUoperations = 4'hx;
                    endcase
                end
            default: ALUoperations = 4'hx;
        endcase
    end
endmodule