# Five-Stage-Pipelined-CPU-Verilog

This lab introduces the idea of the *pipelining technique* for building a fast CPU. The students will *obtain experience with the design implementation and testing of the first four stages* (Instruction Fetch, Instruction Decode, Instruction Execute, Memory) *of the five-stage pipelined CPU using the Xilinx design package for FPGAs*. It is assumed that students are familiar with the operation of the Xilinx design package for Field Programmable Gate Arrays (FPGAs) through the Xilinix tutorial available in the class website.

1. **Pipelining** - Pipelining is an implementation technique in which multiple instructions are overlapped in execution. The five- stage pipelined CPU allows overlapping execution of multiple instructions. Although an instruction takes five clock cycle to pass through the pipeline, a new instruction can enter the pipeline during every clock cycle. Under ideal circumstances, the pipelined CPU can produce a result in every clock cycle. Because in a pipelined CPU there are multiple operations in each clock cycle, we must save the temporary results in each pipeline stage into pipeline registers for use in the follow-up stages. We have five stages: IF, ID, EXE, MEM, and WB. The PC can be considered as the first pipeline register at the beginning of the first stage. We name the other pipeline registers as IF/ID, ID/EXE, EXE/MEM, and MEM/WB in sequence. In order to understand in depth how the pipelined CPU works, we will show the circuits that are required in each pipeline stage of a baseline CPU.

2. **Circuits of the Instruction Fetch Stage** - The circuit in the IF stage are shown in Figure 2. Also, looking at the first clock cycle in Figure 1(b), the first lw instruction is being fetched. In the IF stage, there is an instruction memory module and an adder between two pipeline registers. The left most pipeline register is the PC; it holds 100. In the end of the first cycle (at the rising edge of clk), the instruction fetched from instruction memory is written into the IF/ID register. Meanwhile, the output of the adder (PC + 4, the next PC) is written into PC.

3. **Circuits of the Instruction Decode Stage** - Referring to Figure 3, in the second cycle, the first instruction entered the ID stage. There are two jobs in the second cycle: to decode the first instruction in the ID stage, and to fetch the second instruction in the IF stage. The two instructions are shown on the top of the figures: the first instruction is in the ID stage, and the second instruction is in the IF stage. The first instruction in the ID stage comes from the IF/ID register. Two operands are read from the register file (Regfile in the figure) based on rs and rt, although the lw instruction does not use the operand in the register rt. The immediate (imm) is sign- extended into 32 bits. The regrt signal is used in the ID stage that selects the destination register number; all others must be written into the ID/EXE register for later use. At the end of the second cycle, all the data and control signals, except for regrt, in the ID stage are written into the ID/EXE register. At the same time, the PC and the IF/ID register are also updated.

4. **Circuits of the Execution Stage** - Referring to Figure 4, (8.5) in the third cycle the first instruction entered the EXE stage. The ALU performs addition, and the multiplexer selects the immediate. A letter “e” is prefixed to each control signal in order to distinguish it from that in the ID stage. The second instruction is being decoded in the ID stage and the third instruction is being fetched in the IF stage. All the four pipeline registers are updated at the end of the cycle.

5. **Circuits of the Memory Access Stage** - Referring to Figure 5, (8.6) in the fourth cycle of the first instruction entered the MEM stage. The only task in this stage is to read data memory. All the control signals have a prefix “m”. The second instruction entered the EXE stage; the third instruction is being decoded in the ID stage; and the fourth instruction is being fetched in the IF stage. All the five pipeline registers are updated at the end of the cycle.

6. **Circuits of the Write Back Stage** - Referring to Figure 6, in the fifth cycle the first instruction entered the WB stage. The memory data is selected and will be written into the register file at the end of the cycle. All the control signal have a prefix “w”. The second instruction entered the MEM stage; the third instruction entered the EXE stage; the fourth instruction is being decoded in the ID stage; and the fifth instruction is being fetched in the IF stage. All the six pipeline registers are updated at the end of the cycle (the destination register is considered as the six pipeline register). Then the first instruction is committed. In each of the forth coming clock cycles, an instruction will be commited and a new instruction will enter the pipeline. We use the structure shown in Figure 1 as a baseline for the design of our pipelined CPU.


