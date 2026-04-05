// Registee file 

module reg_file(clk,rst,reg_write,rs1,rs2,rd,write_data,read_data1,read_data2);

    input clk,rst,reg_write;
    input [4:0] rs1,rs2,rd;
    input [31:0] write_data;
    output [31:0] read_data1,read_data2;

    reg [31:0] register [0:31];
    integer i;

    always @(posedge clk or posedge rst) begin
        if(rst)begin
            for (i = 0; i<32; i=i+1) begin
                register[i] <= 32'b0;
            end
        end
        else begin
            if (reg_write && rd!=5'b00000) begin
                register[rd]<=write_data;
            end
        end
    end

    assign read_data1 = (rs1 == 0) ? 32'b0 : register[rs1];
    assign read_data2 = (rs2 == 0) ? 32'b0 : register[rs2];

endmodule 

