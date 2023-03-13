
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;



ENTITY CTG IS
    Port (
        CLK : IN  STD_LOGIC;
        --RESET : IN  STD_LOGIC;           
        NEW_VALUE :IN STD_LOGIC_VECTOR(11 DOWNTO 0);       -- unsigned (12 bits)    0---3.3V
        OUT_VALUE : OUT STD_LOGIC;
        ACQUIRE_FINAL : OUT STD_LOGIC;
        OUTPUT_FINAL : OUT STD_LOGIC;
        ALGO_FINAL : OUT STD_LOGIC;
        acquire_matrix : OUT MATRIX;

        out_matrix : OUT MATRIX_transpose;
        state_at : out  integer;
        OUT_VALUE_REAL: out signed(31 DOWNTO 0); 
        OUT_VALUE_IMAG : out signed(31 DOWNTO 0);
        counter_total : out INTEGER
        
        );
END CTG;



ARCHITECTURE Behavioral OF CTG IS 


    -----------------------------------------------------------
    ------               FSM                            -------
    -----------------------------------------------------------

    TYPE CTG  IS (  ROWS_DFT, MULTIPLY_TWIDDLES,TRANSPOSE_step, COLLUM_DFT); 
    SIGNAL state : CTG := ROWS_DFT;  --estado signal



    -----------------------------------------------------------
    ------          Declaração de sinais                -------
    -----------------------------------------------------------

    -- inicialização de valores e 
    -- A craição de duas matrizes em que guardam os dados previnem o eror4 de multiple driving nets
    SIGNAL initial_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000")));   -- Devo fazer uma matriz para cada estado ou actualizar sempre a mesma matriz? eu tentei a segunda opção mas estava me a dar erros de double assignment
    --SIGNAL acquire_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000")));    -- matriz onde estão os valores adquiridos
    SIGNAL sum_of_factors : Complex_Type := (x"00000000", x"00000000");
    --SIGNAL out_matrix : MATRIX_transpose := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 



BEGIN

    ------------------------------------------------------------
    -- acquire a value at each clock cycle
    --adapted from:
                    --https://vhdlguru.blogspot.com/2010/03/how-to-do-clocked-for-loop.html

    -- stops when the whole N = n*m values are aqcuired
    ------------------------------------------------------------

          
    PROCESS(clk) 
    VARIABLE i : integer := 0;
    VARIABLE j : integer := 0;
    variable acquired_new : signed(31 downto 0);
    VARIABLE counter : integer := 0;
    BEGIN 
    IF (rising_edge(clk)) THEN 

              IF (i < collumns) THEN
              
                    IF(j  <= rows) THEN
                        --write your code here..
                        acquired_new := signed(x"00000" & NEW_VALUE);
                        acquire_matrix(j)(i) <= (signed(acquired_new),x"00000000");      --acquired value (Acquired value,0);                                   
                        j:=j+1; 
                                                                                                                       --increment the pointer 'j' .
                    END IF; 
            
                    IF(j= rows) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF ((j= rows) AND (i = collumns)) THEN
                        i := 0;
                        j := 0;    
                                       
                    END IF;                                  
            END IF; 
            
            
        counter := counter +1;
        if (counter = 12) then
            counter := 0;
            ACQUIRE_FINAL <= '1';
        end if;
            
    END IF;    
    
    END PROCESS;


    PROCESS(clk) IS 
    variable counter_total_aux : integer := 0; 
    BEGIN
        counter_total_aux := counter_total_aux+1;
        counter_total <= counter_total_aux;
        
        IF rising_edge(CLK) and ACQUIRE_FINAL = '1' and ALGO_FINAL /= '1' THEN
        
                   CASE State IS                                                             
                            -- Calcula a DFT de cada linha
                            WHEN ROWS_DFT =>
                                State <= MULTIPLY_TWIDDLES; 
                                state_at <= 1;   
                                     
                            -- Multiplica a matriz anterior pelos twiddle factors   
                            WHEN MULTIPLY_TWIDDLES =>   
                                State <= TRANSPOSE_step;  
                                state_at <= 2;     
                                                                   
                              -- Multiplica a matriz anterior pelos twiddle factors   
                            WHEN TRANSPOSE_step =>   
                                State <= COLLUM_DFT;  
                                state_at <= 3;                                        
                                                                                   
                            -- Calcula a DFT de cada coluna
                            WHEN COLLUM_DFT =>                                          
                                --OUTPUT_START <= '1';
                                State <= ROWS_DFT;
                               state_at <= 4;                                       
                     END CASE;  
                     
            
            END IF;
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
      
        IF rising_edge(clk) and ACQUIRE_FINAL = '1' then
        
      counter := counter +1;

        
        
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
        
        if (counter = 4) then
            counter := 0;
            ALGO_FINAL <= '1';
        end if;
        end if;
    
         
        END PROCESS; 
        
   
    
    
    
    
    
    
    
   PROCESS(clk) 
    
    -- são apenas acedidas dentro deste processo e evitam multiple driving nets
    VARIABLE i : integer := 0;   
    VARIABLE j : integer := 0;
    VARIABLE counter : integer := 0;
 
    BEGIN        

            IF (rising_edge(clk)) and ALGO_FINAL = '1' THEN 
                        

       --OUTPUT_FINAL <= '0';
                IF (i < rows) THEN
                    IF(j  < collumns) THEN        
                        --write your code architecture                              
                         OUT_VALUE_REAL <= out_matrix(j)(i).r; 
                         OUT_VALUE_IMAG <= out_matrix(j)(i).i; 
                         j := j+1;
                         --juntar output real & complex de forma a fazer  
                    END IF;
                    IF(j = collumns) THEN
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
                
            end if;
        END IF;   
        
    END PROCESS;
    
    
    
      
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
END behavioral;