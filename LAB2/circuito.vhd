----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:43:24 10/25/2014 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuito is
	Port ( clk, rst, btn : in  STD_LOGIC;
			 res_out : out  STD_LOGIC_VECTOR (15 downto 0);
			 A, B, C, D, E, F, G, H, I : in  STD_LOGIC_VECTOR (15 downto 0)
			 );
end circuito;


architecture arq_circuito of circuito is
	component fsm is
		Port ( clk, rst, btn : in  STD_LOGIC;
			load_mat : out STD_LOGIC;
         load_reg : out  STD_LOGIC_VECTOR (3 downto 0);
			sel_mux : out STD_LOGIC_VECTOR (8 downto 0) :=(others=>'0');
			controlo : out  STD_LOGIC_VECTOR (1 downto 0)
		);
	end component;
	
	component datapath is
		Port ( clk, rst : STD_LOGIC;
			  ctrl : in STD_LOGIC_VECTOR (1 downto 0);
			  en_reg : in  STD_LOGIC_VECTOR (3 downto 0);
			  sel_mux : in STD_LOGIC_VECTOR (8 downto 0) :=(others=>'0');
			  A, B, C, D, E, F, G, H, I : in  STD_LOGIC_VECTOR (15 downto 0);
           res : out  STD_LOGIC_VECTOR (15 downto 0));
	end component;
	
	signal load_mat : STD_LOGIC;
	signal controlo : STD_LOGIC_VECTOR (1 downto 0);
	signal load_reg : STD_LOGIC_VECTOR (3 downto 0);
	signal sel_mux : STD_LOGIC_VECTOR (8 downto 0);
	signal regA, regB, regC, regD, regE, regF, regG, regH, regI : STD_LOGIC_VECTOR(15 downto 0);
	
begin
	instr_controlo : fsm port map(
		clk => clk,
		rst => rst,
		btn => btn,
		load_mat => load_mat,
		load_reg => load_reg,
	   sel_mux => sel_mux,
		controlo => controlo
	);
	
	intr_datapath : datapath port map(
		clk => clk,
		rst => rst,
		sel_mux => sel_mux,
		A => regA,
		B => regB,
		C => regC,
		D => regD,
		E => regE,
		F => regF,
		G => regG,
		H => regH,
		I => regI,
		ctrl => controlo,
		en_reg => load_reg,
		res => res_out
	);
	
	registos: process (clk, rst, load_mat)
	begin
		if clk'event and clk='1' then
			if rst='1' then 
				regA <= (others=>'0');
				regB <= (others=>'0');
				regC <= (others=>'0');
				regD <= (others=>'0');
				regE <= (others=>'0');
				regF <= (others=>'0');
				regG <= (others=>'0');
				regH <= (others=>'0');
				regI <= (others=>'0');
			elsif load_mat='1' then
				regA <= A;
				regB <= B;
				regC <= C;
				regD <= D;
				regE <= E;
				regF <= F;
				regG <= G;
				regH <= H;
				regI <= I;	
			end if;
		end if;
	end process;


end arq_circuito;

