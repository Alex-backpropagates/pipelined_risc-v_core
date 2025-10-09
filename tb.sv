`timescale 1ns/1ns

module tb;

    logic clk;
    logic rst_n;
    logic [31:0] pc;
    logic mem_write;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata;

    riscv_core dut(
    .clk(clk),
    .rst_n(rst_n),
    .pc(pc),
    .mem_write(mem_write),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_rdata(mem_rdata)
    );


    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, testbench); 
    end

    initial begin
        clk = 0;
        $display("Time %0t: internal_counter = %d (Decimal)", $time, mem_addr);
        forever #20 clk = ~clk;  //(20ns period)
        #100
        $display("Time %0t: internal_counter = %d (Decimal)", $time, mem_addr);
    end

    initial begin
        rst_n = 0;           // Assert reset
        #100 rst_n = 1;      // Deassert after 100ns
        #5000 $finish; //finish run time
    end



endmodule