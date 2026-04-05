// Multiplexer

module Multiplexer(A,B,sel,out);

    input sel;
    input [31:0] A,B;
    output [31:0] out;

    assign out = (sel) ? B:A;

endmodule