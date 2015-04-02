--
-- PrSD 2009/10 - Apoio ao Projecto 3
-- Adapta Projecto BramCfg disponibilizado pela Digilent.
-- Faz upload de ficheiro via usb para porto A da BlockRamIN.
-- Faz download de ficheiro via usb do porto A da BlockRamOUT.
-- Permite visualizar conteudo das BlockRamIN e BlockRamOUT quando execucao parada.
-- Execucao inicia-se quando se activa o botao 1.
-- A datapath troca simplesmente os 4-bits menos siginificativos com os 4-bits mais
-- siginificativos do elemento da BlockRamIN e escreve o novo elemento na BlockRamOUT.
--
--------------------------------------------------------------------------------------
--
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:54:41 03/07/2008 
-- Design Name: 
-- Module Name:    BramCfg - Structural 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- This is the Digilent BramCfg reference project. 
-- It is an example for transferring data between a Block RAM and a PC.
-- The BramCfg project instantiates a Block RAM and interfaces it to 
-- an Epp port (the Digilent OnBoard USB circuitry and firmware)
-- It is used in conjunction with a program running on a PC (a Digilent
-- utility as TransPort or a user generated application) which in turn
-- uses the APIs provided by Digilent Adept Suite.
--
-- The BramCfg project connects to Block RAM port A and leaves all 
-- port B signals "open". Port B can be used for extending the project.
--
-- For more details about using the project, see the 
-- Digilent BramCfg Reference Project Manual
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity usb2bram is
  port ( 
-- Epp-like bus signals
    EppAstb: in std_logic;                       -- Address strobe
    EppDstb: in std_logic;                       -- Data strobe
    EppWr  : in std_logic;                       -- Port write signal
    EppDB  : inout std_logic_vector(7 downto 0); -- port data bus
    EppWait: out std_logic;                      -- Port wait signal

    mclk: in std_logic;
    btn: in std_logic_vector(3 downto 0);
    sw: in std_logic_vector(7 downto 0);
    led: out std_logic_vector(7 downto 0);
    an: out std_logic_vector(3 downto 0);
    seg: out std_logic_vector(6 downto 0);
    dp: out std_logic
    );

end usb2bram;

architecture Structural of usb2bram is

-- signals to interconnect the components
  signal BramDataOut   : std_logic_vector (7 downto 0);
  signal BramAdrIn     : std_logic_vector (10 downto 0);
  signal BramDataIn    : std_logic_vector (7 downto 0);
  signal BramWeIn      : std_logic;
  signal BramEnIn      : std_logic;
  signal BramClkIn     : std_logic;
  signal EppBusOut     : std_logic_vector (7 downto 0);
  signal EppBusIn      : std_logic_vector (7 downto 0);
  signal EppAdrOut     : std_logic_vector (4 downto 0);
  signal EppStbDataOut : std_logic;
  signal EppWrOut      : std_logic;
  signal selBramCtrl   : std_logic;

  signal adrB1, adrB2, adrB1cnt, adrB2cnt  : std_logic_vector (8 downto 0);
  signal data_in, dataB2inAux : std_logic_vector (31 downto 0);
  signal dataB1, dataB2, dataB3, dataB2in : std_logic_vector (31 downto 0);
  signal temp_endB, temp_endB2, addr_aux : std_logic_vector (8 downto 0);
  signal clk_disp7, clk_fast : std_logic;
  signal write_enableOUT, write_enableAUX : std_logic;
  signal cicle : STD_LOGIC_VECTOR(1 downto 0);
  signal write_enable2, is_executing, not_executing : std_logic;
  
-- component declarations
  component EppCtrlAsync
    port ( EppAstb   : in    std_logic; 
           EppDstb   : in    std_logic; 
           EppWr     : in    std_logic; 
           busIn     : in    std_logic_vector (7 downto 0); 
           sel0      : inout std_logic; 
           sel2      : inout std_logic; 
           sel4      : inout std_logic; 
           sel6      : inout std_logic; 
           sel8      : inout std_logic; 
           selA      : inout std_logic; 
           selC      : inout std_logic; 
           selE      : inout std_logic; 
           EppDB     : inout std_logic_vector (7 downto 0); 
           EppWait   : out   std_logic; 
           stbData   : out   std_logic; 
           ctlrWr    : out   std_logic; 
           outEppAdr : out   std_logic_vector (4 downto 0); 
           busOut    : out   std_logic_vector (7 downto 0));
  end component;
  
  component BramComCtrl
    port ( stbData     : in    std_logic; 
           ctrlWr      : in    std_logic; 
           selBram     : in    std_logic; 
           busEppIn    : in    std_logic_vector (7 downto 0); 
           busEppAdrIn : in    std_logic_vector (4 downto 0); 
           busBramIn   : in    std_logic_vector (7 downto 0); 
           ctlWeBram   : out   std_logic; 
           clkBram     : out   std_logic; 
           busEppOut   : out   std_logic_vector (7 downto 0); 
           busBramAdr  : out   std_logic_vector (10 downto 0); 
           busBramOut  : out   std_logic_vector (7 downto 0); 
           ctlEnBram   : out   std_logic);
  end component;
  
  component BlockRam
    port ( ctlWeA : in    std_logic; 
           busDiA : in    std_logic_vector (7 downto 0); 
           busDoA : out   std_logic_vector (7 downto 0); 
           adrA   : in    std_logic_vector (10 downto 0); 
           ctlEnA : in    std_logic; 
           clkA   : in    std_logic; 
           ctlWeB : in    std_logic; 
           busDiB : in    std_logic_vector (31 downto 0); 
           busDoB : out   std_logic_vector (31 downto 0); 
           adrB   : in    std_logic_vector (8 downto 0); 
           ctlEnB : in    std_logic; 
           clkB   : in    std_logic);
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

  component circuito
    Port ( datain : in  STD_LOGIC_VECTOR (31 downto 0);
           dataout : out  STD_LOGIC_VECTOR (31 downto 0);
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           btn : in  STD_LOGIC;
			  cicle : out STD_LOGIC_VECTOR(1 downto 0);
			  enderecoB1 : out std_logic_vector (8 downto 0);
			  enderecoB2 : out std_logic_vector (8 downto 0);
			  enable_out : out STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (7 downto 0));
	end component;
  
