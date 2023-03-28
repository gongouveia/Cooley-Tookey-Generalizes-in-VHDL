library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned


-- Package Declaration Section-0.02112+0.j
package Packages_Util is
    
    
    CONSTANT  rows :     INTEGER :=  10;
    CONSTANT  collumns : INTEGER :=  10;
    
    
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
 (((x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000")),
((x"00001000",x"00000000"),(x"00000ff8",x"fffffeff"),(x"00000fe0",x"fffffdff"),(x"00000fb7",x"fffffd00"),(x"00000f7f",x"fffffc05"),(x"00000f38",x"fffffb0e"),(x"00000ee0",x"fffffa1c"),(x"00000e7a",x"fffff930"),(x"00000e05",x"fffff84b"),(x"00000d82",x"fffff76d")),
((x"00001000",x"00000000"),(x"00000fe0",x"fffffdff"),(x"00000f7f",x"fffffc05"),(x"00000ee0",x"fffffa1c"),(x"00000e05",x"fffff84b"),(x"00000cf2",x"fffff698"),(x"00000baa",x"fffff50c"),(x"00000a33",x"fffff3ac"),(x"00000893",x"fffff27e"),(x"000006d0",x"fffff186")),
((x"00001000",x"00000000"),(x"00000fb7",x"fffffd00"),(x"00000ee0",x"fffffa1c"),(x"00000d82",x"fffff76d"),(x"00000baa",x"fffff50c"),(x"00000968",x"fffff30e"),(x"000006d0",x"fffff186"),(x"000003fb",x"fffff081"),(x"00000101",x"fffff008"),(x"fffffdff",x"fffff020")),
((x"00001000",x"00000000"),(x"00000f7f",x"fffffc05"),(x"00000e05",x"fffff84b"),(x"00000baa",x"fffff50c"),(x"00000893",x"fffff27e"),(x"000004f2",x"fffff0c8"),(x"00000101",x"fffff008"),(x"fffffd00",x"fffff049"),(x"fffff930",x"fffff186"),(x"fffff5cd",x"fffff3ac")),
((x"00001000",x"00000000"),(x"00000f38",x"fffffb0e"),(x"00000cf2",x"fffff698"),(x"00000968",x"fffff30e"),(x"000004f2",x"fffff0c8"),(x"00000000",x"fffff000"),(x"fffffb0e",x"fffff0c8"),(x"fffff698",x"fffff30e"),(x"fffff30e",x"fffff698"),(x"fffff0c8",x"fffffb0e")),
((x"00001000",x"00000000"),(x"00000ee0",x"fffffa1c"),(x"00000baa",x"fffff50c"),(x"000006d0",x"fffff186"),(x"00000101",x"fffff008"),(x"fffffb0e",x"fffff0c8"),(x"fffff5cd",x"fffff3ac"),(x"fffff1fb",x"fffff84b"),(x"fffff020",x"fffffdff"),(x"fffff081",x"000003fb")),
((x"00001000",x"00000000"),(x"00000e7a",x"fffff930"),(x"00000a33",x"fffff3ac"),(x"000003fb",x"fffff081"),(x"fffffd00",x"fffff049"),(x"fffff698",x"fffff30e"),(x"fffff1fb",x"fffff84b"),(x"fffff008",x"fffffeff"),(x"fffff120",x"000005e4"),(x"fffff50c",x"00000baa")),
((x"00001000",x"00000000"),(x"00000e05",x"fffff84b"),(x"00000893",x"fffff27e"),(x"00000101",x"fffff008"),(x"fffff930",x"fffff186"),(x"fffff30e",x"fffff698"),(x"fffff020",x"fffffdff"),(x"fffff120",x"000005e4"),(x"fffff5cd",x"00000c54"),(x"fffffd00",x"00000fb7")),
((x"00001000",x"00000000"),(x"00000d82",x"fffff76d"),(x"000006d0",x"fffff186"),(x"fffffdff",x"fffff020"),(x"fffff5cd",x"fffff3ac"),(x"fffff0c8",x"fffffb0e"),(x"fffff081",x"000003fb"),(x"fffff50c",x"00000baa"),(x"fffffd00",x"00000fb7"),(x"000005e4",x"00000ee0"))
);

CONSTANT collumn_dft_matrix_values : ROW_MATRIX :=
 (((x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000")),
((x"00001000",x"00000000"),(x"00000cf2",x"fffff698"),(x"000004f2",x"fffff0c8"),(x"fffffb0e",x"fffff0c8"),(x"fffff30e",x"fffff698"),(x"fffff000",x"00000000"),(x"fffff30e",x"00000968"),(x"fffffb0e",x"00000f38"),(x"000004f2",x"00000f38"),(x"00000cf2",x"00000968")),
((x"00001000",x"00000000"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"fffff698"),(x"fffff30e",x"00000968"),(x"000004f2",x"00000f38"),(x"00001000",x"00000000"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"fffff698"),(x"fffff30e",x"00000968"),(x"000004f2",x"00000f38")),
((x"00001000",x"00000000"),(x"fffffb0e",x"fffff0c8"),(x"fffff30e",x"00000968"),(x"00000cf2",x"00000968"),(x"000004f2",x"fffff0c8"),(x"fffff000",x"00000000"),(x"000004f2",x"00000f38"),(x"00000cf2",x"fffff698"),(x"fffff30e",x"fffff698"),(x"fffffb0e",x"00000f38")),
((x"00001000",x"00000000"),(x"fffff30e",x"fffff698"),(x"000004f2",x"00000f38"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"00000968"),(x"00001000",x"00000000"),(x"fffff30e",x"fffff698"),(x"000004f2",x"00000f38"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"00000968")),
((x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000")),
((x"00001000",x"00000000"),(x"fffff30e",x"00000968"),(x"000004f2",x"fffff0c8"),(x"000004f2",x"00000f38"),(x"fffff30e",x"fffff698"),(x"00001000",x"00000000"),(x"fffff30e",x"00000968"),(x"000004f2",x"fffff0c8"),(x"000004f2",x"00000f38"),(x"fffff30e",x"fffff698")),
((x"00001000",x"00000000"),(x"fffffb0e",x"00000f38"),(x"fffff30e",x"fffff698"),(x"00000cf2",x"fffff698"),(x"000004f2",x"00000f38"),(x"fffff000",x"00000000"),(x"000004f2",x"fffff0c8"),(x"00000cf2",x"00000968"),(x"fffff30e",x"00000968"),(x"fffffb0e",x"fffff0c8")),
((x"00001000",x"00000000"),(x"000004f2",x"00000f38"),(x"fffff30e",x"00000968"),(x"fffff30e",x"fffff698"),(x"000004f2",x"fffff0c8"),(x"00001000",x"00000000"),(x"000004f2",x"00000f38"),(x"fffff30e",x"00000968"),(x"fffff30e",x"fffff698"),(x"000004f2",x"fffff0c8")),
((x"00001000",x"00000000"),(x"00000cf2",x"00000968"),(x"000004f2",x"00000f38"),(x"fffffb0e",x"00000f38"),(x"fffff30e",x"00000968"),(x"fffff000",x"00000000"),(x"fffff30e",x"fffff698"),(x"fffffb0e",x"fffff0c8"),(x"000004f2",x"fffff0c8"),(x"00000cf2",x"fffff698")));


CONSTANT row_dft_matrix_values : COLLUMN_MATRIX :=
 (((x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000"),(x"00001000",x"00000000")),
((x"00001000",x"00000000"),(x"00000cf2",x"fffff698"),(x"000004f2",x"fffff0c8"),(x"fffffb0e",x"fffff0c8"),(x"fffff30e",x"fffff698"),(x"fffff000",x"00000000"),(x"fffff30e",x"00000968"),(x"fffffb0e",x"00000f38"),(x"000004f2",x"00000f38"),(x"00000cf2",x"00000968")),
((x"00001000",x"00000000"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"fffff698"),(x"fffff30e",x"00000968"),(x"000004f2",x"00000f38"),(x"00001000",x"00000000"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"fffff698"),(x"fffff30e",x"00000968"),(x"000004f2",x"00000f38")),
((x"00001000",x"00000000"),(x"fffffb0e",x"fffff0c8"),(x"fffff30e",x"00000968"),(x"00000cf2",x"00000968"),(x"000004f2",x"fffff0c8"),(x"fffff000",x"00000000"),(x"000004f2",x"00000f38"),(x"00000cf2",x"fffff698"),(x"fffff30e",x"fffff698"),(x"fffffb0e",x"00000f38")),
((x"00001000",x"00000000"),(x"fffff30e",x"fffff698"),(x"000004f2",x"00000f38"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"00000968"),(x"00001000",x"00000000"),(x"fffff30e",x"fffff698"),(x"000004f2",x"00000f38"),(x"000004f2",x"fffff0c8"),(x"fffff30e",x"00000968")),
((x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000"),(x"00001000",x"00000000"),(x"fffff000",x"00000000")),
((x"00001000",x"00000000"),(x"fffff30e",x"00000968"),(x"000004f2",x"fffff0c8"),(x"000004f2",x"00000f38"),(x"fffff30e",x"fffff698"),(x"00001000",x"00000000"),(x"fffff30e",x"00000968"),(x"000004f2",x"fffff0c8"),(x"000004f2",x"00000f38"),(x"fffff30e",x"fffff698")),
((x"00001000",x"00000000"),(x"fffffb0e",x"00000f38"),(x"fffff30e",x"fffff698"),(x"00000cf2",x"fffff698"),(x"000004f2",x"00000f38"),(x"fffff000",x"00000000"),(x"000004f2",x"fffff0c8"),(x"00000cf2",x"00000968"),(x"fffff30e",x"00000968"),(x"fffffb0e",x"fffff0c8")),
((x"00001000",x"00000000"),(x"000004f2",x"00000f38"),(x"fffff30e",x"00000968"),(x"fffff30e",x"fffff698"),(x"000004f2",x"fffff0c8"),(x"00001000",x"00000000"),(x"000004f2",x"00000f38"),(x"fffff30e",x"00000968"),(x"fffff30e",x"fffff698"),(x"000004f2",x"fffff0c8")),
((x"00001000",x"00000000"),(x"00000cf2",x"00000968"),(x"000004f2",x"00000f38"),(x"fffffb0e",x"00000f38"),(x"fffff30e",x"00000968"),(x"fffff000",x"00000000"),(x"fffff30e",x"fffff698"),(x"fffffb0e",x"fffff0c8"),(x"000004f2",x"fffff0c8"),(x"00000cf2",x"fffff698")));
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
	
 
    
END package body Packages_Util;
