
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;



ENTITY CTG IS
    Port (
        CLK : IN  STD_LOGIC;
        RESET : IN  STD_LOGIC;           
        NEW_VALUE : IN STD_LOGIC_VECTOR(11 DOWNTO 0);       -- unsigned (12 bits)    0---3.3V
        OUT_VALUE : OUT STD_LOGIC;
        acquire_matrix : OUT MATRIX;

        out_matrix : OUT MATRIX_transpose;
        state_at : out  integer;
        OUT_VALUE_REAL: OUT signed(31 DOWNTO 0); 
        OUT_VALUE_IMAG : OUT SIGNED(31 DOWNTO 0);
        counter_total : OUT INTEGER
        
        );
END CTG;



ARCHITECTURE Behavioral OF CTG IS 


    -----------------------------------------------------------
    ------               FSM                            -------
    -----------------------------------------------------------

    TYPE CTG  IS ( ACQUIRE_VALUES , ROWS_DFT, MULTIPLY_TWIDDLES,TRANSPOSE_step, COLLUM_DFT, OUTPUT_VALUES); 
    SIGNAL state : CTG := ACQUIRE_VALUES;  --estado signal



    -----------------------------------------------------------
    ------          Declaração de sinais                -------
    -----------------------------------------------------------

    SIGNAL initial_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000")));   -- Devo fazer uma matriz para cada estado ou actualizar sempre a mesma matriz? eu tentei a segunda opção mas estava me a dar erros de double assignment
    SIGNAL auxiliar_acquire_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000")));   -- Devo fazer uma matriz para cada estado ou actualizar sempre a mesma matriz? eu tentei a segunda opção mas estava me a dar erros de double assignment



BEGIN

    ------------------------------------------------------------
    -- acquire a value at each clock cycle
    --adapted from:
                    --https://vhdlguru.blogspot.com/2010/03/how-to-do-clocked-for-loop.html

    -- stops when the whole N = n*m values are aqcuired
    ------------------------------------------------------------
