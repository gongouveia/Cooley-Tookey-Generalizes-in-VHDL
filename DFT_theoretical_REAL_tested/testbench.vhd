

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.fixed_pkg.all;


library work;
use work.packages_Util.all;

ENTITY mat_tb IS
END mat_tb;

ARCHITECTURE behavior OF mat_tb IS
    --signals declared and initialized to zero.
    signal clk : std_logic := '0';
    signal a : COLLUMN_VECTOR:=(others =>  (others =>  0.0));
    --signal prod : COLLUMN_VECTOR_OUTPUT:=(others =>  (others =>     "000000000000000000000000000000000000000000000000"));
   signal DFT : COLLUMN_VECTOR:=(others =>  (others =>       0.0));

    signal twiddles : COLLUMN_MATRIX:=(others =>  (others => (others => 0.0)));


    constant clk_period : time := 0.5 ns;

BEGIN
        -- Instantiate the Unit Under Test (UUT)
        uut: entity work.main PORT MAP (
                                        clk => clk,
                                        a=>a,
                                        twiddles=>twiddles,
                                        DFT=>DFT
                                        );   
            -- Clock process definitions
        clk_process :process
        
        begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
        end process;
    
        -- Stimulus process
        stim_proc: process
        begin
            --first set of inputs..
            a <= ((1.0,0.0),(2.0,0.0),(3.0,0.0),(4.0,0.0));
            wait for 0.5 ns;
            --second set of inputs can be given here and so on.
           
        end process;

END;