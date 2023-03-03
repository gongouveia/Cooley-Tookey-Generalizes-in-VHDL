library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned


-- Package Declaration Section
package Packages_Util is
    
    
    CONSTANT  rows :     INTEGER :=  3;
    CONSTANT  collumns : INTEGER :=  4;
    --clk generation.For 100 MHz clock this generates 1 Hz clock.
    CONSTANT acquisition_clock_counter : INTEGER := 50000000;
    CONSTANT output_clock_counter      : INTEGER := 50000000;
 
	TYPE Complex_Type IS
		RECORD
			r: signed(31 DOWNTO 0);
			i: signed(31 DOWNTO 0);
		END RECORD;
		
    TYPE VECTOR_COLLUMN IS ARRAY (0 to collumns-1) OF Complex_Type; 
    TYPE VECTOR_ROW     IS ARRAY (0 to rows-1)     OF Complex_Type; 
    
    TYPE MATRIX         IS ARRAY (0 TO rows-1) OF VECTOR_COLLUMN;
    TYPE ROW_MATRIX     IS ARRAY (0 TO rows-1) OF VECTOR_ROW;
    TYPE COLLUMN_MATRIX IS ARRAY (0 TO collumns-1) OF VECTOR_COLLUMN;

    
    -- Constant twiddle factors
    -- VAlores para o passo intermedio de fazer o produro de ponto a ponto
    CONSTANT twiddle_matrix : MATRIX :=
    ((("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000")),
    (("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000110111011010","10000000000000000000011111111111"),("00000000000000000000011111111111","10000000000000000000110111011010"),("00000000000000000000000000000000","10000000000000000000111111111111")),
    (("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000011111111111","10000000000000000000110111011010"),("10000000000000000000011111111111","10000000000000000000110111011010"),("10000000000000000000111111111111","10000000000000000000000000000000"))
    );
    
    -- VAlores para o passo de DFT de linhas
    CONSTANT collumn_dft_matrix_values : ROW_MATRIX :=
    ((("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000")),
    (("00000000000000000000111111111111","00000000000000000000000000000000"),("10000000000000000000011111111111","10000000000000000000110111011010"),("10000000000000000000111111111111","00000000000000000000110111011010")),
    (("00000000000000000000111111111111","00000000000000000000000000000000"),("10000000000000000000011111111111","00000000000000000000110111011010"),("10000000000000000000111111111111","10000000000000000000110111011010")));
    
     -- VAlores para o passo de DFT de colunas
    CONSTANT row_dft_matrix_values : COLLUMN_MATRIX :=
    ((("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000")),
    (("00000000000000000000111111111111","00000000000000000000000000000000"),("00000000000000000000000000000000","10000000000000000000111111111111"),("10000000000000000000111111111111","10000000000000000000000000000000"),("10000000000000000000000000000000","00000000000000000000111111111111")),
    (("00000000000000000000111111111111","00000000000000000000000000000000"),("10000000000000000000111111111111","10000000000000000000000000000000"),("00000000000000000000111111111111","00000000000000000000000000000000"),("10000000000000000000111111111111","10000000000000000000000000000000")),
    (("00000000000000000000111111111111","00000000000000000000000000000000"),("10000000000000000000000000000000","00000000000000000000111111111111"),("10000000000000000000111111111111","10000000000000000000000000000000"),("00000000000000000000000000000000","10000000000000000000111111111111")));

    
    

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
    FUNCTION dot_product_row( a : VECTOR_COLLUMN; b:VECTOR_COLLUMN ) return Complex_Type;
    ----------------------------------------------
    
    
    ----------------------------------------------
    FUNCTION dot_product_collumn(a : VECTOR_ROW; b:VECTOR_ROW) return complex_type;
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
        VARIABLE Natural_result : signed(63 downto 0);
        VARIABLE Complex_result : signed(63 downto 0);

	BEGIN
	
        Natural_result := signed(ValueA.r) *signed(ValueB.r)/4096 - signed(ValueA.r)*signed(ValueB.i)/4096;
        Complex_result := signed(ValueA.r) *signed(ValueB.i)/4096 + signed(ValueA.i)*signed(ValueB.r)/4096;

        Result.r := Natural_result(31 downto 0);
        Result.i := Complex_result(31 downto 0);

		RETURN Result;
	END ComplexMult;
	
	
	----------------TESTADO
    FUNCTION dot_product_row(a : VECTOR_COLLUMN; b:VECTOR_COLLUMN) return complex_type is
        VARIABLE prod : VECTOR_COLLUMN := (others => (others => "00000000000000000000000000000000"));
        VARIABLE sum_of_prod : complex_type  :=             ("00000000000000000000000000000000","00000000000000000000000000000000");
        BEGIN
        
            -- makes the product of the factors
            for i in 0 to VECTOR_COLLUMN'length-1 loop --(number of elements in the first matrix - 1)
                prod(i) :=  ComplexMult(a(i), b(i));
             end loop;
             
             -- sum of products
             for j in 0 to VECTOR_COLLUMN'length -1 loop
                sum_of_prod := complexSUM(sum_of_prod, prod(j));
             end loop;
             
    -- Return the dot product value
    RETURN sum_of_prod;
    END dot_product_row;
    
  
      FUNCTION dot_product_collumn(a : VECTOR_ROW; b:VECTOR_ROW) return complex_type is
        VARIABLE prod : VECTOR_ROW := (others => (others => "00000000000000000000000000000000"));
        VARIABLE sum_of_prod : complex_type  :=             ("00000000000000000000000000000000","00000000000000000000000000000000");
        BEGIN
        
            -- makes the product of the factors
            for i in 0 to VECTOR_ROW'length-1 loop --(number of elements in the first matrix - 1)
                prod(i) :=  ComplexMult(a(i), b(i));
             end loop;
             
             -- sum of products
             for j in 0 to VECTOR_ROW'length -1 loop
                sum_of_prod := complexSUM(sum_of_prod, prod(j));
             end loop;
             
    -- Return the dot product value
    RETURN sum_of_prod;
    END dot_product_collumn;
    
    
    
END package body Packages_Util;


