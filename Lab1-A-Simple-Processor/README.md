# Lab 1: A Simple Processor

This project implements a 16-bit simple processor using Verilog. Below is an overview of the repository structure, functionality, and instructions for usage.

## **Files Overview**
- **proc.v**: Contains the Verilog code for the simple processor described in the lab.
- **part2.v**: Top-level Verilog module for connecting the processor to a memory module and counter.
- **inst_mem.v**: Verilog implementation of a 32 x 16 synchronous read-only memory (ROM).
- **inst_mem.mif**: Memory Initialization File (MIF) for ROM, containing test instructions.
- **testbench.v**: Verilog testbench for simulating the processor functionality.
- **testbench.tcl**: ModelSim simulation script for automated testing.
- **wave.do**: Waveform configuration file for visualizing simulation results.

## **Functionality**
The processor supports the following instructions:

- **mv rX, Op2**: Move value `Op2` (register or immediate) into register `rX`.
- **mvt rX, #D**: Move immediate data to the most significant byte of `rX`.
- **add rX, Op2**: Add `Op2` (register or immediate) to `rX`.
- **sub rX, Op2**: Subtract `Op2` (register or immediate) from `rX`.

The processor executes instructions provided in a 16-bit format, loaded via ROM.

## **Usage Instructions**

### **Simulation**
1. Use **ModelSim** or **DESim** to simulate the processor.
2. Load `testbench.v` and execute the simulation script `testbench.tcl`.
3. Visualize waveform results using the `wave.do` configuration file.

### **Synthesis on FPGA**
1. Open the **Quartus project**: `part2.qpf`.
2. Compile the design and program it onto an FPGA (e.g., **DE1-SoC**).
3. Use switches and LEDs to control and observe processor behavior.

### **Customizing ROM**
1. Edit the **inst_mem.mif** file to modify instructions in the ROM.
2. Recompile the design to reflect the changes.

## **Examples**

To load `r0` with 28 and compute its 2's complement:

```verilog
mv r0, #28
mvt r1, #0xFF00
add r1, #0x00FF
sub r1, r0
add r1, #1
```

These instructions are encoded in the provided inst_mem.mif.

## **References**
- [DeSim Tutorial](./DESim_Tutorial.pdf)
- [Lab 1 Handout](Lab1_Handout.pdf)
