library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity intro_display is
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
end intro_display;

architecture Behavioral of intro_display is

    signal chefm_r, chefm_g, chefm_b : STD_LOGIC_VECTOR(3 downto 0);
    signal cheff_r, cheff_g, cheff_b : STD_LOGIC_VECTOR(3 downto 0);
    signal chefm_visible : STD_LOGIC;
    signal cheff_visible : STD_LOGIC;

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

begin

    cheff_intro_inst : cheff_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        chefm_x   => "00010000001", -- 129
        chefm_y   => "00011011011", -- 219
        red       => cheff_r,
        green     => cheff_g,
        blue      => cheff_b,
        visible   => cheff_visible
    );

    chefm_intro_inst : chefm_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        chefm_x   => "00111011111", -- 479
        chefm_y   => "00011011011", -- 219
        red       => chefm_r,
        green     => chefm_g,
        blue      => chefm_b,
        visible   => chefm_visible
    );

process(pixel_row, pixel_col, select_cheff, select_chefm,
        chefm_r, chefm_g, chefm_b, chefm_visible,
        cheff_r, cheff_g, cheff_b, cheff_visible)

    variable px : integer;
    variable py : integer;

begin

    px := to_integer(unsigned(pixel_col));
    py := to_integer(unsigned(pixel_row));

    red <= "0000";
    green <= "0000";
    blue <= "0000";
    visible <= '0';

    -- background floor color
    if px >= 0 and px <= 799 and py >= 0 and py <= 599 then
        visible <= '1';
        red   <= "1100";
        green <= "1100";
        blue  <= "1111";
    end if;

    -- left box CHEFF, light grey background
    if px >= 110 and px <= 340 and py >= 200 and py <= 430 then
        visible <= '1';
        red   <= "1010";
        green <= "1010";
        blue  <= "1010";
    end if;

    -- right box CHEFM, light grey background
    if px >= 460 and px <= 690 and py >= 200 and py <= 430 then
        visible <= '1';
        red   <= "1010";
        green <= "1010";
        blue  <= "1010";
    end if;

    -- draw CHEFF sprite inside left box
    if cheff_visible = '1' then
        visible <= '1';
        red     <= cheff_r;
        green   <= cheff_g;
        blue    <= cheff_b;
    end if;

    -- draw CHEFM sprite inside right box
    if chefm_visible = '1' then
        visible <= '1';
        red     <= chefm_r;
        green   <= chefm_g;
        blue    <= chefm_b;
    end if;

    -- left box border
    if px >= 110 and px <= 340 and py >= 200 and py <= 430 then
        if px <= 116 or px >= 334 or py <= 206 or py >= 424 then
            visible <= '1';
            if select_cheff = '1' then
                red   <= "1111";
                green <= "1111";
                blue  <= "0000"; -- yellow selected
            else
                red   <= "1111";
                green <= "1111";
                blue  <= "1111"; -- white
            end if;
        end if;
    end if;

    -- right box border
    if px >= 460 and px <= 690 and py >= 200 and py <= 430 then
        if px <= 466 or px >= 684 or py <= 206 or py >= 424 then
            visible <= '1';
            if select_chefm = '1' then
                red   <= "1111";
                green <= "1111";
                blue  <= "0000"; -- yellow selected
            else
                red   <= "1111";
                green <= "1111";
                blue  <= "1111"; -- white
            end if;
        end if;
    end if;

end process;

end Behavioral;