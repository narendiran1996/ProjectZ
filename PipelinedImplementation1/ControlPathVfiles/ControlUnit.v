`timescale 1ns/1ps

module ControlUnit
                (
                    input wire clk,
                    input wire rst,
                    input wire [6-1:0]OpCode,
                    output reg RegDst,
                    output reg MemRead,
                    output reg MemtoReg,
                    output reg [1:0]ALUOp,
                    output reg MemWrite,
                    output reg ALUSrc,
                    output reg RegWrite,
                    output reg Branch,
                    output reg Jump
                );


always@(*)
    begin
        if(rst == 1)
            begin
                RegDst = 0;
                ALUSrc = 0;
                MemtoReg = 0;
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 0;
                ALUOp = 2'b00;
            end

        else
            begin
                case (OpCode)
                    6'b000000: // R format
                        begin
                            RegDst = 1;
                            ALUSrc = 0;
                            MemtoReg = 0;
                            RegWrite = 1;
                            MemRead = 0;
                            MemWrite = 0;
                            Branch = 0;
                            Jump = 0;
                            ALUOp = 2'b10;
                        end
                    6'b100011: // lw
                        begin
                            RegDst = 0;
                            ALUSrc = 1;
                            MemtoReg = 1;
                            RegWrite = 1;
                            MemRead = 1;
                            MemWrite = 0;
                            Branch = 0;
                            Jump = 0;
                            ALUOp = 2'b00;
                        end
                    6'b101011: // sw
                        begin
                            RegDst = 0; // 'bx but replaced with 0 for convinience
                            ALUSrc = 1;
                            MemtoReg = 0; // 'bx but replaced with 0 for convinience
                            RegWrite = 0;
                            MemRead = 0;
                            MemWrite = 1;
                            Branch = 0;
                            Jump = 0;
                            ALUOp = 2'b00;
                        end
                    6'b000100: // beq
                        begin
                            RegDst = 0; // 'bx but replaced with 0 for convinience
                            ALUSrc = 0;
                            MemtoReg = 0; // 'bx but replaced with 0 for convinience
                            RegWrite = 0;
                            MemRead = 0;
                            MemWrite = 0;
                            Branch = 1;
                            Jump = 0;
                            ALUOp = 2'b01;
                        end
                    6'b000010: // j
                        begin
                            RegDst = 0;
                            ALUSrc = 0;
                            MemtoReg = 0;
                            RegWrite = 0;
                            MemRead = 0;
                            MemWrite = 0;
                            Branch = 0;
                            Jump = 1;
                            ALUOp = 2'b00;
                        end
                    default: 
                        begin
                            RegDst = 0;
                            ALUSrc = 0;
                            MemtoReg = 0;
                            RegWrite = 0;
                            MemRead = 0;
                            MemWrite = 0;
                            Branch = 0;
                            Jump = 0;
                            ALUOp = 2'b00;
                        end            
                endcase    
            end    
    end

endmodule
