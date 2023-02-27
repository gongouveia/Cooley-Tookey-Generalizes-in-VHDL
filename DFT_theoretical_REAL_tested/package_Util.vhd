
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the folllibrary IEEE;
--use ieee.fixed_pkg.all;
use IEEE.MATH_REAL.ALL;

-- Package Declaration Section
package Packages_Util is
 
    CONSTANT  collumn_length : INTEGER :=  4;
    

    
    
	TYPE Complex_Type IS
		RECORD
			--r: sfixed(11 DOWNTO -12);
			--i: sfixed(11 DOWNTO -12);
			
			r: real;
			i: real;
					
			
		END RECORD;
		
		
   
		
    TYPE COLLUMN_VECTOR is array (0 to collumn_length-1) of Complex_Type;

	    
    TYPE COLLUMN_MATRIX IS ARRAY (0 TO collumn_length-1) of COLLUMN_VECTOR;
    
    
 
--   CONSTANT collumn_matrix_values : COLLUMN_MATRIX :=
-- ((("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000")),
--(("000000000000111111111111","000000000000000000000000"),("000000000000000000000000","100000000000111111111111"),("100000000000111111111111","100000000000000000000000"),("100000000000000000000000","000000000000111111111111")),
--(("000000000000111111111111","000000000000000000000000"),("100000000000111111111111","100000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("100000000000111111111111","100000000000000000000000")),
--(("000000000000111111111111","000000000000000000000000"),("100000000000000000000000","000000000000111111111111"),("100000000000111111111111","100000000000000000000000"),("000000000000000000000000","100000000000111111111111"))); 
  
  
 CONSTANT collumn_matrix_values : COLLUMN_MATRIX :=
    (((1.0,0.0),(1.0,0.0),(1.0,0.0) ,(1.0,0.0)),
    ((1.0,0.0),(0.0,-1.0),(-1.0,0.0),(0.0,1.0)),
    ((1.0,0.0),(-1.0,0.0) ,(1.0, 0.0),(-1.0,0.0)),
    ((1.0,0.0),(0.0,1.0) ,(-1.0,0.0),(0.0,-1.0)));
    
    

   -- SOma de numeros complexos
   ------------------------------------------------
	FUNCTION ComplexSum (A, B: Complex_Type) RETURN Complex_Type;
	------------------------------------------------

    -- Multiplciação de numeros complexos
	------------------------------------------------
	FUNCTION ComplexMULT (A, B: Complex_Type) RETURN Complex_Type;
	------------------------------------------------

  	-- Dot product of row vectors
	----------------------------------------------
    FUNCTION dot_product_collumn ( a : COLLUMN_VECTOR; b:COLLUMN_VECTOR ) return Complex_Type;
	----------------------------------------------
	
	
    end package Packages_Util;
       
      -- Package Body Section
     package body Packages_Util is 
           
	
	------------------------------------------------
	FUNCTION ComplexSum (a, b: Complex_Type) RETURN Complex_Type IS
		
		VARIABLE Result : Complex_Type;
		
	BEGIN
	
		--Result.r := resize(a.r + b.r , Result.r);
		--Result.i := resize(a.i + b.i , Result.i);
		
		Result.r := a.r + b.r;
		Result.i := a.i + b.i;
		RETURN Result;
		
	END ComplexSum;
	
	
	
	------------------------------------------------
	

	------------------------------------------------
	FUNCTION ComplexMult(a, b: Complex_Type) RETURN Complex_Type IS
		
		VARIABLE Result: Complex_Type;

	BEGIN
	
        ---Result.r := resize(ValueA.r * ValueB.r  -  ValueA.i * ValueB.i,     23,-24);
        --Result.i := resize(ValueA.r * ValueB.i  +  ValueA.i * ValueB.r,     23,-24);

        Result.r := a.r * b.r - a.i * b.i;
        Result.i := a.r * b.i + a.i * b.r ;
              
		RETURN Result;
	END ComplexMult;
	
	
    ------------------------------------------------
    FUNCTION dot_product_collumn (a : COLLUMN_VECTOR; b:COLLUMN_VECTOR) return Complex_Type is
        VARIABLE i,j : integer:=0;
        VARIABLE prod : COLLUMN_VECTOR := (others => (others => (0.0)));
        VARIABLE sum_of_prod : Complex_Type := (0.0,0.0);
        BEGIN
        
            -- makes the product of the factors
            for i in 0 to collumn_length-1 loop --(number of elements in the first matrix - 1)
                prod(i) :=  ComplexMult(a(i), b(i));
             end loop;
             
             -- sum of products
             for j in 0 to collumn_length-1 loop
                sum_of_prod := complexSUM(sum_of_prod, prod(j));
             end loop;
             
    -- Return the dot product value
    RETURN sum_of_prod;
    END dot_product_collumn;
    
    
END package body Packages_Util;