`timescale 1ns/1ns
module file_register (
    input  logic [4:0] rs1,
    input  logic [4:0] rs2,
    input  logic [4:0] rd,
    input  logic [31:0] wd, //coming from Write Back section
    input  logic RegWrite, //coming from Write Back section
    input  logic rst_n,
    input  logic clk,
    output logic [31:0] data1, //data of rs1
    output logic [31:0] data2  //data of rs2
);

    logic [31:0] rf [0:31];

    always_comb begin
        data1 = rf[rs1];
        data2 = rf[rs2];
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < 8; i = i + 1) rf[i] <= 'b0;
        end
        if (RegWrite) begin
            rf[rd] = wd;
        end
        rf[rd] = wd;
    end

endmodule