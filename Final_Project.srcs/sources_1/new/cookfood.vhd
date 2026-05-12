library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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

architecture Behavioral of cookfood is

    signal score       : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal last_action : STD_LOGIC := '0';

    signal buns_r, buns_g, buns_b       : STD_LOGIC_VECTOR(3 downto 0);
    signal cheese_r, cheese_g, cheese_b : STD_LOGIC_VECTOR(3 downto 0);
    signal potato_r, potato_g, potato_b : STD_LOGIC_VECTOR(3 downto 0);
    signal patty_r, patty_g, patty_b    : STD_LOGIC_VECTOR(3 downto 0);
    signal fryer_r, fryer_g, fryer_b    : STD_LOGIC_VECTOR(3 downto 0);
    signal cola_r, cola_g, cola_b       : STD_LOGIC_VECTOR(3 downto 0);
    signal sprite_r, sprite_g, sprite_b : STD_LOGIC_VECTOR(3 downto 0);
    signal trash_r, trash_g, trash_b    : STD_LOGIC_VECTOR(3 downto 0);
    signal plate_r, plate_g, plate_b    : STD_LOGIC_VECTOR(3 downto 0);
    signal chefm_r, chefm_g, chefm_b    : STD_LOGIC_VECTOR(3 downto 0);
    signal cheff_r, cheff_g, cheff_b    : STD_LOGIC_VECTOR(3 downto 0);
    signal orders_r, orders_g, orders_b : STD_LOGIC_VECTOR(3 downto 0);

    signal buns_visible   : STD_LOGIC;
    signal cheese_visible : STD_LOGIC;
    signal potato_visible : STD_LOGIC;
    signal patty_visible  : STD_LOGIC;
    signal fryer_visible  : STD_LOGIC;
    signal cola_visible   : STD_LOGIC;
    signal sprite_visible : STD_LOGIC;
    signal trash_visible  : STD_LOGIC;
    signal plate_visible  : STD_LOGIC;
    signal chefm_visible  : STD_LOGIC;
    signal cheff_visible  : STD_LOGIC;
    signal orders_visible : STD_LOGIC;
    
    
    type game_state_t is (INTRO_SELECT, GAME_PLAYING, GAME_OVER, GAME_WIN); --no game start
    signal game_state : game_state_t := INTRO_SELECT;
    
    type chef_select_t is (SELECT_CHEFF, SELECT_CHEFM);
    signal selected_chef : chef_select_t := SELECT_CHEFM;
    
    --Chef holding item
    type held_item_t is (HOLD_NONE, HOLD_BUNS, HOLD_CHEESE, HOLD_PLATE, HOLD_POTATO, HOLD_PATTY, HOLD_COLA, HOLD_SPRITE, HOLD_CHEESEP, HOLD_BUNSPATTY, HOLD_BUNSCHEESE, HOLD_BURGER, HOLD_FRIES);
    signal held_item : held_item_t := HOLD_NONE;
    signal held_r, held_g, held_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_visible : STD_LOGIC;
    signal held_cola_r, held_cola_g, held_cola_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_sprite_r, held_sprite_g, held_sprite_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_cola_visible, held_sprite_visible : STD_LOGIC;
    signal held_buns_r, held_buns_g, held_buns_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_patty_r, held_patty_g, held_patty_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_plate_r, held_plate_g, held_plate_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_cheese_r, held_cheese_g, held_cheese_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_potato_r, held_potato_g, held_potato_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_burger_r, held_burger_g, held_burger_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_fries_r, held_fries_g, held_fries_b : STD_LOGIC_VECTOR(3 downto 0);
    -- CHEESEP, BUNSCHEESE, BUNSPATTY don't need normal signals (only held items)
    signal held_cheesep_r, held_cheesep_g, held_cheesep_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_bunspatty_r, held_bunspatty_g, held_bunspatty_b : STD_LOGIC_VECTOR(3 downto 0);
    signal held_bunscheese_r, held_bunscheese_g, held_bunscheese_b : STD_LOGIC_VECTOR(3 downto 0);
    
    signal held_buns_visible, held_patty_visible, held_plate_visible, held_cheese_visible, held_potato_visible, held_burger_visible : STD_LOGIC;
    signal held_cheesep_visible, held_bunspatty_visible, held_bunscheese_visible, held_fries_visible : STD_LOGIC;

        
    --alignment for the two drinks in chef hands
    signal hand_drink_x, hand_drink_y : STD_LOGIC_VECTOR(10 downto 0);
    --alignment for items in plates in chef hands
    signal hand_plate_x, hand_plate_y : STD_LOGIC_VECTOR(10 downto 0); 
    
    signal near_cola   : STD_LOGIC;
    signal near_sprite : STD_LOGIC;
    signal near_trash : STD_LOGIC;
    signal near_buns   : STD_LOGIC;
    signal near_patty : STD_LOGIC;
    signal near_plate : STD_LOGIC;
    signal near_cheese   : STD_LOGIC;
    signal near_potato : STD_LOGIC;
    signal near_fryer : STD_LOGIC;
    signal near_counter : STD_LOGIC; --serving counter
    
    --Track which order is current order
    --Item a and b for the two items in some order
    signal current_order : integer range 0 to 7 := 0;
    signal item_a_done   : std_logic := '0';
    signal item_b_done   : std_logic := '0';
    signal current_item_a : STD_LOGIC_VECTOR(2 downto 0);
    signal current_item_b : STD_LOGIC_VECTOR(2 downto 0);
    
    --timer
    signal frame_count : integer range 0 to 59 := 0;
    signal time_left   : integer range 0 to 180 := 180; -- 3min timer
    
    --message display
    signal msg_r, msg_g, msg_b : STD_LOGIC_VECTOR(3 downto 0);
    signal msg_visible : STD_LOGIC;
    signal show_time_out_s : STD_LOGIC;
    signal show_victory_s  : STD_LOGIC;
    
    --game intro display
    signal intro_r, intro_g, intro_b : STD_LOGIC_VECTOR(3 downto 0);
    signal intro_visible : STD_LOGIC;
    signal select_cheff_s : STD_LOGIC;
    signal select_chefm_s : STD_LOGIC;
    signal last_sw0 : STD_LOGIC := '0';
    signal last_sw1 : STD_LOGIC := '0';
    signal last_sw2 : STD_LOGIC := '0';
    signal chef_selected : STD_LOGIC := '0';
    
    --Chef near item, item highlighted
    signal slot_visible : STD_LOGIC;
    
    component buns_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  std_logic_vector(10 downto 0);
            icon_y    : in  std_logic_vector(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component cheese_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  std_logic_vector(10 downto 0);
            icon_y    : in  std_logic_vector(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component potato_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  std_logic_vector(10 downto 0);
            icon_y    : in  std_logic_vector(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component patty_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  std_logic_vector(10 downto 0);
            icon_y    : in  std_logic_vector(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component fryer_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component cola_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  std_logic_vector(10 downto 0);
            icon_y    : in  std_logic_vector(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component sprite_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  std_logic_vector(10 downto 0);
            icon_y    : in  std_logic_vector(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component trash_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;
    
    component plate_display is
        Port (
            pixel_row : in  std_logic_vector(10 downto 0);
            pixel_col : in  std_logic_vector(10 downto 0);
            icon_x    : in  std_logic_vector(10 downto 0);
            icon_y    : in  std_logic_vector(10 downto 0);
            red       : out std_logic_vector(3 downto 0);
            green     : out std_logic_vector(3 downto 0);
            blue      : out std_logic_vector(3 downto 0);
            visible : out std_logic
        );
    end component;
    
    component cheesep_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_y    : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;
    
    component bunspatty_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_y    : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;
    
    component bunscheese_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_y    : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;
    
    component burger_held_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_y    : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component fries_held_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_x    : in  STD_LOGIC_VECTOR(10 downto 0);
            icon_y    : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;
    
    component chefm_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            chefm_x   : in  STD_LOGIC_VECTOR(10 downto 0);
            chefm_y   : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    --chef female uses the same definition as chef male for simplicity
    component cheff_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            chefm_x   : in  STD_LOGIC_VECTOR(10 downto 0);
            chefm_y   : in  STD_LOGIC_VECTOR(10 downto 0);
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;

    component orders_display is
        Port (
            pixel_row      : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col      : in  STD_LOGIC_VECTOR(10 downto 0);
            shuffle_sel    : in  STD_LOGIC_VECTOR(2 downto 0);
            current_order  : in  integer range 0 to 7;
            item_a_done    : in  STD_LOGIC;
            item_b_done    : in  STD_LOGIC;
            current_item_a : out STD_LOGIC_VECTOR(2 downto 0);
            current_item_b : out STD_LOGIC_VECTOR(2 downto 0);
            time_left : in integer range 0 to 180;
            red            : out STD_LOGIC_VECTOR(3 downto 0);
            green          : out STD_LOGIC_VECTOR(3 downto 0);
            blue           : out STD_LOGIC_VECTOR(3 downto 0);
            visible        : out STD_LOGIC
        );
    end component;
    
    component game_message_display is
        Port (
            pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
            show_time_out : in STD_LOGIC;
            show_victory  : in STD_LOGIC;
            red       : out STD_LOGIC_VECTOR(3 downto 0);
            green     : out STD_LOGIC_VECTOR(3 downto 0);
            blue      : out STD_LOGIC_VECTOR(3 downto 0);
            visible   : out STD_LOGIC
        );
    end component;
    
    component intro_display is
        Port (
            pixel_row     : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col     : in  STD_LOGIC_VECTOR(10 downto 0);
            select_cheff  : in  STD_LOGIC;
            select_chefm  : in  STD_LOGIC;
            red           : out STD_LOGIC_VECTOR(3 downto 0);
            green         : out STD_LOGIC_VECTOR(3 downto 0);
            blue          : out STD_LOGIC_VECTOR(3 downto 0);
            visible       : out STD_LOGIC
        );
    end component;

    function held_to_code(item : held_item_t) return STD_LOGIC_VECTOR is
    begin
        case item is
            when HOLD_BURGER => return "001";
            when HOLD_FRIES  => return "010";
            when HOLD_SPRITE => return "011";
            when HOLD_COLA   => return "100";
            when others      => return "000";
        end case;
    end function;

begin

    score_out <= score;

    buns_inst : buns_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => "00000001000", -- 8
        icon_y    => "00011100110", -- 230
        red       => buns_r,
        green     => buns_g,
        blue      => buns_b,
        visible   => buns_visible
    );

    cheese_inst : cheese_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x => "01011011000", -- 728
        icon_y => "00011100110", -- 230
        red       => cheese_r,
        green     => cheese_g,
        blue      => cheese_b,
        visible   => cheese_visible
    );

    potato_inst : potato_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x => "01011011000", -- 728
        icon_y => "00101100010", -- 354
        red       => potato_r,
        green     => potato_g,
        blue      => potato_b,
        visible   => potato_visible
    );

    patty_inst : patty_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x => "00000001000", -- 8
        icon_y => "00101100010", -- 354
        red       => patty_r,
        green     => patty_g,
        blue      => patty_b,
        visible   => patty_visible
    );

    fryer_inst : fryer_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        red       => fryer_r,
        green     => fryer_g,
        blue      => fryer_b,
        visible   => fryer_visible
    );

    cola_inst : cola_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => "00010100000", -- 208 left 30 = 178 -> 160
        icon_y    => "00001011101", -- 93
        red       => cola_r,
        green     => cola_g,
        blue      => cola_b,
        visible   => cola_visible
    );

    sprite_inst : sprite_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x => "00100011101", -- 315 left 30 = 285
        icon_y => "00001011101", -- 93
       
        red       => sprite_r,
        green     => sprite_g,
        blue      => sprite_b,
        visible   => sprite_visible
    );

    trash_inst : trash_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        red       => trash_r,
        green     => trash_g,
        blue      => trash_b,
        visible   => trash_visible
    );
    
    plate_inst : plate_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x => "00000001000", -- 8
        icon_y => "00111011110", -- 478
        red       => plate_r,
        green     => plate_g,
        blue      => plate_b,
        visible   => plate_visible
    );

    chefm_inst : chefm_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        chefm_x   => chefm_x,
        chefm_y   => chefm_y,
        red       => chefm_r,
        green     => chefm_g,
        blue      => chefm_b,
        visible   => chefm_visible
    );

    cheff_inst : cheff_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        chefm_x   => chefm_x,
        chefm_y   => chefm_y,
        red       => cheff_r,
        green     => cheff_g,
        blue      => cheff_b,
        visible   => cheff_visible
    );
    
    held_cola_inst : cola_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_drink_x,
        icon_y    => hand_drink_y,
        red       => held_cola_r,
        green     => held_cola_g,
        blue      => held_cola_b,
        visible   => held_cola_visible
    );
    
    -- Holding a copy of table items
    held_sprite_inst : sprite_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_drink_x,
        icon_y    => hand_drink_y,
        red       => held_sprite_r,
        green     => held_sprite_g,
        blue      => held_sprite_b,
        visible   => held_sprite_visible
    );
    
    held_buns_inst : buns_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_buns_r,
        green     => held_buns_g,
        blue      => held_buns_b,
        visible   => held_buns_visible
    );
    
    held_patty_inst : patty_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_patty_r,
        green     => held_patty_g,
        blue      => held_patty_b,
        visible   => held_patty_visible
    );
    
    held_plate_inst : plate_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_plate_r,
        green     => held_plate_g,
        blue      => held_plate_b,
        visible   => held_plate_visible
    );
    
    held_cheese_inst : cheese_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_cheese_r,
        green     => held_cheese_g,
        blue      => held_cheese_b,
        visible   => held_cheese_visible
    );
    
    held_potato_inst : potato_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_potato_r,
        green     => held_potato_g,
        blue      => held_potato_b,
        visible   => held_potato_visible
    );
    
    held_cheesep_inst : cheesep_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_cheesep_r,
        green     => held_cheesep_g,
        blue      => held_cheesep_b,
        visible   => held_cheesep_visible
    );
    
    held_bunspatty_inst : bunspatty_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_bunspatty_r,
        green     => held_bunspatty_g,
        blue      => held_bunspatty_b,
        visible   => held_bunspatty_visible
    );
    
    held_bunscheese_inst : bunscheese_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_bunscheese_r,
        green     => held_bunscheese_g,
        blue      => held_bunscheese_b,
        visible   => held_bunscheese_visible
    );
    
    held_burger_inst : burger_held_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_burger_r,
        green     => held_burger_g,
        blue      => held_burger_b,
        visible   => held_burger_visible
    );
    
    held_fries_inst : fries_held_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => hand_plate_x,
        icon_y    => hand_plate_y,
        red       => held_fries_r,
        green     => held_fries_g,
        blue      => held_fries_b,
        visible   => held_fries_visible
    );

    orders_inst : orders_display
    port map (
        pixel_row      => pixel_row,
        pixel_col      => pixel_col,
        shuffle_sel    => shuffle_sel,
        current_order  => current_order,
        item_a_done    => item_a_done,
        item_b_done    => item_b_done,
        current_item_a => current_item_a,
        current_item_b => current_item_b,
        time_left => time_left,
        red            => orders_r,
        green          => orders_g,
        blue           => orders_b,
        visible        => orders_visible
    );
    
    show_time_out_s <= '1' when game_state = GAME_OVER else '0';
    show_victory_s  <= '1' when game_state = GAME_WIN else '0';
    
    msg_inst : game_message_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        show_time_out => show_time_out_s,
        show_victory  => show_victory_s,
        red => msg_r,
        green => msg_g,
        blue => msg_b,
        visible => msg_visible
    );
    
    --default is no chef selected until sw1 and sw0 toggles
    select_cheff_s <= '1' when selected_chef = SELECT_CHEFF and chef_selected = '1' else '0';
    select_chefm_s <= '1' when selected_chef = SELECT_CHEFM and chef_selected = '1' else '0';
    intro_inst : intro_display
    port map (
        pixel_row    => pixel_row,
        pixel_col    => pixel_col,
        select_cheff => select_cheff_s,
        select_chefm => select_chefm_s,
        red          => intro_r,
        green        => intro_g,
        blue         => intro_b,
        visible      => intro_visible
    );
    
    --align left hand position for drinks, adjust later if needed
    hand_drink_x <= chefm_x + 32; --test two pixel right more on chefm
    hand_drink_y <= chefm_y + 99; --position of bottom of the hand on chefm
    
    --align left hand position for plate items
    hand_plate_x <= chefm_x + 60;
    hand_plate_y <= chefm_y + 102; --105->102 a bit more up 
    
    
    -- chef center near cola center, cola center = 192, 125
    -- chef center is chefm_x + 98, chefm_y + 98
    near_cola <= '1' when
        (chefm_x + 98) >= 162 and (chefm_x + 98) <= 222 and --177-> 162  207->222
        (chefm_y + 98) >= 200 and (chefm_y + 98) <= 276 else '0'; 
    
    -- chef center near sprite center, sprite center = 317, 125
    near_sprite <= '1' when
        (chefm_x + 98) >= 287 and (chefm_x + 98) <= 347 and --302,332 -> 287 347
        (chefm_y + 98) >= 200 and (chefm_y + 98) <= 276 else '0'; 
        
    -- trash center around (760, 510)
    near_trash <= '1' when
        (chefm_x + 98) >= 660 and (chefm_x + 98) <= 720 and 
        (chefm_y + 98) >= 445 and (chefm_y + 98) <= 550 else '0';
        
    near_fryer <= '1' when
        (chefm_x + 98) >= 413 and (chefm_x + 98) <= 477 and
        (chefm_y + 98) >= 200 and (chefm_y + 98) <= 276 else '0'; 
            
    near_buns <= '1' when
        (chefm_x + 98) >= 80 and (chefm_x + 98) <= 140 and
        (chefm_y + 98) >= 230 and (chefm_y + 98) <= 286 else '0'; 
    
    near_patty <= '1' when
        (chefm_x + 98) >= 80 and (chefm_x + 98) <= 140 and
        (chefm_y + 98) >= 322 and (chefm_y + 98) <= 428 else '0'; 
        
    near_plate <= '1' when
        (chefm_x + 98) >= 80 and (chefm_x + 98) <= 140 and
        (chefm_y + 98) >= 464 and (chefm_y + 98) <= 554 else '0'; 
        
    near_cheese <= '1' when
        (chefm_x + 98) >= 660 and (chefm_x + 98) <= 720 and
        (chefm_y + 98) >= 230 and (chefm_y + 98) <= 286 else '0';
        
    near_potato <= '1' when
        (chefm_x + 98) >= 660 and (chefm_x + 98) <= 720 and
        (chefm_y + 98) >= 300 and (chefm_y + 98) <= 428 else '0'; 
        
    near_counter <= '1' when 
        (chefm_x + 98) >= 555 and (chefm_x + 98) <= 625 and
        (chefm_y + 98) >= 200 and (chefm_y + 98) <= 276 else '0'; 
        

    process(pixel_row, pixel_col,
            buns_r, buns_g, buns_b, buns_visible,
            cheese_r, cheese_g, cheese_b, cheese_visible,
            potato_r, potato_g, potato_b, potato_visible,
            patty_r, patty_g, patty_b, patty_visible,
            fryer_r, fryer_g, fryer_b, fryer_visible,
            cola_r, cola_g, cola_b, cola_visible,
            sprite_r, sprite_g, sprite_b, sprite_visible,
            trash_r, trash_g, trash_b, trash_visible,
            plate_r, plate_g, plate_b, plate_visible,
            chefm_r, chefm_g, chefm_b, chefm_visible,
            cheff_r, cheff_g, cheff_b, cheff_visible,
            orders_r, orders_g, orders_b, orders_visible,
            held_cola_r, held_cola_g, held_cola_b, held_cola_visible,
            held_sprite_r, held_sprite_g, held_sprite_b, held_sprite_visible,
            held_buns_r, held_buns_g, held_buns_b, held_buns_visible,
            held_patty_r, held_patty_g, held_patty_b, held_patty_visible,
            held_plate_r, held_plate_g, held_plate_b, held_plate_visible,
            held_cheese_r, held_cheese_g, held_cheese_b, held_cheese_visible,
            held_potato_r, held_potato_g, held_potato_b, held_potato_visible,
            held_cheesep_r, held_cheesep_g, held_cheesep_b, held_cheesep_visible,
            held_bunspatty_r, held_bunspatty_g, held_bunspatty_b, held_bunspatty_visible,
            held_bunscheese_r, held_bunscheese_g, held_bunscheese_b, held_bunscheese_visible,
            held_burger_r, held_burger_g, held_burger_b, held_burger_visible,
            held_fries_r, held_fries_g, held_fries_b, held_fries_visible,
            near_buns, near_patty, near_plate, near_cheese, near_potato, near_trash, near_cola, near_sprite, near_fryer, near_counter,
            msg_r, msg_g, msg_b, msg_visible,
            intro_r, intro_g, intro_b, intro_visible,
            game_state, selected_chef,
            
            held_item)
    begin
        red   <= "1100";
        green <= "1100";
        blue  <= "1111";
        --ADDED: ***
        slot_visible <= '0';

        if pixel_row >= 600 then
            red   <= "1010";
            green <= "0100";
            blue  <= "0000";
        end if;

        if (pixel_col <= 80 and pixel_row >= 170 and pixel_row <= 600) then --left table  90->170
            red   <= "1011"; --1010
            green <= "0101"; --0100
            blue  <= "0001"; --0000
        end if;

        if (pixel_col <= 800 and pixel_row >= 0 and pixel_row <= 170) then -- top table 120, 220
            red   <= "1011";
            green <= "0101";
            blue  <= "0001";
        end if;

        if (pixel_col >= 720 and pixel_col <= 800 and pixel_row >= 170 and pixel_row <= 600) then --right table 
            red   <= "1011";
            green <= "0101";
            blue  <= "0001";
        end if;
        
        --SERVING STATION (height 90 and 150 can change later) 550 to 640 (635) x position span        
        if (pixel_col >= 550 and pixel_col <= 560 and pixel_row >= 102 and pixel_row <= 163) then --90->102
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
        end if;
        
        if (pixel_col >= 561 and pixel_col <= 564 and pixel_row >= 102 and pixel_row <= 163) then --grey bar
            red   <= "1001";
            green <= "1001";
            blue  <= "1001";
        end if;
        
        if (pixel_col >= 565 and pixel_col <= 575 and pixel_row >= 102 and pixel_row <= 163) then 
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
        end if;
        
        if (pixel_col >= 576 and pixel_col <= 579 and pixel_row >= 102 and pixel_row <= 163) then --grey bar
            red   <= "1001";
            green <= "1001";
            blue  <= "1001";
        end if;
        
        if (pixel_col >= 580 and pixel_col <= 590 and pixel_row >= 102 and pixel_row <= 163) then 
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
        end if;
        
        if (pixel_col >= 591 and pixel_col <= 594 and pixel_row >= 102 and pixel_row <= 163) then --grey bar
            red   <= "1001";
            green <= "1001";
            blue  <= "1001";
        end if;
                
        if (pixel_col >= 595 and pixel_col <= 605 and pixel_row >= 102 and pixel_row <= 163) then 
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
        end if;
        
        if (pixel_col >= 606 and pixel_col <= 609 and pixel_row >= 102 and pixel_row <= 163) then --grey bar
            red   <= "1001";
            green <= "1001";
            blue  <= "1001";
        end if;
        
        if (pixel_col >= 610 and pixel_col <= 620 and pixel_row >= 102 and pixel_row <= 163) then 
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
        end if;
        
        if (pixel_col >= 621 and pixel_col <= 624 and pixel_row >= 102 and pixel_row <= 163) then --grey bar
            red   <= "1001";
            green <= "1001";
            blue  <= "1001";
        end if;
        
        if (pixel_col >= 625 and pixel_col <= 635 and pixel_row >= 102 and pixel_row <= 163) then 
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
        end if;
        
        --***
        -- declare signal and set slot_visible = '0'
        if (pixel_col >= 8 and pixel_col <= 71 and pixel_row >= 230 and pixel_row <= 293) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;


        if (pixel_col >= 8 and pixel_col <= 71 and pixel_row >= 354 and pixel_row <= 417) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;

        if (pixel_col >= 8 and pixel_col <= 71 and pixel_row >= 478 and pixel_row <= 541) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;

        if (pixel_col >= 728 and pixel_col <= 791 and pixel_row >= 230 and pixel_row <= 293) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;

        if (pixel_col >= 728 and pixel_col <= 791 and pixel_row >= 354 and pixel_row <= 417) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;

        if (pixel_col >= 728 and pixel_col <= 791 and pixel_row >= 478 and pixel_row <= 541) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;

        if (pixel_col >= 160 and pixel_col <= 223 and pixel_row >= 102 and pixel_row <= 166) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;

        if (pixel_col >= 285 and pixel_col <= 348 and pixel_row >= 102 and pixel_row <= 166) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;

        if (pixel_col >= 411 and pixel_col <= 474 and pixel_row >= 102 and pixel_row <= 166) then
            slot_visible <= '1';
            red <= "1010"; --grey
            green <= "1010";
            blue <= "1010";
        end if;
        
        ---------------------------
        if (pixel_col >= 8 and pixel_col <= 71 and pixel_row >= 230 and pixel_row <= 293) then
            if (pixel_col <= 11 OR pixel_col >= 68 OR pixel_row <= 233 OR pixel_row >= 290) then
            slot_visible <= '1';
                if near_buns = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
        if (pixel_col >= 8 and pixel_col <= 71 and pixel_row >= 354 and pixel_row <= 417) then
            if (pixel_col <= 11 OR pixel_col >= 68 OR pixel_row <= 357 OR pixel_row >= 414) then
            slot_visible <= '1';
                if near_patty = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
        if (pixel_col >= 8 and pixel_col <= 71 and pixel_row >= 478 and pixel_row <= 541) then
            if (pixel_col <= 11 OR pixel_col >= 68 OR pixel_row <= 481 OR pixel_row >= 538) then
            slot_visible <= '1';
                if near_plate = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
         if (pixel_col >= 728 and pixel_col <= 791 and pixel_row >= 230 and pixel_row <= 293) then
            if (pixel_col <= 731 OR pixel_col >= 788 OR pixel_row <= 233 OR pixel_row >= 290) then
            slot_visible <= '1';
                if near_cheese = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
        if (pixel_col >= 728 and pixel_col <= 791 and pixel_row >= 354 and pixel_row <= 417) then
            if (pixel_col <= 731 OR pixel_col >= 788 OR pixel_row <= 357 OR pixel_row >= 414) then
            slot_visible <= '1';
                if near_potato = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
        if (pixel_col >= 728 and pixel_col <= 791 and pixel_row >= 478 and pixel_row <= 541) then
            if (pixel_col <= 731 OR pixel_col >= 788 OR pixel_row <= 481 OR pixel_row >= 538) then
            slot_visible <= '1';
                if near_trash = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
        if (pixel_col >= 160 and pixel_col <= 223 and pixel_row >= 102 and pixel_row <= 166) then
            if (pixel_col <= 163 OR pixel_col >= 220 OR pixel_row <= 105 OR pixel_row >= 163) then
            slot_visible <= '1';
                if near_cola = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
        if (pixel_col >= 285 and pixel_col <= 348 and pixel_row >= 102 and pixel_row <= 166) then
            if (pixel_col <= 288 OR pixel_col >= 345 OR pixel_row <= 105 OR pixel_row >= 163) then
            slot_visible <= '1';
                if near_sprite = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        
        if (pixel_col >= 411 and pixel_col <= 474 and pixel_row >= 102 and pixel_row <= 166) then
            if (pixel_col <= 414 OR pixel_col >= 471 OR pixel_row <= 105 OR pixel_row >= 163) then
            slot_visible <= '1';
                if near_fryer = '1' then
                    red <= "1111"; --yellow
                    green <= "1111";
                    blue <= "0000";
                else 
                    red <= "1111"; --white
                    green <= "1111";
                    blue <= "1111";
                end if;
            end if;
        end if;
        --***
    

        if buns_visible = '1' then
            red   <= buns_r;
            green <= buns_g;
            blue  <= buns_b;
        end if;

        if cheese_visible = '1' then
            red   <= cheese_r;
            green <= cheese_g;
            blue  <= cheese_b;
        end if;

        if potato_visible = '1' then
            red   <= potato_r;
            green <= potato_g;
            blue  <= potato_b;
        end if;

        if patty_visible = '1' then
            red   <= patty_r;
            green <= patty_g;
            blue  <= patty_b;
        end if;

        if fryer_visible = '1' then
            red   <= fryer_r;
            green <= fryer_g;
            blue  <= fryer_b;
        end if;

        if cola_visible = '1' then
            red   <= cola_r;
            green <= cola_g;
            blue  <= cola_b;
        end if;

        if sprite_visible = '1' then
            red   <= sprite_r;
            green <= sprite_g;
            blue  <= sprite_b;
        end if;

        if trash_visible = '1' then
            red   <= trash_r;
            green <= trash_g;
            blue  <= trash_b;
        end if;
        
        if plate_visible = '1' then
            red   <= plate_r;
            green <= plate_g;
            blue  <= plate_b;
        end if;

        if game_state = GAME_PLAYING and selected_chef = SELECT_CHEFM and chefm_visible = '1' then
            red   <= chefm_r;
            green <= chefm_g;
            blue  <= chefm_b;
        end if;
        
        if game_state = GAME_PLAYING and selected_chef = SELECT_CHEFF and cheff_visible = '1' then
            red   <= cheff_r;
            green <= cheff_g;
            blue  <= cheff_b;
        end if;
        
        if held_item = HOLD_COLA and held_cola_visible = '1' then
            red   <= held_cola_r;
            green <= held_cola_g;
            blue  <= held_cola_b;
        end if;
        
        if held_item = HOLD_SPRITE and held_sprite_visible = '1' then
            red   <= held_sprite_r;
            green <= held_sprite_g;
            blue  <= held_sprite_b;
        end if;
        
        if held_item = HOLD_BUNS and held_buns_visible = '1' then
            red   <= held_buns_r;
            green <= held_buns_g;
            blue  <= held_buns_b;
        end if;
        
        if held_item = HOLD_PATTY and held_patty_visible = '1' then
            red   <= held_patty_r;
            green <= held_patty_g;
            blue  <= held_patty_b;
        end if;
        
        if held_item = HOLD_PLATE and held_plate_visible = '1' then
            red   <= held_plate_r;
            green <= held_plate_g;
            blue  <= held_plate_b;
        end if;
        
        if held_item = HOLD_CHEESE and held_cheese_visible = '1' then
            red   <= held_cheese_r;
            green <= held_cheese_g;
            blue  <= held_cheese_b;
        end if;
        
        if held_item = HOLD_POTATO and held_potato_visible = '1' then
            red   <= held_potato_r;
            green <= held_potato_g;
            blue  <= held_potato_b;
        end if;
        
        if held_item = HOLD_CHEESEP and held_cheesep_visible = '1' then
            red   <= held_cheesep_r;
            green <= held_cheesep_g;
            blue  <= held_cheesep_b;
        end if;
        
        if held_item = HOLD_BUNSPATTY and held_bunspatty_visible = '1' then
            red   <= held_bunspatty_r;
            green <= held_bunspatty_g;
            blue  <= held_bunspatty_b;
        end if;
        
        if held_item = HOLD_BUNSCHEESE and held_bunscheese_visible = '1' then
            red   <= held_bunscheese_r;
            green <= held_bunscheese_g;
            blue  <= held_bunscheese_b;
        end if;
        
        if held_item = HOLD_BURGER and held_burger_visible = '1' then
            red   <= held_burger_r;
            green <= held_burger_g;
            blue  <= held_burger_b;
        end if;
        
        if held_item = HOLD_FRIES and held_fries_visible = '1' then
            red   <= held_fries_r;
            green <= held_fries_g;
            blue  <= held_fries_b;
        end if;

        if orders_visible = '1' then
            red   <= orders_r;
            green <= orders_g;
            blue  <= orders_b;
        end if;
        
        if msg_visible = '1' then
            red   <= msg_r;
            green <= msg_g;
            blue  <= msg_b;
        end if;
        
        if game_state = INTRO_SELECT then
            if intro_visible = '1' then
                red   <= intro_r;
                green <= intro_g;
                blue  <= intro_b;
            end if;
        end if;

    end process;


