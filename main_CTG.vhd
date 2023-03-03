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
--  https://pt.mouser.com/ProductDetail/Maxim-Integrated/MAX1377ATP%2b?qs=9Cj2FLRihcPsvIFpzghZdg%3D%3D
--  https://www.allaboutcircuits.com/technical-articles/multiplication-examples-using-the-fixed-point-representation/
--  https://redirect.cs.umbc.edu/portal/help/VHDL/math_complex.vhdl
--  https://perso.telecom-paristech.fr/guilley/ENS/20171205/TP/tp_syn/doc/IEEE_VHDL_1076.2-1996.pdf
--  https://vhdlguru.blogspot.com/2010/03/how-to-do-clocked-for-loop.html para o ciclo de aqusição de dados  CLOCKED FOR LOOP
--                                             
----------------------------------------------------------------------------------------------------------------


library IEEE;
library ieee_proposed;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;



ENTITY CTG IS
    Port (
        CLK : IN  STD_LOGIC;
        RESET : IN  STD_LOGIC;           
        NEW_VALUE :IN signed(11 DOWNTO 0);       -- unsigned (12 bits)    0---3.3V
        OUT_VALUE : OUT STD_LOGIC
        --OUT_REAL : OUT signed(11 DOWNTO 0);
        --OUT_IMAG: OUT signed(11 DOWNTO 0)
         );
END CTG;



ARCHITECTURE Behavioral OF CTG IS 
  
    TYPE CTG            IS ( ACQUIRE_VALUES, ROWS_DFT, MULTIPLY_TWIDDLES, COLLUM_DFT, OUT_VALUES);   --estados
    
    
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
    
    SIGNAL state : CTG;  --estado inicial
    
    -- inicialização de valores e 
    -- A craição de duas matrizes em que guardam os dados previnem o eror4 de multiple driving nets
    SIGNAL initial_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000")));   -- Devo fazer uma matriz para cada estado ou actualizar sempre a mesma matriz? eu tentei a segunda opção mas estava me a dar erros de double assignment
    signal acquire_matrix : MATRIX := (OTHERS => (OTHERS => (x"00000000", x"00000000")));    -- matriz onde estão os valores adquiridos
    SIGNAL sum_of_factors : Complex_Type :=                 (x"00000000", x"00000000");
    
    
    
    
    --variaveis iteradoras
    SIGNAL i : INTEGER := 0;    -- linhas
    SIGNAL j : INTEGER := 0;    -- colunas
    
    -- variaveis da Finite State Machine
    SIGNAL ACQUIRE_FINAL :   STD_LOGIC := '0';
    SIGNAL OUTPUT_FINAL  :   STD_LOGIC := '0';

    
    ----------------------------------------------------------
    ------              Clocks                         -------
    ----------------------------------------------------------
    
    SIGNAL clk_acquisition : STD_LOGIC :='0';
    SIGNAL clk_output     : STD_LOGIC :='0';
  

