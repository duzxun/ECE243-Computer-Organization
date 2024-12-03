# Lab 6 - Using Interrupts with Assembly Language Code

## Overview
This lab focuses on using interrupts with the ARM processor. All solutions were developed using assembly language and tested on the DE1-SoC Computer (via CPUlator). The lab covers configuring the ARM Generic Interrupt Controller (GIC), writing interrupt service routines (ISRs), and interfacing with hardware such as pushbuttons, LEDs, and seven-segment displays.

## Contents
- Part I: Pushbutton Interrupts
- Part II: Timer and Pushbutton Interrupts
- Part III: Adjustable Timer Speed
- Part IV: Real-Time Clock with Interval Timer

Each part is implemented in its own assembly source file (part1.s, part2.s, etc.).

## Part I: Pushbutton Interrupts
The implementation includes:

- Setting up the exception vector table.
- Handling interrupts triggered by the pushbuttons (KEY0 to KEY3).
- Toggling the corresponding seven-segment display (HEX0 to HEX3) between a number and a blank state.

## Part II: Timer and Pushbutton Interrupts
This part combines two interrupt sources:

- A private timer generating interrupts every 0.25 seconds.
- Pushbutton interrupts to toggle a global RUN variable.

Key behavior:

- The RUN variable determines whether the COUNT value displayed on the LEDs increments (RUN = 1) or remains static (RUN = 0).


## Part III: Adjustable Timer Speed
Enhancements to the previous implementation:

- KEY0: Toggle the RUN variable (start/stop counting).
- KEY1: Double the timer speed (faster count).
- KEY2: Halve the timer speed (slower count).

This is achieved by dynamically modifying the timer's load value in the ISR.

## Part IV: Real-Time Clock with Interval Timer
This part adds a third interrupt source:

- The FPGA Interval Timer generates interrupts every 1/100 of a second.

Key behavior:

- A global TIME variable tracks the time in SS:DD (seconds:hundredths) format.
- KEY3: Toggles the real-time clock (start/stop).
- The clock wraps around to 00:00 after 59:99.
- The TIME variable is displayed on the seven-segment displays using a shared HEX_code variable.

## Additional Resources
- [Lab 6 Handout](./Lab6_Handout)
