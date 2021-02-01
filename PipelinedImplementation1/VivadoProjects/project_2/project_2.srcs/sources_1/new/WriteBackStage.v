`timescale 1ns/1ps

module WriteBackStage
                (
                    input wire clk,
                    input wire rst,
                    input wire MemtoReg_from_MEM_WB,
                    input wire [32-1:0]DMReadData_from_MEM_WB,
                    input wire [32-1:0]ALUResultsOut_from_MEM_WB,

                    output wire [32-1:0]RFWriteData_to_ID
                );


MuxTWOxONE32bit RF_WriteSource_Mux_Ins
                (
                    .inp1(ALUResultsOut_from_MEM_WB),
                    .inp2(DMReadData_from_MEM_WB),
                    .selectionLine(MemtoReg_from_MEM_WB),
                    .outp(RFWriteData_to_ID)
                );



endmodule