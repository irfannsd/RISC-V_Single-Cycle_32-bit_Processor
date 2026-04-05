// Control Unit

module Control_Unit(
    input [6:0] opcode,
    
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg Jump,
    output reg [1:0] ALUOp
);

always @(*) begin
    // default values
    RegWrite = 0;
    ALUSrc   = 0;
    MemWrite = 0;
    MemRead  = 0;
    MemtoReg = 0;
    Branch   = 0;
    Jump     = 0;
    ALUOp    = 2'b00;

    case(opcode)

        // R-Type (add, sub, and, or)
        7'b0110011: begin
            RegWrite = 1;
            ALUSrc   = 0;
            ALUOp    = 2'b10;
        end

        // I-Type (addi)
        7'b0010011: begin
            RegWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b10;
        end

        // Load (lw)
        7'b0000011: begin
            RegWrite = 1;
            ALUSrc   = 1;
            MemRead  = 1;
            MemtoReg = 1;
            ALUOp    = 2'b00;
        end

        // Store (sw)
        7'b0100011: begin
            ALUSrc   = 1;
            MemWrite = 1;
            ALUOp    = 2'b00;
        end

        // Branch (beq)
        7'b1100011: begin
            Branch = 1;
            ALUOp  = 2'b01;
        end

        // JAL
        7'b1101111: begin
            Jump     = 1;
            RegWrite = 1;
        end

        // LUI / AUIPC
        7'b0110111,
        7'b0010111: begin
            RegWrite = 1;
        end

        default: begin
            RegWrite = 0;
        end

    endcase


end

endmodule