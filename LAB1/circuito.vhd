----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:23:34 10/04/2014 
-- Design Name: 
-- Module Name:    circuito - Behavioral 
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
use IEEE.STD_LOGIC_SIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuito is
	port(
		clk, rst: in std_logic;
		button: in std_logic_vector(2 downto 0);
		data_in: in std_logic_vector(6 downto 0);
		r2: out std_logic_vector(12 downto 0) :=(others=>'0'); 
		r1: out std_logic_vector(12 downto 0) :=(others=>'0')
   );		
end circuito;

architecture Behavioral of circuito is
	component fsm
		port(
			clk, rst : in std_logic;
			button : in  STD_LOGIC_VECTOR (2 downto 0);
			load : out  STD_LOGIC_VECTOR (1 downto 0) -- REVER IN/OUT
		);
	end component;
	
	component datapath
		port(
			ent : in std_logic_vector (6 downto 0);
			oper : in std_logic_vector (1 downto 0);
			clk, rst_reg : in std_logic;
			r1 : out std_logic_vector (12 downto 0);
			r2 : out std_logic_vector (12 downto 0)
		);
	end component;

  signal load : std_logic_vector(1 downto 0);

	
begin
	instr_controlo: fsm port map(
		clk => clk,
		rst => rst,
		button => button,
		load => load
		);
	instr_datapath: datapath port map(
		ent => data_in,
		rst_reg => rst,
		clk => clk,
		oper => load,
		r1 => r1,
		r2 => r2
	);	

end Behavioral;
	
