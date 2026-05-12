
# Overcooked
**CPE 487 Final Project**

Kaitlyn Adams, Malia Chopra, and Zihan Sun

We pledge our honor that we have abided by the Stevens Honor System.

## Behavior description
This project is a single player Overcooked-style cooking game implemented in VHDL on the Digilent Nexys A7-100T FPGA board. The game is displayed on a display or monitor using VGA output through a VGA-to-HDMI adapter.

The player can control a chef character in a kitchen layout. The goal is to pick up ingredients, prepare food, and complete the order cards before the timer runs out. The kitchen contains ingredient stations, drinks, a cut board and fryer station, a serving counter, plates, and a trash can.

<img width="1441" height="850" alt="IMG_4161" src="https://github.com/user-attachments/assets/4f1594ca-eddf-46b7-b1a8-f7b08ce7b474" />


The player can move the chef near an item or station using 4 directional buttons and press the center button to interact. Depending on the chef’s location and held item, the player can pick up items, combine ingredients, serve food, or discard an item.

The game includes an intro screen where the player selects between two chef characters. During gameplay, only the selected chef appears on the screen.

<img width="3553" height="2387" alt="femcharsel" src="https://github.com/user-attachments/assets/9c3fef91-165c-4f3d-9720-30c3f4d5e141" />


The game has four main states:
```INTRO_SELECT → GAME_PLAYING → GAME_WIN / GAME_OVER```

In ```INTRO_SELECT```, the player can choose a character toggling Switch 0 and Switch 1 on the board and start the game by turning on Switch 2. In ```GAME_PLAYING```, the timer runs and the player completes orders. If all orders are completed before the timer runs out, the game enters ```GAME_WIN```. If the timer reaches zero before all orders are completed, the game enters ```GAME_OVER```.
<img width="2138" height="1290" alt="IMG_4159" src="https://github.com/user-attachments/assets/357455d8-c016-4303-b677-2180ba77ce5c" />
<img width="2104" height="1258" alt="IMG_4162" src="https://github.com/user-attachments/assets/ba54f7a9-1fb5-4cdf-8cf3-1a8ac9754864" />

This project uses finite state machine logic for the states of game flow and Boolean logic for collision and interaction detection. For example, signals such as near_buns, near_cheese, near_fryer, near_counter, and near_trash determine whether the chef is close enough to interact with a station.

### FSM
<img width="1280" height="720" alt="Slide1" src="https://github.com/user-attachments/assets/c1f41d06-57ac-4801-ad48-331308583dd6" />



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

[Full Video of Game Play](https://youtu.be/U1lmlOHkiJk)

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

### Inputs and Outputs (cookfood.vhd)

```VHDL
entity cookfood is
    port (
        v_sync      : in  STD_LOGIC;
        pixel_row   : in  STD_LOGIC_VECTOR(10 downto 0);
        pixel_col   : in  STD_LOGIC_VECTOR(10 downto 0);
        chefm_x     : in  STD_LOGIC_VECTOR(10 downto 0);
        chefm_y     : in  STD_LOGIC_VECTOR(10 downto 0);
        action      : in  STD_LOGIC; --pick up item/submit button
        --for character selection
        sw0         : in  STD_LOGIC;
        sw1         : in  STD_LOGIC;
        sw2         : in  STD_LOGIC;
        red         : out STD_LOGIC_VECTOR(3 downto 0);
        green       : out STD_LOGIC_VECTOR(3 downto 0);
        blue        : out STD_LOGIC_VECTOR(3 downto 0);
        score_out   : out STD_LOGIC_VECTOR(7 downto 0);
        shuffle_sel : in  STD_LOGIC_VECTOR(2 downto 0)
    );
end cookfood;
```

#### Inputs
- `v_sync`, `pixel_row`, `pixel_col1`: VGA display
- `chefm_x`, `chefm_y`: character movement
- `action`: holding items
- `sw0`, `sw1`, `sw2`: switches to pick characters
- `shuffle_sel`: random sequence of orders

#### Outputs
- `red`, `green`, `blue`: VGA color display
- `score_out`: scoring on Nexys board

As part of this category, if using starter code of some kind (discussed below), you should add at least one input and at least one output appropriate to your project to demonstrate your understanding of modifying the ports of your various architectures and components in VHDL as well as the separate .xdc constraints file.

Images and/or videos of the project in action interspersed throughout to provide context (10 points of the Submission category)

## “Modifications” (15 points of the Submission category)

If building on an existing lab or expansive starter code of some kind, describe your “modifications” – the changes made to that starter code to improve the code, create entirely new functionalities, etc. Unless you were starting from one of the labs, please share any starter code used as well, including crediting the creator(s) of any code used. It is perfectly ok to start with a lab or other code you find as a baseline, but you will be judged on your contributions on top of that pre-existing code!

If you truly created your code/project from scratch, summarize that process here in place of the above.

We used `vga_sync.vhd`, `setup.vhd`, `leddec.vhd`, `clk_wiz_0.vhd`, and `clk_wiz_0_clk_wiz.vhd` from Lab 6. We also used some aspects of `pong.vhd` from Lab 6. We used the y movement of that bat to move the chef, but added an x movement component so the chef could go anywhere. We also kept the scoring component from Lab 6. Every time an order is completed, the counter on the Nexys board counts up by 1 in binary.

## Summary
Conclude with a summary of the process itself – who was responsible for what components (preferably also shown by each person contributing to the github repository!), the timeline of work completed, any difficulties encountered and how they were solved, etc. (10 points of the Submission category)

We started by working on the graphics and the placement of the items within our diagram. This took a couple iterations to find 10 places that the chef could reach within the frame. The sprites were created by making a pixelated drawing and running it through a code to give us the palette indexes. The code was generated by AI. We then worked on the movement of the chef in the game using the Nexys board buttons. Next, we worked on making the chef pick up and put down ingredients and carry them through the game. We used a boolean logic for this because it allowed for different cases to be implemented at the same time (ex. you are able to make the burger in any order). Then, we worked on the randomization of orders. Lastly, we added the timer on the top of the order cards and implemented the highlighted items when the chef is close. 

With our project, there are a few bugs. If you toggle switch 2 in the state `GAME_PLAYING`, the sequence of the orders changes. Also, if the timer runs out when you have an item in your hand, the state switches to `GAME_OVER`. However, the item can still be moved by the controls on the Nexys board.

## Code
And of course, the code itself separated into appropriate .vhd and .xdc files. (50 points of the Submission category; based on the code working, code complexity, quantity/quality of modifications, etc.)
