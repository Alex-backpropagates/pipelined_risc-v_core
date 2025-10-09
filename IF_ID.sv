`timescale 1ns/1ns

module IF_ID (
    input  logic         clk,            
    input  logic        rst_n,            
    input  logic        flush,
    input  logic        stall,         

    input  logic [31:0]  pc_if,         //IF plugs
    input logic  [31:0]  pc_plus_4_if,    
    input  logic [31:0]  instr_if, 
    
    output logic  [31:0]  pc_id,          // ID plugs
    output logic  [31:0]  pc_plus_4_id,  
    output logic  [31:0]  instr_id 
);

    always_ff @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            pc_id          <= 32'h0;
            instr_id <= 32'h00000013;
            pc_plus_4_id <= 'b0;
        end else if (flush) begin
            pc_id          <= 32'h0;
            instr_id <= 32'h00000013;
            pc_plus_4_id <= 'b0;
        end else if (stall) begin
            pc_id          <= pc_id;
            instr_id <= instr_id;
            pc_plus_4_id <= pc_plus_4_id;
        end else begin
            pc_id          <= pc_if;
            instr_id <= instr_if;
            pc_plus_4_id <= pc_plus_4_if;
        end
    end

endmodule