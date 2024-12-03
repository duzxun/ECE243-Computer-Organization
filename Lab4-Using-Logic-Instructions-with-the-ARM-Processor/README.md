# Lab 4 - Using Logic Instructions with the ARM Processor

## Overview
This laboratory exercise focuses on using logic instructions with the ARM processor in the DE1-SoC computer. Logic instructions are critical in embedded applications for manipulating bit strings, handling data at the bit level, and solving input/output tasks. In this lab, we will use ARM assembly programming to explore these capabilities and implement various tasks on the CPUlator tool and optionally on the DE1-SoC board.

## Part I: Counting Consecutive 1's
Find the longest sequence of consecutive 1’s in a 32-bit word.

- Understand the provided algorithm using shift and AND operations.
- Test and debug the code using the CPUlator emulator.

## Part II: Subroutine Implementation
Refactor the code into a subroutine ONES that takes a 32-bit word as input (R1) and returns the result (R0).

- Process a list of 10+ words in memory, terminating with 0.
- Store the longest sequence of 1's in R5.

## Part III: Extended Analysis
Enhance the program to calculate:

1. Longest string of 1’s (R5).
2. Longest string of 0’s (R6).
3. Longest alternating sequence of 1’s and 0’s (R7).
- Create subroutines: ONES, ZEROS, ALTERNATE.
- Process a list of data words and track the largest result for each calculation.

## Part IV: Displaying Results
Display results on the DE1-SoC’s seven-segment displays:

- Longest string of 1’s on HEX1-0.
- Longest string of 0’s on HEX3-2.
- Longest alternating string on HEX5-4.
  
Use memory-mapped addresses to light up the displays with converted decimal values.

## File Structure
- part1.s: Longest string of 1’s.
- part2.s: Subroutine-based implementation for multiple data words.
- part3.s: Extended analysis with three subroutines.
- part4.s: Final implementation displaying results on seven-segment displays.

## Tools
- [CPUlator](https://cpulator.01xz.net/?sys=arm-de1soc)
- DE1-SoC Board (optional)

## Additional Resources
- [Lab 4 Handout](./Lab4_Handout.pdf)

