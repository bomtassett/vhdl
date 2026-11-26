----------------------------------------------------------------------------------
-- Company: The Citadel ECE Department
-- Engineer: Thomas Bassett
-- 
-- Create Date: 01/29/2026 07:00:48 PM
-- Design Name: SR4
-- Module Name: SR4 - Behave
-- Target Devices: Digilent Basys3
-- Description: 4-bit shift register SR4
-- Specifications:
--		• asynchronous active-low clear (ClrN)
--		• rising-edge triggered clock (Clk)
--		• active-high load signal (Ld) with parallel data input (D)
--		• function select signal (S).
--			• when S = 0, the register shifts right with a serial data input (SI).
--			• when S = 1, the register shifts right with sign extension.
-- 
-- Dependencies: IEEE.std_logic_1164.all, IEEE.std_logic_unsigned.all
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;

entity SR4 is
    port (ClrN, Clk, Ld, S, SI : in std_logic;
          D : in std_logic_vector(3 downto 0);
          Qout : out std_logic_vector(3 downto 0));
end SR4;

architecture Behave of SR4 is
    signal Q : std_logic_vector(3 downto 0) := "0000";  --initialize Q
begin
    process(ClrN, Clk)
    begin
        if ClrN = '0' then Q <= "0000"; --CLEAR (async active low)
        elsif rising_edge(Clk) then
            if Ld = '1' then Q <= D;  --LOAD (parallel)
            elsif S = '0' then Q <= SI & Q(3 downto 1);  --SHIFT RIGHT (SI load)
            else Q <= Q(3) & Q(3 downto 1);  --SHIFT RIGHT (sign extension)
            end if;
        end if;
    end process;
    Qout <= Q;
end Behave;

