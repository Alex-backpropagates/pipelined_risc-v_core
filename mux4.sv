/* verilator lint_off MULTIDRIVEN */

`timescale 1ns/1ns

module mux4 #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [WIDTH-1:0] c,
    input  logic [WIDTH-1:0] d,
    input  logic [1:0] p,
    output logic [WIDTH-1:0] r  
);
    always_comb begin
        case (p)
            2'b00: r = a;

            2'b01: r = b;

            2'b10: r = c;

            2'b11: r = d;
            default: r = a;
        endcase
    end

endmodule