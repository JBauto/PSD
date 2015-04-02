----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:09:58 10/25/2014 
-- Design Name: 
-- Module Name:    datapath - arq_datapath 
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
    Port ( clk, rst : STD_LOGIC;
			  ctrl : in  STD_LOGIC_VECTOR (1 downto 0);
			  en_reg : in  STD_LOGIC_VECTOR (3 downto 0);
			  A, B, C, D, E, F, G, H, I : in  STD_LOGIC_VECTOR (15 downto 0);
			  sel_mux : in STD_LOGIC_VECTOR (8 downto 0) :=(others=>'0');
           res : out  STD_LOGIC_VECTOR (15 downto 0));
end datapath;

architecture arq_datapath of datapath is
signal r1, r2, r3, r4 : STD_LOGIC_VECTOR (15 downto 0) :=(others=>'0');
signal mux_r1, mux_r2, sum : STD_LOGIC_VECTOR (15 downto 0) :=(others=>'0');
signal mult1_m1, mult1_m2, mult2_m1, mult2_m2 : STD_LOGIC_VECTOR (15 downto 0) :=(others=>'0');
signal mult1, mult2 : STD_LOGIC_VECTOR (31 downto 0) :=(others=>'0');

begin

	--Multiplicadores
	mult1<= mult1_m1 * mult1_m2;
	mult2<= mult2_m1 * mult2_m2;
	
	-- Somador
	sum <= r1 + r2 when ctrl(0)='1'else
			 r2 - r1 when ctrl(1)='1'else
			 r1 - r2;
	
	--Mux R1
	mux_r1 <= mult1(15 downto 0);
	
	--Mux R2
	mux_r2 <= sum when sel_mux(0)='1' else
				 mult2(15 downto 0);
	
	select_mux: process(sel_mux,A,B,C,D,E,F,G,H,I,r1,r2,r3,r4)
	begin
		-- MUX MULTIPLICADOR 1 PORTA 1
		case sel_mux(8 downto 7) is
			when "00" =>
				mult1_m1 <= A;
			when "01" =>
				mult1_m1 <= C;
			when "10" =>
				mult1_m1 <= r3;
			when others =>
				mult1_m1 <= r1;
		end case;
		-- MUX MULTIPLICADOR 1 PORTA 2		
		case sel_mux(6 downto 5) is
			when "00" =>
				mult1_m2 <= I;
			when "01" =>
				mult1_m2 <= H;
			when "10" =>
				mult1_m2 <= E;
			when others =>
				mult1_m2 <= D;
		end case;
		-- MUX MULTIPLICADOR 2 PORTA 1		
		case sel_mux(4 downto 3) is
			when "00" =>
				mult2_m1 <= B;
			when "01" =>
				mult2_m1 <= C;
			when "10" =>
				mult2_m1 <= r4;
			when others =>
				mult2_m1 <= C;
		end case;
		-- MUX MULTIPLICADOR 2 PORTA 2		
		case sel_mux(2 downto 1) is
			when "00" =>
				mult2_m2 <= G;
			when "01" =>
				mult2_m2 <= I;
			when "10" =>
				mult2_m2 <= F;
			when others =>
				mult2_m2 <= I;
		end case;		
	end process;
	
	
	registos: process (clk, rst, en_reg)
	begin
		if clk'event and clk='1' then
			if rst='1' then 
				r1 <= (others=>'0');
				r2 <= (others=>'0');
				r3 <= (others=>'0');
				r4 <= (others=>'0');
			else 
				if en_reg(0)='1' then
					r1 <= mux_r1;
				end if;
				if en_reg(1)='1' then
					r2 <= mux_r2;
				end if;
				if en_reg(2)='1' then
					r3 <= sum;
				end if;
				if en_reg(3)='1' then
					r4 <= sum;
				end if;
			end if;
		end if;
	end process;
	
	res <= r4;
	
end arq_datapath;

