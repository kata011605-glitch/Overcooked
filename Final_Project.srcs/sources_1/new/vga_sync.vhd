library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_sync is
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
end vga_sync;

architecture Behavioral of vga_sync is

    signal h_cnt : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');
    signal v_cnt : STD_LOGIC_VECTOR(10 downto 0) := (others => '0');

    constant H_ACTIVE : integer := 800;
    constant H_FP     : integer := 40;
    constant H_SYNC   : integer := 128;
    constant H_BP     : integer := 88;
    constant H_TOTAL  : integer := H_ACTIVE + H_FP + H_SYNC + H_BP;

    constant V_ACTIVE : integer := 600;
    constant V_FP     : integer := 1;
    constant V_SYNC   : integer := 4;
    constant V_BP     : integer := 23;
    constant V_TOTAL  : integer := V_ACTIVE + V_FP + V_SYNC + V_BP;
    

begin

    process(pixel_clk)
        variable video_on : STD_LOGIC;
    begin
        if rising_edge(pixel_clk) then

            if h_cnt = H_TOTAL - 1 then
                h_cnt <= (others => '0');

                if v_cnt = V_TOTAL - 1 then
                    v_cnt <= (others => '0');
                else
                    v_cnt <= v_cnt + 1;
                end if;
            else
                h_cnt <= h_cnt + 1;
            end if;

            if h_cnt >= H_ACTIVE + H_FP and h_cnt < H_ACTIVE + H_FP + H_SYNC then
                hsync <= '0';
            else
                hsync <= '1';
            end if;

            if v_cnt >= V_ACTIVE + V_FP and v_cnt < V_ACTIVE + V_FP + V_SYNC then
                vsync <= '0';
            else
                vsync <= '1';
            end if;

            pixel_col <= h_cnt;
            pixel_row <= v_cnt;

            if h_cnt < H_ACTIVE and v_cnt < V_ACTIVE then
                video_on := '1';
            else
                video_on := '0';
            end if;

            if video_on = '1' then
                red_out   <= red_in;
                green_out <= green_in;
                blue_out  <= blue_in;
            else
                red_out   <= "0000";
                green_out <= "0000";
                blue_out  <= "0000";
            end if;
        end if;
    end process;

end Behavioral;