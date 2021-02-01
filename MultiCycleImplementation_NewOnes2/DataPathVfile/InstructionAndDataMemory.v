
module InstructionAndDataMemory 
                #
                (
                    parameter INSTDEPTH = 30,
                    parameter INSTMEMFILE = "",
                    parameter DATADEPTH = 100,
                    parameter DATAMEMFILE = ""
                )
                (
                    input wire clk,
                    input wire rst,
                    input wire [$clog2(DATADEPTH)-1:0]addr,
                    input wire [32-1:0] writeDataIn,
                    input wire writeEnable,
                    output reg [32-1:0]readDataOut_DM,
                    output reg [32-1:0]readDataOut_IM,
                    input wire IorD
                );


reg [32-1:0]INS_MEM_REG[0:INSTDEPTH-1];


reg [32-1:0]DATA_MEM_REG[0:DATADEPTH-1];

initial
    begin
        $readmemh(INSTMEMFILE, INS_MEM_REG);
        $readmemh(DATAMEMFILE, DATA_MEM_REG);
    end

always @(posedge clk)
    begin
        if(rst == 1)
            readDataOut_DM <= 0;
        else
            begin
                if(IorD == 1)
                    readDataOut_DM <= DATA_MEM_REG[addr];
                if(writeEnable==1 && IorD == 1)
                    DATA_MEM_REG[addr] <= writeDataIn;
            end
    end    

always @(posedge clk)
    begin
        if(rst == 1)
            readDataOut_IM <= 0;
        else
            begin
                if(IorD == 0)
                    readDataOut_IM <= INS_MEM_REG[addr];
            end
    end    

endmodule