--------------------------------------------------------------------------------
-- Company		: The Citadel
-- Engineer		: Thomas Bassett 
-- Revised		: 2026-02-08
-- Adder16		: 16-bit Ripple Carry Adder
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder16 is
  port(A, B: in std_logic_vector(15 downto 0);  -- multi bit inputs
       Ci: in std_logic;  						-- single bit inputs
       S: out std_logic_vector(15 downto 0);    -- multi bit outputs
	   Co: out std_logic);  					-- single bit outputs
end Adder16;

architecture Structure of Adder16 is
  component Adder4    							-- component definition
    port(A, B: in std_logic_vector(3 downto 0); -- multi bit inputs
	     C0: in std_logic;  					-- single bit inputs
         S: out std_logic_vector(3 downto 0);   -- multi bit outputs
		 C4: out std_logic);  					-- single bit outputs
  end component;
  signal C12, C8, C_4: std_logic;               -- internal signals
begin     
  ADD0: Adder4 port map(A(3 downto 0), B(3 downto 0), Ci, S(3 downto 0), C_4);
  ADD1: Adder4 port map(A(7 downto 4), B(7 downto 4), C_4, S(7 downto 4), C8);
  ADD2: Adder4 port map(A(11 downto 8), B(11 downto 8), C8, S(11 downto 8), C12);
  ADD3: Adder4 port map(A(15 downto 12), B(15 downto 12), C12, S(15 downto 12), Co);
end Structure;

--------------------------------------------------------------------------------
-- Adder4 component entity & Structural architecture
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder4 is
  port(A, B: in std_logic_vector(3 downto 0);   -- multi bit inputs
       C0: in std_logic;  						-- single bit inputs
       S: out std_logic_vector(3 downto 0);		-- multi bit outputs
	   C4: out std_logic);  					-- multi bit outputs
end Adder4;

architecture Structure of Adder4 is
  component Full_Adder
    port(X, Y, Cin: in std_logic;         		-- single bit inputs
         Cout, Sum: out std_logic);       		-- single bit outputs
  end component;
  signal C: std_logic_vector(3 downto 1); 		-- C is an internal signal
begin     										-- instantiate four copies of the Full_Adder
  FA0: Full_Adder port map(A(0), B(0), C0, C(1), S(0));
  FA1: Full_Adder port map(A(1), B(1), C(1), C(2), S(1));
  FA2: Full_Adder port map(A(2), B(2), C(2), C(3), S(2));
  FA3: Full_Adder port map(A(3), B(3), C(3), C4, S(3));
end Structure;

--------------------------------------------------------------------------------
-- Full_Adder component entity & Dataflow architecture
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Full_Adder is
  port(X, Y, Cin: in std_logic;     			-- single bit inputs
       Cout, Sum: out std_logic);   			-- single bit outputs
end Full_Adder;

architecture Dataflow of Full_Adder is
begin											-- concurrent assignment statements
  Sum  <= X xor Y xor Cin after 2 ns; 
  Cout <= (X and Y) or (X and Cin) or (Y and Cin) after 2 ns;
end Dataflow;
