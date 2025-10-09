`timescale 1ns/1ns
module pc_reg (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        stall,
    input  logic [31:0] next_pc,    // The next address to go to
    output logic [31:0] current_pc  // The current address (output to instruction memory)
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_pc <= 32'b0;
        end else if (stall) begin
            current_pc <= current_pc;
        end else begin
            current_pc <= next_pc;
        end
    end

endmodule