-- TER CONTADOR EM CONTA **************************************************************+
    PROCESS(clk) IS 
    variable counter_total_aux : integer := 0; 
    BEGIN
        if (RESET = '1' ) then
            counter_total_aux := 0;
            State <= ACQUIRE_VALUES;
            state_at <= 0;                                        

        else 
        IF rising_edge(CLK) THEN
        counter_total_aux := counter_total_aux+1;
        counter_total <= counter_total_aux;
        
                   CASE State IS                                                             
                            -- Calcula a DFT de cada linha
                             WHEN ACQUIRE_VALUES =>
                                state_at <= 0;
                                IF counter_total = rows*collumns-1 THEN                              
                                    State <= ROWS_DFT; 
                                END IF;
 
                            WHEN ROWS_DFT =>
                                --State <= MULTIPLY_TWIDDLES; 
                                state_at <= 1;
                                if counter_total = rows*collumns + collumns*collumns -1  then
                                    state <= MULTIPLY_TWIDDLES;
                                
                                end if; 
                                     
                            -- Multiplica a matriz anterior pelos twiddle factors   
                            WHEN MULTIPLY_TWIDDLES =>   
                                state_at <= 2; 
                                if counter_total = 2*rows*collumns +  collumns*collumns -1   then
                                    state <= TRANSPOSE_step;
                                
                                end if; 
                                                                   
                              -- Multiplica a matriz anterior pelos twiddle factors   
                            WHEN TRANSPOSE_step =>   
                                state_at <= 3;  
                                 if counter_total = 3*rows*collumns + collumns*collumns -1 then
                                    state <= COLLUM_DFT;
                                
                                end if;
                                                                                   
                            -- Calcula a DFT de cada coluna
                            WHEN COLLUM_DFT =>                                          
                                --OUTPUT_START <= '1';
                               --State <= OUTPUT_VALUES;
                               state_at <= 4;  
                                IF  counter_total =  3*rows*collumns + collumns*collumns + rows*rows-1 then
                                  State <= OUTPUT_VALUES;
                                END IF;    
                               
                             WHEN OUTPUT_VALUES =>                                          
                                --OUTPUT_START <= '1';
                              state_at <= 5;  
                              IF  counter_total = 4*rows*collumns+rows*rows +collumns*collumns -1 then
                                  State <= ACQUIRE_VALUES;
                                  counter_total_aux := 0;
                              END IF;                              
                                                                 
                     END CASE;  
                     
            
            END IF;
            end if; -- reset
    END PROCESS;
    
    
             
    PROCESS(clk) 
    VARIABLE i : integer := 0;
    VARIABLE j : integer := 0;
    variable acquired_new : std_logic_vector(31 downto 0);
    BEGIN 
    if (reset = '1') then
        i := 0;
        j := 0;
        acquire_matrix <= (OTHERS => (OTHERS => (x"00000000", x"00000000")));
    else 
    IF (rising_edge(clk)) THEN 
    
    
    
        IF state = ACQUIRE_VALUES then 
              IF (i < collumns) THEN
                    IF(j  < rows) THEN
                        --write your code here.. 
                         acquire_matrix(j)(i) <= (signed(x"00000" & NEW_VALUE),x"00000000");      --acquired value (Acquired value,0);                                   
                        j:=j+1; 
                                                                                                                       --increment the pointer 'j' .
                    END IF; 
            
                    IF(j= rows) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF  (i = collumns)THEN
                        i := 0;
                        j := 0;                                          
                    END IF;                                  
            END IF;            
        END IF;  
    END IF;
    end if;
    END PROCESS;



    PROCESS(clk)
       Variable i : integer := 0;
       Variable j : integer := 0;
       VARIABLE sum_of_prod : complex_type  := (x"00000000",x"00000000");
       variable auxiliary_vector : VECTOR_COLLUMN := (others => (others => x"00000000"));
       VARIABLE auxiliary_out_matrix : MATRIX_transpose := (OTHERS => (OTHERS => (x"00000000", x"00000000")));
       
    BEGIN                                                             
     if reset = '1' then 
        initial_matrix <= (OTHERS => (OTHERS => (x"00000000", x"00000000")));
        out_matrix <= (OTHERS => (OTHERS => (x"00000000", x"00000000")));
        sum_of_prod := (x"00000000",x"00000000");
     
     else
        if rising_edge(clk) then
         auxiliar_acquire_matrix <= acquire_matrix;
     

        
        IF state = ROWS_DFT then 
              IF (i < collumns) THEN
                    IF(j  < collumns) THEN
                        --write your code here.. 
                        
                        for x in  0 to rows-1 loop
                            auxiliary_vector(x) := ComplexSum( auxiliary_vector(x) , ComplexMULT(acquire_matrix(x)(j),row_dft_matrix_values(i)(j)));
                            initial_matrix(x)(i) <= auxiliary_vector(x);                  
                          end loop;
                        j:=j+1; 
                   -- increment the pointer 'j' .
                    END IF; 
            
                    IF(j= collumns) THEN
                    
                        for k in 0 to rows-1 loop
                            auxiliary_vector(k) := (x"00000000", x"00000000");                    
                        end loop;
        
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF  (i = collumns)THEN                  
                        for k in 0 to rows-1 loop
                            auxiliary_vector(k) := (x"00000000", x"00000000");
                        end loop;
                        i := 0;
                        j := 0;                                          
                    END IF;                                  
            END IF;            
        END IF;       
        
        
        IF state = MULTIPLY_TWIDDLES then 
              IF (i < rows) THEN
                    IF(j  < collumns) THEN
                        --write your code here.. 
                        initial_matrix(i)(j)<=  ComplexMULT(initial_matrix(i)(j),twiddle_matrix(i)(j));      --acquired value (Acquired value,0);                                   
                        j:=j+1; 
                                                                                                                       --increment the pointer 'j' .
                    END IF; 
            
                    IF(j= collumns) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF  (i = rows)THEN
                        i := 0;
                        j := 0;                                          
                    END IF;                                  
            END IF;            
        END IF;  
       
        IF state = TRANSPOSE_step then 
              IF (i < rows) THEN
                    IF(j  < collumns) THEN
                        --write your code here.. 
                        out_matrix(j)(i)<=  initial_matrix(i)(j);      --acquired value (Acquired value,0);                                   
                        auxiliary_out_matrix(j)(i) := initial_matrix(i)(j);  
                                      
   
                        j:=j+1; 
                                                                                                                       --increment the pointer 'j' .
                    END IF; 
            
                    IF(j= collumns) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.


                    END IF;  
                                 
                    IF  (i = rows)THEN
                        i := 0;
                        j := 0; 
                    END IF;                                  
            END IF;            
        END IF;  

        
        IF state = COLLUM_DFT then 
              IF (i < ROWS) THEN
                    IF(j  < ROWS) THEN
                        --write your code here.. 
                        
                        for x in  0 to collumns-1 loop
                        auxiliary_vector(x) := ComplexSum( auxiliary_vector(x) , ComplexMULT(auxiliary_out_matrix(x)(j),collumn_dft_matrix_values(i)(j)));
                        out_matrix(x)(i) <= auxiliary_vector(x);
     
                                            
                          end loop;
                        j:=j+1; 
                   -- increment the pointer 'j' .
                    END IF; 
            
                    IF(j= ROWS) THEN
                    
                        for k in 0 to collumns-1 loop
                            auxiliary_vector(k) := (x"00000000", x"00000000");                    
                        end loop;

                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF  (i = ROWS)THEN                  
                        for k in 0 to collumns-1 loop
                            auxiliary_vector(k) := (x"00000000", x"00000000");
                        end loop;
                        i := 0;
                        j := 0;                                          
                    END IF;                                  
            END IF;            
        END IF;
        
        END IF;
        END IF;
        END PROCESS; 
        

    
    
   PROCESS(clk) 
    
    -- são apenas acedidas dentro deste processo e evitam multiple driving nets
    VARIABLE i : integer := 0;   
    VARIABLE j : integer := 0;
 
    BEGIN        

            IF (rising_edge(clk)) and state = OUTPUT_VALUES THEN 
                if reset = '1' then
                    OUT_VALUE_REAL <=x"00000000";
                    OUT_VALUE_IMAG <=x"00000000";
               
                else        

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
                    
                     IF i = rows THEN
                        i := 0;
                        j := 0;                        
                    END IF;
                END IF;   
        END IF;   
        END IF;
    END PROCESS;
    
    
    
END behavioral;
