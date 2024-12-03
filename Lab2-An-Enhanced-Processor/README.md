# Lab 2 - An Enhanced Processor

## Overview
This project is part of a lab exercise to design and extend the capabilities of a simple processor. The goal is to enhance the processor so that it supports new instructions, can execute read and write operations with memory or other devices, and connect to peripherals like LEDs and seven-segment displays. This project is implemented in Verilog and tested using ModelSim and the DE1-SoC board.

## Features

### **Processor Enhancements:**
- Addition of `ld` (load), `st` (store), `and` (bitwise AND), and `b{cond}` (conditional branch) instructions.
- Replacement of an external counter with an internal program counter (`r7`).
- Addressing and execution of instructions from memory.

### **Peripheral Interfacing:**
- Connection to a 16x256 synchronous SRAM memory unit.
- Interaction with output LEDs and switches.
- Driving seven-segment displays for numerical outputs.

### **Testing and Simulation:**
- Includes test programs to validate new instruction implementations.
- ModelSim simulation setup files and a preconfigured DE1-SoC project environment.

## Project Files

### **Source Code:**
- **proc.v**: Core processor Verilog implementation.
- **part3.v, part4.v, seg7.v**: Top-level modules for different stages of enhancement.
- **flipflop.v, inst_mem.v**: Supporting Verilog modules.

### **Memory Initialization:**
- **inst_mem.mif**: Memory image for test programs.

### **Testbenches:**
- ModelSim testbench and setup files for simulation.

### **Assembler:**
- **sbasm.py**: Python-based assembler for the processor’s assembly language.

### **Quartus Project Files:**
- **part3.qpf, part3.qsf, part4.qpf, part4.qsf**: Quartus project configuration for DE1-SoC.

## Instructions

### **Setting Up the Environment**
1. Install **ModelSim** for simulation.
2. Install **Python 3** to use the `sbasm.py` assembler.
3. Optionally, set up **Quartus Prime** software for DE1-SoC board development.

### **Simulating the Processor**
1. Open the **ModelSim project** and load the provided testbench.
2. Compile the Verilog files.
3. Run the simulation and observe signals to verify functionality.

### **Using the Assembler**
1. Write your program in assembly language (see examples in the document).
2. Use `sbasm.py` to convert assembly code into machine code:
   
   ```bash
   python sbasm.py <input.asm> -o inst_mem.mif
   ```
4. Replace the generated inst_mem.mif in your simulation environment.

### **Deploying to DE1-SoC Board**
1. Compile the project in Quartus Prime.
2. Update the memory initialization file using inst_mem.mif and generate the programming file.
3. Program the DE1-SoC board and run your design.

### **Key Test Scenarios**
- LD and ST Instructions: Validate memory read/write operations using switches and LEDs.
- AND Instruction: Test bitwise AND operations with immediate and register operands.
- Branching Instructions: Test conditional and unconditional branching.
- Seven-Segment Displays: Verify correct digit display and counting functionality.

### **Additional Resources**
- Simulation Tools: ModelSim and DESim for functional validation.
- Development Board: DE1-SoC for physical hardware testing.
- [DESim Tutorial](./DESim_Tutorial.pdf)
- [Lab 2 Handout](./Lab2_Handout.pdf)
