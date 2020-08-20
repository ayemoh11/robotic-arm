library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity Bidir_shift_reg is port
(
	CLK : in std_logic := '0';
	RESET_n : in std_logic := '0';
	CLK_EN : in std_logic := '0';
	LEFT0_RIGHT1 : in std_logic := '0';
	REG_BITS : out std_logic_vector(3 downto 0);
	OUT_BITS : out std_logic_vector(3 downto 0)
);
end Entity;

ARCHITECTURE one OF Bidir_shift_reg IS

Signal sreg : std_logic_vector(3 downto 0);

BEGIN

process (CLK, RESET_n) is
begin
		if (RESET_n = '0') then
			sreg <= "0000";
		elsif (rising_edge(CLK) AND (CLK_EN = '1')) then
			if (LEFT0_RIGHT1 = '1') then -- true for right shift
				sreg (3 downto 0) <= '1' & sreg(3 downto 1); -- right shift of bits
			elsif (LEFT0_RIGHT1 = '0') then
				sreg (3 downto 0) <= sreg(2 downto 0) & '0'; -- left shift of bits
			end if;
		end if;
	
end process;
REG_BITS <= sreg;
OUT_BITS <= sreg;

END one;	