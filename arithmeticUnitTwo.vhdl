--In this VHDL file, the arithmetic unit of the project is built structurally from all of the previously built elements

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY arithmeticUnitTwo IS
	PORT (   a, b: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 SEL0, SEL1: IN STD_LOGIC;
	         carryIn: IN STD_LOGIC;
	         carryOut: OUT STD_LOGIC;
			 d: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END;

ARCHITECTURE structural OF arithmeticUnitTwo IS 
SIGNAL muxOut: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bPrime: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
	COMPLEMENT_OF_B: FOR i IN 0 TO 3 GENERATE
		B_NOT: ENTITY work.not1(delayed) 		    
			PORT MAP ( b(i), bPrime(i));
	END GENERATE COMPLEMENT_OF_B;
		   
	QUADRUPLE_MUX_LOOP: FOR i IN 0 TO 3 GENERATE
				   MUX: ENTITY work.mux4x1(structural)
					    PORT MAP (b(i), bPrime(i), '0', '1', SEL0, SEL1, muxOut(i));	  
	END GENERATE QUADRUPLE_MUX_LOOP;
	
	CARRY_LOOK_AHEAD_ADDER: ENTITY work.carryLookAheadAdder(structural)
						PORT MAP (a, muxOut, carryIn, carryOut,d);    
END ARCHITECTURE structural;   	  





	