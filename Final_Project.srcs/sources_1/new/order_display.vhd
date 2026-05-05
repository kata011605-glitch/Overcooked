library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity orders_display is
    Port (
        pixel_row   : in  std_logic_vector(10 downto 0);
        pixel_col   : in  std_logic_vector(10 downto 0);
        shuffle_sel : in  std_logic_vector(2 downto 0);
        current_order  : in  integer range 0 to 7;
        item_a_done    : in  STD_LOGIC;
        item_b_done    : in  STD_LOGIC;
        current_item_a : out STD_LOGIC_VECTOR(2 downto 0);
        current_item_b : out STD_LOGIC_VECTOR(2 downto 0);
        time_left : in integer range 0 to 180;
        red         : out std_logic_vector(3 downto 0);
        green       : out std_logic_vector(3 downto 0);
        blue        : out std_logic_vector(3 downto 0);
        visible     : out std_logic
    );
end orders_display;

architecture Behavioral of orders_display is

    constant ORDER_W : integer := 90;
    constant ORDER_H : integer := 85;
    constant ORDER_Y : integer := 10;
    constant START_X : integer := 20;
    constant GAP     : integer := 7;

    type int_array  is array (0 to 7) of integer;
    type slv11_array is array (0 to 7) of std_logic_vector(10 downto 0);
    type slv3_array  is array (0 to 7) of std_logic_vector(2 downto 0);
    type color_array is array (0 to 7) of std_logic_vector(3 downto 0);
    type bit_array   is array (0 to 7) of std_logic;

    signal order_code : int_array;

    signal item_a_code : slv3_array;
    signal item_b_code : slv3_array;

    signal icon_a_x : slv11_array;
    signal icon_a_y : slv11_array;
    signal icon_b_x : slv11_array;
    signal icon_b_y : slv11_array;

    signal icon_a_r, icon_a_g, icon_a_b : color_array;
    signal icon_b_r, icon_b_g, icon_b_b : color_array;

    signal icon_a_v : bit_array;
    signal icon_b_v : bit_array;

    component order_slot_display is
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
    end component;

    function get_order_code(sel : std_logic_vector(2 downto 0); idx : integer) return integer is
    begin
        case sel is
            when "000" =>
                case idx is
                    when 0 => return 1;
                    when 1 => return 2;
                    when 2 => return 3;
                    when 3 => return 4;
                    when 4 => return 5;
                    when 5 => return 6;
                    when 6 => return 7;
                    when others => return 8;
                end case;

            when "001" =>
                case idx is
                    when 0 => return 4;
                    when 1 => return 1;
                    when 2 => return 7;
                    when 3 => return 2;
                    when 4 => return 6;
                    when 5 => return 8;
                    when 6 => return 3;
                    when others => return 5;
                end case;

            when "010" =>
                case idx is
                    when 0 => return 8;
                    when 1 => return 6;
                    when 2 => return 2;
                    when 3 => return 5;
                    when 4 => return 1;
                    when 5 => return 7;
                    when 6 => return 4;
                    when others => return 3;
                end case;

            when "011" =>
                case idx is
                    when 0 => return 3;
                    when 1 => return 5;
                    when 2 => return 1;
                    when 3 => return 8;
                    when 4 => return 7;
                    when 5 => return 2;
                    when 6 => return 6;
                    when others => return 4;
                end case;

            when "100" =>
                case idx is
                    when 0 => return 6;
                    when 1 => return 4;
                    when 2 => return 8;
                    when 3 => return 1;
                    when 4 => return 3;
                    when 5 => return 5;
                    when 6 => return 2;
                    when others => return 7;
                end case;

            when "101" =>
                case idx is
                    when 0 => return 2;
                    when 1 => return 7;
                    when 2 => return 5;
                    when 3 => return 3;
                    when 4 => return 8;
                    when 5 => return 4;
                    when 6 => return 1;
                    when others => return 6;
                end case;

            when "110" =>
                case idx is
                    when 0 => return 7;
                    when 1 => return 3;
                    when 2 => return 6;
                    when 3 => return 5;
                    when 4 => return 4;
                    when 5 => return 1;
                    when 6 => return 8;
                    when others => return 2;
                end case;

            when others =>
                case idx is
                    when 0 => return 5;
                    when 1 => return 8;
                    when 2 => return 4;
                    when 3 => return 6;
                    when 4 => return 2;
                    when 5 => return 3;
                    when 6 => return 7;
                    when others => return 1;
                end case;
        end case;
    end function;

    function get_item_a(order : integer) return std_logic_vector is
    begin
        case order is
            when 1 => return "001"; -- burger
            when 2 => return "010"; -- fries
            when 3 => return "001"; -- burger
            when 4 => return "001"; -- burger
            when 5 => return "010"; -- fries
            when 6 => return "001"; -- burger
            when 7 => return "010"; -- fries
            when 8 => return "010"; -- fries
            when others => return "000";
        end case;
    end function;

    function get_item_b(order : integer) return std_logic_vector is
    begin
        case order is
            when 1 => return "000"; -- nothing
            when 2 => return "000"; -- nothing
            when 3 => return "010"; -- fries
            when 4 => return "011"; -- sprite
            when 5 => return "100"; -- coke
            when 6 => return "100"; -- coke
            when 7 => return "011"; -- sprite
            when 8 => return "010"; -- second fries
            when others => return "000";
        end case;
    end function;

