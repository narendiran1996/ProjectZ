
module RegisterNbits 
                #
                (
                    parameter Nbits = 32
                )
                (
                    input wire clk,
                    input wire rst,
                    input wire [Nbits-1:0]newVal,
                    input wire Enable,
                    output reg [Nbits-1:0]RegOUT
                );



always @(posedge clk) 
    begin
        if(rst == 1)
            RegOUT <= 0;
        else
            begin
                if(Enable == 1)
                    RegOUT <= newVal;
            end
    end
    
endmodule