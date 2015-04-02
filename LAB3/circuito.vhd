----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:26:57 12/09/2014 
-- Design Name: 
-- Module Name:    circuito - circuito 
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
    Port ( datain : in  STD_LOGIC_VECTOR (31 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0);
			  enderecoB1 : out std_logic_vector (8 downto 0);
			  enderecoB2 : out std_logic_vector(8 downto 0);
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           btn : in  STD_LOGIC;
			  enable_out : out STD_LOGIC;
			  cicle : out STD_LOGIC_VECTOR(1 downto 0);
           sw : in  STD_LOGIC_VECTOR (7 downto 0));
			  
end circuito;

architecture circuito of circuito is
signal start, first_time, last_time, oper, front, reg_meio, reg_fn, reg_out, reg_in: std_logic;
signal counter : std_logic_vector(6 downto 0);
signal index : std_logic_vector(2 downto 0);
signal endB : std_logic_vector (8 downto 0);
signal endB2 : std_logic_vector(8 downto 0);
signal en_out: std_logic;


	component datapath is
		Port ( clk, rst : in std_logic;
			  start, reg_fn, reg_meio, reg_out, reg_in  : in std_logic;
			  index : in std_logic_vector(2 downto 0);
			  first_time, last_time, oper, front: in std_logic;
			  datain : in  std_logic_vector (31 downto 0);
           dataout : out  std_logic_vector (31 downto 0);
			  counter : in std_logic_vector(6 downto 0)
			  );
	end component;
	
	component fsm is
		Port ( clk, rst, btn : in  STD_LOGIC;
			  sw : in std_logic_vector(7 downto 0);
			  enout, cicle, rep : out std_logic;
			  start,reg_final, reg_meio, reg_out, reg_in : out STD_LOGIC;
			  first_time, last_time, oper, front :out std_logic;
			  index : out std_logic_vector(2 downto 0);
			  cnt : out std_logic_vector(6 downto 0);
			  enderecoB : out std_logic_vector(8 downto 0) :=(others=>'0');
			  enderecoBout : out std_logic_vector(8 downto 0) :=(others=>'0')
			  );
	end component;

begin
	arq_fsm : fsm port map(
		clk => clk,
		rst => rst,
		btn => btn,
		sw => sw,
		index => index,
		first_time =>first_time,
		last_time => last_time,
		oper => oper,
		front => front,
		reg_meio => reg_meio,
		reg_final => reg_fn,
		reg_out => reg_out,
		reg_in => reg_in,
		start => start,
		cnt => counter,
		enderecoB => endB,
		enderecoBout => endB2,
		cicle => cicle(0),
		rep => cicle(1),
		enout => en_out
	);
	
	enderecoB1 <= endB;
	enderecoB2 <= endB2;
	enable_out <= en_out;
	
	arq_datapath : datapath port map(
		clk => clk,
		rst => rst,
		reg_fn => reg_fn,
		first_time =>first_time,
		last_time => last_time,
		oper => oper,
		front => front,
		reg_meio => reg_meio,
		reg_out => reg_out,
		reg_in =>reg_in,
		start => start,
		datain => datain,
		dataout => dataout,
		index => index,
		counter => counter
	);

end circuito;

