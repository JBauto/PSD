----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:57:45 04/23/2010 
-- Design Name: 
-- Module Name:    datapath - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
    Port ( clk, rst : in std_logic;
			  start, reg_fn, reg_meio, reg_out, reg_in : in std_logic;
			  index : in std_logic_vector(2 downto 0);
			  first_time, last_time, oper, front: in std_logic;
			  datain : in  std_logic_vector (31 downto 0);
           dataout : out  std_logic_vector (31 downto 0);
			  counter : in std_logic_vector(6 downto 0)
			  );
end datapath;

architecture arq_datapath of datapath is
signal reg_line1, reg_line2, reg_line3 : std_logic_vector (127 downto 0) :=(others=>'0');
signal reg_int, reg_fin : std_logic_vector (127 downto 0) :=(others=>'0');
signal reg_saida, mux_fr : std_logic_vector (127 downto 0) :=(others=>'0');
signal erosao_lin,dilat_lin, mux_lin : std_logic_vector (127 downto 0) :=(others=>'0');
signal erosao_col,dilat_col, mux_col : std_logic_vector (127 downto 0) :=(others=>'0');
signal int_r, int_l : std_logic_vector(127 downto 0) :=(others=>'0');
signal mux32, out_reg : std_logic_vector (31 downto 0) :=(others=>'0');

begin
	-- Linhas
	copy2reg: process (clk,datain,index)
	begin
	
		-- Load das linhas
		if clk'event and clk='1' then
				if rst = '1' then
					reg_line1 <= X"00000000000000000000000000000000";
					reg_line2 <= X"00000000000000000000000000000000";
					reg_line3 <= X"00000000000000000000000000000000";
				else if first_time = '1' and start = '1' then	-- primeira linha
						case counter is
							when "0000011" => 
								reg_line2(31 downto 0) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							
							when "0000010"  => 
								reg_line2(63 downto 32) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							
							when "0000001" => 
								reg_line2(95 downto 64) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
								
							when "0000000" => 
								reg_line2(127 downto 96) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
								
							when "0000111" => 
								reg_line3(31 downto 0) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							
							when "0000110" => 
								reg_line3(63 downto 32) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
								
							when "0000101" =>  
								reg_line3(95 downto 64) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							
							--when "0000111" => 
							--	reg_line2(127 downto 96) <= datain;
								
							when others => 
								reg_line3(127 downto 96) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
								
						end case;
					elsif index = "000" and reg_in= '1' then 
							reg_line1 <= reg_line2 ;
							reg_line2 <= reg_line3 ;
						else -- segunda e seguintes linhas
							if index="100" and reg_in= '1' then 
								reg_line3(31 downto 0) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							end if;
							if index="011" and reg_in= '1' then 
								reg_line3(63 downto 32) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							end if;
							if index="010" and reg_in= '1' then 
								reg_line3(95 downto 64) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							end if;
							if index="001" and reg_in= '1' then 
								reg_line3(127 downto 96) <= datain(7 downto 0) & datain(15 downto 8) & datain(23 downto 16)& datain(31 downto 24);
							end if;
				end if;
			end if;
		end if;
	end process;

	-- Operações sobre as linhas
	erosao_lin <= reg_line2 and reg_line3 when (first_time = '1' or last_time = '1') else
					 reg_line1 and reg_line2 and reg_line3;
					 
	dilat_lin <= reg_line2 or reg_line3 when (first_time = '1' or last_time = '1') else
					 reg_line1 or reg_line2 or reg_line3;
					
					
	mux_lin <= erosao_lin when oper='1' else
				 dilat_lin;
		
	reg_intermed: process (clk, reg_meio, rst)
	begin
		if clk'event and clk='1' then
			if rst = '1' then
					reg_int <= X"00000000000000000000000000000000";
			elsif reg_meio = '1' then
					reg_int <= mux_lin;
			end if;
		end if;
	end process;
	
	-- Operações sobre as colunas
	int_r <= To_StdLogicVector(to_bitvector(reg_int) SRA 1);
	int_l <= To_StdLogicVector(to_bitvector(reg_int) SLA 1);

	erosao_col <= int_r and reg_int and int_l;
	dilat_col <= int_r or reg_int or int_l;

	mux_col <= erosao_col when oper='1' else
				  dilat_col;
	
	reg_final: process (clk, reg_fn, rst)
	begin
		if clk'event and clk='1' then
				if rst = '1' then
					reg_fin <= X"00000000000000000000000000000000";
				elsif reg_fn = '1' then
					reg_fin <= mux_col;
				end if;	
		end if;
	end process;
	
	-- Detecção de fronteiras
	
	mux_fr <= reg_fin when front = '0' else
				 reg_line2 XOR reg_fin;
				 
	
	reg_output: process (clk, reg_out, rst)
	begin
		if clk'event and clk='1' then
			if rst = '1' then
					reg_saida <= X"00000000000000000000000000000000";
			elsif reg_out = '1' then
					reg_saida <= mux_fr;
			end if;
		end if;
	end process;
	
	mux32 <= reg_saida(31 downto 0) when index="011" else
				reg_saida(63 downto 32) when index="010" else
				reg_saida(95 downto 64) when index="001" else
				reg_saida(127 downto 96);
				
	reg_32: process (clk, out_reg, rst)
	begin
		if clk'event and clk='1' then
			if rst = '1' then
				out_reg <= X"00000000";
			elsif index /= "111" then
						out_reg <= mux32;
			end if;
		end if;
	end process;			
	
	dataout <= out_reg(7 downto 0) & out_reg(15 downto 8) & out_reg(23 downto 16)& out_reg(31 downto 24);
	
end arq_datapath;

