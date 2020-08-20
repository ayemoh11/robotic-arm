library ieee;
use ieee.std_logic_1164.all;
library work;
--Section 201 
--Group 11
--Kayshini Shan
--Ayesha Mohammedally
entity Compx4 is port (
			INPUT_A, INPUT_B: in std_logic_vector(3 downto 0);
			AGTBx4, AEQBx4, ALTBx4 : out std_logic
		  );
end Compx4;

architecture magnitude_comp of Compx4 is

component Compx1
 	port (
			INPUT_A,INPUT_B:in std_logic;
			AGTBx1, AEQBx1, ALTBx1:out std_logic
			);
end component;


signal GT3,EQ3,LT3,GT2,EQ2,LT2,GT1,EQ1,LT1,GT0,EQ0,LT0  : std_logic;

begin
--4 instances of Compx1 created to compare 4 pairs of bits
--each instance has 3 1-bit outputs which are either 100, 010, or 001
inst1: Compx1 port map (
								INPUT_A(3), INPUT_B(3),
								GT3,EQ3,LT3
							  );
							  
inst2: Compx1 port map (
								INPUT_A(2), INPUT_B(2),
								GT2,EQ2,LT2
							  );
							  
inst3: Compx1 port map (
								INPUT_A(1), INPUT_B(1),
								GT1,EQ1,LT1
							  );
							  
inst4: Compx1 port map (
								INPUT_A(0), INPUT_B(0),
								GT0,EQ0,LT0
);
--writing SOP expressions from 4-bit magnitude comparator truth table
--to make use of ALL outputs [GT3 - LT0], added the product of all output values that evaluated to	0 since 0 AND 0 = 0 and x OR 0 = 0
--by doing this, final value of AGTBx4/AEQBx4/ALTBx4 is unchanged							
AGTBx4 <= (GT3 OR (EQ3 AND GT2) OR (EQ3 AND EQ2 AND GT1) OR (EQ3 AND EQ2 AND EQ1 AND GT0)) OR (LT3 AND LT2 AND LT1 AND EQ0 AND LT0);
AEQBx4 <= ((EQ3 AND EQ2 AND EQ1 AND EQ0)) OR (GT3 AND LT3 AND GT2 AND LT2 AND GT1 AND LT1 AND GT0 AND LT0);
ALTBx4 <= (LT3 OR (EQ3 AND LT2) OR (EQ3 AND EQ2 AND LT1) OR (EQ3 AND EQ2 AND EQ1 AND LT0)) OR (GT3 AND GT2 AND GT1 AND GT0 AND EQ0);						  
	

end magnitude_comp;