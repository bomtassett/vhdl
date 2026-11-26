--------------------------------------------------------------------------------
-- Company		: The Citadel
-- Engineer		: Thomas Bassett
-- Revised		: 2026-02-08
-- Serial_Adder	: 32-bit Serial Adder
--------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SerialAdder is
	port(N, CLK: in std_logic;
		 X, Y: in std_logic_vector(31 downto 0);
		 SUM: out std_logic_vector(31 downto 0));
end SerialAdder;

architecture Behave of SerialAdder is
	-- Controller
	signal K, Load, Shift: std_logic := '0';
	signal Counter: std_logic_vector(4 downto 0) := "00000";
	signal State, NextState: integer range 0 to 2 := 0;
	-- Data Path
	signal Sumi, Ci, CiPlus: std_logic := '0';
	signal RegX, RegY: std_logic_vector(31 downto 0) := X"00000000";
begin
	-- Controller
	K <= '1' when Counter = "11111" else '0';
	-- Control Logic
	process(State, N, K)
	begin
		Load <= '0'; Shift <= '0';
		case State is
			when 0 => if N = '1' then
						Load <= '1'; NextState <= 1;
					  else
						NextState <= 0;
					  end if;
			when 1 => if K = '1' then
						Shift <= '1'; NextState <= 2;
					  else
						Shift <= '1'; NextState <= 1;
					  end if;
			when 2 => if N = '0' then
						NextState <= 0;
					  else
						NextState <= 2;
					  end if;
		end case;
	end process;
	-- Control Registers
	process(Clk)
	begin
		if falling_edge(CLK) then
			State <= NextState;
			if Load = '1' then
				Counter <= "00000";
			end if;
			if Shift = '1' then
				Counter <= Counter + 1;
			end if;
		end if;
	end process;
	-- Data Path
	Sumi <= RegX(0) xor RegY(0) xor Ci;
	CiPlus <= (RegX(0) and RegY(0)) or (RegX(0) and Ci) or (RegY(0) and Ci);
	SUM <= RegX;
	-- Data Path Registers
	process(Clk)
	begin
		if falling_edge(CLK) then
			if Load = '1' then
				RegX <= X;
				RegY <= Y;
				Ci <= '0';
			end if;
			if Shift = '1' then
				RegX <= Sumi & RegX(31 downto 1);
				RegY <= RegY(0) & RegY(31 downto 1);
				Ci <= CiPlus;
			end if;
		end if;
	end process;
end Behave;
