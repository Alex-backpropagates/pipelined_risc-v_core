`timescale 1ns/1ns

localparam ALU_ADD  = 4'b0010;
localparam ALU_SUB  = 4'b0110;
localparam ALU_AND  = 4'b0000;
localparam ALU_OR   = 4'b0001;
localparam ALU_XOR  = 4'b0111;
localparam ALU_SLT = 4'b0011;
localparam ALU_SLL = 4'b1100;
localparam ALU_SRL = 4'b0101;
localparam ALU_SRA = 4'b1001;
localparam ALU_SLTU = 4'b0111;

module alu_control (
    input  logic [2:0] alu_category,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [3:0] alu_control 
);
always_comb begin 
        
        case (alu_category)
            3'b000: begin
            case (funct3) // OPERATIONS
                3'b000: case (funct7[5]) // Add and load/store
                            1'b0: alu_control = ALU_ADD; // ADD
                            1'b1: alu_control = ALU_SUB; // SUB
                
                            default:        alu_control = 4'bxxxx;
                        endcase

                3'b100: alu_control = ALU_XOR; // XOR
                3'b110: alu_control = ALU_OR; // OR
                3'b111: alu_control = ALU_AND; // AND
                3'b001: alu_control = ALU_SLL; // SLL
                3'b101: case (funct7[5]) // Add and load/store
                            1'b0: alu_control = ALU_SRL; // SRL
                            1'b1: alu_control = ALU_SRA; // SRA
                
                            default:        alu_control = 4'bxxxx;
                        endcase
                3'b010: alu_control = ALU_SLT; // SLT
                3'b011: alu_control = ALU_SLTU; // SLTU
                
                default:        alu_control = ALU_ADD;
            endcase
            end
            3'b001: begin
            case (funct3) // ADD for store and load
                3'b000: alu_control = ALU_ADD; // ADD
                3'b001: alu_control = ALU_ADD; // ADD
                3'b010: alu_control = ALU_ADD; // ADD

                default:        alu_control = ALU_ADD;
            endcase
            end


            3'b010: begin //branch
            case (funct3) 
                3'b000: alu_control = ALU_SUB; // SUB_ZERO_EQUAL
                3'b001: alu_control = ALU_SUB; // SUB_ZERO_NOT_EQUAL
                3'b010: alu_control = ALU_SUB; // SUB_GREATER
                3'b110: alu_control = ALU_SUB; // SUB_NOT_GREATER
                3'b101: alu_control = ALU_SUB; // SUB_LESS_UNSIGNED
                3'b111: alu_control = ALU_SUB; // SUB_NOT_LESS_UNSIGNED

                default:        alu_control = ALU_SUB;
            endcase
            end 

            3'b011: begin
            case (funct3) // OPERATIONS - IMMEDIATE
                3'b000: alu_control = ALU_ADD;

                3'b100: alu_control = ALU_XOR; // XOR
                3'b110: alu_control = ALU_OR; // OR
                3'b111: alu_control = ALU_AND; // AND
                3'b001: alu_control = ALU_SLL; // SLL
                3'b101: case (funct7[5]) // Add and load/store NOT WORKING
                            1'b0: alu_control = ALU_SRL; // SRL
                            1'b1: alu_control = ALU_SRA; // SRA
                
                            default:        alu_control = 4'bxxxx;
                        endcase
                3'b010: alu_control = ALU_SLT; // SLT
                3'b011: alu_control = ALU_SLTU; // SLTU
                
                default:        alu_control = ALU_ADD;
            endcase
            end

            default: alu_control = 4'b0;
        endcase
end


endmodule

module alu (
    input  logic [31:0] data1,
    input  logic [31:0] data2,
    input  logic [3:0] alu_control_output, 
    output logic [31:0] alu_result,
    output logic        zero,
    output logic        sign,
    output logic        carry

);
always_comb begin
        case (alu_control_output)
            ALU_AND: alu_result = data1 & data2;    
            ALU_OR: alu_result = data1 | data2;   
            ALU_ADD: alu_result = data1 + data2;
            ALU_SUB: alu_result = data1 - data2;    
            ALU_SLT: alu_result = (data1 < data2) ? 32'd1 : 32'd0;
            ALU_XOR: alu_result = (data1 ^ data2);
            ALU_SLL: alu_result = data1 << data2;
            ALU_SRL: alu_result = data1 >> data2;
            default: alu_result = 32'b0;
        endcase
        
        zero = (alu_result == 32'b0);
        sign = alu_result[31];
        carry = (data1<data2);
end


endmodule

