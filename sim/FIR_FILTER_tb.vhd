library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use std.textio.all;
library work;
library vunit_lib;
context vunit_lib.vunit_context;


entity FIR_FILTER_tb is
generic (runner_cfg : string);
port (
 tester : in std_logic := '0'
);
end entity;

architecture FIR_FILTER_tb_beh of FIR_FILTER_tb is
  signal start_stimuli : event_t := new_event;
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
    wait until is_active(start_stimuli);
    file_open(fptr, "DataVec.txt"); -- file must be located in /vunit_out/modelsim
    while (not endfile(fptr)) loop
      readline(fptr, FileLen);
      read(FileLen, TempData);
      InSig <= std_logic_vector(to_unsigned(TempData,C_DATA_W));
      wait until rising_edge(clk);
   end loop;  
  end process;

  runner_proc : process
  begin
    test_runner_setup(runner,runner_cfg);
    while test_suite loop
      if run("Test1") then
        report "Test1 passed";
      elsif run("Test2") then
        notify(start_stimuli);
        assert false report "Test2 failed";
      end if;
    end loop;
    test_runner_cleanup(runner);
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