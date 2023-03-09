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

entity teste_acquisition_tb is
--  Port ( );
end teste_acquisition_tb;

architecture Behavioral of teste_acquisition_tb is


signal CLK :  STD_LOGIC := '0';
signal acquire_matrix   : MATRIX   := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
signal reset :  STD_LOGIC := '0';
signal ACQUIRE_FINAL :  STD_LOGIC := '0';
signal NEW_VALUE : STD_LOGIC_VECTOR(11 DOWNTO 0) := x"000" ; 


constant clk_period   : time       := 20 ns;

begin

uut: entity work.teste_acquisition PORT MAP (reset, clk, new_value,acquire_matrix, ACQUIRE_FINAL );   

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
         reset <= '1';
        NEW_VALUE <= x"000";
        wait for clk_period ;    
        NEW_VALUE <= x"001";
        wait for clk_period ;    
        NEW_VALUE <= x"002";
        wait for clk_period ;    
        NEW_VALUE <= x"003";
        wait for clk_period ;    
        NEW_VALUE <= x"004";
        wait for clk_period ;    
        NEW_VALUE <= x"005";
        wait for clk_period ;    
        NEW_VALUE <= x"006";
        reset <= '0';
        wait for clk_period ;    
        NEW_VALUE <= x"007";
        wait for clk_period ;    
        NEW_VALUE <= x"008";
        wait for clk_period ;    
        NEW_VALUE <= x"009";
        wait for clk_period ;    
        NEW_VALUE <= x"00a";
        wait for clk_period ;    
        NEW_VALUE <= x"00b";
        wait for clk_period ;    
         NEW_VALUE <= x"00c";
        NEW_VALUE <= x"000";
        wait for clk_period ;    
        NEW_VALUE <= x"001";
        wait for clk_period ;    
        NEW_VALUE <= x"002";
        wait for clk_period ;    
        NEW_VALUE <= x"003";
        wait for clk_period ;    
        NEW_VALUE <= x"004";
        wait for clk_period ;    
        NEW_VALUE <= x"005";
        wait for clk_period ;    
        NEW_VALUE <= x"006";
        wait for clk_period ;    
        NEW_VALUE <= x"007";
        wait for clk_period ;    
        NEW_VALUE <= x"008";
        wait for clk_period ;    
        NEW_VALUE <= x"009";
        wait for clk_period ;    
        NEW_VALUE <= x"00a";
        wait for clk_period ;    
        NEW_VALUE <= x"00b";
        wait for clk_period ;    
        NEW_VALUE <= x"00c";        
        wait for clk_period ;    
        wait;
    end process; 


end Behavioral;
