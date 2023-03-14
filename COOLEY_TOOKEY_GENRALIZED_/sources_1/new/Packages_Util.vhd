library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned


-- Package Declaration Section
package Packages_Util is
    
    
    CONSTANT  rows :     INTEGER :=  3;
    CONSTANT  collumns : INTEGER :=  4;
    
    
    ----------------------------------------------------------
    ------              Clocks                         -------
    ----------------------------------------------------------
   
    
    --clk generation.For 100 MHz clock this generates 1 Hz clock.
    CONSTANT acquisition_clock_counter : INTEGER := 100000000;
    CONSTANT output_clock_counter      : INTEGER := 100000000;
 
 
    ----------------------------------------------------------
    ------             Data Types                      -------
    ----------------------------------------------------------
   
 
	TYPE Complex_Type IS
		RECORD
			r: signed(31 DOWNTO 0);
			i: signed(31 DOWNTO 0);
		END RECORD;
		
    TYPE VECTOR_COLLUMN IS ARRAY (0 to collumns-1) OF Complex_Type; 
    TYPE VECTOR_ROW     IS ARRAY (0 to rows-1)     OF Complex_Type; 
    
    TYPE MATRIX         IS ARRAY (0 TO rows-1) OF VECTOR_COLLUMN;
    TYPE MATRIX_transpose  IS ARRAY (0 TO collumns-1) OF VECTOR_ROW;

    TYPE ROW_MATRIX     IS ARRAY (0 TO rows-1) OF VECTOR_ROW;
    TYPE COLLUMN_MATRIX IS ARRAY (0 TO collumns-1) OF VECTOR_COLLUMN;

    ----------------------------------------------------------
    ------           Pre Computed Matrix               -------
    ----------------------------------------------------------
    -- os valores estão calculados em 2s complement " 
CONSTANT twiddle_matrix : MATRIX :=
 (((x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000")),
((x"00001000",x"00000000"),(x"00000ddb",x"fffff800"),(x"00000800",x"fffff225"),(x"00000000",x"fffff000")),
((x"00001000",x"00000000"),(x"00000800",x"fffff225"),(x"fffff800",x"fffff225"),(x"fffff000",x"00000000"))
);

CONSTANT collumn_dft_matrix_values : ROW_MATRIX :=
 (((x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000")),
((x"00001000",x"00000000"),(x"fffff800",x"fffff225"),(x"fffff800",x"00000ddb")),
((x"00001000",x"00000000"),(x"fffff800",x"00000ddb"),(x"fffff800",x"fffff225")));


CONSTANT row_dft_matrix_values : COLLUMN_MATRIX :=
 (((x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000")),
((x"00001000",x"00000000"),(x"00000000",x"fffff000"),(x"fffff000",x"00000000"),(x"00000000",x"00001000")),
((x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000")),
((x"00001000",x"00000000"),(x"00000000",x"00001000"),(x"fffff000",x"00000000"),(x"00000000",x"fffff000")));
    -------------------------------------------------------
    ------        Deslaração de Funções             -------
    -------------------------------------------------------
      

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


    ----------------------------------------------
    FUNCTION transpose(a : matrix) return MATRIX_transpose;
    ----------------------------------------------

	
      end package Packages_Util;
       
      -- Package Body Section
      package body Packages_Util is
       
	
	------------------------------------------------
	--Calcula a soma de dois numeros complexos
	FUNCTION ComplexSum (ValueA, ValueB: Complex_Type) RETURN Complex_Type IS
		
		VARIABLE Result : Complex_Type;
        VARIABLE Natural_result : signed(31 downto 0);
        VARIABLE Complex_result : signed(31 downto 0);
    
	BEGIN
	
		Natural_result := ValueA.r + ValueB.r;
		Complex_result := ValueA.i + ValueB.i;
		
        Result.r := Natural_result(31 downto 0);
        Result.i := Complex_result(31 downto 0);
		RETURN Result;
		
	END ComplexSum;
	

	------------------------------------------------
	-- Calcula o produto entre dois numeros complexos
    FUNCTION ComplexMult(ValueA, ValueB: Complex_Type) RETURN Complex_Type IS
        
        VARIABLE Result: Complex_Type;
        VARIABLE Natural_result_first : signed(63 downto 0);
        VARIABLE Complex_result_first : signed(63 downto 0);
        VARIABLE Natural_result_second : signed(63 downto 0);
        VARIABLE Complex_result_second : signed(63 downto 0);   
        VARIABLE Natural_result : signed(63 downto 0);
        VARIABLE Complex_result : signed(63 downto 0); 
    BEGIN
    
        Natural_result_first := signed(ValueA.r) *signed(ValueB.r)/4096 ;
        Complex_result_first := signed(ValueA.r) *signed(ValueB.i)/4096 ;
   
        Natural_result_second :=  signed(ValueA.i)*signed(ValueB.i)/4096;
        Complex_result_second :=  signed(ValueA.i)*signed(ValueB.r)/4096;
     
     
        Natural_result := Natural_result_first- Natural_result_second;
        Complex_result := Complex_result_first+ Complex_result_second;
     
        Result.r := Natural_result(31 downto 0);
        Result.i := Complex_result(31 downto 0);
    
        RETURN Result;
    END ComplexMult;
	
	
	----------------TESTADO
	-- calcula a soma dos produtos pontoa  ponto 
    FUNCTION dot_product_row(a : VECTOR_COLLUMN; b:VECTOR_COLLUMN) return complex_type is
        VARIABLE prod : VECTOR_COLLUMN := (others => (others => x"00000000"));
        VARIABLE sum_of_prod : complex_type  := (x"00000000",x"00000000");
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
    VARIABLE prod : VECTOR_ROW := (others => (others => x"00000000"));
    VARIABLE sum_of_prod : complex_type  := (x"00000000",x"00000000");
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
    
    
    
    FUNCTION transpose(a : matrix) return MATRIX_transpose is
    VARIABLE transposed_matrix : MATRIX_transpose := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
    
    begin
        for i in 0 to rows-1 loop --(number of elements in the first matrix - 1)
            for j in 0 to collumns-1 loop --(number of elements in the first matrix - 1)
                transposed_matrix(j)(i) := a(i)(j);
            end loop;
        end loop;
        return transposed_matrix;
    end function;
 
    
END package body Packages_Util;