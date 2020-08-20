
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--Section 201 
--Group 11
--Kayshini Shan
--Ayesha Mohammedally
Entity grappler_control IS Port
	(
	    clk_input   : IN  std_logic;
	    rst_n       : IN  std_logic;
	    toggle_grap : IN  std_logic; --pb0
	    en_grap     : IN  std_logic;
	    state_grap  : OUt std_logic
	 );
	END ENTITY;
	

	

	 Architecture SM of grappler_control is

	 TYPE STATE_NAMES IS (S0, S1, idle);  -- s(0) = idle, s(1) = closed 

	 SIGNAL not_pressed : std_logic;
	
	 SIGNAL current_state, next_state   :  STATE_NAMES;         
	

	

	  BEGIN
	-- this process synchronizes activity to the clock
	Register_Section: PROCESS (clk_input, rst_n, next_state, not_pressed)  
	BEGIN
	    IF (rst_n = '0') THEN
	        current_state <= S0;
	    ELSIF(rising_edge(clk_input)) THEN
	        IF (toggle_grap = '0') THEN
	            not_pressed <= '1';
	        ELSIF (toggle_grap = '1') THEN
	            not_pressed <= '0';
	        END IF;
	        current_state <= next_State;
	    END IF;
	END PROCESS;
	
	

	Transition_Section: PROCESS (en_grap, current_state, not_pressed)
	

	BEGIN
	        CASE current_state IS
	            WHEN s0 =>
	                IF (toggle_grap = '1' and en_grap = '1') THEN
	                    next_state <= s1;
	                ELSE
	                    next_state <= s0;
	                END IF;
	            WHEN S1 =>
	                IF (toggle_grap = '1' and en_grap = '1') THEN
	                    next_state <= s0;
	                ELSE
	                    next_state <= s1;
	                END IF;
					WHEN IDLE =>
							  next_state <= idle;
	        END CASE;
	 END PROCESS;
	
	

	Decoder_Section: PROCESS (current_state)
	

	BEGIN
	        CASE current_state IS
	            WHEN s0 =>
	                state_grap <= '0';
	            WHEN s1 =>
	                state_grap <= '1';
					WHEN idle =>
						  state_grap <= '0';
	        END CASE;
	 END PROCESS;
	

	 END ARCHITECTURE SM;
