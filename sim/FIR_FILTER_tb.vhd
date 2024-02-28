library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use std.textio.all;
library work;

entity FIR_FILTER_tb is
port (
 tester : in std_logic := '0'
);
end entity;

architecture FIR_FILTER_tb_beh of FIR_FILTER_tb is
  constant C_CLK_PER  : time := 20 ns;
  constant C_DATA_W   : natural := 16;
  signal   clk        : std_logic := '0';
  signal   InSig      : std_logic_vector(C_DATA_W-1 downto 0) := (others => '0');
  signal   OutSig     : std_logic_vector(C_DATA_W-1 downto 0) := (others => '0');
  signal rst : std_logic := '0';
begin
  clk <= not clk after C_CLK_PER/2;
  rst <= '1', '0' after 5 ns;
--------------------------------------------------------------------------------
  stim_proc : process
    file fptr : text;
    variable FileLen : line;
    variable TempData : integer;
  begin
    file_open(fptr, "DataVec.txt", read_mode);
    while (not endfile(fptr)) loop
      readline(fptr, FileLen);
      read(FileLen, TempData);
      InSig <= std_logic_vector(to_unsigned(TempData,C_DATA_W));
      wait until rising_edge(clk);
   end loop;  
  end process;
--------------------------------------------------------------------------------
FIR_INST: entity work.FIR_FILTER
  port map(
    i_clk          => clk,
    i_rst          => rst,
    iv_InSig       => InSig,
    i_InputValid   => '1',
    ov_OutSig      => OutSig,
    o_OutputValid  => open
  );
  
end architecture;