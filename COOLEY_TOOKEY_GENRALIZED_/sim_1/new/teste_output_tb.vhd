----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2023 02:17:22 PM
-- Design Name: 
-- Module Name: teste_acquisition_tb - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity teste_output_tb is
--  Port ( );
end teste_output_tb;

architecture Behavioral of teste_output_tb is


signal CLK :  STD_LOGIC := '0';
signal acquire_matrix   : MATRIX_transpose   := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
signal OUT_VALUE_REAL : signed(31 downto 0) := x"00000000";
signal OUT_VALUE_IMAG : signed(31 downto 0) := x"00000000";
signal OUTPUT_FINAL :  STD_LOGIC := '0';

constant clk_period   : time       := 20 ns;

begin

uut: entity work.teste_output PORT MAP (CLK,OUT_VALUE_REAL, OUT_VALUE_IMAG, acquire_matrix, OUTPUT_FINAL );   

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
        acquire_matrix <=
        (((x"00000fff",x"00000000"),(x"00000fff",x"00000000"),(x"00000ff0",x"00000000")),
        ((x"0000ffff",x"00000000"),(x"00000fff",x"00000000"),(x"00000ff0",x"00000000")),
        ((x"0000ffff",x"00000000"),(x"00000fff",x"00000000"),(x"00000ff0",x"00000000")),
        ((x"0000ffff",x"00000000"),(x"00000fff",x"00000000"),(x"00000ff0",x"00000000"))
        );
        
    
        wait for clk_period ;    

        wait for clk_period ;        
    
        wait for clk_period ;        
    
        wait for clk_period ;        
    
        wait for clk_period ;        
    
        wait for clk_period ;        
    
        wait for clk_period ;        
    
        wait for clk_period ;        
    
        wait for clk_period ;         
        wait;
    end process; 


end Behavioral;
