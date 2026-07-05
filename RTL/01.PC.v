// Program Counter

module PC (
    input clk,              // clock
    input rst,              // synchronous reset (active high)
    input [31:0] pc_nxt,    // next PC value (PC+4 or branch target)
    output reg [31:0] pc,    // current PC value → IMEM address
    output [31:0] pc_plus_4
);

assign pc_plus_4 = pc + 32'd4;

always @(posedge clk ) begin
    if (rst) begin
        pc <= 32'b0 ;      
    end
    else begin
        pc <= pc_nxt ;
    end
end

    
endmodule
