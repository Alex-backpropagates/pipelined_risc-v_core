`timescale 1ns/1ns

module MEM_WB (
    input  logic         clk,
    input  logic         rst_n,            

    input  logic [31:0]  data_mem,   //MEM inputs
    input logic memtoReg_mem,
    input logic regwrite_mem,
    input  logic [31:0]  alu_result_mem,
    input logic [4:0] rd_mem,
    input  logic [31:0]  pc_plus_4_mem,
    input logic jal_mem,
    
    output  logic [31:0]  data_wb,     //WB outputs
    output logic memtoReg_wb,
    output logic regwrite_wb,
    output  logic [31:0]  alu_result_wb,
    output logic [4:0] rd_wb,
    output  logic [31:0]  pc_plus_4_wb,
    output logic jal_wb
);

    always_ff @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            pc_plus_4_wb <= 32'b0;
            data_wb <= 32'b0;
            memtoReg_wb <= 'b0;
            regwrite_wb <= 'b0;
            alu_result_wb <= 32'b0;
            rd_wb <= 'b0;
            jal_wb <= 'b0;

        end else begin
            pc_plus_4_wb <= pc_plus_4_mem;
            data_wb <= data_mem;
            memtoReg_wb <= memtoReg_mem;
            regwrite_wb <= regwrite_mem;
            alu_result_wb <= alu_result_mem;
            rd_wb <= rd_mem;
            jal_wb <= jal_mem;
        end
    end

endmodule