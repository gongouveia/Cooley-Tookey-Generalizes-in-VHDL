
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
  --        RESET : IN  STD_LOGIC;           
          NEW_VALUE :IN STD_LOGIC_VECTOR(11 DOWNTO 0);
          OUT_VALUE : OUT STD_LOGIC;
          --STATE_at : out INTEGER
          ACQUIRE_FINAL : OUT STD_LOGIC;
          OUTPUT_FINAL : OUT STD_LOGIC;
          ALGO_FINAL :OUT STD_LOGIC;
          acquire_matrix : OUT MATRIX ;
          out_matrix : OUT MATRIX_transpose;
          state_at : OUT integer;
          OUT_VALUE_REAL: out signed(31 DOWNTO 0); 
          OUT_VALUE_IMAG : out signed(31 DOWNTO 0) ;
        counter_total : out INTEGER

           );
  end component;

  signal CLK: STD_LOGIC := '0';
 -- signal RESET: STD_LOGIC := '0';
  signal NEW_VALUE: STD_LOGIC_VECTOR(11 DOWNTO 0) := x"000";
  signal OUT_VALUE: STD_LOGIC := '1';
  constant clock_period: time := 10 ns;
  signal ACQUIRE_FINAL: STD_LOGIC := '0';
  signal OUTPUT_FINAL: STD_LOGIC := '0';
  signal ALGO_FINAL: STD_LOGIC := '0';

  signal acquire_matrix   : MATRIX   := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
  signal out_matrix   : MATRIX_transpose   := (OTHERS => (OTHERS => (x"00000000", x"00000000"))); 
   signal state_at: integer := 0;

  signal counter_total: integer := 0;
signal OUT_VALUE_REAL : SIGNED(31 downto 0) := x"00000000";
signal OUT_VALUE_IMAG : SIGNED(31 downto 0) := x"00000000";
begin

  uut: CTG port map ( CLK       => CLK,
               --       RESET     => RESET,
                      NEW_VALUE => NEW_VALUE,
                      OUT_VALUE => OUT_VALUE,
                      ACQUIRE_FINAL => ACQUIRE_FINAL,
                      OUTPUT_FINAL => OUTPUT_FINAL,
                      ALGO_FINAL => ALGO_FINAL,
                      acquire_matrix => acquire_matrix,
                      out_matrix => out_matrix,
                      state_at => state_at,
                      OUT_VALUE_REAL => OUT_VALUE_REAL,
                      OUT_VALUE_IMAG => OUT_VALUE_IMAG,
                      counter_total => counter_total
                     );

  stimulus: process
  begin
       NEW_VALUE <=  x"fff";

    -- Put initialisation code here
       wait for clock_period;
           NEW_VALUE <=  x"fff";
   
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
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
              wait for clock_period;
 NEW_VALUE <=  x"fff";
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
       wait for clock_period;

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
  