library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity order_slot_display is
    Port (
        pixel_row : in  STD_LOGIC_VECTOR(10 downto 0);
        pixel_col : in  STD_LOGIC_VECTOR(10 downto 0);
        icon_x    : in  STD_LOGIC_VECTOR(10 downto 0);
        icon_y    : in  STD_LOGIC_VECTOR(10 downto 0);
        item_code : in  STD_LOGIC_VECTOR(2 downto 0);
        red       : out STD_LOGIC_VECTOR(3 downto 0);
        green     : out STD_LOGIC_VECTOR(3 downto 0);
        blue      : out STD_LOGIC_VECTOR(3 downto 0);
        visible   : out STD_LOGIC
    );
end order_slot_display;

architecture Behavioral of order_slot_display is

    signal burger_r, burger_g, burger_b : STD_LOGIC_VECTOR(3 downto 0);
    signal fries_r, fries_g, fries_b    : STD_LOGIC_VECTOR(3 downto 0);
    signal sprite_r, sprite_g, sprite_b : STD_LOGIC_VECTOR(3 downto 0);
    signal cola_r, cola_g, cola_b       : STD_LOGIC_VECTOR(3 downto 0);

    signal burger_v, fries_v, sprite_v, cola_v : STD_LOGIC;

    component burger_display is
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

    component fries_display is
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

    component sprite_display is
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

    component cola_display is
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

begin

    burger_inst : burger_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => icon_x,
        icon_y    => icon_y,
        red       => burger_r,
        green     => burger_g,
        blue      => burger_b,
        visible   => burger_v
    );

    fries_inst : fries_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => icon_x,
        icon_y    => icon_y,
        red       => fries_r,
        green     => fries_g,
        blue      => fries_b,
        visible   => fries_v
    );

    sprite_inst : sprite_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => icon_x,
        icon_y    => icon_y,
        red       => sprite_r,
        green     => sprite_g,
        blue      => sprite_b,
        visible   => sprite_v
    );

    cola_inst : cola_display
    port map (
        pixel_row => pixel_row,
        pixel_col => pixel_col,
        icon_x    => icon_x,
        icon_y    => icon_y,
        red       => cola_r,
        green     => cola_g,
        blue      => cola_b,
        visible   => cola_v
    );

    process(item_code, burger_r, burger_g, burger_b, burger_v,
            fries_r, fries_g, fries_b, fries_v,
            sprite_r, sprite_g, sprite_b, sprite_v,
            cola_r, cola_g, cola_b, cola_v)
    begin
        red     <= "0000";
        green   <= "0000";
        blue    <= "0000";
        visible <= '0';

        case item_code is
            when "001" => -- burger
                red <= burger_r; green <= burger_g; blue <= burger_b; visible <= burger_v;

            when "010" => -- fries
                red <= fries_r; green <= fries_g; blue <= fries_b; visible <= fries_v;

            when "011" => -- sprite
                red <= sprite_r; green <= sprite_g; blue <= sprite_b; visible <= sprite_v;

            when "100" => -- cola
                red <= cola_r; green <= cola_g; blue <= cola_b; visible <= cola_v;

            when others =>
                red <= "0000"; green <= "0000"; blue <= "0000"; visible <= '0';
        end case;
    end process;

end Behavioral;