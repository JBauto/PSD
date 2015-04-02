--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:26:13 10/09/2014
-- Design Name:   
-- Module Name:   C:/Users/Joao/Desktop/PSD/Lab1/teste1.vhd
-- Project Name:  Lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: datapath
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY teste1 IS
END teste1;
 
ARCHITECTURE behavior OF teste1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
    PORT(
         ent : IN  std_logic_vector(6 downto 0);
         oper : IN  std_logic_vector(1 downto 0);
         clk : IN  std_logic;
         rst_reg : IN  std_logic;
         r1 : OUT  std_logic_vector(12 downto 0);
         r2 : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ent : std_logic_vector(6 downto 0) := (others => '0');
   signal oper : std_logic_vector(1 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst_reg : std_logic := '0';

 	--Outputs
   signal r1 : std_logic_vector(12 downto 0);
   signal r2 : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          ent => ent,
          oper => oper,
          clk => clk,
          rst_reg => rst_reg,
          r1 => r1,
          r2 => r2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		rst_reg <= '1' after 20 ns,
				 '0' after 40 ns;
		ent <= "0111110" after 40 ns,
		       "0111110" after 120 ns,
				 "0000010" after 200 ns, --
				 "0111110" after 260 ns,
		       "0000001" after 320 ns,
				 "0000000" after 380 ns; --
				 --"1000011" after 420 ns,
				 --"0000010" after 500 ns; --
		 oper <= "11" after 40 ns,
					"00" after 80 ns,
				   "10" after 120 ns,
					"00" after 160 ns,
				   "01" after 200 ns,
					"10" after 260 ns,
				   "01" after 380 ns;
					--"11" after 420 ns,
					--"01" after 500 ns;					
      wait;
   end process;

END;
