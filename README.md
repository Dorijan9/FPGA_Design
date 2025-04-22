# FPGA_Design

# FPGA VGA Maze Game 

This project implements a fully functional **tile-based VGA maze game** on FPGA using Verilog. It supports level switching, heart collectibles, score tracking, and 7-segment display integration. The game runs on a Xilinx Basys 3 development board and renders graphics in real-time on a 640×480 VGA display.

##  Game Features

- **Multiple maze levels** with distinct ROM designs
- **Player-controlled movement** using directional buttons
- **Heart collectibles** that increment score
- **"You Win!" screen** based on score
- **Score displayed** on 7-segment display (8-digit multiplexed)
- **Synchronized FSM**, collision detection, and level transitions

---


---

##  Requirements

- **Hardware**: Digilent Basys 3 (Artix-7)
- **Software**: Vivado 2023.1 or later
- **Resolution**: VGA 640×480 @ 60 Hz

---

##  Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/Dorijan9/FPGA_Design.git
2. Open Vivado and create a new project.

3. Add all Verilog source files and COE ROM files.

4. Add the XDC constraints file to assign pins (buttons, VGA, etc.).

5. Generate bitstream and program the board.

## Controls

Directional Buttons: Move player

Hearts: Collect for +1 point

Levels: Automatically advance after collecting all hearts

## Author
Dorijan Donaj Magašić, Malek Sabbah
University of Warwick, Electrical and Electronic Engineering
GitHub: Dorijan9

## License
This project is for academic and educational purposes.
Feel free to fork or adapt with proper credit.
