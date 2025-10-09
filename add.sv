`timescale 1ns/1ns

module add #(
    parameter int WIDTH = 32
)(
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH-1:0] r  
);
    always_comb begin
        r = a + b;
    end

endmodule