Figure 1 Timing chart comparison between two types of CPUs:

<img width="842" alt="Screen Shot 2022-09-21 at 12 42 11" src="https://user-images.githubusercontent.com/81172033/191562787-591e541d-2194-44b8-bc5f-1c09a8d27e59.png">

Figure 2 Pipeline instruction fetch (IF) stage:

<img width="822" alt="Screen Shot 2022-09-21 at 12 42 37" src="https://user-images.githubusercontent.com/81172033/191562874-dbc35d00-98b5-4f1a-98e9-0a5876893d15.png">

Figure 3 Pipeline instruction decode (ID) stage:

<img width="849" alt="Screen Shot 2022-09-21 at 12 42 58" src="https://user-images.githubusercontent.com/81172033/191563014-05e3ae3e-caf2-40ec-a418-076194c5627c.png">

Figure 4 Pipeline execution (EXE) stage:

<img width="882" alt="Screen Shot 2022-09-21 at 12 44 54" src="https://user-images.githubusercontent.com/81172033/191563334-b9935ae1-c2ac-4310-bf1f-28249a8723a7.png">

Figure 5 Pipeline memory access (MEM) stage:

<img width="903" alt="Screen Shot 2022-09-21 at 12 45 23" src="https://user-images.githubusercontent.com/81172033/191563456-77335e7b-ea00-4428-bbcb-d83560c9b4bb.png">

Figure 6 Pipeline write back (WB) stage:

<img width="914" alt="Screen Shot 2022-09-21 at 12 52 03" src="https://user-images.githubusercontent.com/81172033/191564908-34f85346-f075-44bb-b09c-867d895c1dd3.png">


7. Table 1 lists the names and usages of the 32 registers in the register file.
  
<img width="934" alt="Screen Shot 2022-09-21 at 12 53 04" src="https://user-images.githubusercontent.com/81172033/191565107-c33b3f9b-aa09-4cce-b734-a1be836a16df.png">

8. Table 2 lists some MIPS instructions that will be implemented in our CPU

<img width="799" alt="Screen Shot 2022-09-21 at 12 55 28" src="https://user-images.githubusercontent.com/81172033/191565568-4f167c2b-abb3-4e57-9bd6-21306ace0f83.png">

9. Initialize the first 10 words of the Data memory with the following HEX values:
  
    - A00000AA
    - 10000011
    - 20000022
    - 30000033
    - 40000044
    - 50000055 
    - 60000066 
    - 70000077
    - 80000088 
    - 90000099

10. Write a Verilog code that implement the following instructions using the design shown in Figure 6. Write a Verilog test bench to verify your code: (You have to show all the signals written into and out from the MEM/WB register and the inputs to the Regfile block in your simulation outputs).
 
<img width="737" alt="Screen Shot 2022-09-21 at 12 59 20" src="https://user-images.githubusercontent.com/81172033/191566324-e73d8178-6583-4e45-94e3-7a7af2c99fd5.png">

11. Write a report that contains the following:
  + Your Verilog design code. Use: Device: XC7Z010- CLG400 -1 or choose any other FPGA type. You can use Arria II if you are using Quartus II software.
  + Your Verilog® Test Bench design code. Add “`timescale 1ns/1ps” as the first line of your test bench file.
  + The waveforms resulting from the verification of your design with ModelSim showing all the signals
written in and out from the MEM/WB register and the inputs to the Regfile block. 
 + The design schematics from the Xilinx synthesis of your design. Do not use any area constraints.
 + Snapshot of the I/O Planning and
 + Snapshot of the floor planning












