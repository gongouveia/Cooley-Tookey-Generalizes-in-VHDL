

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;


entity teste_acquisition is
    Port (
        RESET : IN std_logic;
        CLK : IN  STD_LOGIC;
        NEW_VALUE :IN STD_LOGIC_VECTOR(11 DOWNTO 0); 
        acquire_matrix : out MATRIX;
        ACQUIRE_FINAL : out std_logic
         );
end teste_acquisition;

architecture Behavioral of teste_acquisition is


begin

           
    PROCESS(clk) 
    VARIABLE i : integer := 0;
    VARIABLE j : integer := 0;
    variable acquired_new : signed(31 downto 0);
    VARIABLE counter : integer := 0;
    BEGIN
    IF (rising_edge(clk)) THEN 
    
    
    if reset = '1' then 
        i := 0;
        j := 0;
        counter := 0;
        acquire_matrix <= (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
        ACQUIRE_FINAL <= '0';
        
    
    else
              IF (i < collumns) THEN
              
                    IF(j  <= rows) THEN
                        --write your code here..
                        acquired_new := signed(x"00000" & NEW_VALUE);
                        acquire_matrix(j)(i) <= (signed(acquired_new),x"00000000");      --acquired value (Acquired value,0);                                   
                        j:=j+1; 
                                                                                                                       --increment the pointer 'j' .
                    END IF; 
            
                    IF(j= rows-1) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF ((j= rows-1) AND (i = collumns-1)) THEN
                        i := 0;
                        j := 0;                   
                    END IF;                                  
            END IF; 
    
            counter := counter +1;
            if (counter = 12) then
                counter := 0;
                ACQUIRE_FINAL <= '1';
            else 
                ACQUIRE_FINAL <= '0';
            end if;
    end if;
    
    end if;
    END PROCESS;
 

end Behavioral;
