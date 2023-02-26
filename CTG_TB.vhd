
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity CTG_tb is
end;

architecture bench of CTG_tb is

  component CTG
      Port (
          CLK : IN  STD_LOGIC;
          RESET : IN  STD_LOGIC;           
          NEW_VALUE :IN STD_LOGIC_VECTOR(11 DOWNTO 0);
          OUT_VALUE : OUT std_logic
           );
  end component;

  signal CLK: STD_LOGIC := '0';
  signal RESET: STD_LOGIC := '0';
  signal NEW_VALUE: STD_LOGIC_VECTOR(11 DOWNTO 0);
  signal OUT_VALUE: std_logic ;

  constant clock_period: time := 10 ns;




begin

  uut: CTG port map ( CLK       => CLK,
                      RESET     => RESET,
                      NEW_VALUE => NEW_VALUE,
                      OUT_VALUE => OUT_VALUE );

  stimulus: process
  begin
  
    -- Put initialisation code here
       RESET <= '1';
       wait for clock_period;
       NEW_VALUE <=  "000000000001";
       wait for clock_period;
       NEW_VALUE <=  "000000000011";
       wait for clock_period;
       NEW_VALUE <=  "000000000111";
       wait for clock_period;
       NEW_VALUE <=  "000000001111";       
       wait for clock_period;
       NEW_VALUE <=  "000000000001";
       wait for clock_period;
       NEW_VALUE <=  "000000000011";
       wait for clock_period;
       NEW_VALUE <=  "000000000111";
       wait for clock_period;
       NEW_VALUE <=  "000000001111";   
       wait for clock_period;
       NEW_VALUE <=  "000000000001";
       wait for clock_period;
       NEW_VALUE <=  "000000000011";
       wait for clock_period;
       NEW_VALUE <=  "000000000111";
       wait for clock_period;
       NEW_VALUE <=  "111111111111"; 
 
    wait;
  end process;

 

    -- continuous clock
    process 
    begin
        clk <= '0';
        wait for clock_period/2;
        clk <= '1';
        wait for clock_period/2;
    end process;
end;
  