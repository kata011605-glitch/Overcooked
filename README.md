
# Overcooked
**CPE 487 Final Project**

Kaitlyn Adams, Malia Chopra, and Zihan Sun

We pledge our honor that we have abided by the Stevens Honor System.

## Behavior description
This project is a single-player Overcooked-style cooking game implemented in VHDL on the Digilent Nexys A7-100T FPGA board. The game is displayed on a TV or monitor using VGA output through a VGA-to-HDMI adapter.

The player controls a chef character in a kitchen layout. The goal is to pick up ingredients, prepare food, and complete the order cards before the timer runs out. The kitchen contains ingredient stations, drink stations, a cutting board area, a fryer station, a serving counter, plates, and a trash can.

<img width="1718" height="1279" alt="139c79df3c834e425dd917b8602b420c" src="https://github.com/user-attachments/assets/eefdbfd5-88d7-4396-bc97-6bc6219e816d" />

**Figure 1.** Main gameplay screen showing the kitchen layout, chef character, ingredient stations, drink stations, fryer station, serving counter, order cards, and countdown timer.

The player moves the chef near an item or station using the four directional buttons and presses the center button to interact. Depending on the chef’s location and held item, the player can pick up items, combine ingredients, serve food, or discard an item. 

The game includes an intro screen where the player selects between two chef characters. During gameplay, only the selected chef appears on the screen.

<img width="1736" height="1279" alt="144717c98008fef56e640a487f47f316" src="https://github.com/user-attachments/assets/d8d06c17-6cf8-4906-8c90-5a65d04c6dcc" />

**Figure 2.** Character selection screen where the player chooses between the male chef and female chef before starting the game.

### FSM and Game Flow
The game has four main states:
`INTRO_SELECT` → `GAME_PLAYING` → `GAME_WIN` / `GAME_OVER`

<img width="1137" height="470" alt="b16a977f8b09f5158ef0b022f39c1b5a" src="https://github.com/user-attachments/assets/c9a8c8b4-9763-4409-bb23-df16247f369e" />

**Figure 3.** Finite state machine for the main game flow. The game starts in `INTRO_SELECT`, enters `GAME_PLAYING` after a character is selected, and transitions to either `GAME_WIN` or `GAME_OVER`.

This project uses finite state machine logic for game flow and Boolean logic for collision and interaction detection. Signals such as `near_buns`, `near_cheese`, `near_fryer`, `near_counter`, and `near_trash` determine whether the chef is close enough to interact with a station. When the chef enters the interaction boundary for a station, the border around that station changes from white to yellow to show that the action button can be used.

In `INTRO_SELECT`, the player selects a character by toggling Switch 0 or Switch 1 on the board, then starts the game using Switch 2. In `GAME_PLAYING`, the timer runs and the player completes orders. If all orders are completed before the timer runs out, the game enters `GAME_WIN`. If the 3-minute timer reaches zero before all orders are completed, the game enters `GAME_OVER`.

<img width="1133" height="862" alt="6b03a5677321cedc7f7587a191fbf7bd" src="https://github.com/user-attachments/assets/7423eb6d-8915-4e24-9751-f11851c9ed7a" />

**Figure 4.** Victory screen displayed when all eight orders are completed before the timer runs out.

<img width="1727" height="1279" alt="ac086343d5d05781d84274a1fc223510" src="https://github.com/user-attachments/assets/abb320ab-9391-4008-ba17-07b6ba108fb1" />

**Figure 5.** Game-over screen displayed when the countdown timer reaches zero before all orders are completed.


### Controls
The game is controlled using the Nexys board buttons and switches.

- `BTNU`: move character up
- `BTND`: move character down
- `BTNL`: move character left
- `BTNR`: move character right
- `BTNC` / `BTN0`: action button for picking up, combining, serving, or discarding items
- `SW0`: male character select on the right
- `SW1`: female character select on the left
- `SW2`: game start/return to character selection after game over

Toggling `SW0` selects the male character on the right side of the character selection screen. Toggling `SW1` selects the female character on the left side. Toggling `SW2` starts the game after a character is selected. After the game ends, toggling `SW2` returns the game back to the character selection screen.


