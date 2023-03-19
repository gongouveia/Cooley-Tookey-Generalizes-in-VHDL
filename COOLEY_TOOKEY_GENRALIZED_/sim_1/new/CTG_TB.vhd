
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.Packages_Util.all;

entity CTG_tb is
end;

architecture bench of CTG_tb is


  component CTG
      Port (
          CLK : IN  STD_LOGIC;
          RESET : IN  STD_LOGIC;           
          NEW_VALUE :IN STD_LOGIC_VECTOR(11 DOWNTO 0);
          OUT_VALUE : OUT STD_LOGIC;
          --STATE_at : out INTEGER       
          acquire_matrix : OUT MATRIX ;
          out_matrix : OUT MATRIX_transpose;
          state_at : OUT integer;
          OUT_VALUE_REAL: out signed(31 DOWNTO 0); 
          OUT_VALUE_IMAG : out signed(31 DOWNTO 0) ;
        counter_total : out INTEGER

           );
  end component;

    signal CLK: STD_LOGIC := '0';
    signal RESET: STD_LOGIC := '0';
    signal NEW_VALUE: STD_LOGIC_VECTOR(11 DOWNTO 0) := x"000";
    signal OUT_VALUE: STD_LOGIC := '1';
    constant clock_period: time := 10 ns;
    signal acquire_matrix   : MATRIX   := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
    signal out_matrix   : MATRIX_transpose   := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
    signal state_at: integer := 0;
    signal counter_total: integer := 0;
    signal OUT_VALUE_REAL : SIGNED(31 downto 0) := x"00000000";
    signal OUT_VALUE_IMAG : SIGNED(31 downto 0) := x"00000000";
    
    
    begin

    uut: CTG port map ( CLK       => CLK,
                      RESET     => RESET,
                      NEW_VALUE => NEW_VALUE,
                      OUT_VALUE => OUT_VALUE,
                      acquire_matrix => acquire_matrix,
                      out_matrix => out_matrix,
                      state_at => state_at,
                      OUT_VALUE_REAL => OUT_VALUE_REAL,
                      OUT_VALUE_IMAG => OUT_VALUE_IMAG,
                      counter_total => counter_total
                     );
    
      stimulus: process
      begin
            
             NEW_VALUE <=  x"aaa";
             wait for 12*clock_period;
             RESET <= '1';
             wait for 3*clock_period;
             NEW_VALUE <=  x"fff";
             RESET <='0';            
      
             NEW_VALUE <=  x"fff";
    
            -- Put initialisation code here
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";     
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"7ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"f5f";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"ff7";
            wait for clock_period;
            NEW_VALUE <=  x"fff";-----first
            wait for 10*clock_period;
            NEW_VALUE <=  x"000";
            wait for clock_period;
            NEW_VALUE <=  x"001";
            wait for clock_period;
            NEW_VALUE <=  x"002";
            wait for clock_period;
            NEW_VALUE <=  x"003";
            wait for clock_period;
            NEW_VALUE <=  x"004";
            wait for clock_period;
            NEW_VALUE <=  x"000"; -- primeira entrada
            wait for clock_period;
            NEW_VALUE <=  x"008";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"0ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"0ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            wait for clock_period;
            NEW_VALUE <=  x"213";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            wait for clock_period;
            NEW_VALUE <=  x"412";
            wait for clock_period;
            NEW_VALUE <=  x"513";
            wait for clock_period;
            NEW_VALUE <=  x"0ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            wait for clock_period;
            NEW_VALUE <=  x"412";
            wait for clock_period;
            NEW_VALUE <=  x"513";
            wait for clock_period;
            NEW_VALUE <=  x"0ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"0ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            wait for clock_period;
            NEW_VALUE <=  x"213";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            wait for clock_period;
            NEW_VALUE <=  x"412";
            wait for clock_period;
            NEW_VALUE <=  x"513";
            wait for clock_period;
            NEW_VALUE <=  x"0ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
            wait for clock_period;
            NEW_VALUE <=  x"412";
            wait for clock_period;
            NEW_VALUE <=  x"513";
            wait for clock_period;
            NEW_VALUE <=  x"0ff";
            wait for clock_period;
            NEW_VALUE <=  x"fff";
            wait for clock_period;
            NEW_VALUE <=  x"2ff";
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
      
