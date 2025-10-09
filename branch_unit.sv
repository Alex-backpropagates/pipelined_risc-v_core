`timescale 1ns/1ns

module branch_unit (
    input  logic [2:0] funct3,
    input  logic zero,
    input  logic sign,
    input  logic carry,
    output logic branch_condition 
);
always_comb begin
        case (funct3)
            3'b000: branch_condition = zero;
            3'b001: branch_condition = !zero;
            3'b010: branch_condition = sign;
            3'b110: branch_condition = !sign;
            3'b101: branch_condition = carry;
            3'b111: branch_condition = !carry;
            default: branch_condition = 1'b0;
        endcase
end
endmodule