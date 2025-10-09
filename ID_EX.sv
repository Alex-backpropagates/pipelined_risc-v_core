`timescale 1ns/1ns

module ID_EX (
    input  logic         clk,            // Clock signal
    input  logic         rst_n,            // Reset signal
    input  logic         flush,          // Pipeline flush signal

    input  logic [31:0]  pc_plus_4_id,          
    input  logic [31:0]  data1_id,
    input  logic [31:0]  data2_id,
    input  logic [31:0]  immediate_value_id,
    input  logic [4:0]  rs1_id,
    input  logic [4:0]  rs2_id,
    input  logic [4:0]  rd_id,
    input logic [2:0] alu_category_id,
    input logic branch_id,
    input logic memtoReg_id,
    input logic memWrite_id,
    input logic immediate_id,
    input logic regWrite_id,
    input logic jal_id,
    input logic jalr_id,
    input logic [2:0] funct3_id,
    input logic [6:0] funct7_id,
    input logic [31:0]  pc_id,
    input logic memRead_id,
    
    output logic  [31:0]  pc_ex,          // Program counter to ID stage
    output logic [2:0] funct3_ex,
    output logic [6:0] funct7_ex, // instr to ID stage
    output  logic [31:0]  pc_plus_4_ex,
    output  logic [31:0]  data1_ex,
    output  logic [31:0]  data2_ex,
    output  logic [31:0]  immediate_value_ex,
    output  logic [4:0]  rs1_ex,
    output logic [4:0]  rs2_ex,
    output logic [4:0]  rd_ex,
    output logic [2:0] alu_category_ex,
    output logic branch_ex,
    output logic memtoReg_ex,
    output logic memWrite_ex,
    output logic immediate_ex,
    output logic regWrite_ex,
    output logic jal_ex,
    output logic jalr_ex,
    output logic memRead_ex
);

    always_ff @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            pc_plus_4_ex <= 'b0;
            data1_ex <= 'b0;
            data2_ex <= 'b0;
            immediate_value_ex <= 'b0;
            rs1_ex <= 'b0;
            rs2_ex <= 'b0;
            rd_ex <= 'b0;
            alu_category_ex <= 'b0;
            branch_ex <= 'b0;
            memtoReg_ex <= 'b0;
            memWrite_ex <= 'b0;
            immediate_ex <= 'b0;
            regWrite_ex <= 'b0;
            funct3_ex <= 'b0;
            funct7_ex <= 'b0;
            pc_ex <= 'b0;
            jal_ex <= 'b0;
            jalr_ex <= 'b0;
            memRead_ex <= 'b0;
        end else if (flush) begin
            pc_plus_4_ex <= pc_plus_4_ex;
            data1_ex <= 'b0;
            data2_ex <= 'b0;
            immediate_value_ex <= 'b0;  
            rs1_ex <= 'b0;
            rs2_ex <= 'b0;
            rd_ex <= 'b0;
            alu_category_ex <= 'b0;
            branch_ex <= 'b0;
            memtoReg_ex <= 'b0;
            memWrite_ex <= 'b0;
            immediate_ex <= 'b1;
            regWrite_ex <= 'b0;
            funct3_ex <= 'b0;
            funct7_ex <= 'b0;
            pc_ex <= pc_ex;
            jal_ex <= 'b0;
            jalr_ex <= 'b0;
            memRead_ex <= 'b0;
        end
        
        else begin
            pc_plus_4_ex <= pc_plus_4_id;
            data1_ex <= data1_id;
            data2_ex <= data2_id;
            immediate_value_ex <= immediate_value_id;  
            rs1_ex <= rs1_id;
            rs2_ex <= rs2_id;
            rd_ex <= rd_id;
            alu_category_ex <= alu_category_id;
            branch_ex <= branch_id;
            memtoReg_ex <= memtoReg_id;
            memWrite_ex <= memWrite_id;
            immediate_ex <= immediate_id;
            regWrite_ex <= regWrite_id;
            funct3_ex <= funct3_id;
            funct7_ex <= funct7_id;
            pc_ex <= pc_id;
            jal_ex <= jal_id;
            jalr_ex <= jalr_id;
            memRead_ex <= memRead_id;
        end
    end

endmodule