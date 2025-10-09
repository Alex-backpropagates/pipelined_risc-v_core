/* verilator lint_off MULTIDRIVEN */

`timescale 1ns/1ns

module mux #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic p,
    output logic [WIDTH-1:0] r  
);
    always_comb begin
        r = a;
        if (p) begin
            r = b;
        end
    end

endmodule