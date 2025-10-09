`timescale 1ns/1ns

module add_sign #(
    parameter int WIDTH = 32
)(
    input  logic signed [WIDTH-1:0] a,
    input  logic signed [WIDTH-1:0] b,
    output logic signed [WIDTH-1:0] r  
);
    always_comb begin
        r = a + b;
    end

endmodule