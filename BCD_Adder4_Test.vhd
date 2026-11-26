----------------------------------------------------------------------------------
-- Company: The Citadel ECE Department
-- Engineer: Thomas Bassett
-- 
-- Create Date: 03/05/2026 01:45:47 PM
-- Design Name: elec418_project2_BCD_Adder4
-- Module Name: BCD_Adder4_Test - Behave
-- Target Devices: Digilent Basys3
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BCD_Adder4_Test is
end BCD_Adder4_Test;

architecture Behave of BCD_Adder4_Test is
--Component Declaration for the Unit Under Test (UUT)
component BCD_Adder4
    port(St, Clk : in std_logic;
         A, B : in std_logic_vector(3 downto 0);
         Done : out std_logic;
         Sum_out : out std_logic_vector(4 downto 0));
end component;

--Inputs
signal St, Clk : std_logic := '0';
signal A, B : std_logic_vector(3 downto 0) := "0000";

--Outputs
signal Done : std_logic := '0';
signal Sum_out : std_logic_vector(4 downto 0) := "00000";

--Clock period definitions
constant Clk_period : time := 10ns; --Clock period (10ns for Basys3, f = 100MHz)

--Test vector arrays
constant N: integer := 2;
type arr1 is array(1 to N) of std_logic;
type arr2 is array(1 to N) of std_logic_vector(4 downto 0);
constant RegA_array: arr2 := ("01000", "00101");
constant RegB_array: arr2 := ("00111", "00100");
constant ACC_array: arr2 := ("10101", "01001");
constant Sout_array: arr2 := ("10101", "01001");

begin
--Instantiate the Unit Under Test (UUT)
uut : BCD_Adder4 port map (St, Clk, A, B, Done, Sum_out); --component instantiation statement

--Clock process definitions
Clk_process : process --no sensitivity list = endless loop
begin
    Clk <= '0';
    wait for Clk_period / 2;
    Clk <= '1';
    wait for Clk_period / 2;
end process;

--Stimulus process
stim_proc : process
begin
    for
    wait for Clk_period * 1.25;
    A <= "1000"; B <= "0111"; St <= '1';
    wait for Clk_period;
    St <= '0';
    wait;
end process;

end Behave;
