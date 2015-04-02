--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:49:43 10/28/2014
-- Design Name:   
-- Module Name:   C:/Users/PSD/Desktop/Lab2/circuito_tb.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: circuito
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
 
    COMPONENT circuito
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         btn : IN  std_logic;
         res_out : OUT  std_logic_vector(15 downto 0);
         A : IN  std_logic_vector(15 downto 0);
         B : IN  std_logic_vector(15 downto 0);
         C : IN  std_logic_vector(15 downto 0);
         D : IN  std_logic_vector(15 downto 0);
         E : IN  std_logic_vector(15 downto 0);
         F : IN  std_logic_vector(15 downto 0);
         G : IN  std_logic_vector(15 downto 0);
         H : IN  std_logic_vector(15 downto 0);
         I : IN  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal btn : std_logic := '0';
   signal A : std_logic_vector(15 downto 0) := (others => '0');
   signal B : std_logic_vector(15 downto 0) := (others => '0');
   signal C : std_logic_vector(15 downto 0) := (others => '0');
   signal D : std_logic_vector(15 downto 0) := (others => '0');
   signal E : std_logic_vector(15 downto 0) := (others => '0');
   signal F : std_logic_vector(15 downto 0) := (others => '0');
   signal G : std_logic_vector(15 downto 0) := (others => '0');
   signal H : std_logic_vector(15 downto 0) := (others => '0');
   signal I : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal res_out : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: circuito PORT MAP (
          clk => clk,
          rst => rst,
          btn => btn,
          res_out => res_out,
          A => A,
          B => B,
          C => C,
          D => D,
          E => E,
          F => F,
          G => G,
          H => H,
          I => I
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
      -- hold reset state for 50 ns.
      wait for 50 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		rst <= '1' after 20 ns,
				 '0' after 40 ns;
		A <= "0000000000000101" after 40 ns;
      B <= "0000000000001010" after 40 ns;
      C <= "0000000000000011" after 40 ns;
      D <= "0000000000000111" after 40 ns;
      E <= "0000000000000100" after 40 ns;
      F <= "0000000000000011" after 40 ns;
      G <= "0000000000000101" after 40 ns;
      H <= "0000000000000010" after 40 ns;
      I <= "0000000000000110" after 40 ns;
		
		btn <= '1' after 60 ns,
				 '0' after 80 ns;
		
      wait;
   end process;

END;
