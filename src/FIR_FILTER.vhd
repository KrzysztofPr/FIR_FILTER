library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
library work;

entity FIR_FILTER is
port (
  clk                : in std_logic;
  rst                : in std_logic
);
end entity;

architecture FIR_FILTER_rtl of FIR_FILTER is

begin

FIR_FIL_proc: process(clk)
begin
  if rising_edge(clk) then
    if (rst = '1') then
      
    else
    
    end if;
  end if;
end process;
end architecture;