--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:30:47 10/04/2014
-- Design Name:   
-- Module Name:   C:/Users/Joao/Desktop/PSD/Lab1/circuito_tb.vhd
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
 
ENTITY circuito_tb IS
END circuito_tb;
 
ARCHITECTURE behavior OF circuito_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT datapath
    PORT(
         ent : IN  std_logic_vector(6 downto 0);
         oper : IN  std_logic_vector(1 downto 0);
         clk : IN  std_logic;
         rst_reg : IN  std_logic;
         res : OUT  std_logic_vector(12 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ent : std_logic_vector(6 downto 0) := (others => '0');
   signal oper : std_logic_vector(1 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst_reg : std_logic := '0';

 	--Outputs
   signal res : std_logic_vector(12 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: datapath PORT MAP (
          ent => ent,
          oper => oper,
          clk => clk,
          rst_reg => rst_reg,
          res => res
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
		ent <= X"67" after 40 ns,
				 X"12" after 120 ns,
			    X"C3" after 200 ns;
		instr <= "001" after 40 ns,
					"010" after 80 ns,
					"011" after 120 ns,
					"100" after 160 ns,
					"101" after 200 ns,
					"000" after 300 ns;
      wait;
   end process;

END;
