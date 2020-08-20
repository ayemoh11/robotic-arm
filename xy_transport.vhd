library ieee;
use ieee.std_logic_1164.all;
library work;

--Section 201 
--Group 11
--Kayshini Shan
--Ayesha Mohammedally

--takes 2 inputs: 4-bit x and y coordinates
--movement is enabled only when RAC motion is ON
--type of movement(up or down) is indicated by output of the 4-bit comparator
--extender is enabled only when motion is OFF
--error is indicated if and when RAC attempts to move while extender is OUT

entity xy_transport is port (
			x_target, y_target: in std_logic_vector(3 downto 0);
			motion : in std_logic;
			bitcomp1, bitcomp2, bitcomp3 : in std_logic;
			extender_out : in std_logic;
			clk_en : out std_logic;
			up_down : out std_logic;
			extender_enable : out std_logic;
			error : out std_logic
		  );
end xy_transport;

architecture two of xy_transport is

begin

process(bitcomp1, bitcomp2, bitcomp3) is
begin
--bitcomp1 = GT
--bitcomp2 = EQ
--bitcomp3 = LT

--if extender is in retracted position and RAC motion is ON, then RAC motion is enabled
--type of movement depends on how the current RAC position compares to the target coordinate
if ((motion = '1') AND (extender_out = '0')) then
	extender_enable <= '0';
	error <= '0';
	if ((bitcomp1 = '1') OR (bitcomp3 = '1')) then
		clk_en <= '1';
		if (bitcomp1 = '1') then
			up_down <= '0';
			clk_en <= '1';
		elsif (bitcomp3 = '1') then
			up_down <= '1';
			clk_en <= '1';
		end if;	
	elsif(bitcomp2 = '1') then
		clk_en <= '0';
	end if;
end if;
--	if RAC motion is ON when extender is not in retracted position, then an error is in indicated
if ((motion = '1') AND (extender_out = '1')) then
	error <= '1';
end if;	
--if RAC motion is OFF then extender motion is enabled
if (motion = '0') then
	error <= '0';
	extender_enable <= '1';
	clk_en <= '0';
end if;	
end process;	

end two;