
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--Section 201 
--Group 11
--Kayshini Shan
--Ayesha Mohammedally
ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   Clk			: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 
   leds			: out std_logic_vector(15 downto 0)
	);
END LogicalStep_Lab4_top;

ARCHITECTURE Circuit OF LogicalStep_Lab4_top IS

component xy_transport port (
			x_target, y_target: in std_logic_vector(3 downto 0);
			motion : in std_logic;
			bitcomp1, bitcomp2, bitcomp3 : in std_logic;
			extender_out : in std_logic;
			clk_en : out std_logic;
			up_down : out std_logic;
			extender_enable : out std_logic;
			error : out std_logic
	);
end component;

component bit4counterx
	port (
			CLK : in std_logic := '0';
			RESET_n : in std_logic := '0';
			CLK_EN : in std_logic := '0';
			UP1_DOWN0 : in std_logic := '0';
			COUNTER_BITS : out std_logic_vector(3 downto 0)
			);
end component;

component Compx4
port (
			INPUT_A, INPUT_B: in std_logic_vector(3 downto 0);
			AGTBx4, AEQBx4, ALTBx4 : out std_logic
		  );
end component;	

component extender
port (
		extender_position : IN std_logic_vector(3 downto 0);
		clk_input   : IN  std_logic;
	    rst_n       : IN  std_logic;
	    ex_toggle   : IN  std_logic; --PB(1)
	    Ex_enable   : IN  std_logic;
		 Clk_en      : OUT std_logic; 
		 Gr_enable    : OUT std_logic;
		 Ex_lr       : OUT std_logic;
		 Ex_out 		 : OUT std_logic
		);
	end component;

component grappler_control
port (
		clk_input   : IN  std_logic;
	    rst_n       : IN  std_logic;
	    toggle_grap : IN  std_logic;
	    en_grap     : IN  std_logic;
	    state_grap  : OUt std_logic
		 );
	end component;	 

component four_bit_shiftregister
port (
		CLK : in std_logic;
		RESET_n : in std_logic;
		CLK_EN : in std_logic;
		LEFT0_RIGHT1 : in std_logic;
		REG_BITS : out std_logic_vector(3 downto 0)
		);
end component;		

signal biggerx,equalx,smallerx : std_logic;
signal biggery, equaly, smallery : std_logic;
signal clk_enx, up_or_downx : std_logic;
signal clk_eny, up_or_downy : std_logic;
signal rac_x, rac_y : std_logic_vector(3 downto 0);
signal x_target, y_target : std_logic_vector(3 downto 0);
signal extend_out : std_logic;
signal extend_enablex, extend_enabley : std_logic;
signal extend_left_right : std_logic;
signal grappler_enable : std_logic;
signal bit_shift_clk : std_logic;
signal ext_pos : std_logic_vector(3 downto 0);

BEGIN
x_target <= sw(7 downto 4);
y_target <= sw(3 downto 0);
leds(15 downto 12) <= rac_x;
leds(11 downto 8) <= rac_y;
leds(7 downto 4) <= ext_pos;

--first instance of xy transport is for movement in x direction ONLY
--takes 2 target coordinate values (x and y)	but ignores y-target coordinate	
--leds0 and leds1	have the same output because they have the same functionality - ERROR indicator		  
inst1: xy_transport port map (
										x_target, y_target,
										pb(2),
										biggerx, equalx, smallerx,
										extend_out,
										clk_enx,
									   up_or_downx,
										extend_enablex,
										leds(0)
									  );
--controls movement of RAC in the x-direction ONLY
--RAC's x-position at any time can be seen as rac_X								  
inst2 : bit4counterx port map (
										 Clk,
										 rst_n,
										 clk_enx,
										 up_or_downx,
										 rac_x
										);
--operates only using target x-coordinate and RAC's current x-position
--if RAC's position is larger or smaller than the target x-coordinate then, this instance sends a signal to enable RAC movement to bit4counter
inst3 : Compx4 port map (
								 rac_x, x_target,
								 biggerx, equalx, smallerx
								);	
--second instance of xy transport is for movement in y direction ONLY
--takes 2 target coordinate values (x and y)	but ignores x-target coordinate	
--leds0 and leds1	have the same output because they have the same functionality - ERROR indicator								
inst4: xy_transport port map (
										x_target, y_target,
										pb(2),
										biggery, equaly, smallery,
										extend_out,
										clk_eny,
									   up_or_downy,
										extend_enabley,
										leds(1) --same as functionality as leds(0)
									  );
--controls movement of RAC in the y-direction ONLY
--RAC's y-position at any time can be seen as rac_y									  
inst5 : bit4counterx port map (
										 Clk,
										 rst_n,
										 clk_eny,
										 up_or_downy,
										 rac_y
										);
--operates only using target y-coordinate and RAC's current y-position
--if RAC's position is larger or smaller than the target y-coordinate then, this instance sends a signal to enable RAC movement to bit4counter
inst6 : Compx4 port map (
								 rac_y, y_target,
								 biggery, equaly, smallery
								);		
--only operates when RAC motion is OFF
--after press AND release, extender goes from 0000 --> 1111 [fully extend]
--grappler movement is enabled ONLY when fully extended
--if pressed and released again, extender will fully retract		
inst7 : extender port map (
									ext_pos,
									Clk,
									rst_n,
									pb(1),
									extend_enablex,
									bit_shift_clk,
									grappler_enable,
									extend_left_right,
									extend_out
									);
--controls movement of extender
--outputs extender's current position which is used to determine whether grappler can be enabled or not
inst8 : four_bit_shiftregister port map (
													  Clk,
													  rst_n,
													  bit_shift_clk,
													  extend_left_right,
													  ext_pos
													  );
--operates only when extender is fully extended
--can change once extender is at "1111" but it cannot move while extender is in motion
inst9 : grappler_control port map (
											  Clk,
											  rst_n,
											  pb(0),
											  grappler_enable,
											  leds(3)
											  );
									
									
										
END Circuit;
