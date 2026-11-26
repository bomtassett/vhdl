library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FP_Mult32 is
	port(St, CLK : in std_logic;			   --inputs
		 N1, N2 : in std_logic_vector(31 downto 0); --mcand, mplier
		 Done, V : out std_logic;		          --outputs
		 Nout : out std_logic_vector(31 downto 0)); --product
end FP_Mult32;

architecture Behave of FP_Mult32 is
signal RSF, Set0 : std_logic; --control signals
alias E1 : std_logic_vector(7 downto 0) is N1(30 downto 23); --mcand exponent
alias F1 : std_logic_vector(22 downto 0) is N1(22 downto 0); --mcand fraction
alias E2 : std_logic_vector(7 downto 0) is N2(30 downto 23); --mplier exponent
alias F2 : std_logic_vector(22 downto 0) is N2(22 downto 0); --mplier exponent
signal addout : std_logic_vector(8 downto 0);   --exponent adder
signal multout : std_logic_vector(47 downto 0); --fraction multiplier
signal Sout : std_logic;                        --product sign bit register
signal PS, NS : integer range 0 to 2;           --sm signals

begin
    Sout <= N1(31) xor N2(31);
    addout <= ('0' & E1) + ('0' & E2) - 127;
    multout <= ('1' & F1) * ('1' & F2);
  
    ctrl_main : process(PS, St, addout, multout)--control unit process
    begin
        RSF <= '0'; Set0 <= '0'; Done <= '0'; V <= '0'; NS <= 0;
        case PS is
            when 0 =>
                if St = '1' then NS <= 1;
			end if;
            when 1 =>
                if E1 & F1 = x"00000000" or E2 & F2 = x"00000000" then
                	Set0 <= '1'; Nout <= x"00000000"; --FZ
                elsif multout(47) = '1' then
                	RSF <= '1'; --FV
                	Nout <= Sout & (addout(7 downto 0) + 1) & multout(46 downto 24);
                else Nout <= Sout & addout(7 downto 0) & multout(45 downto 23);
                end if;
                Done <= '1';
                NS <= 2;
            when 2 =>
                if addout(8) = '1' then V <= '1'; --EV
				end if;
         end case;
    end process ctrl_main;
    ctrl_regs : process(CLK) --control register process
    begin
        if rising_edge(CLK) then PS <= NS; end if;
    end process ctrl_regs; 
end Behave;
