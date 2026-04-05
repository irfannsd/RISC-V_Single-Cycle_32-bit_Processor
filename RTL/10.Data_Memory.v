// Data Memory

// Data Memory for RISC-V

module data_memory(
    input clk,
    input MemRead,
    input MemWrite,
    input [31:0] address,
    input [31:0] write_data,
    output [31:0] read_data
);

reg [31:0] memory [0:255];   // 256 words = 1 KB

integer i;

initial begin
    for(i=0;i<256;i=i+1)
        memory[i] = 32'b0;
end

// Write operation (synchronous)
always @(posedge clk) begin
    if (MemWrite)
        memory[address[31:2]] <= write_data;
end

// Read operation (combinational)
assign read_data = (MemRead) ? memory[address[31:2]] : 32'b0;

endmodule