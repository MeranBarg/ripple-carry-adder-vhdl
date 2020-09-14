--In this VHDL file, a structural 4x1 MUX is built whilst using the delayed gates implemented earlier.	

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY mux4x1 IS
	PORT ( a, b, c, d: IN STD_LOGIC;
		   SEL0, SEL1: IN STD_LOGIC;
					y: OUT STD_LOGIC); 
END;

ARCHITECTURE structural OF mux4x1 IS
SIGNAL NOTSEL0, NOTSEL1: STD_LOGIC;
SIGNAL wire1, wire2, wire3, wire4: STD_LOGIC;
BEGIN 
	INVERT_SEL0:     ENTITY work.not1(delayed)
				     PORT MAP (SEL0, NOTSEL0);
	INVERT_SEL1:     ENTITY work.not1(delayed)
				     PORT MAP (SEL1, NOTSEL1);
	NAND_GATE1:  	 ENTITY work.nand3(delayed)	
					 PORT MAP(a,NOTSEL1, NOTSEL0, wire1);
	NAND_GATE2: 	 ENTITY work.nand3(delayed)
					 PORT MAP(b, NOTSEL1, SEL0, wire2);
	NAND_GATE3:  	 ENTITY work.nand3(delayed)
					 PORT MAP(c, SEL1, NOTSEL0, wire3);
	NAND_GATE4:		 ENTITY work.nand3(delayed)
					 PORT MAP(d, SEL1, SEL0, wire4);
		
	NAND_GATE_FINAL: ENTITY work.nand4(delayed)
					 PORT MAP(wire1, wire2, wire3, wire4, y);
END ARCHITECTURE structural;