### How to Play
The player completes orders by picking up ingredients, combining them, and serving the finished food at the serving counter. The action button, `BTNC` / `BTN0`, is used to pick up items, combine ingredients, use stations, serve completed orders, or discard items at the trash.

The basic combinations used in the game are shown below:

<img width="800" height="597" alt="e605c7b19e3287fa088ac3727483ed2c" src="https://github.com/user-attachments/assets/4455dfc5-b1c1-4afb-9fe6-813a9a6a3631" />

**Figure 6.** Food combination guide showing how ingredients are combined to create fries, intermediate burger items, and the final burger. For burger-related items, the ingredient order does not matter. For example, buns, cheese, and patty can still create the same final burger item even if the player picks up the ingredients in a different sequence.

The chef must move near the correct station until the station border turns yellow, then press `BTNC` / `BTN0` to interact. Completed food items can be served at the counter if they match the current order card.

## Required Hardware/Software
- Digilent Nexys A7-100T FPGA Board
- Micro USB Cable
- VGA to HDMI Adapter
- HDMI Cable
- TV or Monitor with an HDMI input
- AMD Vivado™ Design Suite


## System Architecture
The top-level module, `overcooked.vhd`, connects the FPGA hardware inputs and outputs to the game logic. It receives the board clock, push buttons, switches, VGA outputs, and 7-segment display outputs. The VGA synchronization module generates the current `pixel_row` and `pixel_col` values used to draw the screen. The top-level module also updates the chef’s x and y position based on the directional buttons and generates the `shuffle_sel` value used for order sequence selection.

The `cookfood.vhd` module contains the main gameplay logic. It receives the chef position, current pixel location, button and switch inputs, and shuffle value. It controls the game state, selected character, held item, station detection, order completion, score, timer, and final RGB output.

Individual sprite display modules are used to draw each item or character. Each sprite module checks whether the current pixel position falls inside the sprite’s coordinate range. If the pixel is part of the sprite, the module outputs RGB values and sets its visible signal to on. The main cookfood.vhd module layers these visible signals together to create the final game display.


**Full Gameplay Demo Video:** This video shows the game running on the Nexys A7-100T board, including character selection, movement, item pickup, food combinations, order serving, score updates, game state transitions, game win, and game restart.

<a href="http://www.youtube.com/watch?feature=player_embedded&v=haoUbl20fis" target="_blank">
  <img src="http://img.youtube.com/vi/haoUbl20fis/0.jpg" 
       alt="Full Gameplay Demo Video" width="720" height="540" border="10" />
</a>


## Setup and Run Instructions
1. Create a new RTL project called _overcooked_ in Vivado
     - Download Final_Project files
     - Add the downloaded VHDL source and constraint files from the repository into the Vivado project.
2. Select Digilent Nexys A7-100T board as the target FPGA board
3. Connect the Nexys A7-100T board to the computer using a micro-USB cable
4. Connect the VGA-to-HDMI adapter to the VGA port on the Nexys A7-100T board. Then connect an HDMI cable from the adapter to a TV or monitor. Set the TV or monitor to the correct HDMI input
5. Run Synthesis
6. Run Implementation
7. Generate Bitstream
8. Open Hardware Manager -> Open Target -> Auto Connect to device
9. Program Device and select the generated bitstream file
10. Play the game!

<img width="1280" height="720" alt="Slide1" src="https://github.com/user-attachments/assets/7a1e8fa4-f9ad-4950-a212-5c0dcb2247b5" />

**Figure 7.** Example project setup and demonstration screen used during FPGA testing and final verification.

## Inputs and Outputs 
The project uses the Nexys A7-100T buttons and switches as the main player inputs. The directional buttons control chef movement: `BTNU` moves up, `BTND` moves down, `BTNL` moves left, and `BTNR` moves right. `BTNC` (`BTN0`) is used as the action button for picking up items, combining ingredients, serving completed orders, and discarding items. The switches are used for game setup and state control: `SW0` selects the male chef, `SW1` selects the female chef, and `SW2` starts the game after a character is selected or returns to character selection after the game ends.

