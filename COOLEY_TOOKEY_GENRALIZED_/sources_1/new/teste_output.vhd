

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;


entity teste_output is
    Port (
        RESET : IN STD_LOGIC;
        CLK :   IN  STD_LOGIC;
        OUT_VALUE_REAL:out signed(31 DOWNTO 0); 
        OUT_VALUE_IMAG :out signed(31 DOWNTO 0); 
        acquire_matrix : in MATRIX_transpose;
        OUTPUT_FINAL : out std_logic
         );
end teste_output;

architecture Behavioral of teste_output is


begin

   PROCESS(clk) 
    
    -- são apenas acedidas dentro deste processo e evitam multiple driving nets
    VARIABLE i : integer := 0;   
    VARIABLE j : integer := 0;
    VARIABLE counter : integer := 0;
 
    BEGIN        

            IF (rising_edge(clk)) THEN 
                if reset = '1' then
                    i := 0;
                    j := 0;
                    counter := 0;
                    OUT_VALUE_REAL <= x"00000000"; 
                    OUT_VALUE_IMAG <= x"00000000"; 
                    OUTPUT_FINAL <= '0';

                    
            else            
            
                --OUTPUT_FINAL <= '0';
                IF (i < collumns) THEN
                    IF(j  < rows) THEN        
                        --write your code architecture                              
                         OUT_VALUE_REAL <= acquire_matrix(i)(j).r; 
                         OUT_VALUE_IMAG <= acquire_matrix(i)(j).i; 
                         j := j+1;
                         --juntar output real & complex de forma a fazer  
                    END IF;
                    IF(j= rows) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;
                    
                     IF(j= collumns AND i = rows) THEN
                        i := 0;
                        j := 0;                        
                    END IF;
                END IF;   
    
    
            counter := counter +1;
            if (counter = 12) then
                counter := 0;
                OUTPUT_FINAL <= '1';
            else 
                OUTPUT_FINAL <= '0';
                
            end if;
        END IF;   
        
    END IF;   
    END PROCESS;
    
    
    

end Behavioral;
