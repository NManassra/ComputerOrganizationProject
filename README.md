# ComputerOrganizationProject
The project main idea is to design and implement an accumulator computer 
using Verilog. And as we know the computer consists of a memory module and 
a CPU module. The memory module is implemented as an array of registers 
representing memory cells. The CPU module includes registers such as AC, PC, 
IR, MAR, MBR and an arithmetic and logical unit (ALU) along with a control 
unit.
The CPU module executes instructions stored in memory by fetching them, 
decoding them, and performing the corresponding operations. The given 
instructions have 4 bits for the opcode, 1 for the mode (this one will choose for 
us to deal with the other 11 bits as median or as memory address), and the other 
11 bits which will work as memory address or constant..
For each module, the CPU module. First we divided it into states, and the most 
important point to do this is to solve the delay problem at the clock. At first three 
states we fetch and decode the instruction, and calculate the AC and we get the 
values for the registers (MAR, MBR, IR, PC), and at the fourth state it’s almost 
empty so the delay will be solved. Finally the last state is to determine the flags
(Carry, Zero, Overflow, and Negative) for each case.
The Memory module, first the memory will work as an array of registers, each 
one is a memory cell. The array index works as the memory address. It will work 
depending on the write/read signals. If the read is 1 the data will be sent to the 
CPU, but if write is 1 the data will be written at the memory.
The Whole computer is done schematic, we connected the wires together at the 
block diagram where the read/write from the CPU will be inputs for the memory, 
and the MAR, and MBR will be inputs as the data address and the data in for the 
memory
