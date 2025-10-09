`timescale 1ns/1ns
module EX_MEM (
    input  logic         clk,            
    input  logic         rst_n,           

    input  logic [31:0]  pc_plus_4_ex,          
    input  logic [31:0]  rs2_ex,
    input  logic [4:0]  rd_ex,
    input logic memtoReg_ex,
    input logic memWrite_ex,
    input logic regWrite_ex,
    input logic [31:0]  alu_result_ex,
    input logic memRead_ex,
    input logic jal_ex,
    
    output  logic [31:0]  pc_plus_4_mem,          
    output  logic [31:0]  rs2_mem,
    output  logic [4:0]  rd_mem,
    output logic memtoReg_mem,
    output logic memWrite_mem,
    output logic regWrite_mem,
    output logic [31:0]  alu_result_mem,
    output logic memRead_mem,
    output logic jal_mem
);

    always_ff @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin     
            pc_plus_4_mem <= 'b0;          
            rs2_mem <= 'b0;
            rd_mem <= 'b0;
            memtoReg_mem <= 'b0;
            memWrite_mem <= 'b0;
            regWrite_mem <= 'b0;
            alu_result_mem <= 'b0;
            memRead_mem <= 'b0;
            jal_mem <= 'b0;

        end else begin      

            pc_plus_4_mem <= pc_plus_4_ex;          
            rs2_mem <= rs2_ex;
            rd_mem <= rd_ex;
            memtoReg_mem <= memtoReg_ex;
            memWrite_mem <= memWrite_ex;
            regWrite_mem <= regWrite_ex;
            alu_result_mem <= alu_result_ex;
            memRead_mem <= memRead_ex;
            jal_mem <= jal_ex;
        end
    end

endmodule