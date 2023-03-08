--------------------------------------------------------------------------------------------------------------
--                                                                                                          --
--                                 CooleyTukey_Generalized.vhd -- ARTY A7 /UART                             --
--                                                                                                          --
--------------------------------------------------------------------------------------------------------------
-- Author: Gonçalo Gouveia
-- onControl technologies
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
--
--    REFERENCES:
--
--  https://perso.telecom-paristech.fr/guilley/ENS/20171205/TP/tp_syn/doc/IEEE_VHDL_1076.2-1996.pdf
--  Para o ciclo de aqusição de dados  CLOCKED FOR LOOP
--  https://vhdlguru.blogspot.com/2010/03/how-to-do-clocked-for-loop.html P
--                                             
----------------------------------------------------------------------------------------------------------------


library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;



ENTITY CTG IS
    Port (
        CLK : IN  STD_LOGIC;
        RESET : IN  STD_LOGIC;           
        NEW_VALUE :IN STD_LOGIC_VECTOR(11 DOWNTO 0);       -- unsigned (12 bits)    0---3.3V
        OUT_VALUE : OUT STD_LOGIC

         );
END CTG;



ARCHITECTURE Behavioral OF CTG IS 


    -----------------------------------------------------------
    ------               FSM                            -------
    -----------------------------------------------------------
    --  Fazer a FFT de N = 12 , N é composito em 12=3*4
    --  0 | 4 | 8  |    começar a inicializar a matriz desta maneira ..... linhas j / colunas j
    --  1 | 5 | 9  |
    --  2 | 6 | 10 |
    --  3 | 7 | 11 |
    
    
    --  CREATE_TWIDDLE_MATRIX   Isto é feito apenas uma vez, estou a pensar passra para constante. este estado pode desaparecer no signal
    --  ACQUIRE_VALUES          Obtem os valores no formato Matrix
    --  ROWS_DFT                Fazer a DFT/fft de cada uma das linhas
    --  MULTIPLY_TWIDDLES       Multiplicar cada valor da mariz final anterior pelos valores da twiddle signal
    --  COLLUM_DFT              Fazer a DFT/fft de cada uma das colunas
    --  OUT_VALUES              Enviar os valores finais
   
    TYPE CTG            IS ( ACQUIRE_VALUES, ROWS_DFT, MULTIPLY_TWIDDLES,TRANSPOSE_step, COLLUM_DFT, OUT_VALUES); 
    
    -- variaveis da Finite State Machine
    
    -- esta variavel dermina quando se deve adquirir valores ou quando se deve parar de adquirir valores
    SIGNAL ACQUIRE_FINAL :   STD_LOGIC := '0';
   -- esta variavel dermina quando se deve enciar valores ou quando se deve parar de eviar valores
    SIGNAL OUTPUT_FINAL  :   STD_LOGIC := '0';

  
   
    SIGNAL state : CTG;  --estado signal
    
    
    
    -----------------------------------------------------------
    ------          Declaração de sinais                -------
    -----------------------------------------------------------
    
    -- inicialização de valores e 
    -- A craição de duas matrizes em que guardam os dados previnem o eror4 de multiple driving nets
    -- matriz inicial onde vão ser guardados os valores que são adquirirods
    SIGNAL initial_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000")));   
    -- matriz onde estão os valores adquiridos e onde vão ser realizadas as operações matriciais
    SIGNAL acquire_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
       
    SIGNAL out_matrix : MATRIX_transpose := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 

   
    ----------------------------------------------------------
    ------              Clocks                         -------
    ----------------------------------------------------------
    
    SIGNAL clk_acquisition : STD_LOGIC :='0';
    SIGNAL clk_output      : STD_LOGIC :='0';
  

