library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--controls movement of extender
--outputs extender's current position which is used to determine whether grappler can be enabled or not
Entity four_bit_shiftregister is port
(
	CLK : in std_logic;
	RESET_n : in std_logic;
	CLK_EN : in std_logic;
	LEFT0_RIGHT1 : in std_logic;
	REG_BITS : out std_logic_vector(3 downto 0)
);
end Entity;

ARCHITECTURE one OF four_bit_shiftregister IS

Signal sreg : std_logic_vector(3 downto 0);

BEGIN

process (CLK, RESET_n) is
begin
		if (RESET_n = '0') then
			sreg <= "0000";
--if rising edge of the clock signal is met, then extender motion is enabled
		elsif (rising_edge(CLK) AND (CLK_EN = '1')) then
			if (LEFT0_RIGHT1 = '1') then -- true for right shift
				sreg (3 downto 0) <= '1' & sreg(3 downto 1); -- right shift of bits
			elsif (LEFT0_RIGHT1 = '0') then
				sreg (3 downto 0) <= sreg(2 downto 0) & '0'; -- left shift of bits
			end if;
		end if;
	
end process;
--current extender position is outputted to certain leds
--determines whether or not grappler motion can be enabled
REG_BITS <= sreg;

END one;	