The main outputs are the VGA display signals and the 7-segment score display. `VGA_red`, `VGA_green`, and `VGA_blue` send the color values for each pixel, and `VGA_hsync` and `VGA_vsync` control the VGA timing. These signals allow the game screen to appear on a monitor through the VGA-to-HDMI adapter. The score is sent to the Nexys board 7-segment display through SEG7_anode and SEG7_seg. Score is displayed in binary. Each completed order increases the score by one, and completing all eight orders displays a score of 00001000. Restarting the game would reset the score. 

Internally, the gameplay module also uses signals such as `pixel_row`, `pixel_col`, `chefm_x`, `chefm_y`, and `shuffle_sel`. They connect the VGA system, chef movement, and order shuffle logic to the main game module, allowing `cookfood.vhd` to draw the screen, check station boundaries, update the held item, complete orders, and output the final RGB color values for the display.

_cookfood.vhd_:
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
_

## Modifications 
This project was built from the Lab 6 Pong structure. The files `pong.vhd`, `bat_n_ball.vhd`, `vga_sync.vhd`, `pong.xdc`, `leddec.vhd`, `clk_wiz_0.vhd`, and `clk_wiz_0_clk_wiz.vhd` were reused from Lab 6. Some aspects of `pong.vhd` were also used as a baseline. `pong.vhd` was renamed to `overcooked.vhd`, `bat_n_ball.vhd` to `cookfood.vhd` and `pong.xdc` to `setup.xdc`.

The original Pong project used coordinate-based contact logic between the ball and bat. In this project, that idea was modified into proximity detection between the chef and kitchen stations. Instead of checking whether a ball touches the bat, the game checks whether the chef’s center point is inside the interaction boundary of an item station, fryer, trash can, or serving counter.

Compared to the original Pong starter project, this project added additional inputs such as `BTNU`, `BTND`, `SW0`, `SW1`, and `SW2` for full movement, character selection, and game-state control. The starter code mainly used horizontal movement of the bat, but this project adds both x-direction and y-direction movement so the chef can move around the kitchen layout. Therefore, `BTNU` and `BTND` were added in the constraints file for vertical movement control. 

_setup.xdc_:
```tcl
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports { btn0 }]; #IO_L9P_T1_DQS_14 Sch=btnc
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports { btnl }]; #IO_L12P_T1_MRCC_14 Sch=btnl
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { btnr }]; #IO_L10N_T1_D15_14 Sch=btnr
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports { btnu }]; #ADDED btnu top button
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports { btnd }]; #ADDED btnd bottom button
```

The score display from Lab 6 was kept in binary and modified for this game, so that each time an order is completed, the score increases by 1 and is displayed on the Nexys board in binary. The score reaches `00001000` when all 8 orders are completed.

Other features that were created for this game includes character selection, item pickup, food combining, held item display, order tracking, order shuffling, a 3-minute countdown timer, station highlighting, trash logic, serving logic, and win/game-over message screens.

An order shuffle system was also added. A 3-bit counter, `rand_count`, runs continuously in the top-level module. When `SW2` starts a new game, the current counter value is captured as `shuffle_sel`. This value selects one of eight predefined order sequences, so the displayed order list changes between game runs to simulate a "random" shuffle.

## Development Process and Challenges

### Team Contributions
Kaitlyn Adams: 

Malia Chopra: Character movement modifications and boundaries, holding item logic, diagrams, FPGA testing/debugging, github repository editing, and documentation.

Zihan Sun: Pixelated drawings, sprite conversion, station placement, interaction boundary calculations and implementation, yellow station highlighting, held-item alignment, item pickup and combination logic, order display and shuffle, timer display, character selection, game-over/game-win screens, module integration, FPGA testing/debugging, and documentation.

### Timeline
The project started in mid-April by converting the Lab 6 Pong starter structure into the Overcooked project structure. The first stage focused on renaming the main files, keeping the VGA display system working, and confirming that the Nexys A7-100T board could output the game screen correctly. After the basic display setup was working, the next stage focused on creating the pixel-art sprites and placing the chef, ingredients, stations, and kitchen layout on the screen.

