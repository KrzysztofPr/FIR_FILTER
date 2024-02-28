library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
library work;

entity Top_ent is
port (
  i_clk        : in std_logic;
  i_rst        : in std_logic;
  iv_InSig     : in std_logic_vector(16-1 downto 0);
  ov_OutSig    : out std_logic_vector(16-1 downto 0)
);
end entity;

architecture Top_ent_rtl of Top_ent is

begin

FIR_INST: entity work.FIR_FILTER
  port map(
    i_clk          => i_clk,
    i_rst          => i_rst,
    iv_InSig       => iv_InSig,
    i_InputValid   => '1',
    ov_OutSig      => ov_OutSig,
    o_OutputValid  => open
  );
  
end architecture;