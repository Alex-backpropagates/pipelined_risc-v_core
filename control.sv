`timescale 1ns/1ns

module control (
    input  logic [6:0] opcode,
    output logic [2:0] alu_category,
    output logic branch,
    output logic memtoReg,
    output logic memWrite,
    output logic immediate,
    output logic regWrite,
    output logic jal,
    output logic jalr,
    output logic memRead
);
always_comb begin
        
        case (opcode[6:0])
            7'b0110011: begin //logic
            alu_category = 3'b000;
            branch = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            immediate = 1'b0;
            regWrite = 1'b1;
            jal = 1'b0;
            jalr = 1'b0;
            memRead = 1'b0;
            end
            7'b0010011: begin
            alu_category = 3'b011; //logic-imm
            branch = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            immediate = 1'b1;
            regWrite = 1'b1;
            jal = 1'b0;
            jalr = 1'b0;
            memRead = 1'b0;
            end

            7'b0100011: begin //store
            alu_category = 3'b001;
            branch = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b1;
            immediate = 1'b1;
            regWrite = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            memRead = 1'b0;
            end

            7'b0000011: begin //load
            alu_category = 3'b001;
            branch = 1'b0;
            memtoReg = 1'b1;
            memWrite = 1'b0;
            immediate = 1'b0;
            regWrite = 1'b1;
            jal = 1'b0;
            jalr = 1'b0;
            memRead = 1'b1;
            end

            7'b1100011: begin //branch
            alu_category = 3'b010;
            branch = 1'b1;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            immediate = 1'b0;
            regWrite = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            memRead = 1'b0;
            end

            7'b1101111: begin //jal
            alu_category = 3'b001;
            branch = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            immediate = 1'b1;
            regWrite = 1'b0;
            jal = 1'b1;
            jalr = 1'b0;
            memRead = 1'b0;
            end

            7'b1100111: begin //jalr
            alu_category = 3'b001;
            branch = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            immediate = 1'b1;
            regWrite = 1'b0;
            jal = 1'b0;
            jalr = 1'b1;
            memRead = 1'b0;
            end

            default: begin alu_category = 3'b0;
            branch = 1'b0;
            memtoReg = 1'b0;
            memWrite = 1'b0;
            immediate = 1'b0;
            regWrite = 1'b0;
            jal = 1'b0;
            jalr = 1'b0;
            memRead = 1'b0;
            end
        endcase
end


endmodule