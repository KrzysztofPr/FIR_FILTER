library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use std.textio.all;
library work;
library vunit_lib;
context vunit_lib.vunit_context;


entity FIR_FILTER_tb is
generic (runner_cfg : string;
  G_NUM_TESTPOINTS : integer := 1000
  );
port (
 tester : in std_logic := '0'
);
end entity;

architecture FIR_FILTER_tb_beh of FIR_FILTER_tb is
  signal start_stimuli : event_t := new_event;
  constant C_CLK_PER  : time := 20 ns;
  constant C_DATA_W   : natural := 16;
  signal   clk        : std_logic := '0';
  signal   OutValid   : std_logic := '0';
  signal   InputValid : std_logic := '0';
  signal   InSig      : std_logic_vector(C_DATA_W-1 downto 0) := (others => '0');
  signal   OutSig     : std_logic_vector(C_DATA_W-1 downto 0) := (others => '0');
  signal rst : std_logic := '0';
  shared variable TempInData : integer;
  shared variable TempOutData : integer;
  constant C_ZeroOutVec : std_logic_vector(C_DATA_W-1 downto 0) := (others => '0');
  
begin
  clk <= not clk after C_CLK_PER/2;
--------------------------------------------------------------------------------
  runner_proc : process
    file fptr : text;
    variable FileLine : line;
  begin
    test_runner_setup(runner,runner_cfg);
    while test_suite loop
      if run("Init_values_test") then
        wait until rising_edge(clk);
        check_equal(OutSig,C_ZeroOutVec,"Init output is not equal to 0!");
        check_equal(OutValid,'0',"Init out valid is not equal to 0!");
      elsif run("Reset_test") then
        InputValid <= '1';
        rst <= '0';
        InSig <= std_logic_vector((to_unsigned(232,16)));
        for p in 0 to 100-1 loop
          wait until rising_edge(clk);
        end loop;
        rst <= '1';
        wait until rising_edge(clk);
        wait until falling_edge(clk); -- skip delta cycles
        check_equal(OutSig,C_ZeroOutVec,"Reset state output is not equal to 0!");
        check_equal(OutValid,'0',"Reset state ouyt valid is not equal to 0!");
      elsif run("Test_transposed_FIR_model") then
        notify(start_stimuli);
        InputValid <= '1';
        file_open(fptr, "DataVec.txt"); -- file must be located in /vunit_out/modelsim
        while (not endfile(fptr)) loop
          readline(fptr, FileLine);
          read(FileLine, TempInData);
          read(FileLine, TempOutData);
          InSig <= std_logic_vector(to_unsigned(TempInData,C_DATA_W));
          wait until rising_edge(clk);
          print(to_string(to_integer(unsigned(InSig))));
          print(to_string(to_integer(unsigned(OutSig))));
          check_equal(OutSig,std_logic_vector(to_unsigned(TempOutData,16)),"Golden vs reference data error!");
        end loop;  
    end loop;
      test_runner_cleanup(runner);
  end process;
--------------------------------------------------------------------------------
-- DUT
FIR_INST: entity work.FIR_FILTER
  port map(
    i_clk          => clk,
    i_rst          => rst,
    iv_InSig       => InSig,
    i_InputValid   => InputValid,
    ov_OutSig      => OutSig,
    o_OutputValid  => OutValid
  );
end architecture;