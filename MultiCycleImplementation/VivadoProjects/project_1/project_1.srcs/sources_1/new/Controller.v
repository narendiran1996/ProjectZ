`define STATE_COUNT 12

module Controller 
                (
                    input wire clk,
                    input wire rst,
                    
                    output reg IorD,
                    output reg MemWrite,
                    output reg IRWrite,

                    input wire [32-1:0]currentInstruction,

                    output reg RegDst,
                    output reg MemtoReg,
                    output reg RegWrite, 
                    output reg ALUSrcA,
                    output reg [1:0]ALUSrcB,
                    output wire [3-1:0]ALUControl,
                    output reg Branch,
                    output reg PCSrc,
                    output reg PCWrite                          
                );
wire [6-1:0]Funct;
assign Funct = currentInstruction[5:0];
wire [6-1:0]OP;
assign OP = currentInstruction[31:26];

reg [1:0]ALUOP;
ALUControl ALUControl_Ins
                (
                    .Funct(currentInstruction[5:0]),
                    .AluOp(ALUOP),
                    .ALUoperations(ALUControl)
                );


reg [$clog2(`STATE_COUNT)-1:0]presentState, nextState;
parameter IDLE = 0, FETCH = 1, DECODE = 2, MEMADR = 3, MEMREAD = 4, MEMWRITEBACK = 5, MEMWRITE = 6, EXECUTE = 7, ALUWRITEBACK = 8, BRANCH = 9;
parameter BRANCH_DUMMY = 10; // added by me

always @(posedge clk)
    begin
        if (rst == 1)
            presentState <= IDLE;
        else
            presentState <= nextState;
    end


always @(presentState, OP)
    begin
        case(presentState)
            IDLE:
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b00000;
                    nextState = FETCH;
                end
            FETCH: // during FETCH, instruction is fetched and also new PC value is updated with PC+4
                begin
                    {Branch, PCSrc, PCWrite} = 3'b001;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b001000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b00100;
                    nextState = DECODE;
                end
            DECODE: // during DECODE, just normarl decoding is done in the ALU - changing of state based on OP code
            // and ALU source B is slected to sign extended +4 for BRANCH isntruciton
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b01100;
                    if(OP == 6'b100011 || OP == 6'b101011)
                        nextState = MEMADR;
                    else if(OP == 6'b000000)
                        nextState = EXECUTE;
                    else if(OP == 6'b000100)
                        nextState = BRANCH;
                    else
                        nextState = IDLE;
                end
            MEMADR: // during MEMADR, address of memeory read is generated for lw and sw insturctions, 
                    //-- the sign extended value is added with Register value specified in the instuction
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b11000;
                    if(OP == 6'b100011) // for loading
                        nextState = MEMREAD;
                    else // for storing
                        nextState = MEMWRITE;
                end
            MEMREAD: // drung MEMREAD, the memory valu is read and stored in Data Register after 1 cycle
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b100000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b00000;
                    nextState = MEMWRITEBACK;
                end
            MEMWRITEBACK: // druing MEMWRITEBACK, the value of data register is written into memory and goes back to FETCH
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000011;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b00000;
                    nextState = FETCH;
                end
            MEMWRITE: // during MEMWRITE, the value of of write data is written intor the memory into memory
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b110000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b00000;
                    nextState = FETCH;
                end
            EXECUTE: // for RTYPE, exectuion -- during EXECTUE, the alu operands are selected from reg and operation of arithmetic is given
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b10010;
                    nextState = ALUWRITEBACK;
                end
            ALUWRITEBACK: // during ALU write back, alu out is stored into reg
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000101;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b00000;
                    nextState = FETCH;
                end
            BRANCH: // during branch, we update the newPC value by checking the equality in the ALU
                begin
                    {Branch, PCSrc, PCWrite} = 3'b110;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b10001;
                    nextState = BRANCH_DUMMY;
                end
            BRANCH_DUMMY:
                begin
                    {Branch, PCSrc, PCWrite} = 3'b000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'b00000;
                    nextState = FETCH;
                end
            default:
                begin
                    {Branch, PCSrc, PCWrite} = 3'bxxx;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'bxxxxxx;
                    {ALUSrcA, ALUSrcB, ALUOP} = 5'bxxxxx;
                    nextState = 'hx;
                end
        endcase
    end
    
endmodule