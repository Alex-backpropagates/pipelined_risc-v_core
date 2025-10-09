`timescale 1ns/1ns
module hazard_unit (
    input  logic RegWrite_mem,
    input  logic RegWrite_wb,
    input  logic rst_n,
    input  logic clk,
    input  logic [4:0] rs1_ex,
    input  logic [4:0] rs2_ex,
    input  logic [4:0] rs1_id,
    input  logic [4:0] rs2_id,
    input  logic [4:0] rd_ex,
    input  logic [4:0] rd_mem,
    input  logic [4:0] rd_wb,
    input  logic branchorjal,
    input  logic memRead_ex,

    output logic stall_if,
    output logic stall_id,
    output logic flush_id,
    output logic flush_ex,
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    logic hazard_ALU_MEM_a;
    logic hazard_ALU_MEM_b;
    logic hazard_ALU_WB_a;
    logic hazard_ALU_WB_b;
    logic hazard_load_a;
    logic hazard_load_b;

    always_comb begin
        hazard_ALU_MEM_a = (rs1_ex == rd_mem) && RegWrite_mem;
        hazard_ALU_MEM_b = (rs2_ex == rd_mem) && RegWrite_mem;
        hazard_ALU_WB_a = (rs1_ex == rd_wb) && (RegWrite_wb);
        hazard_ALU_WB_b = (rs2_ex == rd_wb) && (RegWrite_wb);
        hazard_load_a = (rs1_id == rd_ex) && memRead_ex;
        hazard_load_b = (rs2_id == rd_ex) && memRead_ex;

        if (!rst_n) begin
            stall_if = 'b0;
            stall_id = 'b0;
            flush_id = 'b0;
            flush_ex = 'b0;
            forward_a = 'b0;
            forward_b = 'b0;
        end

        if (hazard_ALU_MEM_a) begin //forward the correct value in the ALU if there is an hazard (for a)
            forward_a = 2'b10;
        end
        else if (hazard_ALU_WB_a) begin
            forward_a = 2'b01;
        end 
        else begin
            forward_a = 2'b00;
        end

        if (hazard_ALU_MEM_b) begin //forward the correct value in the ALU if there is an hazard (for b)
            forward_b = 2'b10;
        end
        else if (hazard_ALU_WB_b) begin
            forward_b = 2'b01;
        end
        else begin
            forward_b = 2'b00;
        end

        
        if (branchorjal) begin //if branching, flush the instruction that should not be executed
            flush_id = 'b1;
        end
        else begin
            flush_id = 'b0;
        end


        if (hazard_load_a || hazard_load_b) begin //stalling if trying to get register that hasn't been loaded yet
            stall_if = 'b1;
            stall_id = 'b1;
        end
        else begin 
            stall_if = 'b0;
            stall_id = 'b0;
        end

        if (hazard_load_a || hazard_load_b || branchorjal) begin //flush this anyway
            flush_ex = 'b1;
        end
        else begin 
            flush_ex = 'b0;
        end


    end

endmodule