begin
    current_item_a <= item_a_code(current_order);
    current_item_b <= item_b_code(current_order);
    
    gen_orders : for i in 0 to 7 generate

        order_code(i) <= get_order_code(shuffle_sel, i);

        item_a_code(i) <= get_item_a(order_code(i));
        item_b_code(i) <= get_item_b(order_code(i));

        -- For single-item orders, center the icon more.
        -- For two-item orders, overlap slightly so two 64x64 icons still fit inside a 90-pixel box.
        icon_a_x(i) <= std_logic_vector(to_unsigned(START_X + i * (ORDER_W + GAP) + 13, 11))
                       when order_code(i) = 1 or order_code(i) = 2 else
                       std_logic_vector(to_unsigned(START_X + i * (ORDER_W + GAP) + 0, 11));

        icon_b_x(i) <= std_logic_vector(to_unsigned(START_X + i * (ORDER_W + GAP) + 26, 11));

        icon_a_y(i) <= std_logic_vector(to_unsigned(ORDER_Y + 18, 11));
        icon_b_y(i) <= std_logic_vector(to_unsigned(ORDER_Y + 18, 11));

        icon_a_inst : order_slot_display
        port map (
            pixel_row => pixel_row,
            pixel_col => pixel_col,
            icon_x    => icon_a_x(i),
            icon_y    => icon_a_y(i),
            item_code => item_a_code(i),
            red       => icon_a_r(i),
            green     => icon_a_g(i),
            blue      => icon_a_b(i),
            visible   => icon_a_v(i)
        );

        icon_b_inst : order_slot_display
        port map (
            pixel_row => pixel_row,
            pixel_col => pixel_col,
            icon_x    => icon_b_x(i),
            icon_y    => icon_b_y(i),
            item_code => item_b_code(i),
            red       => icon_b_r(i),
            green     => icon_b_g(i),
            blue      => icon_b_b(i),
            visible   => icon_b_v(i)
        );

    end generate;
     
process(pixel_row, pixel_col, shuffle_sel, current_order, item_a_done, item_b_done,
        icon_a_r, icon_a_g, icon_a_b, icon_a_v,
        icon_b_r, icon_b_g, icon_b_b, icon_b_v, time_left)
    variable px : integer;
    variable py : integer;
    variable ox : integer;
    variable bar_w : integer;
begin
    red     <= "0000";
    green   <= "0000";
    blue    <= "0000";
    visible <= '0';

    px := to_integer(unsigned(pixel_col));
    py := to_integer(unsigned(pixel_row));
    bar_w := (ORDER_W * time_left) / 180;

    -- Draw order cards, but hide completed old orders
    for k in 0 to 7 loop
        ox := START_X + k * (ORDER_W + GAP);

        if k >= current_order then

            -- white card
        if px >= ox and px < ox + ORDER_W and
           py >= ORDER_Y and py < ORDER_Y + ORDER_H then
            visible <= '1';
            red   <= "1111";
            green <= "1111";
            blue  <= "1111";
        end if;
        
        -- timer bar: green normally, red when low time
        if px >= ox and px < ox + bar_w and
           py >= ORDER_Y and py < ORDER_Y + 10 then
            visible <= '1';
        
            if time_left <= 30 then
                red   <= "1111";
                green <= "0000";
                blue  <= "0000";
            else
                red   <= "0000";
                green <= "1111";
                blue  <= "0000";
            end if;
        end if;

            -- black border
            if px >= ox and px < ox + ORDER_W and
               py >= ORDER_Y and py < ORDER_Y + ORDER_H then
                if px = ox or px = ox + ORDER_W - 1 or
                   py = ORDER_Y or py = ORDER_Y + ORDER_H - 1 then
                    visible <= '1';
                    red   <= "0000";
                    green <= "0000";
                    blue  <= "0000";
                end if;
            end if;

        end if;
    end loop;

    -- Draw icons, but hide completed item inside current order
    for k in 0 to 7 loop

        if k >= current_order then

            if icon_a_v(k) = '1' then
                if not (k = current_order and item_a_done = '1') then
                    visible <= '1';
                    red     <= icon_a_r(k);
                    green   <= icon_a_g(k);
                    blue    <= icon_a_b(k);
                end if;
            end if;

            if icon_b_v(k) = '1' then
                if not (k = current_order and item_b_done = '1') then
                    visible <= '1';
                    red     <= icon_b_r(k);
                    green   <= icon_b_g(k);
                    blue    <= icon_b_b(k);
                end if;
            end if;
        end if;

    end loop;
end process;
end Behavioral;