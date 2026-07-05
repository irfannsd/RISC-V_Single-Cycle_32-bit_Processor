//Register file 


module Register (
    input  wire        clk,
    input  wire        rst,        // Active-high synchronous reset
    input  wire        we,         // Write enable
    input  wire [4:0]  waddr,      // Write address (rd)
    input  wire [31:0] wdata,      // Write data
    input  wire [4:0]  raddr1,     // Read address 1 (rs1)
    input  wire [4:0]  raddr2,     // Read address 2 (rs2)
    output wire [31:0] rdata1,     // Read data 1
    output wire [31:0] rdata2      // Read data 2
);

    // 32 × 32-bit register file
    reg [31:0] regs [0:31];
    integer i;

    // Power-on initialisation
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    // Synchronous write and reset
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end
        else if (we && (waddr != 5'd0)) begin
            regs[waddr] <= wdata;
        end
    end

    // Asynchronous read ports
    assign rdata1 = (raddr1 == 5'd0) ? 32'b0 : regs[raddr1];
    assign rdata2 = (raddr2 == 5'd0) ? 32'b0 : regs[raddr2];

endmodule

