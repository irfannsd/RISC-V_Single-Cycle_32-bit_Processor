module Inst_Mem(
    input [31:0] PC,
    output [31:0] instruction
);

reg [31:0] mem [0:1023];

// assign instruction = mem[PC[31:2]];
assign instruction =(PC[31:2] < 1024) ? mem[PC[31:2]] : 32'h00000013;

integer i;

initial begin
    for(i=0;i<1024;i=i+1)
        mem[i] = 32'b0;

    $readmemh("4.instr_mem.hex", mem);
end
endmodule