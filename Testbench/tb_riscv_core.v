// `timescale 1ns/1ps

// module tb_riscv_core;

//     reg clk;
//     reg rst;

//     // Instantiate DUT
//     RiscV_Core dut (
//         .clk(clk),
//         .rst(rst)
//     );

//     // Clock Generation
//     initial begin
//         clk = 0;
//         forever #5 clk = ~clk;
//     end

//     // Reset
//     initial begin
//         rst = 1;
//         #20;
//         rst = 0;
//     end

//     // Load Program
//     initial begin
//         $readmemh("program.hex", dut.imem.mem);
//     end

//     // Waveform Dump
//     initial begin
//         $dumpfile("tb_riscv_core.vcd");
//         $dumpvars(0, tb_riscv_core);
//     end

//     // End Simulation
//     initial begin
//         #400;

//         $display("\n==============================");
//         $display("Simulation Results");
//         $display("==============================");
//         $display("x1 = %0d", dut.rf.regs[1]);
//         $display("x2 = %0d", dut.rf.regs[2]);
//         $display("x3 = %0d", dut.rf.regs[3]);
//         $display("mem[0] = %0d", dut.dmem.mem[0]);
//         $display("PC = %h", dut.pc);

//         if (dut.dmem.mem[0] == 15)
//             $display("\n******** TEST PASSED ********");
//         else
//             $display("\n******** TEST FAILED ********");

//         $finish;
//     end

// endmodule



`timescale 1ns/1ps

module tb_riscv_core;

    reg clk;
    reg rst;

    //=========================================================
    // DUT
    //=========================================================
    RiscV_Core dut(
        .clk(clk),
        .rst(rst)
    );

    //=========================================================
    // Clock
    //=========================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //=========================================================
    // Reset
    //=========================================================
    initial begin
        rst = 1;
        #20;
        rst = 0;
    end

    //=========================================================
    // Waveform
    //=========================================================
    initial begin
        $dumpfile("Waveforms/tb_riscv_core.vcd");
        $dumpvars(0, tb_riscv_core);
    end

    //=========================================================
    // Execution Monitor
    //=========================================================
    always @(posedge clk) begin
        if(!rst) begin
            $display("----------------------------------------------------");
            $display("Time = %0t", $time);
            $display("PC   = %h", dut.pc);
            $display("INST = %h", dut.inst);
        end
    end

    //=========================================================
    // PASS / FAIL CHECK
    //=========================================================
    initial begin

        // Wait until CPU reaches the final infinite loop
        wait(dut.pc == 32'h00000054);

        // Wait one more clock cycle
        #20;

        $display("");
        $display("===============================================");
        $display("        RV32I Verification Report");
        $display("===============================================");

        // ADDI
        if(dut.rf.regs[1] == 10)
            $display("PASS : ADDI x1");
        else
            $display("FAIL : ADDI x1");

        if(dut.rf.regs[2] == 20)
            $display("PASS : ADDI x2");
        else
            $display("FAIL : ADDI x2");

        // ADD
        if(dut.rf.regs[3] == 30)
            $display("PASS : ADD");
        else
            $display("FAIL : ADD");

        // SUB
        if(dut.rf.regs[4] == 10)
            $display("PASS : SUB");
        else
            $display("FAIL : SUB");

        // AND
        if(dut.rf.regs[5] == 0)
            $display("PASS : AND");
        else
            $display("FAIL : AND");

        // OR
        if(dut.rf.regs[6] == 30)
            $display("PASS : OR");
        else
            $display("FAIL : OR");

        // XOR
        if(dut.rf.regs[7] == 30)
            $display("PASS : XOR");
        else
            $display("FAIL : XOR");

        // SLT
        if(dut.rf.regs[8] == 1)
            $display("PASS : SLT");
        else
            $display("FAIL : SLT");

        // SLL
        if(dut.rf.regs[10] == 1024)
            $display("PASS : SLL");
        else
            $display("FAIL : SLL");

        // SRL
        if(dut.rf.regs[11] == 512)
            $display("PASS : SRL");
        else
            $display("FAIL : SRL");

        // LW
        if(dut.rf.regs[12] == 30)
            $display("PASS : LW 0");
        else
            $display("FAIL : LW 0");

        if(dut.rf.regs[13] == 10)
            $display("PASS : LW 4");
        else
            $display("FAIL : LW 4");

        // Branch
        if(dut.rf.regs[14] == 0)
            $display("PASS : BEQ");
        else
            $display("FAIL : BEQ");

        // JAL
        if(dut.rf.regs[15] == 32'h00000048)
            $display("PASS : JAL");
        else begin
            $display("FAIL : JAL");
            $display("Expected : 00000048");
            $display("Actual   : %h", dut.rf.regs[15]);
        end

        // JAL Skip
        if(dut.rf.regs[16] == 0)
            $display("PASS : JAL Skip");
        else
            $display("FAIL : JAL Skip");

        // LUI
        if(dut.rf.regs[17] == 32'h12345000)
            $display("PASS : LUI");
        else
            $display("FAIL : LUI");

        // AUIPC
        if(dut.rf.regs[18] == 32'h00000050)
            $display("PASS : AUIPC");
        else begin
            $display("FAIL : AUIPC");
            $display("Expected : 00000050");
            $display("Actual   : %h", dut.rf.regs[18]);
        end

        // Memory Check
        if({dut.dmem.mem[3],dut.dmem.mem[2],dut.dmem.mem[1],dut.dmem.mem[0]} == 32'd30)
            $display("PASS : SW MEM[0]");
        else
            $display("FAIL : SW MEM[0]");

        if({dut.dmem.mem[7],dut.dmem.mem[6],dut.dmem.mem[5],dut.dmem.mem[4]} == 32'd10)
            $display("PASS : SW MEM[4]");
        else
            $display("FAIL : SW MEM[4]");

        $display("");
        $display("===============================================");
        $display(" Verification Finished");
        $display("===============================================");

        $finish;

    end

    //=========================================================
    // Timeout Protection
    //=========================================================
    initial begin
        #1000;

        $display("");
        $display("===============================================");
        $display("TIMEOUT!");
        $display("CPU did not reach the final instruction.");
        $display("Current PC = %h", dut.pc);
        $display("===============================================");

        $finish;
    end

    initial begin

    rst = 1;
    #20;
    rst = 0;

    // Wait long enough for the program to finish
    #400;

    $display("========================");
    $display("Verification Results");
    $display("========================");

    // Your PASS/FAIL checks go here

    $finish;

end

endmodule