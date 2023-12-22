# Foosball Game on BASYS-3 FPGA Board

## Project Overview
This project implements a foosball-like game on the BASYS-3 FPGA board using Vivado. The game is controlled by a top module named `main_control`, which orchestrates various components to create an interactive gaming experience.

## Files Included
1. **SevenSegment.sv**: Module to display scores on the 7-segment display of BASYS3.
2. **anim_gen.sv**: Animation generator module for game dynamics.
3. **keyboard_1.v**: Keyboard input module for player controls.
4. **main_control.sv**: Top module coordinating game elements.
5. **sync_mod.sv**: VGA synchronization module for display updates.
6. **vga.sv**: VGA module for video output.

## Game Logic
- Player scores are displayed on the 7-segment display.
- Player controls are handled through the PS/2 keyboard inputs.
- Game animations and dynamics are managed by the animation generator module.
- VGA synchronization ensures smooth video output.

## Score Tracking
- Scores are tracked for both Player 1 (top bar) and Player 2 (bottom bar).
- Scoring logic updates scores based on game events.

# Setup Guide

## Prerequisites
1. **Vivado Installation**: Ensure that Vivado, the FPGA design and implementation tool, is installed on your system. You can download it from the official Xilinx website.
2. **BASYS-3 FPGA Board**: Have the BASYS-3 FPGA board ready for the implementation of the foosball game.
   
## Implementation Steps
Follow these steps to run the foosball game on the BASYS-3 FPGA board:

1. **Download Code Files**: Download all the code files provided in the project, including:
2. **Open Vivado**: Launch Vivado and create a new project.
3. **Add Files to Project**: Add the downloaded code files to your Vivado project.
4. **Create Constraints**: Define the necessary constraints for your BASYS-3 FPGA board. This may include clock constraints and pin assignments.
5. **Generate Bitstream**: Generate the bitstream for your project in Vivado.
6. **Export Hardware (Optional)**: If needed, export the hardware design to the SDK (Software Development Kit) for further programming.
7. **Program FPGA**: Use Vivado or a suitable programming tool to program the generated bitstream onto the BASYS-3 FPGA board.
8. **Connect PS/2 Keyboard**: Connect a PS/2 keyboard to the appropriate port on the BASYS-3 board.
9. **Power On**: Power on the BASYS-3 FPGA board.
10. **Run the Game**: Once the FPGA is programmed, the foosball game should start running. Use the PS/2 keyboard for player controls.

Feel free to reach out for any additional information or assistance.
