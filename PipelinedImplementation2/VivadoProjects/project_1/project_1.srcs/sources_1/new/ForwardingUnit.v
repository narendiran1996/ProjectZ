`timescale 1ns / 1ps

module ForwardingUnit
                (
                    input wire [5-1:0]Rs_ID_EX,
                    input wire [5-1:0]Rt_ID_EX,
                    input wire [5-1:0]Rd_ID_EX,

                    input wire [5-1:0]Rd_EX_MEM,

                    input wire  [5-1:0]Rd_MEM_WB,

                    input wire  [5-1:0]Rd_WB,

                    input wire RegWrite_EX_MEM,
                    input wire RegWrite_MEM_WB,

                    output reg [1:0]ForwardA,
                    output reg [1:0]ForwardB
                );

always@(*)
    begin
        if((RegWrite_EX_MEM == 1) && (Rd_EX_MEM != 0) && (Rd_EX_MEM == Rs_ID_EX))
            ForwardA = 2'b10;
        else if((RegWrite_MEM_WB==1) && (Rd_MEM_WB != 0) && (Rd_MEM_WB == Rs_ID_EX))
            ForwardA = 2'b01;
        else if((RegWrite_EX_MEM == 1) && (Rd_WB != 0) && (Rd_WB == Rs_ID_EX))
            ForwardA = 2'b11;
        else
            ForwardA = 2'b00;
        
        if((RegWrite_EX_MEM == 1) && (Rd_EX_MEM != 0) && (Rd_EX_MEM == Rt_ID_EX))
            ForwardB = 2'b10;
        else if((RegWrite_MEM_WB == 1) && (Rd_MEM_WB != 0) && (Rd_MEM_WB == Rt_ID_EX))
            ForwardB = 2'b01;
        else if((RegWrite_EX_MEM == 1) && (Rd_WB != 0) && (Rd_WB == Rt_ID_EX))
            ForwardB = 2'b11;
        else
            ForwardB = 2'b00;
    end


endmodule