Toward the end of April, the main gameplay logic was added. This included chef movement, station interaction boundaries, yellow station highlighting, held-item display, item pickup, food combinations, trash logic, and serving logic. In early May, the project was expanded with the order display, order shuffling, order completion tracking, score output, countdown timer, character selection screen, and win/game-over screens.

The final stage focused on testing the game on the FPGA board, debugging sprite layering, adjusting station boundaries, fixing gameplay issues, organizing the GitHub repository, adding screenshots and a demo video, and writing the final README documentation.

### Graphics and Sprite Creation
The project started with the graphics design and placement of items within the kitchen layout. The sprites were created by making pixelated drawings for the chef characters, ingredients, drinks, and prepared foods. These pixelated drawings were then downloaded as PNG images and converted into CSV palette-index data in VS Code using the help of AI (ChatGPT). The CSV values were then used to create VHDL sprite display modules, where each palette index mapped to a specific RGB color value, allowing the drawn pixel-art sprites to display on the FPGA screen.

One plate-based food sprite was drawn first and used as the base template for the other plate-based items. The remaining food sprites were created by copying that original pixel-drawing format and modifying the details for each item. 

### Station Placement and Interaction Boundaries
After the main sprites were created, the item stations were placed on the tables in the kitchen layout. Item placement required calculating and testing the pixel spacing within the table areas. The food sprites were designed to visually match the size of the chef’s hand so that held items would look proportional during gameplay. Most food sprites were originally drawn as 32 × 32 pixel images, while the drink sprites and fryer were drawn as 64 × 64 pixel images. The food sprites were scaled up by 2 for display, and the chef sprites were also scaled by 2 so the proportions stayed consistent.

The pictures shown on the screen are handled as sprite instances in VHDL. Each sprite display module acts like a reusable drawing template. For example, `buns_display`, `cola_display`, `chefm_display`, and other sprite modules receive the current `pixel_row`, `pixel_col`, and a placement coordinate `icon_x` and `icon_y`. If the current pixel falls inside that sprite’s area, the module outputs the correct RGB color and sets its visible signal to '1'.

The same sprite module can be reused in multiple places by instantiating it with different coordinates. For example, `cola_display` is used once for the cola station and again for the cola held in the chef’s hand. The order display also reuses these item sprite modules to show the food and drink icons on the order cards. In that case, the order system sends an item code, such as burger, fries, Sprite, or cola, and the display logic chooses the matching sprite to draw in the order slot. The station sprites use fixed icon_x and icon_y positions, while the held-item sprites use hand coordinates such as hand_drink_x, hand_drink_y, hand_plate_x, and hand_plate_y, so they move with the chef. The order card sprites use their own fixed order-slot coordinates. This allowed the same sprite artwork to be reused without conflicts.

After placing the stations, interaction boundaries were defined around each item or station using the chef’s center point, calculated as `chefm_x + 98` and `chefm_y + 98`. This value was used because the chef sprite was originally 98 × 98 pixels and then scaled by 2 for display, making the center point approximately 98 pixels from the top-left coordinate. Using the chef’s center point worked better than using the top-left corner because it more accurately represented where the chef was standing relative to each station and allowed for easier calculations later on for interaction zone calculations.

Most interaction zones were around 30–40 pixels wide, but the exact x and y thresholds varied depending on the station. For example, the spacing between cola and Sprite was different from the spacing between Sprite and the fryer station, so each boundary had to be adjusted separately. The goal was to make the interaction zones close enough so that the chef visually appears next to the station, but not so large that nearby stations accidentally trigger at the same time. 

### Station Highlighting and Action Logic
When a near-item condition is satisfied, such as `near_buns`, `near_cola`, `near_fryer`, or `near_counter`, the border around that specific station changes from white to yellow, similar to the character selection border highlight. 

