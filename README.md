# RISC-V Pipelined core (IF,ID,EX,MEM,WB) with basic RV32I instructions

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

Made for self-education purpose

# Testing the core

To modify the program used by the core, edit the file program.mem

On Linux, by using Verilator and GTKwave, run the following commands :

```verilator --binary --trace  risc-v_core_pipelined.sv tb.sv --top tb <br />```
OR IF YOU WANT TO TEST THE SINGLE CYCLE CORE : <br />
```verilator --binary --trace  risc-v_core_single_cycle.sv tb.sv --top tb <br />```

```./obj_dir/Vtb <br />```

```gtkwave waves.vcd <br />```

You can also use Vivado to simulate.

<img width="1188" height="259" alt="image" src="https://github.com/user-attachments/assets/62cdfc85-eedc-480c-acae-7349cd0b92c8" />

```
00000013  // addi x0, x0, 0   (NOP)
00400093  // addi x1, x0, 4
00800113  // addi x2, x0, 8 
00C00193  // addi x3, x0, 12 

// GOAL : TESTING LOAD HAZARDS 
00A00513  // addi x10, x0, 10 
00A02023  // sw x10, 0(x0)       
00002283  // lw x5, 0(x0)        
00550333  // add x6, x10, x5   


// GOAL : LOOPING THROUGH A COUNTER OF 9 LOOPS
00000013 //NOP
00800513 // addi x10, x0, 8
FFF50513 // addi x10, x10, -1
FEA01F63 // bne x10, x0, -2
06300693 // addi x13, x0, 99 (On the screen you see alu result getting x63 which is d99)
```



# What's next?

I will try to make it useful for AI by adding matrix/vectors operations first