BEGIN

     
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
    END IF;    
    
    IF (rising_edge(clk)) THEN 
        counter := counter +1;
        if (counter = 12) then
            counter := 0;
            ACQUIRE_FINAL <= '1';
        else 
            ACQUIRE_FINAL <= '0';
        end if;
    end if;
 
    END PROCESS;
    
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
    BEGIN
    IF (rising_edge(clk)) THEN 
        IF(state = ACQUIRE_VALUES) THEN
              --ACQUIRE_FINAL <= '0';
              IF (i < collumns) THEN
              
                    IF(j  < rows) THEN
                        --write your code here..
                        acquired_new := signed(x"00000" & NEW_VALUE);
                        acquire_matrix(j)(i) <= (signed(acquired_new),x"00000000");      --acquired value (Acquired value,0);                                   
                        j:=j+1;                                                                                      --increment the pointer 'j' .
                    END IF; 
            
                    IF(j= rows) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF(j= rows AND i = collumns) THEN
                        i := 0;
                        j := 0;
                        ACQUIRE_FINAL <= '1';
                    ELSE 
                        ACQUIRE_FINAL <= '0';
                    END IF;                                  
            END IF; 
        END IF;   --End of "if( ACQUIRE='1') then" 
    END IF;     
    END PROCESS;




    -----------------------------------------------------------
    -- This process computes the row DFT, the collumns DFT and the product point by point between two matrixs
    -- each process is computed at each clock
    -----------------------------------------------------------
   
    
    PROCESS(clk)
        -- variavel que guarda um coluna de uma matriz de valores pre calculados
        VARIABLE auxiliary_collumn : VECTOR_ROW;
        -- variavel que guarda um linha de uma matriz de valores pre calculados
        VARIABLE auxiliary_row     : VECTOR_COLLUMN;
        -- variavel que guarda o valor de uma coluna da matriz principal
        VARIABLE AUX_collumn_from_acquire_matrix : VECTOR_ROW; 

    BEGIN
             
             
                                                                
--  TESTADO EM PYTHON O QUE EU QUERO FAZER                    x =[[(1+0j), (1+0j), (1+0j)], [(1+0j), (-0.4999999999999998-0.8660254037844387j), (-0.5000000000000004+0.8660254037844384j)], [(1+0j), (-0.5000000000000004+0.8660254037844384j), (-0.4999999999999992-0.8660254037844392j)]]
--                                                            y = [[1,2,3],[1,2,3]]
--                                                            DFT = []
--                                                            for s in range(len(y)):
--                                                                aux= 0
--                                                                for i in range(3):
--                                                                    print("\n")
--                                                                    aux = 0
--                                                                    for j in range(3):
--                                                                      aux = aux + x[i][j]*y[s][j]
--                                                                      print(aux)
--                                                                     DFT.append(aux)
--                                                                   print("\n")       
  --                                                                           
                                                                          
      
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
                    -- extrai os valores de uma coluna da matriz de dados
                   -- AUX_collumn_from_acquire_matrix(j) :=  acquire_matrix(j)(i);                                
                   -- initial_matrix(j)(i) <=  dot_product_collumn(AUX_collumn_from_acquire_matrix, collumn_dft_matrix_values(j));   
                   -- out_matrix <=  initial_matrix;    
                   out_matrix   <= transpose(initial_matrix);    
                END LOOP;
            END LOOP ; 
        END IF;
        
        
        IF(state = COLLUM_DFT) THEN
         -- itera por cada coluna
            FOR i IN 0 TO collumns-1 LOOP 
                -- por cada linha                      
                FOR j IN 0 TO rows-1 LOOP   
                    -- extrai os valores de uma coluna da matriz de dados
                    --AUX_collumn_from_acquire_matrix(j) :=  acquire_matrix(j)(i);                                
                    --initial_matrix(j)(i) <=  dot_product_collumn(AUX_collumn_from_acquire_matrix, collumn_dft_matrix_values(j));   
                    --out_matrix <=  transpose(initial_matrix);    
                   out_matrix(i)(j) <= dot_product_collumn(out_matrix(i), collumn_dft_matrix_values(j));
        
                  -- out_matrix   <= transpose(initial_matrix);    
                END LOOP;
            END LOOP ;                  
        END IF;
        
        end if;
       
        END PROCESS;      
 
 
 
    -----------------------------------------------------------
    -- Output values
    -----------------------------------------------------------
  PROCESS(clk) 
    
    -- são apenas acedidas dentro deste processo e evitam multiple driving nets
    VARIABLE i : integer := 0;   
    VARIABLE j : integer := 0;
    VARIABLE counter : integer := 0;
 
    BEGIN        

            IF (rising_edge(clk)) THEN 
                --OUTPUT_FINAL <= '0';
                IF (i < collumns) THEN
                    IF(j  < rows) THEN        
                        --write your code architecture                              
                         OUT_VALUE <= out_matrix(i)(j).r(2); 
                         --OUT_VALUE_IMAG <= acquire_matrix(i)(j).i(2); 
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
    END IF;   
    
    
    IF (rising_edge(clk)) THEN 
    counter := counter +1;
    if (counter = 12) then
        counter := 0;
        OUTPUT_FINAL <= '1';
    else 
        OUTPUT_FINAL <= '0';
    end if;
    end if;      
    END PROCESS;

    ----------------------------------------------------------
    ------              em consrução              -------
    ----------------------------------------------------------  
    
    -- os seguiets processos alteram os clocks de entrada  e saida 



END behavioral;





