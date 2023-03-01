

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


library work;
use work.packages_Util.all;

ENTITY mat_tb IS
END mat_tb;

ARCHITECTURE behavior OF mat_tb IS
    --signals declared and initialized to zero.
    signal clk : std_logic := '0';
    signal a : COLLUMN_VECTOR:=(others =>  (others =>        "000000000000000000000000"));
    --signal prod : COLLUMN_VECTOR_OUTPUT:=(others =>  (others =>     "000000000000000000000000000000000000000000000000"));
   signal DFT : COLLUMN_VECTOR:=(others =>  (others =>        "000000000000000000000000"));

    signal twiddles : COLLUMN_MATRIX:=(others =>  (others => (others => "000000000000000000000000")));


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
            a <= ((x"001000",x"000000"),(x"002800",x"000000"),(x"007000",x"000000"),(x"004000",x"000000"));
            wait for 0.5 ns;
            --second set of inputs can be given here and so on.
           
        end process;

END;