This visual highlight was used to assist players in determining if the chef was inside the correct interaction boundary for action logic, including picking up ingredients, combining items, using the fryer, serving orders, and discarding items at the trash. For example, if the chef is holding nothing and `near_cola = '1'`, pressing the action button (BTN0/BTNC) changes the held item to `HOLD_COLA`. If the chef is holding a potato and `near_fryer = '1'`, pressing `BTNC` / `BTN0` changes the held item to `HOLD_FRIES`.

### Held Item Alignment
Held item placement was tested by mapping separate sprite instances to the chef’s hand. Since the sprite drawing modules use the top-left pixel as the placement reference, the held item coordinates had to be offset from the chef sprite’s top-left position. For drinks, the hand position was set using `hand_drink_x <= chefm_x + 32` and `hand_drink_y <= chefm_y + 99`. For plate-based food items, the hand position was set using `hand_plate_x <= chefm_x + 60` and `hand_plate_y <= chefm_y + 102`. These offsets were calculated by comparing the chef sprite’s top-left border to the intended hand location, then subtracting or adjusting based on where the food sprite’s own top-left pixel should start.

An example calculation for `hand_plate_y` is shown to explain why the value 102 was used in `hand_plate_y <= chefm_y + 102`. In this calculation, `chefm_y` represents the top y-coordinate of the chef sprite, and chefm_x represents the left x-coordinate. Since each sprite is placed using its top-left coordinate, the held item needs an offset from the chef’s top-left corner to appear correctly in the chef’s hand.

<img width="477" height="302" alt="image" src="https://github.com/user-attachments/assets/44d8fea9-70fc-44c7-a953-e927c15eb84b" />

**Figure 8.** Held-item alignment calculation used to position plate-based food sprites relative to the chef’s hand.

All the food sprites shared the same general size and top-left placement style, they had similar alignment requirements when being mapped to the chef’s hand. The drink sprites also shared their own alignment requirements. Therefore, only two hand-position mappings were needed: one for drinks and one for plate-based food items because of plate pixel consistency across drawings. This kept the held-item display simpler while still allowing different food and drink sprites to appear correctly in the chef’s hand.

### Chef Position Signals
The signal names `chefm_x` and `chefm_y` were kept throughout the project even after adding the female chef sprite. The male chef was implemented first, so the original movement and position signals were based on `chefm_x` and `chefm_y`. After the female chef was added, both chef sprites were mapped using the same x and y position signals because their hand locations were aligned to the same relative pixel position. Keeping the original signal names avoided having to rename the movement and display logic across multiple files.

### Movement and Gameplay Logic
Movement, item pickup and item carrying logic were the most important implementations for the game. Boolean logic was used for the interaction system because it allowed different gameplay cases to be checked clearly, such as picking up an item, combining ingredients, using the fryer, serving an order, or throwing an item away.

The burger logic was designed so ingredients could be combined in different orders. For example, buns, cheese, and patty can still form a burger even if the player picks up the ingredients in different sequences. For example, if the player picks up cheese first, then patty, and then buns, the first combination creates the cheese-patty intermediate item, and adding buns later completes the burger.

### Order System and Timer
The order system was added after the item logic. Each order uses item codes for burger, fries, Sprite, and cola. The game tracks the current order, checks whether item A and item B are completed, and advances to the next order when the required items are served.

The order display also uses `item_a_done` and `item_b_done` signals so that completed parts of an order can be hidden or marked as completed. Once all required items for the current order are served, the score increases by 1 and the game moves to the next order. After all 8 orders are completed, the game enters the win state.

The timer was added above the order cards and counts down during gameplay. If the timer reaches zero before all orders are completed, the game enters the game-over state. Lastly, station highlighting was added to make interactions easier to understand during gameplay and to help the player know when the action button can be used.

### Challenges
One major difficulty was aligning the sprites correctly on the VGA display. Since each sprite module uses a top-left coordinate for placement, the held food and drink items required some calculations, testing, and adjusting for it to correctly appear in the chef’s hand. 

Another difficulty was creating interaction boundaries for each station. If the boundaries were too large, the chef could accidentally trigger the wrong item station. If they were too small, the player had to stand in an overly specific position to interact. This was solved by using the chef’s center point, adjusting the x and y coordinate ranges for each station, and repeatedly testing the boundaries during gameplay until each station had a reasonable interaction zone.

