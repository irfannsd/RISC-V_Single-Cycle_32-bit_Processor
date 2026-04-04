// Program Counter Adder

module PC_adder(pc,nxt_pc);
    input clk,rst;
    input  [31:0] pc;
    output [31:0] nxt_pc;

    assign nxt_pc=pc+4;

endmodule

