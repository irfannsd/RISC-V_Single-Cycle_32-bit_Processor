
`timescale 1ns/1ps

`include "13.Top_Module.v"

module tb_riscv;

reg clk;
reg rst;

////////////////////////////////////////////////
// Instruction Counter
////////////////////////////////////////////////
integer instr_count;

////////////////////////////////////////////////
// Instantiate CPU
////////////////////////////////////////////////
Top_Module uut(
    .clk(clk),
    .rst(rst)
);

////////////////////////////////////////////////
// Clock
////////////////////////////////////////////////
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

////////////////////////////////////////////////
// Reset
////////////////////////////////////////////////
initial begin
    rst = 1;
    instr_count = 0;
    #20;
    rst = 0;
end

////////////////////////////////////////////////
// Waveform dump
////////////////////////////////////////////////
initial begin
    $dumpfile("riscv.vcd");
    $dumpvars(0,tb_riscv);
end

////////////////////////////////////////////////
// Execution Monitor
////////////////////////////////////////////////
initial begin
    $display("-------------------------------------------------------------------------------");
    $display("Time      PC        Instr        ALU        x1      x2      x3      x4");
    $display("-------------------------------------------------------------------------------");

    $monitor("%0t   %h   %h   %h   %h   %h   %h   %h",
        $time,
        uut.PC,
        uut.instruction,
        uut.ALUResult,
        uut.reg_file.register[1],
        uut.reg_file.register[2],
        uut.reg_file.register[3],
        uut.reg_file.register[4]
    );
end

////////////////////////////////////////////////
// Instruction Counter + NOP Detection
////////////////////////////////////////////////
always @(posedge clk) begin

    if(!rst)
        instr_count = instr_count + 1;

    // Stop when NOP encountered
    if(uut.instruction == 32'h00000013) begin

        $display("\n===============================");
        $display("NOP detected - Program finished");
        $display("===============================");

        $display("\nInstructions executed = %0d", instr_count);

        $display("\nFINAL REGISTER VALUES");
        $display("x1 = %h", uut.reg_file.register[1]);
        $display("x2 = %h", uut.reg_file.register[2]);
        $display("x3 = %h", uut.reg_file.register[3]);
        $display("x4 = %h", uut.reg_file.register[4]);
        $display("x5 = %h", uut.reg_file.register[5]);

        $display("\nMEMORY STATE");
        $display("mem[0] = %h", uut.data_mem.memory[0]);
        $display("mem[1] = %h", uut.data_mem.memory[1]);

        $finish;
    end

end

endmodule