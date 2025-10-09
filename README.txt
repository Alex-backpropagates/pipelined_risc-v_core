RISC-V Pipelined core (IF,ID,EX,MEM,WB) with basic RV32I instructions, made in one month

WORKING RV32I INSTRUCTIONS:
add
sub
and
or
xor
beq
bne
sw
lw
srl
sll


To modify the program used by the core, edit the file program.mem

On Linux, by using Verilator and GTKwave, run the following commands :

verilator --binary --trace  risc-v_core_pipelined.sv tb.sv --top tb
OR IF YOU WANT TO TEST THE SINGLE CYCLE CORE :
verilator --binary --trace  risc-v_core_single_cycle.sv tb.sv --top tb 

./obj_dir/Vtb

gtkwave waves.vcd


