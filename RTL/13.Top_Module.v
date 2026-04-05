`include "1.PC.v"
`include "2.PC_adder.v"
`include "3.inst_mem.v"
`include "5.Register.v"
`include "6.Immediate_Generate.v"
`include "7.Control_Unit.v"
`include "8.ALU_Control.v"
`include "9.ALU.v"
`include "10.Data_Memory.v"
`include "11.Multiplexer.v"
`include "12.PC_Branch_target.v"

module Top_Module(clk,rst);


    input clk,rst;

    wire [31:0] PC, PC_nxt, PC_Plus4, branch_target ;


    wire [31:0] instruction, ImmExt;

    wire [31:0] ReadData1, ReadData2;

    wire [31:0] ALU_B, ALUResult;

    wire [31:0] MemData, WriteBack;

    wire [3:0] ALUControl;
    wire [1:0] ALUOp;

    wire RegWrite;
    wire ALUSrc;
    wire MemRead;
    wire MemWrite;
    wire MemtoReg;
    wire Branch;
    wire Zero;
    wire PCSrc;


    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = instruction[6:0];
    assign rd     = instruction[11:7];
    assign funct3 = instruction[14:12];
    assign rs1    = instruction[19:15];
    assign rs2    = instruction[24:20];
    assign funct7 = instruction[31:25];





    reg [31:0] instr_count;

    always @(posedge clk or posedge rst) begin
        if (rst)
            instr_count <= 0;
        else
            instr_count <= instr_count + 1;
    end



    // PC
    program_counter pc(.clk(clk), .rst(rst), .pc_in(PC_nxt), .pc_out(PC));

    // Instruction Memory
    Inst_Mem Inst_mem (.PC(PC), .instruction(instruction));

    // PC +4
    PC_adder pc_adder(.pc(PC),.pcPlus4(PC_Plus4));

    // Immediate Generator
    Immediate_Generate Imm_gen(.opcode(instruction[6:0]), .instruction(instruction), .ImmExt(ImmExt));

    // Control Unit
    Control_Unit Control_Unit (.opcode(opcode), .Branch(Branch), .MemRead(MemRead), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .ALUOp(ALUOp));

    // Register File
    reg_file reg_file(.clk(clk),.rst(rst),.reg_write(RegWrite),.rs1(rs1),.rs2(rs2),.rd(rd),.write_data(WriteBack),.read_data1(ReadData1),.read_data2(ReadData2));

    // ALU Control
    alu_control alu_control(.ALUOp(ALUOp), .funct3(funct3), .funct7(funct7), .ALUControl(ALUControl));

    // ALU Source MUX
    Multiplexer alu_source_mux(.A(ReadData2),.B(ImmExt),.sel(ALUSrc),.out(ALU_B));

    // ALU
    alu alu( .A(ReadData1), .B(ALU_B), .ALUControl(ALUControl), .Result(ALUResult), .Zero(Zero));

    // Data Memory
    data_memory data_mem ( .clk(clk), .MemRead(MemRead), .MemWrite(MemWrite), .address(ALUResult), .write_data(ReadData2), .read_data(MemData));

    // Writeback MUX
    Multiplexer mem_to_reg_mux(.A(ALUResult),.B(MemData),.sel(MemtoReg),.out(WriteBack));

    // Branch Target
    branch_adder branch_adder(.pc(PC),.imm(ImmExt),.branch_target(branch_target));

    // Branch Decision
    assign PCSrc = Branch & Zero;

    // PC MUX
    Multiplexer pc_mux(.A(PC_Plus4),.B(branch_target),.sel(PCSrc),.out(PC_nxt));


endmodule