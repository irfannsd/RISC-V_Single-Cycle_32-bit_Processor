module RiscV_Core (
    input clk,
    input rst
);

    // ----- Program Counter -----
    wire [31:0] pc, pc_plus_4;
    wire [31:0] pc_next;
    PC pc_inst (
        .clk(clk),
        .rst(rst),
        .pc_nxt(pc_next),
        .pc(pc),
        .pc_plus_4(pc_plus_4)
    );

    // ----- Instruction Memory -----
    wire [31:0] inst;
    Inst_Mem imem (
        .PC(pc),
        .instruction(inst)
    );

    // ----- Decode signals -----
    wire [6:0] opcode = inst[6:0];
    wire [4:0] rd     = inst[11:7];
    wire [2:0] funct3 = inst[14:12];
    wire [4:0] rs1    = inst[19:15];
    wire [4:0] rs2    = inst[24:20];
    wire [6:0] funct7 = inst[31:25];

    // ----- Control Unit -----
    wire reg_write, alu_src, mem_read, mem_write, branch, alu_a_sel, jump;
    wire [1:0] wb_sel;
    wire [3:0] alu_op;
    wire [2:0] imm_sel;

    Control_Unit ctrl (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .wb_sel(wb_sel),
        .alu_op(alu_op),
        .imm_sel(imm_sel),
        .alu_a_sel(alu_a_sel)
    );

    // ----- Register File -----
    wire [31:0] rdata1, rdata2, wr_data;
    regfile rf (
        .clk(clk),
        .rst(rst),                     // optional – synchronous reset
        .we(reg_write),
        .waddr(rd),
        .wdata(wr_data),
        .raddr1(rs1),
        .raddr2(rs2),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // ----- Immediate Generator -----
    wire [31:0] imm;
    Immediate_Generate ig (
        .instr(inst),
        .imm_sel(imm_sel),
        .imm(imm)
    );

    // ----- ALU -----
    wire [31:0] alu_b = alu_src ? imm : rdata2;
    wire [31:0] alu_result;
    wire alu_zero, alu_lt, alu_ltu;
    wire [31:0] alu_a = alu_a_sel ? pc : rdata1;

    ALU alu (
        .a(alu_a),
        .b(alu_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(alu_zero),
        .alu_lt(alu_lt),
        .alu_ltu(alu_ltu)
    );

    // ----- Data Memory -----
    wire [31:0] dmem_rdata;
    Data_Memory dmem (
        .clk(clk),
        .we(mem_write),
        .addr(alu_result),
        .wdata(rdata2),
        .funct3(funct3),
        .rdata(dmem_rdata)
    );

    // ----- Branch Unit -----
    wire branch_taken;
    wire [31:0] branch_target;
    Branch_Unit bu (
        .funct3(funct3),
        .zero(alu_zero),
        .alu_lt(alu_lt),
        .alu_ltu(alu_ltu),
        .pc(pc),
        .b_imm(imm),
        .branch_taken(branch_taken),
        .branch_target(branch_target)
    );

    // ----- PC Next Mux -----
    wire [31:0] jal_target  = alu_result ;          // JAL uses PC-relative (pc + imm)
    wire [31:0] jalr_target = alu_result & 32'hFFFFFFFE ; // JALR (rdata1 + imm) & ~32'h1

    wire [31:0] pc_from_branch = (branch & branch_taken) ? branch_target : pc_plus_4;
    wire [31:0] pc_from_jump   = jump ? ( (opcode == 7'b1100111) ? jalr_target : jal_target ) : pc_from_branch;
    assign pc_next = pc_from_jump;

    // ----- Write‑Back Mux (ful  l 4‑way) -----
    reg [31:0] wb_mux_out;
    always @(*) begin
        case (wb_sel)
            2'b00: wb_mux_out = alu_result;       // ALU result
            2'b01: wb_mux_out = dmem_rdata;       // Load data
            2'b10: wb_mux_out = pc_plus_4;        // PC+4 (JAL/JALR)
            2'b11: wb_mux_out = imm;              // U‑type (LUI)
            default: wb_mux_out = 32'b0;
        endcase
    end
    assign wr_data = wb_mux_out;

endmodule

