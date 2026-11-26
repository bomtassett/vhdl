-- DFF - D Flip-flop with Active-low Asynchronous Clear
library IEEE;
use IEEE.std_logic_1164.all;

entity DFF is
  port(D, Clk, ClrN: in std_logic;  -- Inputs
       Q: out std_logic);           -- Output
end DFF;

architecture Behave of DFF is
begin
  process(Clk, ClrN)
  begin
    if ClrN = '0' then
      Q <= '0';
	elsif rising_edge(Clk) then
      Q <= D;
    end if;
  end process;
end Behave;
