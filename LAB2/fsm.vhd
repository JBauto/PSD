----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:24:06 10/25/2014 
-- Design Name: 
-- Module Name:    fsm - fsm 
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
    Port ( clk, rst, btn : in  STD_LOGIC;
			  load_mat : out STD_LOGIC;
           load_reg : out  STD_LOGIC_VECTOR (3 downto 0);
			  controlo : out  STD_LOGIC_VECTOR (1 downto 0);
			  sel_mux : out STD_LOGIC_VECTOR (8 downto 0) :=(others=>'0')
			  );
end fsm;

architecture arq_fsm of fsm is
	type fsm_states is ( s_init, s_1, s_2, s_3, s_4, s_5, s_6, s_end);
	signal curr_state, next_state: fsm_states;
	
begin
	--  Reset/troca sincrona:
	sync: process (clk, rst)
		begin
			if rst = '1' then
				curr_state <= s_init;
			elsif clk'event and clk = '1' then
				curr_state <= next_state ;
			end if;
	end process ;

	--  Logica Combinatoria
	--	A mudança de estado no estado inicial depende do vector button,
	--	em todos os outros estados excepto o final mudamos para o estado final 
	--	ao passo que no estado final mudamos para o inicial. Este estado serve para 
	--	evitar operações consecutivas. O sinal load é enviado para o datapath.
	comb: process (btn, curr_state)
	begin
		next_state <= curr_state ;
		
		case curr_state is
			when s_init =>
				load_reg <= (others=>'0');
				load_mat <= '1';
				controlo <= "00";
				sel_mux <= "000000000";
				if btn = '1' then
					next_state <= s_1;
				end if;
				
			when s_1 =>
				controlo <= "00";
				load_reg <= "0011";
				sel_mux <= "000001000";
				load_mat <= '0';
				next_state <= s_2;
			when s_2 =>
				controlo <= "00";
				load_reg <= "0111";
				sel_mux <= "000100000";
				load_mat <= '0';
				next_state <= s_3;
			when s_3 =>
				controlo <= "10";
				load_reg <= "1011";
				sel_mux <= "010100010";
				load_mat <= '0';
				next_state <= s_4;		
			when s_4 =>
				controlo <= "00";
				load_reg <= "0111";
				sel_mux <= "101010100";
				load_mat <= '0';
				next_state <= s_5;
		   when s_5 =>
				controlo <= "01";
				load_reg <= "0011";
				sel_mux <= "101100001";
				load_mat <= '0';
				next_state <= s_6;
			when s_6 =>
				controlo <= "01";
				load_reg <= "1000";
				sel_mux <= "000000000";
				load_mat <= '0';
				next_state <= s_end;
			when s_end =>
				sel_mux <= "000000000";
				controlo <= "00";
				load_reg <= "0000";
				load_mat <= '0';
				next_state <= s_end;
				
		end case;
		
	end process;

end arq_fsm;

