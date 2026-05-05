library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity overcooked is
    port (
        clk_in      : in  STD_LOGIC;
        VGA_red     : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_green   : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_blue    : out STD_LOGIC_VECTOR(3 downto 0);
        VGA_hsync   : out STD_LOGIC;
        VGA_vsync   : out STD_LOGIC;
        btnl        : in  STD_LOGIC;
        btnr        : in  STD_LOGIC;
        btnu        : in  STD_LOGIC;
        btnd        : in  STD_LOGIC;
        btn0        : in  STD_LOGIC;
        sw0         : in  STD_LOGIC;
        sw1         : in  STD_LOGIC;
        sw2         : in  STD_LOGIC;
        SEG7_anode  : out STD_LOGIC_VECTOR(7 downto 0);
        SEG7_seg    : out STD_LOGIC_VECTOR(6 downto 0)
    );
end overcooked;

architecture Behavioral of overcooked is

    signal pxl_clk : STD_LOGIC := '0';

    signal S_red, S_green, S_blue : STD_LOGIC_VECTOR(3 downto 0);
    signal S_vsync : STD_LOGIC;
    signal S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR(10 downto 0);

    signal chefm_x : STD_LOGIC_VECTOR(10 downto 0) := conv_std_logic_vector(400, 11);
    signal chefm_y : STD_LOGIC_VECTOR(10 downto 0) := conv_std_logic_vector(300, 11);

    signal count   : STD_LOGIC_VECTOR(20 downto 0) := (others => '0');
    signal display : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal led_mpx : STD_LOGIC_VECTOR(2 downto 0);
    
    --Shuffle signals:
    signal rand_count  : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal shuffle_sel : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal last_sw2 : STD_LOGIC := '0';

    component cookfood is
        port (
            v_sync      : in  STD_LOGIC;
            pixel_row   : in  STD_LOGIC_VECTOR(10 downto 0);
            pixel_col   : in  STD_LOGIC_VECTOR(10 downto 0);
            chefm_x     : in  STD_LOGIC_VECTOR(10 downto 0);
            chefm_y     : in  STD_LOGIC_VECTOR(10 downto 0);
            shuffle_sel : in  STD_LOGIC_VECTOR(2 downto 0);
            action      : in  STD_LOGIC;
            sw0         : in  STD_LOGIC;
            sw1         : in  STD_LOGIC;
            sw2         : in  STD_LOGIC;
            red         : out STD_LOGIC_VECTOR(3 downto 0);
            green       : out STD_LOGIC_VECTOR(3 downto 0);
            blue        : out STD_LOGIC_VECTOR(3 downto 0);
            score_out   : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component vga_sync is
        port (
            pixel_clk : in  STD_LOGIC;
            red_in    : in  STD_LOGIC_VECTOR(3 downto 0);
            green_in  : in  STD_LOGIC_VECTOR(3 downto 0);
            blue_in   : in  STD_LOGIC_VECTOR(3 downto 0);
            red_out   : out STD_LOGIC_VECTOR(3 downto 0);
            green_out : out STD_LOGIC_VECTOR(3 downto 0);
            blue_out  : out STD_LOGIC_VECTOR(3 downto 0);
            hsync     : out STD_LOGIC;
            vsync     : out STD_LOGIC;
            pixel_row : out STD_LOGIC_VECTOR(10 downto 0);
            pixel_col : out STD_LOGIC_VECTOR(10 downto 0)
        );
    end component;

    component clk_wiz_0 is
        port (
            clk_in1  : in  STD_LOGIC;
            clk_out1 : out STD_LOGIC
        );
    end component;

    component leddec is
        port (
            dig   : in  STD_LOGIC_VECTOR(2 downto 0);
            data  : in  STD_LOGIC_VECTOR(7 downto 0);
            anode : out STD_LOGIC_VECTOR(7 downto 0);
            seg   : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

begin

    process(clk_in)
    begin
        if rising_edge(clk_in) then
            count <= count + 1;
            rand_count <= rand_count + 1; --increment randcount to allow shuffle
            
            -- shuffle order when SW2 starts a new game
            if sw2 = '1' and last_sw2 = '0' then
                shuffle_sel <= rand_count;
            end if;
            
            last_sw2 <= sw2;
            
            if count = 0 then
                if btnl = '1' and chefm_x > 30 then --80 -64 64-30 
                    chefm_x <= chefm_x - 8;
                elsif btnr = '1' and chefm_x < 580 then  --544
                    chefm_x <= chefm_x + 8;
                end if;

                if btnu = '1' and chefm_y > 150 then --220, 170
                    chefm_y <= chefm_y - 8;
                elsif btnd = '1' and chefm_y < 420 then  --408 ->504 -> 400
                    chefm_y <= chefm_y + 8; 
                end if;
            end if;
            -- Try passing chefm_y on to the anode
            
            
        end if;
    end process;

    led_mpx <= count(19 downto 17);

    game_inst : cookfood
    port map (
        v_sync    => S_vsync,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col,
        chefm_x   => chefm_x,
        chefm_y   => chefm_y,
        action    => btn0,
        sw0         => sw0,
        sw1         => sw1,
        sw2         => sw2,
        red       => S_red,
        green     => S_green,
        blue      => S_blue,
        score_out => display,
        shuffle_sel => shuffle_sel
    );

    vga_driver : vga_sync
    port map (
        pixel_clk => pxl_clk,
        red_in    => S_red,
        green_in  => S_green,
        blue_in   => S_blue,
        red_out   => VGA_red,
        green_out => VGA_green,
        blue_out  => VGA_blue,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col,
        hsync     => VGA_hsync,
        vsync     => S_vsync
    );

    VGA_vsync <= S_vsync;

    clk_wiz_0_inst : clk_wiz_0
    port map (
        clk_in1  => clk_in,
        clk_out1 => pxl_clk
    );

    led1 : leddec
    port map (
        dig   => led_mpx,
        data  => display,
        anode => SEG7_anode,
        seg   => SEG7_seg
    );

end Behavioral;