begin

-- component instantiations
  EppCtrlAsyncInst : EppCtrlAsync port map (
    busIn     => EppBusIn,
    EppAstb   => EppAstb,
    EppDstb   => EppDstb,
    EppWr     => EppWr,
    busOut    => EppBusOut,
    ctlrWr    => EppWrOut,
    EppWait   => EppWait,
    outEppAdr => EppAdrOut,
    stbData   => EppStbDataOut,
    EppDB     => EppDB,
    selA      => open,
    selC      => open,
    selE      => open,
    sel0      => selBramCtrl,
    sel2      => open,
    sel4      => open,
    sel6      => open,
    sel8      => open);
  
  BramComCtrlInst : BramComCtrl port map (
    busBramIn   => BramDataOut,
    busEppAdrIn => EppAdrOut,
    busEppIn    => EppBusOut,
    ctrlWr      => EppWrOut,
    selBram     => selBramCtrl,
    stbData     => EppStbDataOut,
    busBramAdr  => BramAdrIn,
    busBramOut  => BramDataIn,
    busEppOut   => EppBusIn,
    clkBram     => BramClkIn,
    ctlEnBram   => BramEnIn,
    ctlWeBram   => BramWeIn);
  
  BlockRamIN : BlockRam port map (
    adrA   => BramAdrIn,
    adrB   => temp_endB,
    busDiA => BramDataIn,
    busDiB => "00000000000000000000000000000000",
    clkA   => BramClkIn,
    clkB   => clk_fast,
    ctlEnA => BramEnIn,
    ctlEnB => '1',
    ctlWeA => BramWeIn,
    ctlWeB => '0',
    busDoA => open,
    busDoB => dataB1);
  BlockRamOUT : BlockRam port map (
    adrA   => BramAdrIn,
    adrB   => temp_endB2,
    busDiA => "00000000",
    busDiB => dataB2in,
    clkA   => BramClkIn,
    clkB   => clk_fast,
    ctlEnA => BramEnIn,
    ctlEnB => '1',
    ctlWeA => '0',
    ctlWeB => write_enableOUT,
    busDoA => BramDataOut,
    busDoB => open);
	BlockRamAUX : BlockRam port map (
    adrA   => "00000000000",
    adrB   => addr_aux,
    busDiA => "00000000",
    busDiB => dataB3,
    clkA   => '0',
    clkB   => clk_fast,
    ctlEnA => '0',
    ctlEnB => '1',
    ctlWeA => '0',
    ctlWeB => write_enableAUX,
    busDoA => open,
    busDoB => dataB2inAux);

  inst_disp7: disp7 port map(
    disp4 => dataB2in(15 downto 12),
    disp3 => dataB2in(11 downto 8),
    disp2 => dataB2in(7 downto 4),
    disp1 => dataB2in(3 downto 0),
    clk => clk_disp7,
    aceso => "1111",
    en_disp => an,
    segm => seg,
    dp => dp
    );

  inst_clkdiv: clkdiv port map(
    clk => mclk,
    clk50m => clk_fast,
    clk10hz => open,
    clk_disp => clk_disp7
    );
	 
	BlockCircuito: circuito port map(
		clk => clk_fast,
		datain => data_in,
      dataout => dataB2in,
		enderecoB1 => temp_endB,
		enderecoB2 => temp_endB2,
		enable_out => write_enable2,
		cicle => cicle,
      rst => btn(0),
      btn => btn(1),
      sw => sw
	);

  -- 6 leftmost leds show the 6 lower bits of the adress counter.
  --led <= adrB1cnt(5 downto 0) & '0' & not_executing;
  led <= "00000000";
  
  -- address values are defined by the control during execution
  -- and by the board switches when not executing
  --adrB1 <= "0" & sw when not_executing = '1' else adrB1cnt;
  --adrB2 <= "0" & sw when not_executing = '1' else adrB2cnt;
  --write_enable <= is_executing;
  --not_executing <= not is_executing;
  
	write_enableOUT <= write_enable2 when cicle = "00" or cicle = "10" else '0';
	write_enableAUX <= write_enable2 when cicle = "11" else '0';
	
	data_in <= dataB2inAux when cicle = "10" else
				  dataB1;
  
   addr_aux <= temp_endB when cicle = "10" else
				   temp_endB2;
  
  dataB3 <= dataB2in;
  
end Structural;
