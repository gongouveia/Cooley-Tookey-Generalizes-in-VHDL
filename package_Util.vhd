----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2023 02:33:09 PM
-- Design Name: 
-- Module Name: package_Util - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
-- Uncomment the folllibrary IEEE;

-- Package Declaration Section
package Packages_Util is
 
    CONSTANT  collumn_length : INTEGER :=  4;
    

    
    
	TYPE Complex_Type IS
		RECORD
			--r: sfixed(11 DOWNTO -12);
			--i: sfixed(11 DOWNTO -12);
			
			r: signed(23 DOWNTO 0);
			i: signed(23 DOWNTO 0);
					
			
		END RECORD;
		
		
   
    TYPE COLLUMN_VECTOR is array (0 to collumn_length-1) of complex_type;
    TYPE COLLUMN_VECTOR_OUTPUT is array (0 to collumn_length-1) of complex_type;



	    
    TYPE COLLUMN_MATRIX IS ARRAY (0 TO collumn_length-1) of COLLUMN_VECTOR;
    
    

 -- [(1+0j), (1+0j),                   (1+0j),                        (1+0j),
 -- (1+0j), (6.123233995736766e-17-1j), (-1-1.2246467991473532e-16j), (-1.8369701987210297e-16+1j),
 -- (1+0j), (-1-1.2246467991473532e-16j), (1+2.4492935982947064e-16j), (-1-3.6739403974420594e-16j), 
 -- (1+0j), (-1.8369701987210297e-16+1j), (-1-3.6739403974420594e-16j), (5.51091059616309e-16-1j)]

 
   CONSTANT collumn_matrix_values : COLLUMN_MATRIX :=
 (((x"001000",x"000000"),(x"001000",x"000000"),(x"001000",x"000000"),(x"001000",x"000000")),
((x"001000",x"000000"),(x"000000",x"fff000"),(x"fff000",x"000000"),(x"000000",x"001000")),
((x"001000",x"000000"),(x"fff000",x"000000"),(x"001000",x"000000"),(x"fff000",x"000000")),
((x"001000",x"000000"),(x"000000",x"001000"),(x"fff000",x"000000"),(x"000000",x"fff000"))); 
  

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
		VARIABLE first_factor_real : signed(47 downto 0);
		VARIABLE second_factor_real: signed(47 downto 0);
		VARIABLE first_factor_imag : signed(47 downto 0);
		VARIABLE second_factor_imag: signed(47 downto 0);

	BEGIN
	
        ---Result.r := resize(ValueA.r * ValueB.r  -  ValueA.i * ValueB.i,     23,-24);
        --Result.i := resize(ValueA.r * ValueB.i  +  ValueA.i * ValueB.r,     23,-24);
        first_factor_real := a.r * b.r/4096;
        second_factor_real :=  a.i * b.i/4096;
        first_factor_imag  := a.r * b.i/4096;
        second_factor_imag := a.i * b.r/4096;
        
        
        Result.r := (first_factor_real(23 DOWNTO 0) + second_factor_real(23 DOWNTO 0));
        
        Result.i := first_factor_imag(23 DOWNTO 0) + second_factor_imag(23 DOWNTO 0);
              
		RETURN Result;
	END ComplexMult;
	
	
    ------------------------------------------------
    FUNCTION dot_product_collumn (a : COLLUMN_VECTOR; b:COLLUMN_VECTOR) return Complex_Type is
        VARIABLE i,j : integer:=0;
        VARIABLE prod : COLLUMN_VECTOR_OUTPUT := (others => (others => ("000000000000000000000000")));
        VARIABLE sum_of_prod : Complex_Type :=                  ("000000000000000000000000","000000000000000000000000");
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