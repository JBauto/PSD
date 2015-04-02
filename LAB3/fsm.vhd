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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
    Port ( clk, rst, btn : in  STD_LOGIC;
			  sw : in std_logic_vector(7 downto 0);
			  enout, cicle, rep : out std_logic;
			  start, reg_final, reg_meio, reg_out, reg_in : out STD_LOGIC;
			  first_time, last_time, oper, front :out std_logic;
			  index : out std_logic_vector(2 downto 0);
			  cnt : out std_logic_vector(6 downto 0):=(others=>'0');
			  enderecoB : out std_logic_vector(8 downto 0) :=(others=>'0');			  
			  enderecoBout : out std_logic_vector(8 downto 0) :=(others=>'0')
			  );
end fsm;

architecture arq_fsm of fsm is
	type fsm_states is ( s_init, s_first, s_increm, s_load0, s_load1, s_load2, s_load3, s_load4, 
								s_lin, s_col, s_front, s_loop, s_final, s_incremf, s_check, s_wait, s_end);
	signal curr_state, next_state: fsm_states;
	signal counter, count : std_logic_vector(6 downto 0);
	signal inst_en, repeat : std_logic;
	signal inst_reg : std_logic_vector(3 downto 0);
	signal end_counter : std_logic_vector(8 downto 0);
	signal end_counter_out : std_logic_vector(8 downto 0);
