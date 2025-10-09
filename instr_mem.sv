`timescale 1ns/1ns
module instr_mem (
    input  logic [31:0] addr,
    output logic [31:0] instr
);
    localparam MEM_SIZE = 256;

    logic [31:0] rom [0:MEM_SIZE-1];

    initial begin
        $display("Loading instruction memory...");
        $readmemh("program.mem", rom);
    end

    always_comb begin
        instr = rom[addr[9:2]]; 
    end

endmodule