
// see figure 4.12 (page 260)
module ALUControl
                (
                    input wire [6-1:0]Funct,
                    input wire [1:0]AluOp,
                    output reg [3-1:0]ALUoperations
                );

always@(*)
    begin
        case(AluOp)
            2'b00: ALUoperations = 3'b010;
            2'b01: ALUoperations = 3'b110;
            2'b10:
                begin
                    case(Funct)
                        6'b100000: ALUoperations = 3'b010;
                        6'b100010: ALUoperations = 3'b110;
                        6'b100100: ALUoperations = 3'b000;
                        6'b100101: ALUoperations = 3'b001;
                        6'b101010: ALUoperations = 3'b111;
                        default: ALUoperations = 3'hx;
                    endcase
                end
            default: ALUoperations = 3'hx;
        endcase
    end
endmodule