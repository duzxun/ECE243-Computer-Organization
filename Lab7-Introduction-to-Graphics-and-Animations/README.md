# Lab 7 - Introduction to Graphics and Animation

## Overview
This project explores the basics of graphics and animation using C programming on an ARM processor with the DE1-SoC platform. Graphics are displayed via a VGA controller, either on a monitor or in simulation using the CPUlator's "VGA pixel buffer" window.
- Display graphics programmatically using a VGA controller.
- Create animations and understand concepts like vertical synchronization.
- Implement double-buffering to optimize rendering performance.

## Background
### Pixel Buffer and Graphics Rendering
The VGA controller relies on a pixel buffer to manage display output. Each pixel is represented as a 16-bit value:

- Red: 5 bits
- Green: 6 bits
- Blue: 5 bits

### Default Configuration:

- Resolution: 320 × 240 pixels
- Base Address: 0xC8000000

To improve rendering, double-buffering is used:

- Front Buffer: Displays the current frame.
- Back Buffer: Prepares the next frame in the background.
- The buffers are swapped during vertical synchronization, minimizing flickering.

## Line Drawing
A line-drawing algorithm determines which pixels are colored between two points. This project implements Bresenham’s Algorithm for efficient line drawing.

## Animation
Animating graphics involves changing an object’s position over time and redrawing it. Synchronization ensures updates occur smoothly at a rate of 1/60th of a second.

## Project Components
### Part I: Line Drawing
Implement a function to draw lines using Bresenham's Algorithm.

Steps:

- Write a draw_line() function to connect two points: (x1, y1) and (x2, y2).
- Use the helper function plot_pixel() to color individual pixels.
- Compile and run the code using CPUlator, verifying output in the VGA pixel buffer.

### Part II: Moving a Horizontal Line
Animate a horizontal line that bounces vertically between the top and bottom edges of the screen.

Steps:

- Clear the screen and draw the line at its initial position.
- In an infinite loop:
  - Erase the previous line.
  - Move the line up or down by one pixel.
  - Reverse direction upon reaching the edges.
  - Use wait_for_vsync() to synchronize updates to the display:
  - Verify the animation speed; the line should complete a full cycle (~4 seconds).

### Part III: Bouncing Rectangles Animation
Animate eight rectangles that bounce diagonally across the screen, connected by lines.

Features:

- Implement double-buffering to eliminate flicker.
- Use rand() to randomize initial positions and directions.

Steps:

- Set up the front buffer at 0xC8000000 and the back buffer at 0xC0000000.
- For each frame:
  - Clear the back buffer.
  - Draw the rectangles and connecting lines.
  - Update the positions of the rectangles based on their directions.
  - Synchronize and swap buffers using
    
Optionally, disable double-buffering to observe the flicker caused by unsynchronized drawing.

## File Structure
- Part I: part1.c
- Part II: part2.c
- Part III: part3.c
 
## Compilation and Testing
- Use [CPUlator](https://cpulator.01xz.net/?sys=arm-de1soc) for compilation and debugging.
- Verify rendering in the VGA pixel buffer window.
- Measure animation performance, ensuring smooth updates.

## Additional Resources
- [Lab 7 Handout](./Lab7_Handout.pdf)
