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
logic [31:0] instr_if;
logic [31:0] wb;
logic [31:0] data1;
logic [31:0] data2;
logic [31:0] data_mem;

//hazard_unit_wires
logic stall_if;
logic stall_id = 'b0;
logic flush_id;
logic flush_ex;
logic [1:0] forward_a;
logic [1:0] forward_b;

hazard_unit hazard_unit_i(
    .RegWrite_wb(regwrite_wb),
    .RegWrite_mem(regWrite_mem),
    .rst_n(rst_n),
    .clk(clk),
    .rs1_id(instr_id[19:15]),
    .rs2_id(instr_id[24:20]),
    .rs1_ex(rs1_ex),
    .rs2_ex(rs2_ex),
    .rd_ex(rd_ex),
    .rd_mem(rd_mem),
    .rd_wb(rd_wb),
    .branchorjal((branch_ex & condition) || (jal_ex)),
    .memRead_ex(memRead_ex),


    .stall_if(stall_if),
    .stall_id(stall_id),
    .flush_id(flush_id),
    .flush_ex(flush_ex),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

pc_reg pc_reg_i(
    .clk(clk),
    .rst_n(rst_n),
    .stall(stall_if),
    .next_pc(next_pc),
    .current_pc(current_pc)
);



add add_i1(
    .a(current_pc),
    .b(32'b100),
    .r(pc_plus_4)
);

logic signed [31:0] branched_pc;

logic [31:0] branchorjalpc;

mux mux_jalrornot(
    .a (jal_result),
    .b (alu_result_ex),
    .p(jalr_ex),
    .r (branchorjalpc)
);

mux mux_branchingornot(
    .a (pc_plus_4),
    .b (branchorjalpc),
    .p((branch_ex & condition) || (jal_ex)),
    .r (next_pc)
);


instr_mem instr_mem_i(
    .addr (current_pc),
    .instr (instr_if)
);

logic [2:0] alu_category_id;
logic [31:0] instr_id;
logic [31:0] pc_id;
logic [31:0] pc_plus_4_id;

IF_ID if_id(
    .clk(clk),         
    .rst_n(rst_n),
    .flush(flush_id),
    .stall(stall_id),
    .pc_if(current_pc), 
    .pc_plus_4_if(pc_plus_4),
    .instr_if(instr_if), 
    .pc_id(pc_id),
    .pc_plus_4_id(pc_plus_4_id),
    .instr_id(instr_id)
);

file_register file_register_i(
    .clk(clk),
    .rst_n(rst_n),
    .rs1(instr_id[19:15]),
    .rs2(instr_id[24:20]),
    .rd(rd_wb),
    .wd(wb),
    .RegWrite(regwrite_wb),
    .data1(data1),
    .data2(data2)
);

logic [3:0] alu_ctrl;
logic branch_id;
logic memtoReg_id;
logic memWrite_id;
logic immediate_id;
logic regWrite_id;
logic jal_id;
logic jalr_id;
logic memRead_id;

control control_i(
    .opcode(instr_id[6:0]),
    .alu_category(alu_category_id),
    .branch(branch_id),
    .memtoReg(memtoReg_id),
    .memWrite(memWrite_id),
    .immediate(immediate_id),
    .regWrite(regWrite_id),
    .jal(jal_id),
    .jalr(jalr_id),
    .memRead(memRead_id)
);

logic [31:0] immediate_value_id;

mux mux_immediate_format(
    .a ({{20{instr_id[31]}},instr_id[31:20]}),
    .b ({{20{instr_id[31]}}, instr_id[31:25], instr_id[11:7]}),
    .p (branch_id || memWrite_id),
    .r (immediate_value_id)
);

logic [31:0]  pc_plus_4_ex;
logic [31:0]  pc_ex;
logic [4:0]  rs1_ex;
logic [4:0]  rs2_ex;
logic [31:0]  data1_ex;
logic [31:0]  data2_ex;
logic [31:0]  immediate_value_ex;
logic [4:0]  rd_ex;
logic [2:0]  funct3_ex;
logic [6:0]  funct7_ex;
logic [2:0]  alu_category_ex;
logic memtoReg_ex;
logic memWrite_ex;
logic regWrite_ex;
logic immediate_ex;
logic branch_ex;
logic jal_ex;
logic jalr_ex;
logic memRead_ex;

ID_EX id_ex(
    .clk(clk),
    .rst_n(rst_n),          
    .flush(flush_ex),

    .pc_plus_4_id(pc_plus_4_id),          
    .data1_id(data1),
    .data2_id(data2),
    .immediate_value_id(immediate_value_id),
    .rs1_id(instr_id[19:15]),
    .rs2_id(instr_id[24:20]),
    .rd_id(instr_id[11:7]),
    .alu_category_id(alu_category_id),
    .branch_id(branch_id),
    .memtoReg_id(memtoReg_id),
    .memWrite_id(memWrite_id),
    .immediate_id(immediate_id),
    .regWrite_id(regWrite_id),
    .jal_id(jal_id),
    .jalr_id(jalr_id),
    .funct3_id(instr_id[14:12]),
    .funct7_id(instr_id[31:25]),
    .pc_id(pc_id),
    .memRead_id(memRead_id),
    
    .pc_ex(pc_ex),        
    .funct3_ex(funct3_ex),
    .funct7_ex(funct7_ex), 
    .pc_plus_4_ex(pc_plus_4_ex),
    .data1_ex(data1_ex),
    .data2_ex(data2_ex),
    .immediate_value_ex(immediate_value_ex),
    .rs1_ex(rs1_ex),
    .rs2_ex(rs2_ex),
    .rd_ex(rd_ex),
    .alu_category_ex(alu_category_ex),
    .branch_ex(branch_ex),
    .memtoReg_ex(memtoReg_ex),
    .memWrite_ex(memWrite_ex),
    .immediate_ex(immediate_ex),
    .regWrite_ex(regWrite_ex),
    .jal_ex(jal_ex),
    .jalr_ex(jalr_ex),
    .memRead_ex(memRead_ex)
);

mux4 mux_forward_a( //choosing value to forward
    .a (data1_ex),
    .b (wb),
    .c (alu_result_mem),
    .d ('b0),
    .p(forward_a),
    .r (a)
);

logic [31:0] a;

mux4 mux_forward_b( //choosing value to forward
    .a (data2_ex),
    .b (wb),
    .c (alu_result_mem),
    .d ('b0),
    .p(forward_b),
    .r (bb)
);

logic [31:0] bb;

mux mux_i2( //choosing value from register or from immediate
    .a (bb),
    .b (immediate_value_ex),
    .p(immediate_ex),
    .r (b)
);

logic [31:0] b;


alu_control alu_control_i(
    .alu_category(alu_category_ex),
    .funct3(funct3_ex),
    .funct7(funct7_ex),
    .alu_control(alu_ctrl)
);

logic [31:0] alu_result_ex;
logic condition;
logic zero;
logic sign;
logic carry;

logic [31:0] jal_result;

add add_for_jal(
    .a(pc_ex),
    .b(immediate_value_ex<<1),
    .r(jal_result)
);

alu alu_i(
    .data1(a),
    .data2(b),
    .alu_control_output(alu_ctrl), 
    .alu_result(alu_result_ex),
    .zero(zero),
    .sign(sign),
    .carry(carry)
);

branch_unit branch_unit_i(
    .funct3(funct3_ex),
    .zero(zero),
    .sign(sign),
    .carry(carry),
    .branch_condition(condition) 
);

logic [31:0] pc_plus_4_mem;
logic [31:0] data2_mem;
logic [4:0] rd_mem;
logic memtoReg_mem;
logic memWrite_mem;
logic regWrite_mem;
logic memRead_mem;
logic [31:0] alu_result_mem;
logic jal_mem;

EX_MEM ex_mem(
    .clk(clk),            // Clock signal
    .rst_n(rst_n),            // Reset signal

    .alu_result_ex(alu_result_ex),
    .pc_plus_4_ex(pc_plus_4_ex),          
    .rs2_ex(bb),
    .rd_ex(rd_ex),
    .memtoReg_ex(memtoReg_ex),
    .memWrite_ex(memWrite_ex),
    .regWrite_ex(regWrite_ex),
    .memRead_ex(memRead_ex),
    .jal_ex(jal_ex),
    
    .alu_result_mem(alu_result_mem),
    .pc_plus_4_mem(pc_plus_4_mem),
    .rs2_mem(data2_mem),
    .rd_mem(rd_mem),
    .memtoReg_mem(memtoReg_mem),
    .memWrite_mem(memWrite_mem),
    .regWrite_mem(regWrite_mem),
    .memRead_mem(memRead_mem),
    .jal_mem(jal_mem)
);

data_memory data_memory_i(
    .clk(clk),
    .rst_n(rst_n),
    .address(alu_result_mem[9:0]),
    .wd(data2_mem),
    .memwrite(memWrite_mem),
    .memread(memRead_mem),
    .data(data_mem)
);

logic [31:0] pc_plus_4_wb;
logic memtoReg_wb;
logic regwrite_wb;
logic jal_wb;
logic [4:0] rd_wb;
logic [31:0] data_wb;
logic [31:0] alu_result_wb;

MEM_WB mem_wb(
    .clk(clk),            
    .rst_n(rst_n),                      

    .data_mem(data_mem),          
    .memtoReg_mem(memtoReg_mem),
    .regwrite_mem(regWrite_mem),
    .alu_result_mem(alu_result_mem),
    .pc_plus_4_mem(pc_plus_4_mem),
    .jal_mem(jal_mem),
    .rd_mem(rd_mem),

    .data_wb(data_wb),          
    .memtoReg_wb(memtoReg_wb),
    .regwrite_wb(regwrite_wb),
    .alu_result_wb(alu_result_wb),
    .pc_plus_4_wb(pc_plus_4_wb),
    .jal_wb(jal_wb),
    .rd_wb(rd_wb)
);

mux mux_alu_result_or_data_mem(
    .a (alu_result_wb),
    .b (data_wb),
    .p (memtoReg_wb),
    .r (wb_datafrommem)
);

logic [31:0] wb_datafrommem;

mux mux_pc_to_save(
    .a (wb_datafrommem),
    .b (pc_plus_4_wb),
    .p (jal_wb),
    .r (wb)
);

always_comb begin
        pc = current_pc;
        mem_addr = alu_result_mem;
        mem_wdata = data2_mem;
        //mem_rdata = data_mem;

    end



endmodule