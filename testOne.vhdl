--*********************************************************************************	  
--First, we will create a generator that generates values to verify the correctness of the arithmetic unit
 LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 USE IEEE.STD_LOGIC_ARITH.ALL; 	
 USE IEEE.STD_LOGIC_SIGNED.ALL;
 
 ENTITY inputGenerator IS
 	PORT ( clock: IN STD_LOGIC;
 		  firstInput: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
 		  secondInput: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  selectInput: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
 		  expectedResult: OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
 END ENTITY inputGenerator;	 
 
 ARCHITECTURE test OF inputGenerator IS	 
 BEGIN
 	PROCESS
	BEGIN

		 FOR I IN 0 TO 15 LOOP
 		 	FOR J IN 0 TO 15 LOOP
				  FOR K IN 0 TO 7 LOOP
 				-- Here the inputs are generated
 					firstInput <= CONV_STD_LOGIC_VECTOR(i,4);
			   	    secondInput <= CONV_STD_LOGIC_VECTOR(j,4);
					selectInput <= CONV_STD_LOGIC_VECTOR(k,3); 	
 				-- Calculate what the output of the adder should be	 
				 	 IF    ( k = 0 ) THEN
					 	expectedResult <= CONV_STD_LOGIC_VECTOR(i + j, 5) AFTER 40 NS;
					 ELSIF ( k = 1 ) THEN 
					 	expectedResult <= CONV_STD_LOGIC_VECTOR(i + j + 1, 5) AFTER 40 NS; 
					 ELSIF ( k = 2 ) THEN 
					 	expectedResult <= CONV_STD_LOGIC_VECTOR(i - j - 1 , 5) AFTER 40 NS; 
					 ELSIF ( k = 3 ) THEN 
					 	expectedResult <= CONV_STD_LOGIC_VECTOR(i - j , 5) AFTER 40 NS; 
					 ELSIF ( k = 4 ) THEN 
					 	expectedResult <= CONV_STD_LOGIC_VECTOR(i, 5) AFTER 40 NS; 
					 ELSIF ( k = 5 ) THEN 
					 	expectedResult <= CONV_STD_LOGIC_VECTOR(i + 1, 5) AFTER 40 NS; 
					 ELSIF ( k = 6 ) THEN 
					 	expectedResult <= CONV_STD_LOGIC_VECTOR(i - 1, 5) AFTER 40 NS; 
					 ELSIF ( k = 7 ) THEN 
					    expectedResult <= CONV_STD_LOGIC_VECTOR(i , 5) AFTER 40 NS;
					
					 END IF;

 				    WAIT until rising_edge(clock);
 				   END LOOP;
           END LOOP;
        END LOOP;
 		WAIT;
 	END PROCESS;
 END ARCHITECTURE test;
 
 
 LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 
 ENTITY resultAnalyzer IS
 	PORT ( clock: IN STD_LOGIC;
    	   firstInput: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 		   secondInput: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 		   expectedResult: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
 		   actualSum: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 		   actualCarry: IN STD_LOGIC);
 END ENTITY resultAnalyzer;	 
 
 ARCHITECTURE test OF resultAnalyzer IS
 BEGIN
 	PROCESS(clock)
 	BEGIN
 		IF rising_edge(clock) THEN
 			-- Check whether adder output matches expectation
 			ASSERT expectedResult(3 DOWNTO 0) = actualSum
 			AND expectedResult(4) = actualCarry
 			REPORT "BE CAREFUL, ACTUAL CARRY AND SUM DON'T MATCH THE EXPECTED ONES!"
 			SEVERITY WARNING;
 		END IF;
 	END PROCESS;
 END ARCHITECTURE test;	 
 --Since all of the components have been created for the test verification, they will all be instanstiated below! 
	 
 LIBRARY IEEE;
 USE IEEE.STD_LOGIC_1164.ALL;
 
 ENTITY finalTestOne IS
 END ENTITY; 
 
 ARCHITECTURE testCarryRippleAdder OF finalTestOne IS
 SIGNAL clock: std_logic:='0';	
 
 --First we declare the signals which are to be used in the instantiation
 SIGNAL firstInput: STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL secondInput: STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL selectInput: STD_LOGIC_VECTOR(2 DOWNTO 0);
 SIGNAL actualSum: STD_LOGIC_VECTOR(3 DOWNTO 0);
 SIGNAL actualCarry: STD_LOGIC;	
 SIGNAL expectedResult: STD_LOGIC_VECTOR(4 DOWNTO 0);
 	BEGIN
 	clock <= NOT clock AFTER 10 NS;
 	-- Place one instance of test generation unit
 	TEST_GENERATOR:  ENTITY work.inputGenerator(test)
 					 PORT MAP ( clock, firstInput, secondInput, selectInput,expectedResult);
 	-- Place one instance of the Unit Under Test
 	UNIT_UNDER_TEST: ENTITY work.arithmeticUnitOne(structural)
 					 PORT MAP ( firstInput, secondInput, selectInput(1), selectInput(2),selectInput(0), actualCarry, actualSum);
                   
    -- Place one instance of the result analyzer
 	RESULT_ANALYZER: ENTITY work.resultAnalyzer(test)
 					 PORT MAP (clock, firstInput, secondInput,expectedResult, actualSum, actualCarry);
 END ARCHITECTURE testCarryRippleAdder;
	 