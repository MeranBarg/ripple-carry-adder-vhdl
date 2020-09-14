 -- In this VHDL file, the carry look-ahead adder is implemented from 1-bit fulladders
 LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 
 ENTITY fullAdderCLA IS
	 PORT( a, b, carryIn: IN STD_LOGIC;
		   sum, generateOut, propagateOut: OUT STD_LOGIC);   
 END;
 
 ARCHITECTURE structural OF fullAdderCLA IS
 BEGIN
	 --Here, the sum, the genrate and the propagate outputs are each assigned an equation structurally
GENERATE_OUT:  ENTITY work.and2(delayed)
			   PORT MAP( a, b, generateOut);
PROPAGATE_OUT: ENTITY work.xor2(delayed)
			   PORT MAP( a, b, propagateOut);   
SUM_OUT: 	   ENTITY work.xor3(delayed)
			   PORT MAP( a, b, carryIn, sum);
END ARCHITECTURE structural; 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY carryLookAheadAdder IS
	PORT(a, b: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 carryIn: IN STD_LOGIC;
	 	 carryOut: OUT STD_LOGIC;
		 sumOut: OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END;  

ARCHITECTURE structural OF carryLookAheadAdder IS
SIGNAL carry1, carry2, carry3: STD_LOGIC;
SIGNAL generateOut, propagateOut: STD_LOGIC_VECTOR(3 DOWNTO 0);	 
SIGNAL output: STD_LOGIC_VECTOR(9 DOWNTO 0); --used as a buffer

BEGIN
	--Here, the fullAdderCLA will be called four times
	FIRST_CLA:  ENTITY work.fullAdderCLA(structural)
			    PORT MAP( a(0), b(0), carryIn, sumOut(0), generateOut(0), propagateOut(0)); 
	SECOND_CLA: ENTITY work.fullAdderCLA(structural)
			    PORT MAP( a(1), b(1), carry1,  sumOut(1), generateOut(1), propagateOut(1));
	THIRD_CLA:  ENTITY work.fullAdderCLA(structural)
			    PORT MAP( a(2), b(2), carry2, sumOut(2), generateOut(2), propagateOut(2));
    FOURTH_CLA: ENTITY work.fullAdderCLA(structural)
				PORT MAP( a(3), b(3), carry3, sumOut(3), generateOut(3), propagateOut(3));  
		
--Now, since carry1, carry2 and carry3 are found recursively, their respective 
--equations are defined below while also defining the equation for carryOut
	--First carry
	FIRST_CARRY1:  ENTITY work.and2(delayed)
				   PORT MAP( propagateOut(0), carryIn, output(0));
	FIRST_CARRY2:  ENTITY work.or2(delayed)
				   PORT MAP( generateOut(0), output(0), carry1);	
	SECOND_CARRY1: ENTITY work.and2(delayed)
				   PORT MAP( propagateOut(1), output(0), output(1));
	SECOND_CARRY2: ENTITY work.and2(delayed)
		           PORT MAP( propagateOut(1), generateOut(0), output(2));
	SECOND_CARRY3: ENTITY work.or3(delayed)
				   PORT MAP( generateOut(1), output(1), output(2), carry2); 	 
	THIRD_CARRY1:  ENTITY work.and2(delayed) 
				   PORT MAP( propagateOut(2), output(1), output(3));  
	THIRD_CARRY2:  ENTITY work.and2(delayed) 
				   PORT MAP( propagateOut(2), output(2), output(4));
	THIRD_CARRY3:  ENTITY work.and2(delayed) 
				   PORT MAP( propagateOut(2), generateOut(1), output(5));
	THIRD_CARRY4:  ENTITY work.or4(delayed) 
			       PORT MAP( generateOut(2), output(3), output(4), output(5), carry3);	
	CARRY_OUT1:    ENTITY work.and2(delayed) 
			       PORT MAP( propagateOut(3), output(3), output(6)); 
	CARRY_OUT2:    ENTITY work.and2(delayed) 
			       PORT MAP( propagateOut(3), output(4), output(7)); 
	CARRY_OUT3:    ENTITY work.and2(delayed) 
			       PORT MAP( propagateOut(3), output(5), output(8)); 
	CARRY_OUT4:    ENTITY work.and2(delayed) 
			       PORT MAP( propagateOut(3), generateOut(2), output(9));
	CARRY_OUT5:    ENTITY work.or5(delayed)
				   PORT MAP( generateOut(3), output(6), output(7), output(8), output(9), carryOut);
END ARCHITECTURE structural;











		
	
	