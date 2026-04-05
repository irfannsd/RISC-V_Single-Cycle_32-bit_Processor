// Program Counter

module program_counter(clk,rst,pc_in,pc_out);

  input clk,rst;
  input [31:0] pc_in;
  output reg [31:0] pc_out;

  always @(posedge clk,posedge rst)
  begin
    if(rst)
      pc_out<={32{1'b0}};
    else
      pc_out<=pc_in;
  end

endmodule
