-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_fsm                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Automat za upravljanje radom stoperice                                              
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_fsm IS PORT (
                          clk_i             : IN  STD_LOGIC; -- ulazni takt signal
                          rst_i             : IN  STD_LOGIC; -- reset signal
                          reset_switch_i    : IN  STD_LOGIC; -- prekidac za resetovanje brojaca
                          start_switch_i    : IN  STD_LOGIC; -- prekidac za startovanje brojaca
                          stop_switch_i     : IN  STD_LOGIC; -- prekidac za zaustavljanje brojaca
                          continue_switch_i : IN  STD_LOGIC; -- prekidac za nastavak brojanja brojaca
                          cnt_en_o          : OUT STD_LOGIC; -- izlazni signal koji sluzi kao signal dozvole brojanja
                          cnt_rst_o         : OUT STD_LOGIC  -- izlazni signal koji sluzi kao signal resetovanja brojaca (clear signal)
                         );
END timer_fsm;

ARCHITECTURE rtl OF timer_fsm IS

TYPE   STATE_TYPE IS (IDLE, COUNT, STOP); -- stanja automata

SIGNAL curent_state_r, next_state : STATE_TYPE; -- trenutno i naredno stanje automata

BEGIN

-- DODATI :
-- automat sa konacnim brojem stanja koji upravlja brojanjem sekundi na osnovu stanja prekidaca
process(clk_i, rst_i)begin
	if rst_i = '1' then
		curent_state_r <= IDLE;
	elsif rising_edge(clk_i) then
		curent_state_r <= next_state;
	end if;
end process;


process(curent_state_r, reset_switch_i, start_switch_i, stop_switch_i, continue_switch_i)begin
		next_state <= curent_state_r;
		case (curent_state_r) is
			when IDLE => 
				if(reset_switch_i = '1') then next_state <= IDLE;
				elsif(start_switch_i = '1') then next_state <= COUNT;
				end if;
			when COUNT =>
				if(reset_switch_i = '1') then next_state <= IDLE;
				elsif(stop_switch_i = '1') then next_state <= STOP;
				end if;
			when others =>
				if(reset_switch_i = '1') then next_state <= IDLE;
				elsif(continue_switch_i = '1') then next_state <= COUNT;
				end if;
			end case;
end process;

cnt_en_o <= '1' when (curent_state_r = COUNT or curent_state_r = IDLE) else '0';

cnt_rst_o <= '1' when curent_state_r = IDLE else '0';


END rtl;