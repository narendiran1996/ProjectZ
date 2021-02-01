`timescale 1ns/1ps

module WriteBackStage
                (
                    input wire clk,
                    input wire rst,
                    input wire MemtoReg_from_MEM_WB,
                    input wire [32-1:0]DMReadData_from_MEM_WB,
                    input wire [32-1:0]ALUResultsOut_from_MEM_WB,

                    output wire [32-1:0]RFWriteData_to_ID,

                    // added for data hazard in third insturction of dependecny
                    output reg [32-1:0]WriteBackDataValuetoRF,
                    output reg [5-1:0]Rd_WB,
                    input wire [5-1:0]Rd_MEM_WB
                );


MuxTWOxONE32bit RF_WriteSource_Mux_Ins
                (
                    .inp1(ALUResultsOut_from_MEM_WB),
                    .inp2(DMReadData_from_MEM_WB),
                    .selectionLine(MemtoReg_from_MEM_WB),
                    .outp(RFWriteData_to_ID)
                );

// added for data hazard in third insturction of dependecny


always@(posedge clk)
    begin
        if(rst == 1)
            begin
               WriteBackDataValuetoRF <= 0; 
               Rd_WB <= 0;
            end            
        else
            begin
                WriteBackDataValuetoRF <= ALUResultsOut_from_MEM_WB;
                Rd_WB <= Rd_MEM_WB;
            end

    end

endmodule