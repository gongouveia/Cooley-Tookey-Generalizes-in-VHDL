library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned


-- Package Declaration Section
package Packages_Util is
    
    
    CONSTANT  number_of_bits : integer := 24;

    CONSTANT  row_length :     INTEGER :=  3;
    CONSTANT  collumn_length : INTEGER :=  4;
    --clk generation.For 100 MHz clock this generates 1 Hz clock.
    CONSTANT acquisition_clock_counter : INTEGER := 50000000;
    CONSTANT output_clock_counter      : INTEGER := 50000000;
 
	TYPE Complex_Type IS
		RECORD
			r: signed(23 DOWNTO 0);
			i: signed(23 DOWNTO 0);
		END RECORD;
		
    TYPE VECTOR_COLLUMN IS ARRAY (0 to collumn_length-1) OF Complex_Type; 
    TYPE VECTOR_ROW     IS ARRAY (0 to row_length-1)     OF Complex_Type; 
    
    TYPE MATRIX         IS ARRAY (0 TO row_length-1, 0   TO collumn_length-1) OF Complex_Type;
    TYPE ROW_MATRIX     IS ARRAY (0 TO row_length-1, 0   TO row_length-1) OF Complex_Type;
    TYPE COLLUMN_MATRIX IS ARRAY (0 TO collumn_length-1, 0   TO collumn_length-1) OF Complex_Type;
    
    
    -- Constant twiddle factors
    -- VAlores para o passo intermedio de fazer o produro de ponto a ponto
    CONSTANT twiddle_matrix : MATRIX :=
    ((("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000")),
    (("000000000000111111111111","000000000000000000000000"),("000000000000110111011010","100000000000011111111111"),("000000000000011111111111","100000000000110111011010"),("000000000000000000000000","100000000000111111111111")),
    (("000000000000111111111111","000000000000000000000000"),("000000000000011111111111","100000000000110111011010"),("100000000000011111111111","100000000000110111011010"),("100000000000111111111111","100000000000000000000000"))
    );
    
    -- VAlores para o passo de DFT de linhas
    CONSTANT row_matrix_values : ROW_MATRIX :=
    ((("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000")),
    (("000000000000111111111111","000000000000000000000000"),("100000000000011111111111","100000000000110111011010"),("100000000000011111111111","000000000000110111011010")),
    (("000000000000111111111111","000000000000000000000000"),("100000000000011111111111","000000000000110111011010"),("100000000000011111111111","100000000000110111011010")));
    
     -- VAlores para o passo de DFT de colunas
    CONSTANT collumn_matrix_values : COLLUMN_MATRIX :=
    ((("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("000000000000111111111111","000000000000000000000000")),
    (("000000000000111111111111","000000000000000000000000"),("000000000000000000000000","100000000000111111111111"),("100000000000111111111111","100000000000000000000000"),("100000000000000000000000","000000000000111111111111")),
    (("000000000000111111111111","000000000000000000000000"),("100000000000111111111111","100000000000000000000000"),("000000000000111111111111","000000000000000000000000"),("100000000000111111111111","100000000000000000000000")),
    (("000000000000111111111111","000000000000000000000000"),("100000000000000000000000","000000000000111111111111"),("100000000000111111111111","100000000000000000000000"),("000000000000000000000000","100000000000111111111111")));

    
    

   -- Soma de numeros complexos
   ------------------------------------------------
	FUNCTION ComplexSum (ValueA, ValueB: Complex_Type) RETURN Complex_Type;
	------------------------------------------------

    -- Multiplciação de numeros complexos
	------------------------------------------------
	FUNCTION ComplexMULT (ValueA, ValueB: Complex_Type) RETURN Complex_Type;
	------------------------------------------------
	
	-- Dot product of two vectors with same size
	----------------------------------------------
    FUNCTION dot_product( a : VECTOR_ROW; b:VECTOR_ROW; size : INTEGER ) return Complex_Type;
    ----------------------------------------------
  
 	
	
      end package Packages_Util;
       
      -- Package Body Section
      package body Packages_Util is
       
	
	------------------------------------------------
	FUNCTION ComplexSum (ValueA, ValueB: Complex_Type) RETURN Complex_Type IS
		
		VARIABLE Result : Complex_Type;
		
	BEGIN
	
		Result.r := ValueA.r + ValueB.r;
		Result.i := ValueA.i + ValueB.i;
		RETURN Result;
		
	END ComplexSum;
	

	------------------------------------------------
	FUNCTION ComplexMult(ValueA, ValueB: Complex_Type) RETURN Complex_Type IS
		
		VARIABLE Result: Complex_Type;
        VARIABLE Natural_result : signed(47 downto 0);
        VARIABLE Complex_result : signed(47 downto 0);

	BEGIN
	
        Natural_result := signed(ValueA.r) *signed(ValueB.r) - signed(ValueA.r)*signed(ValueB.i);
        Complex_result := signed(ValueA.r) *signed(ValueB.i) + signed(ValueA.i)*signed(ValueB.r);

        Result.r := Natural_result(47 downto 24);
        Result.i := Complex_result(47 downto 24);

		RETURN Result;
	END ComplexMult;
	
	
	----------------TESTADO
    FUNCTION dot_product (a : VECTOR_ROW; b:VECTOR_ROW; size : INTEGER) return complex_type is
        VARIABLE prod : VECTOR_ROW := (others => (others => ("000000000000000000000000","000000000000000000000000")));
        VARIABLE sum_of_prod : complex_type  :=             ("000000000000000000000000","000000000000000000000000");
        BEGIN
        
            -- makes the product of the factors
            for i in 0 to size-1 loop --(number of elements in the first matrix - 1)
                prod(i) :=  ComplexMult(a(i), b(i));
             end loop;
             
             -- sum of products
             for j in 0 to size-1 loop
                sum_of_prod := complexSUM(sum_of_prod, prod(j));
             end loop;
             
    -- Return the dot product value
    RETURN sum_of_prod;
    END dot_product;
    
  
    
    
END package body Packages_Util;


