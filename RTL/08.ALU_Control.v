// ALU Control Unit

module alu_control(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg [3:0] ALUControl
);

always @(*) begin

    case(ALUOp)

        // Load / Store (always ADD)
        2'b00: ALUControl = 4'b0000;

        // Branch (BEQ uses SUB for comparison)
        2'b01: ALUControl = 4'b0001;

        // R-type and I-type
        2'b10: begin

            case(funct3)

                3'b000: begin
                    if(funct7 == 7'b0100000)
                        ALUControl = 4'b0001; // SUB
                    else
                        ALUControl = 4'b0000; // ADD
                end

                3'b111: ALUControl = 4'b0010; // AND

                3'b110: ALUControl = 4'b0011; // OR

                3'b010: ALUControl = 4'b0100; // SLT

                default: ALUControl = 4'b0000;

            endcase

        end

        default: ALUControl = 4'b0000;

    endcase

end

endmodule