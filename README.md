# Overcooked
**CPE 487 Final Project**

Kaitlyn Adams, Malia Chopra, and Zihan Sun

We pledge our honor that we have abided by the Stevens Honor System

## Behavior description
This project is a single player Overcooked-style cooking game implemented in VHDL on the Digilent Nexys A7-100T FPGA board. The game is displayed on a display or monitor using VGA output through a VGA-to-HDMI adapter.

The player can control a chef character in a kitchen layout. The goal is to pick up ingredients, prepare food, and complete the order cards before the timer runs out. The kitchen contains ingredient stations, drinks, a cut board and fryer station, a serving counter, plates, and a trash can.

The player can move the chef near an item or station using 4 directional buttons and press the center button to interact. Depending on the chef’s location and held item, the player can pick up items, combine ingredients, serve food, or discard an item.

The game includes an intro screen where the player selects between two chef characters. During gameplay, only the selected chef appears on the screen.

The game has four main states:
```INTRO_SELECT → GAME_PLAYING → GAME_WIN / GAME_OVER```

In ```INTRO_SELECT```, the player can choose a character toggling Switch 0 and Switch 1 on the board and start the game by turning on Switch 2. In ```GAME_PLAYING```, the timer runs and the player completes orders. If all orders are completed before the timer runs out, the game enters ```GAME_WIN```. If the timer reaches zero before all orders are completed, the game enters ```GAME_OVER```.

This project uses finite state machine logic for the states of game flow and Boolean logic for collision and interaction detection. For example, signals such as near_buns, near_cheese, near_fryer, near_counter, and near_trash determine whether the chef is close enough to interact with a station.

### Controls

- BTNU: move character up
- BTND: move character down
- BTNL: move character left
- BTNR: move character right
- BTNC (btn0): pick up and put down
- Switch SW0: male charecter select on the right
- Switch SW1: female charecter select on the left
- Switch SW2: game start when flipped up / game back to character selection when game over and flipped down

### Required Hardware/Software
- Digilent Nexys A7-100T FPGA Board
- Micro USB Cable
- VGA to HDMI Adapter
- HDMI Cable
- TV or Monitor with an HDMI input
- AMD Vivado™ Design Suite

The more detailed the better – you all know how much I love a good finite state machine and Boolean logic, so those could be some good ideas if appropriate for your system. If not, some kind of high level block diagram showing how different parts of your program connect together and/or showing how what you have created might fit into a more complete system could be appropriate instead.

## Summary of steps
1. Create a new RTL project called _overcooked_ in Vivado Quick Start
     - Create 27 new files using the names listed in under Final_Project.srcs
     - Create a new constraint file of file type XDC called setup.xdc
     - Choose Nexys A7-100T board for the project
     - Click 'Finish'
     - Click design sources and copy the VHDL code for each file
     - Click constraints and copy the code from setup.xdc
3. Run synthesis
4. Run implementation
5. Generate bitstream, open hardware manager, and program device
6. Play the game!
<img width="1280" height="720" alt="Slide1" src="https://github.com/user-attachments/assets/7a1e8fa4-f9ad-4950-a212-5c0dcb2247b5" />

A summary of the steps to get the project to work in Vivado and on the Nexys board (5 points of the Submission category)

Description of inputs from and outputs to the Nexys board from the Vivado project (10 points of the Submission category)

As part of this category, if using starter code of some kind (discussed below), you should add at least one input and at least one output appropriate to your project to demonstrate your understanding of modifying the ports of your various architectures and components in VHDL as well as the separate .xdc constraints file.

Images and/or videos of the project in action interspersed throughout to provide context (10 points of the Submission category)

## “Modifications” (15 points of the Submission category)

If building on an existing lab or expansive starter code of some kind, describe your “modifications” – the changes made to that starter code to improve the code, create entirely new functionalities, etc. Unless you were starting from one of the labs, please share any starter code used as well, including crediting the creator(s) of any code used. It is perfectly ok to start with a lab or other code you find as a baseline, but you will be judged on your contributions on top of that pre-existing code!

If you truly created your code/project from scratch, summarize that process here in place of the above.

## Summary
Conclude with a summary of the process itself – who was responsible for what components (preferably also shown by each person contributing to the github repository!), the timeline of work completed, any difficulties encountered and how they were solved, etc. (10 points of the Submission category)

## Code
And of course, the code itself separated into appropriate .vhd and .xdc files. (50 points of the Submission category; based on the code working, code complexity, quantity/quality of modifications, etc.)
