----------------------------------------------------------------------------------
-- Company: The Citadel ECE Department
-- Engineer: Thomas Bassett
-- 
-- Create Date: 03/05/2026 01:44:22 PM
-- Design Name: elec418_project2_BCD_Adder4
-- Module Name: BCD_Adder4 - Behave
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

entity BCD_Adder4 is
    port(St, Clk : in std_logic;
         A, B : in std_logic_vector(3 downto 0); --BCD addend & augend
         Done : out std_logic;
         Sum_out : out std_logic_vector(4 downto 0)); --BCD sum output
end BCD_Adder4;

architecture Behave of BCD_Adder4 is
    signal State, NextState : integer range 0 to 4;  --state signals (5 states -> 3-bit address)
    signal Ld, Ad, Corr, GT9 : std_logic;  --control signals
    signal RegA, RegB, Sum, ACC : std_logic_vector(4 downto 0);  --register signals
begin
    --Adder_5bit MUXes
    Sum <= RegA + RegB when Corr = '0' else ACC + "00110";
    
    --control_logic process (combinational)
    ctrl_logic : process(State, St, GT9)
    begin
        --Zeroing control outputs (not GT9!)
        Done <= '0'; Ld <= '0'; Ad <= '0'; Corr <= '0';
        case State is
            when 0 =>
                if St = '1' then
                    Ld <= '1'; NextState <= 1; --Load RegA & RegB
                else
                    NextState <= 0;
                end if;
            when 1 =>
                Ad <= '1'; NextState <= 2; --Add RegA & RegB
            when 2 =>
                if GT9 = '0' then --Sum greater than 9?
                    Done <= '1'; NextState <= 0; --No -> Done, return to State 0
                else
                    NextState <= 3;
                end if;
            when 3 =>
                Ad <= '1'; Corr <= '1'; NextState <= 4; --Yes -> Correct & Add
            --Adding 5th state for Done doesn't affect memory size (3 bits)
            --Would have to reduce to 3 states to downsize to 2-bit address
            when 4 =>
                Done <= '1'; NextState <= 0; --Done, return to State 0             
        end case;
    end process;
    
    --control_regs process (sequential)
    ctrl_regs : process(Clk)
    begin
        if rising_edge(Clk) then
            State <= NextState; --D_FF
        end if;
    end process;
    
    --datapath comparator process (combinational)
    dp_comb: process(ACC)
    begin
        if ACC > "01001" then
            GT9 <= '1'; --Greater than 9
        else
            GT9 <= '0'; --Less than 9
        end if;
    end process;
    
    --datapath register process (sequential)
    dp_regs : process(Clk)
    begin
        if rising_edge(Clk) then
            if Ld = '1' then
                RegA <= '0' & A; --Accomodating for corrected output
                RegB <= '0' & B; --Accomodating for corrected output
            end if;
            if Ad = '1' then
            ACC <= Sum;
            end if;
        end if;
    end process;
 
Sum_out <= ACC; --connect signal to output port.
 
end Behave;