process(v_sync)
    variable held_code : STD_LOGIC_VECTOR(2 downto 0);
    variable a_done_v  : STD_LOGIC;
    variable b_done_v  : STD_LOGIC;
begin
    if rising_edge(v_sync) then
    
    --SW0 and SW1 toggle to select Chef
        if game_state = INTRO_SELECT then
        -- if SW1 toggles on or off, choose CHEFF on the left
            if (sw1 = '1' and last_sw1 = '0') OR (sw1 = '0' and last_sw1 = '1') then
                selected_chef <= SELECT_CHEFF;
                chef_selected <= '1';           
        
            -- if SW0 toggles on or off, choose CHEFM on the right
            elsif (sw0 = '1' and last_sw0 = '0') OR (sw0 = '0' and last_sw0 = '1') then
                selected_chef <= SELECT_CHEFM;
                chef_selected <= '1';
            
            -- SW2 starts game only after a chef was selected, toggle SW2 to start game
            elsif ((sw2 = '1' and last_sw2 = '0') OR (sw2 = '0' and last_sw2 = '1')) and chef_selected = '1' then                
                game_state <= GAME_PLAYING;
                    
                -- reset game
                score <= (others => '0');
                current_order <= 0;
                item_a_done <= '0';
                item_b_done <= '0';
                held_item <= HOLD_NONE;
                time_left <= 180;
                frame_count <= 0;
            end if; 
        
        elsif game_state = GAME_PLAYING then
            -- timer only runs during gameplay
            if time_left > 0 then
                if frame_count = 59 then
                    frame_count <= 0;
                    time_left <= time_left - 1;
                else
                    frame_count <= frame_count + 1;
                end if;
            else
                game_state <= GAME_OVER;
            end if;

            -- action logic only works during gameplay
            if action = '1' and last_action = '0' then

                a_done_v := item_a_done;
                b_done_v := item_b_done;
                held_code := held_to_code(held_item);

                --If chef is near trash, clear hand
                if near_trash = '1' then
                    held_item <= HOLD_NONE;
                    
                --Serve food if near counter
                elsif near_counter = '1' then            
                    if held_code /= "000" then
                        if held_code = current_item_a and a_done_v = '0' then
                            a_done_v := '1';
                            held_item <= HOLD_NONE;

                        elsif held_code = current_item_b and b_done_v = '0' then
                            b_done_v := '1';
                            held_item <= HOLD_NONE;
                        end if;
                    end if;

                    item_a_done <= a_done_v;
                    item_b_done <= b_done_v;

                    --Single item order complete
                    if current_item_b = "000" and a_done_v = '1' then
                        if current_order < 7 then
                            current_order <= current_order + 1;
                            item_a_done <= '0';
                            item_b_done <= '0';
                        else
                            game_state <= GAME_WIN;
                        end if;
                        
                        score <= score + 1;

                    --Two item order complete
                    elsif current_item_b /= "000" and a_done_v = '1' and b_done_v = '1' then
                        if current_order < 7 then
                            current_order <= current_order + 1;
                            item_a_done <= '0';
                            item_b_done <= '0';
                        else
                            game_state <= GAME_WIN;
                        end if;
                        
                        score <= score + 1;
                    end if;

                --if hand is empty, can pick up drinks and plate
                elsif held_item = HOLD_NONE then
                    if near_cola = '1' then
                        held_item <= HOLD_COLA;
                    elsif near_sprite = '1' then
                        held_item <= HOLD_SPRITE;
                    elsif near_plate = '1' then
                        held_item <= HOLD_PLATE;
                    end if;
                        
                --if hand holds plate, can pick up food ingredients
                elsif held_item = HOLD_PLATE then
                    if near_buns = '1' then
                        held_item <= HOLD_BUNS;
                    elsif near_patty = '1' then
                        held_item <= HOLD_PATTY;                    
                    elsif near_cheese = '1' then
                        held_item <= HOLD_CHEESE;
                    elsif near_potato = '1' then
                        held_item <= HOLD_POTATO;
                    end if;
                    
                --Else if holding buns, can add cheese or patty to it
                elsif held_item = HOLD_BUNS then
                    if near_cheese = '1' then
                        held_item <= HOLD_BUNSCHEESE;
                    elsif near_patty = '1' then 
                        held_item <= HOLD_BUNSPATTY;
                    end if;
                        
                --Else if holding cheese, can add buns or patty to it
                elsif held_item = HOLD_CHEESE then
                    if near_buns = '1' then
                        held_item <= HOLD_BUNSCHEESE;
                    elsif near_patty = '1' then 
                        held_item <= HOLD_CHEESEP;
                    end if;
                        
                --Else if holding patty, can add buns or cheese to it
                elsif held_item = HOLD_PATTY then
                    if near_buns = '1' then 
                        held_item <= HOLD_BUNSPATTY;
                    elsif near_cheese = '1' then 
                        held_item <= HOLD_CHEESEP;
                    end if;
                        
                --Else if holding buns and cheese, can add patty to it to make burger
                elsif held_item = HOLD_BUNSCHEESE then
                    if near_patty = '1' then 
                        held_item <= HOLD_BURGER;
                    end if;
                        
                --Else if holding buns and patty, can add cheese to it to make burger
                elsif held_item = HOLD_BUNSPATTY then
                    if near_cheese = '1' then 
                        held_item <= HOLD_BURGER;
                    end if;
                        
                --Else if holding cheese and patty, can add buns to it to make burger
                elsif held_item = HOLD_CHEESEP then
                    if near_buns = '1' then 
                        held_item <= HOLD_BURGER;
                    end if;
                    
                --Turn Potato into fries at fryer station
                elsif held_item = HOLD_POTATO then
                    if near_fryer = '1' then 
                        held_item <= HOLD_FRIES;
                    end if;
                end if;

            end if;

        elsif game_state = GAME_OVER or game_state = GAME_WIN then
            --In game over state, toggle SW2 to return to intro screen
            if (sw2 = '1' and last_sw2 = '0') OR (sw2 = '0' and last_sw2 = '1') then
                game_state <= INTRO_SELECT;
                chef_selected <= '0';
            end if;
        end if;

        last_action <= action;
        last_sw0 <= sw0;
        last_sw1 <= sw1;
        last_sw2 <= sw2;
    
    end if;
end process;
end Behavioral;