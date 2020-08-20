LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY work;
--Section 201 
--Group 11
--Kayshini Shan
--Ayesha Mohammedally
ENTITY Compx1 IS
	PORT (
			INPUT_A,INPUT_B:IN STD_LOGIC;
			AGTBx1, AEQBx1, ALTBx1:OUT STD_LOGIC
		  );
END Compx1;

ARCHITECTURE magnitude_comp OF Compx1 IS
BEGIN
--writing SOP expressions from the single-bit comparator truth table:
--A>B = AB'
--A=B = A'B' + AB
--A<B = A'B 
AGTBx1 <= INPUT_A AND (NOT INPUT_B);
AEQBx1 <= ((NOT INPUT_A) AND (NOT INPUT_B)) OR (INPUT_A AND INPUT_B);
ALTBx1 <= (NOT INPUT_A) AND INPUT_B;

END magnitude_comp;