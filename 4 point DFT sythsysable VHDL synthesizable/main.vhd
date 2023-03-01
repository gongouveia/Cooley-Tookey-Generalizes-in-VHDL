
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

library work;
use work.packages_Util.all;




entity main is
port (clk : in std_logic;
       --inputs
    a : in COLLUMN_VECTOR;
    twiddles: out COLLUMN_MATRIX;
    DFT : out COLLUMN_VECTOR
);
end main;



architecture Behavioral of main is
begin
    process(clk)
    
    
        variable auxiliar1 : COLLUMN_VECTOR := (others => (others => ("000000000000000000000000")));
        --variable auxiliar1 : COLLUMN_VECTOR := (others => (others => ("000000000000000000000000")));
        variable auxiliar  : Complex_Type;

        begin
        if(clk'event and clk='1') then
        for i in 0 to 3 loop
            -- Calls the dot product function
            -- this is the dft from the formula
            auxiliar := dot_product_collumn(a, collumn_matrix_values(i));
            auxiliar1(i) := auxiliar;
        end loop;   
       
        DFT <= auxiliar1;  
        twiddles <=   collumn_matrix_values;
        
        end if;
    end process;
end Behavioral;