# RISC-V Pipelined core (IF,ID,EX,MEM,WB) with basic RV32I instructions, made in one month

Implemented with Hazard and Forward unit <br />

WORKING RV32I INSTRUCTIONS:
- add/addi
- sub
- and/andi
- or/ori
- xor/xori
- beq
- bne
- sw
- lw
- srl/srli
- sll/slli
- jal/jalr

# Testing the core

To modify the program used by the core, edit the file program.mem

On Linux, by using Verilator and GTKwave, run the following commands :

verilator --binary --trace  risc-v_core_pipelined.sv tb.sv --top tb <br />
OR IF YOU WANT TO TEST THE SINGLE CYCLE CORE : <br />
verilator --binary --trace  risc-v_core_single_cycle.sv tb.sv --top tb <br />

./obj_dir/Vtb <br />

sgtkwave waves.vcd <br />

You can also use Vivado to simulate.

<img width="1188" height="259" alt="image" src="https://github.com/user-attachments/assets/62cdfc85-eedc-480c-acae-7349cd0b92c8" />

# What's next?

I will try to make it useful for AI by adding matrix/vectors operations first


