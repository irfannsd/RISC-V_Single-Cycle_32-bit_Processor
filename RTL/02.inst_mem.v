module Inst_Mem #(
    parameter DEPTH = 256
)(
    input  [31:0] PC,            // Byte address from Program Counter
    output [31:0] instruction    // 32-bit instruction
);

    // Instruction memory (DEPTH words)
    reg [31:0] mem [0:DEPTH-1];

    // RISC-V NOP instruction (ADDI x0, x0, 0)
    localparam NOP = 32'h00000013;

    // Convert byte address to word address (PC >> 2)
    assign instruction = (PC[31:2] < DEPTH) ? mem[PC[31:2]] : NOP;

    integer i;

    initial begin
        // Initialize all memory locations to NOP
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = NOP;

        // Load program from hex file
        $readmemh("program.hex", mem);
    end

endmodule
