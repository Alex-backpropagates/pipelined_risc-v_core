/* verilator lint_off UNOPTFLAT */

`timescale 1ns/1ns

module riscv_core (
    input logic clk,
    input logic rst_n,
    output logic [31:0] pc,
    output logic mem_write,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_wdata,
    input logic [31:0] mem_rdata
);

logic [31:0] next_pc =  32'b0;
logic [31:0] current_pc;
logic [31:0] pc_plus_4;
logic [31:0] instr;
logic [31:0] wb;
logic [31:0] data1;
logic [31:0] data2;
logic [31:0] data_mem;




pc_reg pc_reg_i(
    .clk (clk),
    .rst_n (rst_n),
    .stall('b0),
    .next_pc (next_pc),
    .current_pc (current_pc)
);

add add_i1(
    .a(current_pc),
    .b(32'b100),
    .r(pc_plus_4)
);

logic signed [31:0] branched_pc;

logic [31:0] branchorjalpc;

mux mux_i4(
    .a (jal_result),
    .b (alu_result),
    .p(jalr),
    .r (branchorjalpc)
);

mux mux_i5(
    .a (pc_plus_4),
    .b (branchorjalpc),
    .p((branch & condition) || (jal)),
    .r (next_pc)
);


instr_mem instr_mem_i(
    .addr (current_pc),
    .instr (instr)
);

file_register file_register_i(
    .clk(clk),
    .rst_n(rst_n),
    .rs1(instr[19:15]),
    .rs2(instr[24:20]),
    .rd(instr[11:7]),    
    .wd(wb),
    .RegWrite(regWrite),
    .data1(data1),
    .data2(data2)
);

logic [31:0] immediate_value;

mux mux_immediate_format(
    .a ({{20{instr[31]}},instr[31:20]}),
    .b ({{20{instr[31]}}, instr[31:25], instr[11:7]}),
    .p (branch || memWrite),
    .r (immediate_value)
);

logic [31:0] b;

mux mux_reg_or_register( //choosing value from register or from immediate
    .a (data2),
    .b (immediate_value),
    .p(immediate),
    .r (b)
);

logic [2:0] alu_category;
logic [3:0] alu_ctrl;
logic branch;
logic memtoReg;
logic memWrite;
logic immediate;
logic regWrite;
logic jal;
logic jalr;
logic memRead;

control control_i(
    .opcode(instr[6:0]),
    .alu_category(alu_category),
    .branch(branch),
    .memtoReg(memtoReg),
    .memWrite(memWrite),
    .immediate(immediate),
    .regWrite(regWrite),
    .jal(jal),
    .jalr(jalr),
    .memRead(memRead)
);

alu_control alu_control_i(
    .alu_category(alu_category),
    .funct3(instr[14:12]),
    .funct7(instr[31:25]),
    .alu_control(alu_ctrl)
);

logic [31:0] alu_result;
logic condition;
logic zero;
logic sign;
logic carry;

logic [31:0] jal_result;

add add_for_jal(
    .a(pc),
    .b(immediate_value<<1),
    .r(jal_result)
);

alu alu_i(
    .data1(data1),
    .data2(b),
    .alu_control_output(alu_ctrl), 
    .alu_result(alu_result),
    .zero(zero),
    .sign(sign),
    .carry(carry)
);

branch_unit branch_unit_i(
    .funct3(instr[14:12]),
    .zero(zero),
    .sign(sign),
    .carry(carry),
    .branch_condition(condition) 
);

data_memory data_memory_i(
    .clk(clk),
    .rst_n(rst_n),
    .address(alu_result[9:0]),
    .wd(data2),
    .memwrite(memWrite),
    .memread(instr[6:2]== 5'b00000),
    .data(data_mem)
);

mux mux_alu_result_or_data_mem(
    .a (alu_result),
    .b (data_mem),
    .p (memtoReg),
    .r (wb_data)
);

logic [31:0] wb_data;

mux mux_pc_to_save(
    .a (wb_data),
    .b (pc_plus_4),
    .p (jal || jalr),
    .r (wb)
);

always_comb begin
        pc = current_pc;
        mem_addr = alu_result;
        mem_wdata = data2;
        //mem_rdata = data_mem;

    end



endmodule