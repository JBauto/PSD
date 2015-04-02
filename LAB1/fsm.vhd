----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:30:38 10/01/2014 
-- Design Name: 
-- Module Name:    fsm - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
    Port(  
	 clk, rst : in std_logic;
    button : in  STD_LOGIC_VECTOR (2 downto 0);
    load : out  STD_LOGIC_VECTOR (1 downto 0) 
	 );
end fsm;

architecture arq_fsm of fsm is
	type fsm_states is ( s_initial, s_end, s_inst, s_load1, s_load2 );
	signal curr_state, next_state: fsm_states;

begin
	--  Reset/troca sincrona:
	sync: process (clk, rst)
		begin
			if rst = '1'then
				curr_state <= s_initial ;
			elsif clk'event and clk = '1' then
				curr_state <= next_state ;
		end if ;
	end process ;
	
	--  Logica Combinatoria
	comb: process (button, curr_state)
	begin
		next_state <= curr_state ;
		
		case curr_state is
			when s_initial =>
				load <= "00";
				if button="100" then
					next_state <= s_inst ;
				elsif button="001" then
					next_state <= s_load1 ;
				elsif button="010" then
					next_state <= s_load2;
				end if;
				
			when s_inst =>
				next_state <= s_end;
				load <= "01";
			
			when s_load1 =>
				next_state <= s_end;
				load <= "10";
				
			when s_load2 =>
				next_state <= s_end;
				load <= "11";
			
			when s_end =>
				next_state <= s_initial;
				load <= "00";
				
		end case;
		
	end process;
end arq_fsm;

