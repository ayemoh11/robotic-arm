library ieee;
	use ieee.std_logic_1164.all;
	use ieee.numeric_std.all;

	Entity extender IS Port
	(
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
	END ENTITY;
	

	

	 Architecture SM of extender is

	 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7);  
	 --s0: idle
	 --s1: extend + 1
	 --s2: extend + 2
	 --s3: extend + 3
	 --s4: idle extended
	 --s5: extend - 3
	 --s6: extend - 2
	 --s7: extend - 1 
	
	 SIGNAL current_state, next_state   :  STATE_NAMES;         
	
	 SIGNAL not_pressed : std_logic;
	

	

	  BEGIN
	
	-- this process synchronizes the activity to a clock
	Register_Section: PROCESS (clk_input, rst_n, next_state, not_pressed)  
	BEGIN
		--reset will bring extender back to fully retracted position
	    IF (rst_n = '0') THEN
	        current_state <= S0;
		 --positive edge triggered
	    ELSIF(rising_edge(clk_input)) THEN
			  --not_pressed is always '0' when toggle is pushed, else '1'
	        IF (ex_toggle = '0') THEN
	            not_pressed <= '1';
	        ELSIF (ex_toggle = '1') THEN
	            not_pressed <= '0';
					--grappler can only be active when extender is fully extended
					IF (extender_position = "1111") THEN
						Gr_enable <= '1';
					ELSE
						Gr_enable <= '0';
					END IF;	
	        END IF;
	        current_state <= next_State;
	    END IF;
	END PROCESS;
	

	Transition_Section: PROCESS (ex_toggle, ex_enable, current_state, not_pressed)
	

	BEGIN
	     CASE current_state IS
	            WHEN s0 =>
						 -- in order to move to next state extender toggle must be pushed
	                IF (ex_toggle = '1' and not_pressed = '0' and ex_enable = '1') THEN 
	                    next_state <= s1;
	                ELSE
	                    next_state <= s0;
	                END IF;
	

	            WHEN s1 =>
	                IF (ex_toggle = '1' and not_pressed = '0' and ex_enable = '1') THEN
	                    next_state <= s2;
	                ELSE
	                    next_state <= s1;
	                END IF;
	

	            WHEN s2 =>
	                IF (ex_toggle = '1' and not_pressed = '0' and ex_enable = '1') THEN
	                    next_state <= s3;
	                ELSE
	                    next_state <= s2;
	                END IF;
	

	            WHEN s3 =>
	                IF (ex_toggle = '0' and not_pressed = '1' and ex_enable = '1') THEN
	                    next_state <= s6;
	                ELSE
	                    next_state <= s4;
	                END IF;
	

	            WHEN s4 =>
	                IF (ex_toggle = '0' and not_pressed = '1' and ex_enable = '1') THEN
	                    next_state <= s5;
	                ELSE
	                    next_state <= s4;
	                END IF;
	

	            WHEN s5 =>
	                IF (ex_toggle = '0' and not_pressed = '1' and ex_enable = '1') THEN
	                    next_state <= s4;
	                ELSE
	                    next_state <= s6;
	                END IF;
	

	            WHEN s6 =>
	                IF (ex_toggle = '0' and not_pressed = '1') THEN
	                    next_state <= s3;
	                ELSE
	                    next_state <= s7;
	                END IF;
	

	            WHEN s7 =>
	                IF (ex_toggle = '0' and not_pressed = '1' and ex_enable = '1') THEN
	                    next_state <= s2;
	                ELSE
	                    next_state <= s0;
	                END IF;
	        END CASE;
	 END PROCESS;
	
	

	Decoder_Section: PROCESS (current_state)
	

	BEGIN
	     CASE current_state IS
					
	            WHEN s0 => 
	                Clk_en  <= '1';
--	                Gr_enable <= '0';
	                ex_lr   <= '0';
						 Ex_out <= '0'; -- when the extender is idle, it is fully retracted
	

	            WHEN s1 =>
	                Clk_en  <= '0';
--	                Gr_enable <= '0';
	                ex_lr   <= '1';
						 Ex_out <= '1';
	

	            WHEN s2 =>
	                Clk_en  <= '0';
--	                Gr_enable <= '0';
	                ex_lr   <= '1';
						 Ex_out <= '1';
	

	            WHEN s3 =>
	                Clk_en  <= '0';
--	                Gr_enable <= '0';
	                ex_lr   <= '1';
						 Ex_out <= '1';
	
	            
	            WHEN s4 =>
	                Clk_en  <= '1';
--	                Gr_enable <= '1'; --grappler can only open/close when extender is fully extended
	                ex_lr   <= '1';
						 Ex_out <= '1';
	

	            WHEN s5 =>
	                Clk_en  <= '0';
--	                Gr_enable <= '0';
	                ex_lr   <= '0';
						 Ex_out <= '1';
	

	            WHEN s6 =>
	                Clk_en  <= '0';
--	                Gr_enable <= '0';
	                ex_lr   <= '0';
						 Ex_out <= '1';
	

	            WHEN s7 =>
	                Clk_en  <= '0';
--	                Gr_enable <= '0';
	                ex_lr  <= '0';
						 Ex_out <= '1';
			END CASE;
	 END PROCESS;
	

	 END ARCHITECTURE SM;