The order system and timer were another important challenge. The game uses `current_order` to track which order the player is currently completing, and `item_a_done` and `item_b_done` to track whether each part of the order has already been served. This was needed because some orders only require one item, while other orders require two items. The `orders_display` module receives these signals and uses them to show the current order cards, hide or update completed order items, and display the shared countdown timer above the orders. Separate tracking signals were used for item A and item B, checking whether `current_item_b` was empty for single-item orders, and only advance `current_order` after the correct completion condition was met. The serving logic also had to check whether the item the chef is holding matches the required order item. To make this easier, the held item is converted into a small item code using the `held_to_code` function. For example, burger, fries, Sprite, and cola each have their own code. When the chef is near the serving counter and presses the action button, the code checks whether the held item matches `current_item_a` or `current_item_b`. If it matches, the matching item is marked as completed and the chef’s hand is cleared. Once all required parts of the order are completed, the score increases by one, the game moves to the next order, and the completion signals reset for the next order.

**Single-Item and Two-Item Order Completion Logic**

<img width="752" height="500" alt="image" src="https://github.com/user-attachments/assets/65fd5775-d5f1-4352-b255-9617fb8fba43" />

**Figure 9.** VHDL order completion logic for single-item and two-item orders. The score only increases after the required item conditions are completed.

This code checks whether the current order requires one item or two items. Single-item orders complete when item A is served, while two-item orders require both item A and item B before the score increases and the game moves to the next order.

The timer was also challenging because it needed to count down in real time during gameplay without running during the intro, win, or game-over screens. This was handled using `frame_count` and `time_left`. Since the VGA vertical sync runs once per frame, `frame_count` counts from 0 to 59, and then `time_left` decreases by one second. The timer starts at 180 seconds for a 3-minute game and only updates while the game is in `GAME_PLAYING`. If `time_left` reaches zero before all orders are completed, the game changes to `GAME_OVER`. If the player completes all 8 orders before the timer runs out, the game changes to `GAME_WIN`.

Overall, this project required combining VGA display logic, sprite modules, button/switch input, finite state machine logic, Boolean interaction checks, and hardware testing. Through debugging and repeated testing on the FPGA board, the final game was able to run as a playable Overcooked-style game with character selection, movement, item pickup, food combinations, order serving, scoring, a countdown timer, and end-game screens.

## Bugs and Future Improvements
There are a few bugs in the current version of the project. If `SW2` is toggled during `GAME_PLAYING`, the sequence of the orders can change during gameplay. One issue occurs when the player reaches the last order with item A already completed. If `SW2` is toggled at that point, the order may switch into a single-item order and appear blank, which can temporarily prevent the last order from completing normally. However, if `SW2` is toggled again until the order changes back to one with a non-empty item B, the player can still complete the game.

Another limitation is that if the timer runs out while the chef is holding an item, the game state switches to `GAME_OVER` and the chef becomes invisible, but the held item sprite can still move with the chef controls. This happens because the chef sprite is hidden outside of `GAME_PLAYING`, but the held-item display logic is still active. A future fix would be to also hide held-item sprites when the game is not in `GAME_PLAYING`, or to clear `held_item` when the game enters `GAME_OVER`.

Another current limitation is that the timer is shared across the entire game and displays the same countdown above each order card. In a future version, each order could have its own individual timer instead of using one timer for all orders. This would make the order system more similar to the original Overcooked gameplay, where each order has its own time constraint.

Additional gameplay features could also be added to make the game more realistic and more similar to Overcooked. For example, the fryer station could include a short cooking delay so potatoes do not turn into fries immediately. A grill station could also be added for cooking burger patties, with a timer that tracks how long the burger stays on the grill. If the burger is left on the grill for too long, a fire event could be triggered as a penalty or obstacle. Another future improvement would be adding a two-player mode, where two chefs can move independently and work together to complete orders.

## AI Assistance

ChatGPT was used to assist with some troubleshooting and converting sprite artwork concepts into VHDL sprite logic. The final project design, implementation, testing, debugging, and verification were completed by the project team.
