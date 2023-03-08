
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;


entity teste_processo is
    Port (
        CLK : IN  STD_LOGIC;
        acquire_matrix :IN MATRIX;      -- unsigned (12 bits)    0---3.3V
        out_matrix : inout MATRIX_transpose;
        twiddle_matrix_values : out MATRIX;
        initial_matrix : INOUT MATRIX;
         ALGO_FINAL : out std_logic;
        process_counter : OUT integer
         );
end teste_processo;

architecture Behavioral of teste_processo is

    TYPE CTG  IS (  ROWS_DFT, MULTIPLY_TWIDDLES,TRANSPOSE_step, COLLUM_DFT); 
    SIGNAL state : CTG := ROWS_DFT;  --estado signal

begin

    twiddle_matrix_values  <= twiddle_matrix;

    PROCESS(clk) IS                       
    BEGIN
    
        IF rising_edge(CLK) THEN
                    --FINITE STATE MACHINE
                   CASE State IS                        
                                                
                            -- Calcula a DFT de cada linha
                            WHEN ROWS_DFT =>
                                State <= MULTIPLY_TWIDDLES; 
                                process_counter <= 1;   
                                     
                            -- Multiplica a matriz anterior pelos twiddle factors   
                            WHEN MULTIPLY_TWIDDLES =>   
                                State <= TRANSPOSE_step;  
                                process_counter <= 2;     
                                                                   
                              -- Multiplica a matriz anterior pelos twiddle factors   
                            WHEN TRANSPOSE_step =>   
                                State <= COLLUM_DFT;  
                                process_counter <= 3;                                        
                                                                                   
                            -- Calcula a DFT de cada coluna
                            WHEN COLLUM_DFT =>                                          
                                --OUTPUT_START <= '1';
                                State <= ROWS_DFT;
                               process_counter <= 4;                                       
                     END CASE;  
        END if;
    END PROCESS;
    





    PROCESS(clk)
        -- variavel que guarda um coluna de uma matriz de valores pre calculados
        VARIABLE auxiliary_collumn : VECTOR_ROW;
        -- variavel que guarda um linha de uma matriz de valores pre calculados
        VARIABLE auxiliary_row     : VECTOR_COLLUMN;
        -- variavel que guarda o valor de uma coluna da matriz principal
        VARIABLE AUX_collumn_from_acquire_matrix : VECTOR_ROW; 
        Variable counter : integer:= 0;
        
 
    BEGIN                                                             
      
        IF rising_edge(clk) then
        IF(state = ROWS_DFT) THEN
            FOR i IN 0 TO rows-1 LOOP   
                FOR j IN 0 TO collumns-1 LOOP  
                    -- extrai os valores de uma linha da matriz de valores pre calculados para a DFT da linha
                    initial_matrix(i)(j) <= dot_product_row(acquire_matrix(i), row_dft_matrix_values(j));
                END LOOP;
            END LOOP ;      
        END IF;
        
                  
        IF(state = MULTIPLY_TWIDDLES) THEN     
            FOR i IN 0 TO rows-1 LOOP                       
                FOR j IN 0 TO collumns-1 LOOP                      
                     --This is being done in parallel
                    initial_matrix(i)(j)<=  ComplexMULT(initial_matrix(i)(j),twiddle_matrix(i)(j));
                END LOOP;
            END LOOP ;      
        END IF;  
       
       
        IF(state = TRANSPOSE_step) THEN
         -- itera por cada coluna
            FOR i IN 0 TO collumns-1 LOOP 
                -- por cada linha                      
                FOR j IN 0 TO rows-1 LOOP      
                   out_matrix   <= transpose(initial_matrix);    
                END LOOP;
            END LOOP ; 
        END IF;
        
        
        IF(state = COLLUM_DFT) THEN
         -- itera por cada coluna
            FOR i IN 0 TO collumns-1 LOOP 
                -- por cada linha                      
                FOR j IN 0 TO rows-1 LOOP   
  
                   out_matrix(i)(j) <= dot_product_collumn(out_matrix(i), collumn_dft_matrix_values(j));

                  -- out_matrix   <= transpose(initial_matrix);    
                END LOOP;
            END LOOP ;                  
        END IF;
        
        end if;
        
        
        
        IF (rising_edge(clk)) THEN 
        counter := counter +1;
        if (counter = 4) then
            counter := 0;
            ALGO_FINAL <= '1';
        else 
            ALGO_FINAL <= '0';
        end if;
        end if;     
        
        
         
        END PROCESS; 
        
             
 

end Behavioral;
