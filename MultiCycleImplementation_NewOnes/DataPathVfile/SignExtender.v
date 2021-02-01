module SignExtender
                (
                    input wire [16-1:0]inp,
                    output reg [32-1:0]outp
                );

always@(*)
    begin
        outp = {{16{inp[16-1]}}, inp};
    end

endmodule