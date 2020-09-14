--In this VHDL file, a 1-bit full adder is built structurally whilst using the 
--delayed gates implemented previously and subsequently a Ripple Carry Adder 
--is built from the implemented 1-bit full adder. 


--1-BIT FULL ADDER
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY fullAdder IS
	PORT ( a, b, carryIn: IN STD_LOGIC;
		   carryOut, sum: OUT STD_LOGIC);
END;

ARCHITECTURE structural OF fullAdder IS	
SIGNAL wire1, wire2, wire3: STD_LOGIC;
BEGIN
	OUTPUT_SUM:   ENTITY work.xor3(delayed)
				  PORT MAP(a, b, carryIn, sum); 
	AND_GATE1:    ENTITY work.and2(delayed)
				  PORT MAP(a, b, wire1); 	
	AND_GATE2:    ENTITY work.and2(delayed)
				  PORT MAP(a, carryIn, wire2); 
	AND_GATE3:    ENTITY work.and2(delayed)
				  PORT MAP(b, carryIn, wire3);   
	OUTPUT_CARRY: ENTITY work.or3(delayed)
				  PORT MAP(wire1, wire2, wire3, carryOut);	   
END ARCHITECTURE structural;   

--RIPPLE CARRY ADDER 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 

ENTITY rippleCarryAdder IS
	PORT (     x, y: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			carryIn: IN STD_LOGIC;
			    sum: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		   carryOut: OUT STD_LOGIC); 
END;

ARCHITECTURE structural OF rippleCarryAdder IS
SIGNAL localCarry: STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN 
	localCarry(0) <= carryIn;
	carryOut <= localCarry(4);
	
	QUADRUPLE_ADDER_LOOP: FOR i IN 0 TO 3 GENERATE
		FULL_ADDER: ENTITY work.fullAdder(structural)
					PORT MAP( x(i), y(i), localCarry(i), localCarry(i+1), sum(i));
			
	END GENERATE QUADRUPLE_ADDER_LOOP;
END ARCHITECTURE structural;



