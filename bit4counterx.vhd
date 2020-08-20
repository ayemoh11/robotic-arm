library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
--Section 201 
--Group 11
--Kayshini Shan
--Ayesha Mohammedally

--controls movement of RAC in x and y directions
--RAC's position at any time is outputted to certain leds
Entity bit4counterx is port
(
	CLK : in std_logic := '0';
	RESET_n : in std_logic := '0';
	CLK_EN : in std_logic := '0';
	UP1_DOWN0 : in std_logic := '0';
	COUNTER_BITS : out std_logic_vector(3 downto 0)
);
end Entity;

ARCHITECTURE one OF bit4counterx IS

Signal bit_counter : UNSIGNED(3 downto 0);

BEGIN

process (CLK, RESET_n) is
begin
		if (RESET_n = '0') then
			bit_counter <= "0000";
			
		elsif (rising_edge(CLK)) then
--if rising edge of the clock signal is met then movement of RAC is enabled		
			if ((UP1_DOWN0 = '1') AND (CLK_EN = '1')) then
				bit_counter <= (bit_counter + 1);
				
			elsif ((UP1_DOWN0 = '0') AND (CLK_EN = '1')) then
				bit_counter <= (bit_counter - 1);
				
			end if;
			
		end if;
	
end process;

COUNTER_BITS <= std_logic_vector(bit_counter);

END one;	