module Inst_Mem(
    input [31:0] PC,
    output [31:0] instruction
);

reg [31:0] mem [0:1023];

assign instruction = mem[PC[31:2]];

initial begin
    $readmemh("instr_mem.hex", mem);
end

endmodule