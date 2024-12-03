# Lab 5 - Using Input/Output Devices including a Timer

## Overview
This exercise explores input/output (I/O) synchronization techniques using ARM assembly language. The focus is on program-controlled polling with the DE1-SoC Computer and CPUlator emulator, utilizing parallel port interfaces and hardware timers for I/O tasks.

## Part I: Single-Digit Display
- Control the HEX0 seven-segment display based on the pushbutton inputs.
  - KEY0: Reset to 0.
  - KEY1: Increment (max 9).
  - KEY2: Decrement (min 0).
  - KEY3: Blank display (return to 0 on any subsequent key press).
    
- Use the base addresses 0xFF200020 (HEX) and 0xFF200050 (KEY).

## Part II: Two-Digit Counter
- Display a 2-digit decimal counter (HEX1-0) incrementing every ~0.25 seconds.
- Counter stops/starts with any pushbutton press.
- Use a delay loop for timing and the Edge-capture register for input detection.

## Part III: Timer-Based Delay
- Replace the delay loop with the ARM A9 Private Timer for precise 0.25-second intervals.
- Use the timer's Load, Control, and Interrupt Status registers (base 0xFFFEC600).

## Part IV: Real-Time Clock
- Implement a real-time clock displaying SS:DD (seconds:hundredths) on HEX3-0.
- Measure 0.01-second intervals using the ARM A9 Private Timer.
- Clock stops/starts with any pushbutton and wraps around after 59:99.

## Notes
- Follow ARM Procedure Call Standard (PCS) for subroutine register usage.
- Save and restore registers (R4-R11) as needed in subroutines.
- Ensure proper memory-mapped register access for I/O operations.

## File Structure
- part1.s: Single-digit display program.
- part2.s: Two-digit counter with delay loop.
- part3.s: Two-digit counter with timer delay.
- part4.s: Real-time clock implementation.

## Tools
- [CPUlator](https://cpulator.01xz.net/?sys=arm-de1soc)

## References
- [Lab 5 Handout](./Lab5_Handout.pdf)
