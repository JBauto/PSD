library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity fpga is
  port (
    mclk: in std_logic;                     -- 50MHz clock
    btn: in std_logic_vector(3 downto 0);   -- buttons
    sw: in std_logic_vector(7 downto 0);    -- switches
    led: out std_logic_vector(7 downto 0);  -- leds
    an: out std_logic_vector(3 downto 0);   -- display selectors
    seg: out std_logic_vector(6 downto 0);  -- display 7-segments
    dp: out std_logic                       -- display point
    );
end fpga;

architecture Behavioral of fpga is
  component circuito
    port(
      clk : in std_logic;
      rst : in std_logic;
      button : in std_logic_vector(2 downto 0);
      data_in : in std_logic_vector(6 downto 0); 
		r2 : out std_logic_vector(12 downto 0);
      r1 : out std_logic_vector(12 downto 0)
      );
  end component;
  component disp7
    port(
      disp4 : in std_logic_vector(3 downto 0);
      disp3 : in std_logic_vector(3 downto 0);
      disp2 : in std_logic_vector(3 downto 0);
      disp1 : in std_logic_vector(3 downto 0);
      clk : in std_logic;
      aceso : in std_logic_vector(4 downto 1);          
      en_disp : out std_logic_vector(4 downto 1);
      segm : out std_logic_vector(7 downto 1);
      dp : out std_logic
      );
  end component;
  component clkdiv
    port(
      clk : in std_logic;          
      clk50M  : out std_logic;
      clk10Hz : out std_logic;
      clk_disp : out std_logic
      );
  end component;

  signal clk50M, clk10Hz, clk_disp : std_logic;
  signal res : std_logic_vector (15 downto 0) := (others =>'0') ;
  signal r1, r2 : std_logic_vector (12 downto 0);
  
begin
  inst_circuito: circuito port map(
    clk => clk10Hz,
    rst => btn(0),
    button => btn(3 downto 1),
    data_in => sw(6 downto 0),
    r1 => r1,
	 r2 => r2
    );
  inst_clkdiv: clkdiv port map(
    clk => mclk,
    clk50m => clk50m,
    clk10hz => clk10hz,
    clk_disp => clk_disp
    );
	
  res(12 downto 0) <=  r1 when sw(7)='1' 
								else r2;
	
  inst_disp7: disp7 port map(
    disp4 => res(15 downto 12),
    disp3 => res(11 downto 8),
    disp2 => res(7 downto 4),
    disp1 => res(3 downto 0),
    clk => clk_disp,
    aceso => "1111",
    en_disp => an,
    segm => seg,
    dp => dp
    );

  led <= sw;
end behavioral;

