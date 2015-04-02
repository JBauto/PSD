----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:59:28 09/25/2014 
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
--use IEEE.STD_LOGIC_SIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
    Port ( ent : in   STD_LOGIC_VECTOR (6 downto 0);
           oper : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
           rst_reg : in  STD_LOGIC;
           r1 : out  STD_LOGIC_VECTOR (12 downto 0);
			  r2 : out STD_LOGIC_VECTOR (12 downto 0)
			  );
end datapath;

architecture Behavioral of datapath is
signal addsub, addsubc2, log_and, log_sra, m_alu, m2: STD_LOGIC_VECTOR (12 downto 0):=(others=>'0');
signal tmp: STD_LOGIC_VECTOR (5 downto 0) :=(others=>'0');
signal reg_end, reg_end_c2, reg_in_c2: STD_LOGIC_VECTOR (12 downto 0) :=(others=>'0');
signal reg_in: STD_LOGIC_VECTOR (6 downto 0) :=(others=>'0');
signal muls: STD_LOGIC_VECTOR (19 downto 0) := (others=>'0');

begin 
	signed2comp: process(reg_in, reg_end)
	begin
		if reg_end(12) = '0' then
			reg_end_c2 <= reg_end;
		else
			reg_end_c2 <= not(reg_end) + 1;
			reg_end_c2(12) <= '1';
		end if;
		if reg_in(6) = '0' then
			reg_in_c2 <= "000000" & reg_in;
		else
			reg_in_c2 <= "111111" & not(reg_in) + 1;
			reg_in_c2(6) <= '1';
		end if;
	end process;
	
	-- soma ou subtracçao
	addsubc2 <= reg_end_c2 + reg_in_c2 when ent(0)='0' else
				reg_end_c2 - reg_in_c2;
				
	addsubcp2: process (addsubc2)
	begin
		if addsubc2(12) = '1' then
			addsub <= not(addsubc2) + 1;
			addsub(12) <= '1';
		else
			addsub <= addsubc2;
		end if;
	end process;
				
				
	-- multipliçao 
   muls(17 downto 0) <= reg_end(11 downto 0) * reg_in(5 downto 0);
	muls(18) <= ( muls(12) or muls(13) or muls(14) or muls(15) or muls(16) or muls(17) );
	muls(19) <= '0' when  (reg_end(12) xor reg_in(6))='0'
					else (reg_end(12) xor reg_in(6)) xor muls(18);
	
	-- and 
	log_and <= reg_end and (tmp & reg_in);

-- shift right arithmetic
	with reg_in(2 downto 0) select log_sra <=
		reg_end when "000",
			(12 downto 11 => reg_end(12), 
			 10 => reg_end(11), 9 => reg_end(10), 8 => reg_end(9), 7 => reg_end(8), 6 => reg_end(7),
			 5 => reg_end(6), 4 => reg_end(5), 3 => reg_end(4), 2 => reg_end(3), 1 => reg_end(2), 0 => reg_end(1)
			 ) when "001",
			(12 downto 10 => reg_end(12),
			 9 => reg_end(11), 8 => reg_end(10), 7 => reg_end(9), 6 => reg_end(8), 5 => reg_end(7),
			 4 => reg_end(6), 3 => reg_end(5), 2 => reg_end(4), 1 => reg_end(3), 0 => reg_end(2)
			) when "010",
			(12 downto 9 => reg_end(12),
			 8 => reg_end(11), 7 => reg_end(10), 6 => reg_end(9), 5 => reg_end(8), 4 => reg_end(7),
			 3 => reg_end(6), 2 => reg_end(5), 1 => reg_end(4), 0 => reg_end(3)
			) when "011",
			(12 downto 8 => reg_end(12),
			 7 => reg_end(11), 6 => reg_end(10), 5 => reg_end(9), 4 => reg_end(8), 
			 3 => reg_end(7), 2 => reg_end(6), 1 => reg_end(5), 0 => reg_end(4)
			) when "100",
			(12 downto 7 => reg_end(12),
			 6 => reg_end(11), 5 => reg_end(10), 4 => reg_end(9), 3 => reg_end(8), 
			 2 => reg_end(7), 1 => reg_end(6), 0 => reg_end(5)
			) when "101",
			(12 downto 6 => reg_end(12),
			 5 => reg_end(11), 4 => reg_end(10), 3 => reg_end(9), 
			 2 => reg_end(8), 1 => reg_end(7), 0 => reg_end(6)
			) when "110",
			(12 downto 5 => reg_end(12),
			 4 => reg_end(11), 3 => reg_end(10), 2 => reg_end(9), 
			 1 => reg_end(8), 0 => reg_end(7)
			) when "111",		
			reg_end when others;
			
	-- instruçoes
	mux_alu: process (ent, addsub, muls, log_and, log_sra)
	begin
		case ent(2 downto 0) is 
			when "000" =>
				m_alu <= addsub;
			when "001" =>
				m_alu <= addsub;
			when "010" =>
				m_alu(11 downto 0) <= muls(11 downto 0);
				m_alu(12) <=  muls(19); 
			when "011" =>
				m_alu <= log_and;
			when "100" =>
				m_alu <= log_sra;
			when others =>
				m_alu <= log_sra;
		end case;
	end process;
	
	m2 <= (12 => ent(6), 
			5 => ent(5), 
			4 => ent(4), 
			3 => ent(3), 
			2 => ent(2) , 
			1 => ent(1), 
			0 => ent(0),
			others=>'0') 
			when oper ="11" else m_alu;
	
	-- registos
	process (clk, oper)
	begin
		if clk'event and clk='1' then
			if rst_reg='1' then 
				reg_in <= (others=>'0');
				reg_end <= (others=>'0');
			elsif oper(0)='1' then
				reg_end <= m2;
			elsif oper="10" then
				reg_in <= ent;
			end if;
		end if;
	end process;
	
	r2 <= reg_end;
	r1 <= (12 => reg_in(6),
			 5 => reg_in(5),
			 4 => reg_in(4),
			 3 => reg_in(3),
			 2 => reg_in(2),
			 1 => reg_in(1),
			 0 => reg_in(0), 
			 others=>'0'
			 );
	--r1 <= (others=>'0');
	--r1(12) <= reg_in(6);
	--r1(5 downto 0) <= reg_in(5 downto 0);
	
end Behavioral;
