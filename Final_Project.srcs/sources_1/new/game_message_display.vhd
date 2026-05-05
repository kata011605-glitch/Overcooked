library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity game_message_display is
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
end game_message_display;

architecture Behavioral of game_message_display is
begin

process(pixel_row, pixel_col, show_time_out, show_victory)
    variable px : integer;
    variable py : integer;
begin
    px := to_integer(unsigned(pixel_col));
    py := to_integer(unsigned(pixel_row));

    red <= "0000";
    green <= "0000";
    blue <= "0000";
    visible <= '0';

    if show_time_out = '1' or show_victory = '1' then
        -- center rectangle
        if px >= 190 and px <= 610 and py >= 220 and py <= 385 then
            visible <= '1';
            red <= "0001";
            green <= "0001";
            blue <= "0001";
        end if;

        -- white border around rectangle
        if px >= 190 and px <= 610 and py >= 220 and py <= 385 then
            if px <= 195 or px >= 605 or py <= 225 or py >= 380 then
                visible <= '1';
                red <= "1111";
                green <= "1111";
                blue <= "1111";
            end if;
        end if;

        --Message display: TIME OUT + COOKED!
        if show_time_out = '1' then
            --red TIME OUT 
            if
            -- T
            ((px >= 235 and px <= 275 and py >= 255 and py <= 262) or
             (px >= 251 and px <= 259 and py >= 255 and py <= 305)) or

            -- I
            ((px >= 285 and px <= 315 and py >= 255 and py <= 262) or
             (px >= 296 and px <= 304 and py >= 255 and py <= 305) or
             (px >= 285 and px <= 315 and py >= 298 and py <= 305)) or

            -- M
            ((px >= 325 and px <= 333 and py >= 255 and py <= 305) or
             (px >= 357 and px <= 365 and py >= 255 and py <= 305) or
             (px >= 337 and px <= 345 and py >= 265 and py <= 280) or
             (px >= 349 and px <= 353 and py >= 265 and py <= 280)) or

            -- E
            ((px >= 375 and px <= 383 and py >= 255 and py <= 305) or
             (px >= 375 and px <= 410 and py >= 255 and py <= 262) or
             (px >= 375 and px <= 405 and py >= 276 and py <= 283) or
             (px >= 375 and px <= 410 and py >= 298 and py <= 305)) or

            -- O
            ((px >= 435 and px <= 470 and py >= 255 and py <= 262) or
             (px >= 435 and px <= 470 and py >= 298 and py <= 305) or
             (px >= 435 and px <= 443 and py >= 255 and py <= 305) or
             (px >= 462 and px <= 470 and py >= 255 and py <= 305)) or

            -- U
            ((px >= 480 and px <= 488 and py >= 255 and py <= 305) or
             (px >= 507 and px <= 515 and py >= 255 and py <= 305) or
             (px >= 480 and px <= 515 and py >= 298 and py <= 305)) or

            -- T
            ((px >= 525 and px <= 565 and py >= 255 and py <= 262) or
             (px >= 541 and px <= 549 and py >= 255 and py <= 305))
            then
                visible <= '1';
                red <= "1111";
                green <= "0000";
                blue <= "0000";
            end if;

            -- red COOKED!
            if
            -- C
            ((px >= 245 and px <= 280 and py >= 325 and py <= 332) or
             (px >= 245 and px <= 253 and py >= 325 and py <= 370) or
             (px >= 245 and px <= 280 and py >= 363 and py <= 370)) or

            -- O
            ((px >= 290 and px <= 325 and py >= 325 and py <= 332) or
             (px >= 290 and px <= 325 and py >= 363 and py <= 370) or
             (px >= 290 and px <= 298 and py >= 325 and py <= 370) or
             (px >= 317 and px <= 325 and py >= 325 and py <= 370)) or

            -- O
            ((px >= 335 and px <= 370 and py >= 325 and py <= 332) or
             (px >= 335 and px <= 370 and py >= 363 and py <= 370) or
             (px >= 335 and px <= 343 and py >= 325 and py <= 370) or
             (px >= 362 and px <= 370 and py >= 325 and py <= 370)) or

            -- K
            ((px >= 380 and px <= 388 and py >= 325 and py <= 370) or
             (px >= 410 and px <= 418 and py >= 325 and py <= 347) or
             (px >= 402 and px <= 410 and py >= 343 and py <= 352) or
             (px >= 410 and px <= 418 and py >= 350 and py <= 370)) or

            -- E
            ((px >= 428 and px <= 436 and py >= 325 and py <= 370) or
             (px >= 428 and px <= 463 and py >= 325 and py <= 332) or
             (px >= 428 and px <= 458 and py >= 344 and py <= 351) or
             (px >= 428 and px <= 463 and py >= 363 and py <= 370)) or

            -- D
            ((px >= 473 and px <= 481 and py >= 325 and py <= 370) or
             (px >= 473 and px <= 505 and py >= 325 and py <= 332) or
             (px >= 473 and px <= 505 and py >= 363 and py <= 370) or
             (px >= 497 and px <= 505 and py >= 332 and py <= 363)) or

            -- !
            ((px >= 525 and px <= 533 and py >= 325 and py <= 355) or
             (px >= 525 and px <= 533 and py >= 363 and py <= 370))
            then
                visible <= '1';
                red <= "1111";
                green <= "0000";
                blue <= "0000";
            end if;

        --Message: YOU WIN + COOKING!
        elsif show_victory = '1' then

            --green YOU WIN
            if
            -- Y
            ((px >= 250 and px <= 258 and py >= 255 and py <= 280) or
             (px >= 282 and px <= 290 and py >= 255 and py <= 280) or
             (px >= 266 and px <= 274 and py >= 278 and py <= 305)) or

            -- O
            ((px >= 300 and px <= 335 and py >= 255 and py <= 262) or
             (px >= 300 and px <= 335 and py >= 298 and py <= 305) or
             (px >= 300 and px <= 308 and py >= 255 and py <= 305) or
             (px >= 327 and px <= 335 and py >= 255 and py <= 305)) or

            -- U
            ((px >= 345 and px <= 353 and py >= 255 and py <= 305) or
             (px >= 372 and px <= 380 and py >= 255 and py <= 305) or
             (px >= 345 and px <= 380 and py >= 298 and py <= 305)) or

            -- W
            ((px >= 410 and px <= 418 and py >= 255 and py <= 305) or
             (px >= 442 and px <= 450 and py >= 255 and py <= 305) or
             (px >= 422 and px <= 430 and py >= 285 and py <= 305) or
             (px >= 434 and px <= 438 and py >= 285 and py <= 305)) or

            -- I
            ((px >= 460 and px <= 490 and py >= 255 and py <= 262) or
             (px >= 471 and px <= 479 and py >= 255 and py <= 305) or
             (px >= 460 and px <= 490 and py >= 298 and py <= 305)) or

            -- N
            ((px >= 500 and px <= 508 and py >= 255 and py <= 305) or
             (px >= 532 and px <= 540 and py >= 255 and py <= 305) or
             (px >= 512 and px <= 520 and py >= 265 and py <= 285) or
             (px >= 522 and px <= 530 and py >= 285 and py <= 305))
            then
                visible <= '1';
                red <= "0000";
                green <= "1111";
                blue <= "0000";
            end if;

            --green COOKING!
            if
            -- C
            ((px >= 215 and px <= 250 and py >= 325 and py <= 332) or
             (px >= 215 and px <= 223 and py >= 325 and py <= 370) or
             (px >= 215 and px <= 250 and py >= 363 and py <= 370)) or

            -- O
            ((px >= 260 and px <= 295 and py >= 325 and py <= 332) or
             (px >= 260 and px <= 295 and py >= 363 and py <= 370) or
             (px >= 260 and px <= 268 and py >= 325 and py <= 370) or
             (px >= 287 and px <= 295 and py >= 325 and py <= 370)) or

            -- O
            ((px >= 305 and px <= 340 and py >= 325 and py <= 332) or
             (px >= 305 and px <= 340 and py >= 363 and py <= 370) or
             (px >= 305 and px <= 313 and py >= 325 and py <= 370) or
             (px >= 332 and px <= 340 and py >= 325 and py <= 370)) or

            -- K
            ((px >= 350 and px <= 358 and py >= 325 and py <= 370) or
             (px >= 380 and px <= 388 and py >= 325 and py <= 347) or
             (px >= 372 and px <= 380 and py >= 343 and py <= 352) or
             (px >= 380 and px <= 388 and py >= 350 and py <= 370)) or

            -- I
            ((px >= 398 and px <= 428 and py >= 325 and py <= 332) or
             (px >= 409 and px <= 417 and py >= 325 and py <= 370) or
             (px >= 398 and px <= 428 and py >= 363 and py <= 370)) or

            -- N
            ((px >= 438 and px <= 446 and py >= 325 and py <= 370) or
             (px >= 470 and px <= 478 and py >= 325 and py <= 370) or
             (px >= 450 and px <= 458 and py >= 335 and py <= 350) or
             (px >= 460 and px <= 468 and py >= 350 and py <= 370)) or

            -- G
            ((px >= 488 and px <= 523 and py >= 325 and py <= 332) or
             (px >= 488 and px <= 496 and py >= 325 and py <= 370) or
             (px >= 488 and px <= 523 and py >= 363 and py <= 370) or
             (px >= 515 and px <= 523 and py >= 345 and py <= 370) or
             (px >= 505 and px <= 523 and py >= 345 and py <= 352)) or

            -- !
            ((px >= 543 and px <= 551 and py >= 325 and py <= 355) or
             (px >= 543 and px <= 551 and py >= 363 and py <= 370))
            then
                visible <= '1';
                red <= "0000";
                green <= "1111";
                blue <= "0000";
            end if;

        end if;
    end if;
end process;

end Behavioral;