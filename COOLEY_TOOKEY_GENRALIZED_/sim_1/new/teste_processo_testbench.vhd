----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/06/2023 10:49:52 PM
-- Design Name: 
-- Module Name: teste_processo_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;      -- going to use to convert std vector to unsigned

use work.Packages_Util.all;


entity teste_processo_testbench is
--  Port ( );
end teste_processo_testbench;

architecture Behavioral of teste_processo_testbench is

signal CLK :  STD_LOGIC;
signal acquire_matrix      : MATRIX       := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
signal out_matrix          : MATRIX_transpose       := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
signal INITIAL_MATRIX      : MATRIX       := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
SIGNAL   twiddle_matrix_values :  MATRIX  := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
signal ALGO_FINAL : std_logic := '0';
signal process_counter : integer := 0;
constant clk_period      : time    := 20 ns;
signal reset : std_logic := '0';

begin

uut: entity work.teste_processo PORT MAP (reset,clk,acquire_matrix, out_matrix,twiddle_matrix_values,initial_matrix,ALGO_FINAL , process_counter);   


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
            reset <= '0';

           acquire_matrix <=    (((x"00000fff",x"00000000"),(x"00000fff",x"00000000"),(x"00000fff",x"00000000"),(x"00000fff",x"00000000")),
                             ((x"0000ffff",x"00000000"),(x"00000fff",x"00000000"),(x"00000fff",x"00000000"),(x"00000fff",x"00000000" )),
                             ((x"00000fff",x"00000000"),(x"00000fff",x"00000000"),(x"00000fff",x"00000000"),(x"00000fff",x"00000000")));
        wait for clk_period ;
            reset <= '0';

        --first set of inputs..
       
        wait for clk_period ;        --second set of inputs can be given here and so on.
         
        wait for clk_period ;
        wait for clk_period ;
        wait for clk_period ;
        wait for clk_period ;
        wait for clk_period ;
        wait for clk_period ;
        wait for clk_period ;
        wait for clk_period ;
        wait for 3*clk_period ; 
        reset<= '1';
 
        wait for 3*clk_period ;  
        --reset <= '1';
        wait;
    end process; 
    

end Behavioral;
