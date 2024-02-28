library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
library work;

entity FIR_FILTER is
generic (
  G_DATA_W : natural := 16
);
port (
  i_clk        : in std_logic;
  i_rst        : in std_logic;
  iv_InSig     : in std_logic_vector(G_DATA_W-1 downto 0);
  i_InputValid : in std_logic;
  ov_OutSig    : out std_logic_vector(G_DATA_W-1 downto 0);
  o_OutputValid: out std_logic
);
end entity;

architecture FIR_FILTER_rtl of FIR_FILTER is
  constant C_TAPS : integer := 10;
  type t_Coefs is array(C_TAPS-1 downto 0) of unsigned(G_DATA_W-1 downto 0);
  type t_Values is array(C_TAPS-1 downto 0) of unsigned(G_DATA_W-1 downto 0);
  type t_Muls is array(C_TAPS-1 downto 0) of unsigned(2*G_DATA_W-1 downto 0);
  constant C_Coefs : t_Coefs := ( --IQ16
    0 => to_unsigned(1061,G_DATA_W),
    1 => to_unsigned(2489,G_DATA_W),
    2 => to_unsigned(6104,G_DATA_W),
    3 => to_unsigned(10215,G_DATA_W),
    4 => to_unsigned(12898,G_DATA_W),
    5 => to_unsigned(12898,G_DATA_W),
    6 => to_unsigned(10215,G_DATA_W),
    7 => to_unsigned(6104,G_DATA_W),
    8 => to_unsigned(2489,G_DATA_W),
    9 => to_unsigned(1061,G_DATA_W)
  );
  signal Values : t_Values := (others => (others => '0'));
begin

FIR_FIL_proc: process(i_clk)
  variable MulRes : t_Muls := (others => (others => '0'));
begin
  if rising_edge(i_clk) then
    if (i_rst = '1') then
      Values <= (others => (others => '0'));
    else
      MulRes(0) := C_Coefs(0) * unsigned(iv_InSig);
      Values(0) <=  MulRes(0)(2*G_DATA_W-1 downto G_DATA_W);
      --------------------------------------------------------------------------------
      for i in 1 to C_Taps-1 loop
        MulRes(i) := C_Coefs(i) * unsigned(iv_InSig);
        Values(i) <= Values(i-1) + MulRes(i)(2*G_DATA_W-1 downto G_DATA_W);
      end loop;
      --------------------------------------------------------------------------------
    end if;
  end if;
end process;
ov_OutSig <= std_logic_vector(Values(Values'left));
end architecture;