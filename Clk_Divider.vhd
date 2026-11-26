-- THE CITADEL DEPT. OF ELECTRICAL & COMPUTER ENGINEERING
-- Engineer:    T. Bassett
-- Modified:    8/31/2026
--              Post-implementation timing report flagged
--              critical timing warnings on ctr2 & ctr3; they are 
--              not connected to clock line. Corrected so all three
--              counters run on sysclk (100MHz).
-- Module:      UART_ClkDiv v1.5
-- Project:     Processor_COMPLETE v1.0

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity clk_divider is
  port(sysclk: in std_logic;
       sel: in std_logic_vector(2 downto 0);
       bclkx8: buffer std_logic;
       bclk: out std_logic);
end clk_divider;

architecture behave of clk_divider is
  signal ctr1: std_logic_vector(7 downto 0) := X"00"; --divide by 163
  signal ctr2: std_logic_vector(7 downto 0) := X"00"; --divide by 256
  signal ctr3: std_logic_vector(2 downto 0) := "000"; --divide by 8
  signal div163: std_logic := '0'; --sysclock divided by 163
  signal bclkx8_dlay: std_logic := '0'; --bclkx8-10ns
  signal bclkx8_rise: std_logic := '0'; --rising edge bclkx8
  
begin
  --combinational
  div163 <= '1' when ctr1 = x"A2" else '0'; --ctr2 clock gate
  bclkx8 <= ctr2(conv_integer(sel)); --select baud (table 12.1)
  bclkx8_rise <= bclkx8 and (not bclkx8_dlay); --rising edge bclkx8
  bclk <= ctr3(2); --bclk = bclkx8/8
  
  --synchronous
  clkdiv: process(sysclk)
  begin
    if rising_edge(sysclk) then
      ctr1 <= ctr1 + 1;
      bclkx8_dlay <= bclkx8;
      if ctr1 = x"A2" then
        ctr1 <= x"00"; --ctr1 reset
      end if;
      if div163 = '1' then --sysclk/163
        ctr2 <= ctr2 + 1;
      end if;
      if bclkx8_rise = '1' then
        ctr3 <= ctr3 + 1;
      end if;
    end if;
  end process; 
end behave;


