`define STATE_COUNT 20

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
                    output reg [1:0]ALUSrcA,
                    output reg [1:0]ALUSrcB,
                    output wire [3-1:0]ALUControl,
                    output reg Branch_EQ,
                    output reg Branch_NEQ,
                    output reg [1:0]PCSrc,
                    output reg PCWrite                          
                );
reg [6-1:0]Funct;
// assign Funct = currentInstruction[5:0];
wire [6-1:0]OP;
assign OP = currentInstruction[31:26];

reg [1:0]ALUOP;
ALUControl ALUControl_Ins
                (
                    .Funct(Funct),
                    .AluOp(ALUOP),
                    .ALUoperations(ALUControl)
                );


reg [$clog2(`STATE_COUNT)-1:0]presentState, nextState;
parameter IDLE = 0, FETCH = 1, DECODE = 2, MEMADR = 3, MEMREAD = 4, MEMWRITEBACK = 5, MEMWRITE = 6;
parameter EXECUTE = 7, ALUWRITEBACK = 8, BRANCH = 9, JUMP = 11, IMMEDIATE_EXECUTRE = 12, IMMEDIATEWRITEBACK=13;

parameter Branch_EQ_DUMMY = 10; // added by me

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
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = FETCH;
                end
            FETCH: // during FETCH, instruction is fetched and also new PC value is updated with PC+4
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00001;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b001000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000100;
                    Funct = 0;
                    nextState = DECODE;
                end
            DECODE: // during DECODE, just normarl decoding is done in the ALU - changing of state based on OP code
            // and ALU source B is slected to sign extended +4 for Branch_EQ isntruciton
                begin
                    {Branch_EQ,  Branch_NEQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b001100;
                    Funct = 0;
                    if(OP == 6'b100011 || OP == 6'b101011)
                        nextState = MEMADR;
                    else if(OP == 6'b000000)
                        nextState = EXECUTE;
                    else if(OP == 6'b000100 || OP == 6'b000101)
                        nextState = BRANCH;
                    else if(OP == 6'b000010)
                        nextState = JUMP;
                    else if(OP == 6'b001000 || OP == 6'b001100 || OP == 6'b001101) // ADDI, ANDI, ORI
                        nextState = IMMEDIATE_EXECUTRE;
                    else
                        nextState = IDLE;
                end
            MEMADR: // during MEMADR, address of memeory read is generated for lw and sw insturctions, 
                    //-- the sign extended value is added with Register value specified in the instuction
                begin
                    {Branch_EQ,  Branch_NEQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b011000;
                    Funct = 0;
                    if(OP == 6'b100011) // for loading
                        nextState = MEMREAD;
                    else // for storing
                        nextState = MEMWRITE;
                end
            MEMREAD: // drung MEMREAD, the memory valu is read and stored in Data Register after 1 cycle
                begin
                    {Branch_EQ,  Branch_NEQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b100000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = MEMWRITEBACK;
                end
            MEMWRITEBACK: // druing MEMWRITEBACK, the value of data register is written into memory and goes back to FETCH
                begin
                    {Branch_EQ,  Branch_NEQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000011;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = FETCH;
                end
            MEMWRITE: // during MEMWRITE, the value of of write data is written intor the memory into memory
                begin
                    {Branch_EQ,  Branch_NEQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b110000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = FETCH;
                end
            EXECUTE: // for RTYPE, exectuion -- during EXECTUE, the alu operands are selected from reg and operation of arithmetic is given
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    if(currentInstruction[10:6] == 5'b00000) // if r type
                        {ALUSrcA, ALUSrcB, ALUOP} = 6'b010010; // select rs as one of the source
                    else // shift operations
                        {ALUSrcA, ALUSrcB, ALUOP} = 6'b100010; // select rs as one of the source
                    Funct = currentInstruction[5:0];
                    nextState = ALUWRITEBACK;
                end
            ALUWRITEBACK: // during ALU write back, alu out is stored into reg
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000101;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = FETCH;
                end
            BRANCH: // during Branch_EQ, we update the newPC value by checking the equality in the ALU
                begin
                    if(OP[0] == 0)
                        {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b10010;// beq
                    else
                        {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b01010; // bneq
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b010001;
                    Funct = 0;
                    nextState = Branch_EQ_DUMMY;
                end
            Branch_EQ_DUMMY:
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = FETCH;
                end
            JUMP: // compute the new address directly by appending PC'S 4 bit with (immediate address * 4) and have a dummy state
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00101;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = Branch_EQ_DUMMY;
                end
            IMMEDIATE_EXECUTRE: // find the OPERATION OF of A and intermiditate 16-bit constant
            // modified to have funct filed for having multiple operations
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000000;
                    // {ALUSrcA, ALUSrcB, ALUOP} = 6'b011000;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b011010;
                    case (OP)
                        6'b001000: Funct = 6'b100000; // for addi
                        6'b001100: Funct = 6'b100100; // for andi
                        6'b001101: Funct = 6'b100101; // for ori
                        default: Funct = 6'hx;
                    endcase
                    
                    nextState = IMMEDIATEWRITEBACK;
                end
            IMMEDIATEWRITEBACK: // wirte back into RF 
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'b00000;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'b000001;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'b000000;
                    Funct = 0;
                    nextState = FETCH;
                end

            default:
                begin
                    {Branch_EQ,  Branch_NEQ, PCSrc, PCWrite} = 5'bxxxxx;
                    {IorD, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite} = 6'bxxxxxx;
                    {ALUSrcA, ALUSrcB, ALUOP} = 6'bxxxxxx;
                    Funct = 'hx;
                    nextState = 'hx;
                end
        endcase
    end
    
endmodule