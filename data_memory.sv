`timescale 1ns/1ns
module data_memory(
    input logic clk,
    input logic rst_n,
    input  logic [9:0] address, //Is actually the alu result
    input  logic [31:0] wd, //Comes from the "b" value of ALU
    input logic memwrite,
    input logic memread,
    output logic [31:0] data  // The current address (output to memory)
);

    reg [31:0] mem [0:1023];
    
    always_comb begin
        data = mem[address];
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem = '{default: '0};
        end else begin
            if (memwrite) begin
            mem[address] = wd;
            end 
        end
    end

endmodule