BEGIN

    PROCESS(clk) IS                       
    Variable state_at: integer := 0;
    BEGIN
    
        IF rising_edge(CLK) THEN
        
        -- Reset values with switch
            IF RESET = '0' THEN    
                ACQUIRE_FINAL <= '0';  
                OUTPUT_FINAL  <= '0';        
                i<=0;
                j<=0;    
                State   <= ACQUIRE_VALUES;
                OUT_VALUE<= '1';
                ELSE                       

                
                    --FINITE STATE MACHINE
                        CASE State IS                        
                            --acquire values collumn wise
                            WHEN ACQUIRE_VALUES => 
                                STATE_at := 1;
                                IF ACQUIRE_FINAL= '1' THEN                                       
                                     ACQUIRE_FINAL <= '0'; 
                                     State         <= ROWS_DFT; 
                                END iF;                        
                            -- Calcula a DFT de cada linha
                            WHEN ROWS_DFT =>
                                 STATE_at := 2;
                                State <= MULTIPLY_TWIDDLES;                                         
                            -- Multiplica a matriz anterior pelos twiddle factors   
                            WHEN MULTIPLY_TWIDDLES =>   
                                STATE_at := 3;               
                                State <= COLLUM_DFT;                                                                                                                               
                            --Calcula a DFT de cada coluna
                            WHEN COLLUM_DFT =>                                          
                                --OUTPUT_START <= '1';
                                State <= OUT_VALUES;                    
                            -- Outputs the values                 
                            WHEN OUT_VALUES =>   
                                IF OUTPUT_FINAL = '1' THEN  
                                    State <= ACQUIRE_VALUES; 
                                    OUTPUT_FINAL <= '0';
                                END iF;
                          
                        END CASE;
                        
                END IF;
        END if;
    END PROCESS;
    

    
    
    
    
    ------------------------------------------------------------
    -- acquire a value at each clock cycle
    --adapted from:
                    --https://vhdlguru.blogspot.com/2010/03/how-to-do-clocked-for-loop.html
    ------------------------------------------------------------
    
    PROCESS(clk) 
    VARIABLE i : integer := 0;
    VARIABLE j : integer := 0;
    variable acquired_new : signed(31 downto 0);
    BEGIN
    IF (rising_edge(clk)) THEN 
        IF(state = ACQUIRE_VALUES) THEN
              --ACQUIRE_FINAL <= '0';
              IF (i < rows) THEN
              
                    IF(j  < collumns) THEN
                        --write your code here..
                        acquired_new := x"00000" & NEW_VALUE;
                        acquire_matrix(i)(j)<=  (signed(acquired_new),x"00000000");      --acquired value (Acquired value,0);                                   
                        j:=j+1;                                                                                      --increment the pointer 'j' .
                    END IF; 
            
                    IF(j= collumns) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;  
                                 
                    IF(j= collumns AND i = rows) THEN
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
    -- Row DFT
    -----------------------------------------------------------
    
    --ESTA PARTE NÂO ESTA A AFZER O QUE EU QUERO
    
    
    
    PROCESS(clk)
    
    VARIABLE auxliary_variable : Complex_Type;
    VARIABLE auxiliary_collumn : VECTOR_ROW;

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
             
      
        IF(state = ROWS_DFT) THEN
            -- por cada linha 
            FOR i IN 0 TO rows-1 LOOP   
               -- itera por cada coluna              
                FOR j IN 0 TO rows-1 LOOP                            
                      initial_matrix(j)(i) <= dot_product_row(acquire_matrix(i), row_dft_matrix_values(i));
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
        
         
        IF(state = COLLUM_DFT) THEN
           -- itera por cada coluna
            FOR i IN 0 TO collumns-1 LOOP 
            
                -- por cada linha                      
                FOR j IN 0 TO rows-1 LOOP   
                           -- extrai os valores de uma coluna
                         auxiliary_collumn(j)  := acquire_matrix(j)(i);                                
                         initial_matrix(j)(i)  <= dot_product_collumn(auxiliary_collumn, collumn_dft_matrix_values(j));
                END LOOP;
            END LOOP ;      
        END IF;
       
        END PROCESS;      
 
 
 
    -----------------------------------------------------------
    -- Output values
    -----------------------------------------------------------

    PROCESS(clk) 
    
    -- são apenas acedidas dentro deste processo e evitam multiple driving nets
    VARIABLE i : integer := 0;   
    VARIABLE j : integer := 0;
    
    BEGIN        
        IF(state = OUT_VALUES) THEN

            IF (rising_edge(clk)) THEN 
                --OUTPUT_FINAL <= '0';
                IF (i < rows) THEN
                    IF(j  < collumns) THEN        
                        --write your code architecture                              
                         OUT_VALUE <= initial_matrix(i)(j).r(9);   
                         --juntar output real & complex de forma a fazer  
                    END IF;
                    IF(j= collumns) THEN
                        i:=i+1;   --increment the pointer 'i' when j reaches its maximum value.
                        j:=0;    --reset j to zero.
                    END IF;
                    
                     IF(j= collumns AND i = rows) THEN
                        i := 0;
                        j := 0;
                        OUTPUT_FINAL <= '1';
                     ELSE 
                        OUTPUT_FINAL <= '0';
                    
                    END IF;
                END IF;   
        END IF;
    END IF;         
    END PROCESS;










    ----------------------------------------------------------
    ------              em consrução              -------
    ----------------------------------------------------------  
    
    -- os seguiets processos alteram os clocks de entrada  esaida e tmb posso entity work.CTG
    --


    ----------------------------------------------------------
    ------              Acquisiton Clock               -------
    ----------------------------------------------------------  
    
     --clk generation.For 100 MHz clock this generates 1 Hz clock.
    process(clk)
        VARIABLE counter_ack : integer := 0;  
        BEGIN
        IF(rising_edge(clk)) then
            counter_ack :=counter_ack+1;
            if(counter_ack = acquisition_clock_counter) then
                clk_acquisition <= not clk_acquisition;
                counter_ack :=0;
             else
                clk_acquisition <= '0';
        end if;
    end if;
    end process;
    
      ----------------------------------------------------
      ------              Output Clock               -----
      ----------------------------------------------------
    
      
     --clk generation.For 100 MHz clock this generates 1 Hz clock.
    process(clk)
        VARIABLE counter_output : integer := 0;  
        BEGIN
        IF(rising_edge(clk)) then
            counter_output :=counter_output+1;
            if(counter_output = acquisition_clock_counter) then
                clk_output <= not clk_output;
                counter_output :=0;
             else
                clk_output <= '0';
        end if;
    end if;
    end process;

    END behavioral;





