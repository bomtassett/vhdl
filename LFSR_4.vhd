----------------------------------------------------------------------------------
-- Company      	:     The Citadel ECE Department
-- Engineer     	:     Thomas Bassett
-- 
-- Create Date 	    :     02/13/2026 11:00:10 PM
-- Design Name      :     LFSR_4
-- Module Name      :     LFSR_4 - Behavioral
-- Target Devices   :     Digilent Basys 3
--
-- Description      :     4-bit linear feedback shift register (LFSR) where Q+ = (Q1 XOR Q0) & Q3-1.
--                        The circuit can perform basic encryption of a data byte D by shifting it N times.  When
--                        St = 1, D is loaded into the 4-bit register and N is loaded into a 4-bit down counter.
--                        The register then shifts until the counter reaches 0, when Done is signaled.
-- 
-- Dependencies     :     ieee.std_logic_1164.all;
--                        ieee.std_logic_unsigned.all;
-- 
-- Revision:
-- Revision 0.01    :	    File Created
-- Revision 0.02    :     2026-03-13 - Separated Control and Datapath sequential processes
--				          
-- Adttl. Comments  :     Enforces best practices for clarity and complexity management.
-- 
----------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity LFSR_4 is
    port (Clk, St : in std_logic;
          D, N : in std_logic_vector(3 downto 0);
          Done : out std_logic;
          Qout : out std_logic_vector(3 downto 0));
end LFSR_4;

architecture Behave of LFSR_4 is
    signal State, NextState : integer range 0 to 1;  --state signals
    signal Load, Sh_C : std_logic;    			     --control signals
    signal Nc, Q : std_logic_vector(3 downto 0);     --register signals
begin
    -- control_logic process (combinational)
    control_logic: process(State, St, Nc)
    begin
        Done <= '0'; Load <= '0'; Sh_C <= '0';  --initialize control outputs to 0
        case State is
            when 0 =>
                if St = '1' then
                    Load <= '1'; NextState <= 1;  --load state
                else
                    NextState <= 0;
                end if;
            when 1 =>  --shift/countdown state
                if Nc /= "0000" then
                    Sh_C <= '1'; NextState <= 1;
                else
                    Done <= '1'; NextState <= 0;
                end if;
        end case;
    end process;
    
    --control register process (sequential)
    control_regs: process(Clk)
    begin
        if rising_edge(CLK) then
            State <= NextState;  --D_FF
		end if;
	end process;
    
    --datapath register process (sequential)
	--keep ctrl and datapath sequential processes separate
	--for clarity and complexity management
    datapath: process(CLK)
    begin
        if rising_edge(CLK) then
            if Load = '1' then
                Q  <= D;  --data input->data register signal
                Nc <= N;  --counter input->counter register signal
            end if;
            if Sh_C = '1' then
                Q <= (Q(1) XOR Q(0)) & Q(3 downto 1);  --encryption
                Nc <= Nc - "0001";  --decrement counter
            end if;
        end if;
    end process;
    
    Qout <= Q;  --connect signal->output port

end Behave;