begin

	--  Reset/troca sincrona:
	sync: process (clk, rst)
		begin
			if clk'event and clk = '1' then
				if rst = '1' then
					curr_state <= s_init;
					counter <= (others =>'0');
				else
					curr_state <= next_state;
					counter <= count;
				end if;
			end if;
	end process ;
	
	mem_inst: process (clk, rst, inst_en)
		begin
			if clk'event and clk = '1' then
				if rst = '1' then
					inst_reg <= "0000";
				elsif inst_en = '1' then
					inst_reg <= sw(3 downto 0);
				end if;
			end if;
	end process ;
	
	endereco : process (clk, rst, curr_state)
		begin
			if clk'event and clk = '1' then
				if rst = '1' 
					or curr_state = s_init 
					or next_state = s_end
					or next_state = s_check then
						end_counter <= "000000000";
						end_counter_out <= "111111111";
				else
					if next_state = s_increm
						or next_state = s_load0 
						or next_state = s_load1
						or next_state = s_load2
						or next_state = s_load3	then 
							end_counter <= unsigned(end_counter) + 1;
					end if;
					if next_state = s_load1 
						or next_state = s_load2
						or next_state = s_load3
						or next_state = s_load4	
						or next_state = s_final then
							end_counter_out <= unsigned(end_counter_out) + 1;
					end if;
				end if;
			end if;
	end process ;
	
	repetir : process (clk, rst, inst_en)
		begin
			if clk'event and clk = '1' then
				if rst = '1' or curr_state = s_end or curr_state = s_check then
						repeat <= '0';
				elsif inst_en = '1' then
						repeat <= sw(2);
				end if;
			end if;
	end process;
	
	--  Logica Combinatoria
	--	A mudança de estado no estado inicial depende do vector button,
	--	em todos os outros estados excepto o final mudamos para o estado final 
	--	ao passo que no estado final mudamos para o inicial. Este estado serve para 
	--	evitar operações consecutivas. O sinal load é enviado para o datapath.
	comb: process (btn, curr_state, counter, repeat)
	begin
		next_state <= curr_state ;
		
		case curr_state is
			------------------------------
			when s_init =>
				first_time <= '0';
				last_time <= '0';
				reg_in <= '0';
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				enout <= '0';
				count <= (others=>'0');
				index <= "111";
			
				if btn = '1' then
					next_state <= s_first;
					inst_en <= '1';
				else
					next_state <= s_init;
				end if;
				
			------------------------------
			-- Load das duas primeiras linhas
			when s_first =>
				first_time <= '1';
				last_time <= '0';
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '0';
				reg_in <= '0';
				start <= '1';
				inst_en <= '0';
				count <= counter;
				index <= "111";
				enout <= '0';
				
				if counter = "0000111" then
					count <= "0000000";
					reg_meio <= '1';
					next_state <= s_col;
				else 
					next_state <= s_increm;
				end if;
			
			------------------------------
			when s_increm =>
				first_time <= '1';
				last_time <= '0';
				reg_in <= '0';
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				index <= "111";
				enout <= '0';
				
				count <= unsigned(counter) + 1;
				next_state <= s_first;

			------------------------------
			-- SHIFT
			when s_load0 =>
				first_time <= '0';
				last_time <= '0';  
				start <= '0';
				index <= "000";
				count <= counter;
				reg_in <= '1';
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				enout <= '0';
				
				if counter = "1111111" then
					reg_in <= '0';
				else 
					reg_in <= '1';
				end if;
				
				next_state <= s_load1;
				
			------------------------------
			-- LOAD1 
			when s_load1 =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "001";
				count <= counter;
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				enout <= '1';
				
				if counter = "1111111" then
					reg_in <= '0';
				else 
					reg_in <= '1';
				end if;

				
				next_state <= s_load2;
			
			------------------------------
			-- LOAD2
			when s_load2 =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "010";
				count <= counter;
				reg_final <= '0';
				reg_meio <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				enout <= '1';
				
				if counter = "1111111" then
					reg_in <= '0';
				else 
					reg_in <= '1';
				end if;

				
				next_state <= s_load3;
			
			------------------------------
			-- LOAD3
			when s_load3 =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "011";
				count <= counter;
				reg_final <= '0';
				reg_meio <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				enout <= '1';
				
				if counter = "1111111" then
					reg_in <= '0';
				else 
					reg_in <= '1';
				end if;

				
				next_state <= s_load4;
				
			------------------------------
			-- LOAD4
			when s_load4 =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "100";
				count <= counter;
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				enout <= '1';
				
				if counter = "1111111" then
					reg_in <= '0';
				else 
					reg_in <= '1';
				end if;

				
				next_state <= s_lin;
				
			------------------------------
			-- Operação sobre as linhas
			when s_lin =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "111";
				count <= counter;
				reg_in <= '0';
				reg_meio <= '1';
				reg_out <= '0';
				reg_final <= '0';
				inst_en <= '0';
				enout <= '0';
				
				if counter = "1111111" then
					last_time <= '1';
				else
					last_time <= '0';
				end if;
				
				next_state <= s_col;
			
			------------------------------
			-- Operação sobre as colunas
			when s_col =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "111";
				count <= counter;
				reg_in <= '0';
				reg_meio <= '0';
				reg_out <= '0';
				reg_final <= '1';
				inst_en <= '0';
				enout <= '0';
				
				next_state<= s_front;
		
			------------------------------
			-- Subtração se necessário
			when s_front =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "111";
				count <= counter;
				reg_in <= '0';
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '1';
				inst_en <= '0';
				index <= "111";
				enout <= '0';
	
				next_state <= s_loop;
			
			------------------------------			
			-- Regresso ao Inicio
			when s_loop =>
				first_time <= '0';
				last_time <= '0';
				start <= '0';
				index <= "111";
				count <= counter;
				reg_in <= '0';
				reg_meio <= '0';
				reg_final <= '0';
				reg_out <= '0';
				inst_en <= '0';
				index <= "111";
				enout <= '0';
				
				if counter = "1111110" then
					count <= unsigned(counter) + 1;
					
					next_state <= s_load0;
				elsif counter = "1111111" then
					count <= "0000000";
					
					next_state <= s_final;
				else
					count <= unsigned(counter) + 1;
					
					next_state <= s_load0;
				end if;
				
			------------------------------
			when s_final =>
				reg_meio <= '0';
				first_time <= '0';
				last_time <= '0';
				count <= counter;
				reg_in <= '0';
				reg_final <= '0';
				reg_out <= '0';
				reg_meio <= '0';
				start <= '0';
				inst_en <= '0';
				index <= count(2 downto 0);
				enout <= '0';
				
				next_state <= s_incremf;
				
			------------------------------	
			when s_incremf =>
				first_time <= '0';
				last_time <= '0';
				reg_meio <= '0';
				reg_final <= '0';
				reg_in <= '0';
				reg_out <= '0';
				start <= '0';
				inst_en <= '0';
				count <= unsigned(counter) + 1;
				index <= count(2 downto 0);
				enout <= '1';
				
				if count(2 downto 0) = "011" then
					next_state <= s_check;
				else
					next_state <= s_final;
				end if;
				
			------------------------------
			when s_check =>
				reg_in <= '0';
				reg_meio <= '0';
				first_time <= '0';
				last_time <= '0';
				count <= (others => '0');
				reg_final <= '0';
				reg_out <= '0';
				reg_meio <= '0';
				inst_en <= '0';
				start <= '0';
				index <= "111";
				enout <= '0';
				
				if repeat = '1' then
					next_state <= s_wait;	
				else
					next_state <= s_end;	
				end if;
				
			------------------------------
			when s_wait =>
				reg_in <= '0';
				reg_meio <= '0';
				first_time <= '0';
				last_time <= '0';
				count <= (others => '0');
				reg_final <= '0';
				reg_out <= '0';
				reg_meio <= '0';
				inst_en <= '0';
				start <= '0';
				index <= "111";
				enout <= '0';
				
				next_state <= s_first;
				
			------------------------------
			when s_end =>
				reg_in <= '0';
				reg_meio <= '0';
				first_time <= '0';
				last_time <= '0';
				count <= (others => '0');
				reg_final <= '0';
				reg_out <= '0';
				reg_meio <= '0';
				inst_en <= '0';
				start <= '0';
				index <= "111";
				enout <= '0';
				
				next_state <= s_init;
			------------------------------	
		end case;
		
	end process;
	
	cicle <= repeat;
	
	enderecoB <= end_counter;
	enderecoBout <= end_counter_out;
	cnt <= counter;
	
	rep <= inst_reg(2);
	
	oper <= inst_reg(0) when repeat = '1' or inst_reg(2)= '0' else
			  inst_reg(1);
	
	front <= '1' when inst_reg="1001" else
				'0';
end arq_fsm;

