--------------------------------------------------------------------------------
-- Company		: The Citadel
-- Engineer		: Thomas Bassett
-- Revised		: 2026-02-08
-- Adder16_CLA  : 16-bit Carry Look-Ahead Adder
-- Notes		: **DRAFT** - REVIEW PRIOR TO USE
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder16_CLA is
	port(A, B: in std_logic_vector(15 downto 0);
		 C0: in std_logic;
		 S: out std_logic_vector(15 downto 0);
		 C16, PG, GG: out std_logic);
end Adder16_CLA;

architecture Structure of Adder16_CLA is
component Adder4_CLA
	port(A, B: in std_logic_vector(3 downto 0);
	     C0: in std_logic;
         S: out std_logic_vector(3 downto 0);
         C4, PG, GG: out std_logic);
end component;
component CLA_Logic is
	port(G, P: in std_logic_vector(3 downto 0);
         C0: in std_logic;
         C: out std_logic_vector(3 downto 1);
         C4, PG, GG: out std_logic);
end component;
signal G, P: std_logic_vector(3 downto 0);
signal C: std_logic_vector(3 downto 1);
begin
	Carry_Logic: CLA_Logic port map(G, P, C0, C, C16, PG, GG);
	ADD0:Adder4_CLA port map(A(3 downto 0), B(3 downto 0), C0, S(3 downto 0), open, P(0), G(0));
	ADD1:Adder4_CLA port map(A(7 downto 4), B(7 downto 4), C(1), S(7 downto 4), open, P(1), G(1));
	ADD2:Adder4_CLA port map(A(11 downto 8), B(11 downto 8), C(2), S(11 downto 8), open, P(2), G(2));
	ADD3:Adder4_CLA port map(A(15 downto 12), B(15 downto 12), C(3), S(15 downto 12), open, P(3), G(3));
end Structure;

--------------------------------------------------------------------------------
-- Adder4_CLA component entity & Dataflow architecture
--------------------------------------------------------------------------------
entity Adder4_CLA
	port(A, B: in std_logic_vector(3 downto 0);
	     C0: in std_logic;
         S: out std_logic_vector(3 downto 0);
         C4, PG, GG: out std_logic);
end Adder4_CLA;

architecture Dataflow of Adder4_CLA is

begin
	-- FILL
end Dataflow;

--------------------------------------------------------------------------------
-- CLA_Logic component entity & Dataflow architecture
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity CLA_Logic is
	port(G, P: in std_logic_vector(3 downto 0);
         C0: in std_logic;
         C: out std_logic_vector(3 downto 1);
         C4, PG, GG: out std_logic);
end CLA_Logic;

architecture Dataflow of CLA_Logic is

begin
	-- FILL
end Dataflow;

