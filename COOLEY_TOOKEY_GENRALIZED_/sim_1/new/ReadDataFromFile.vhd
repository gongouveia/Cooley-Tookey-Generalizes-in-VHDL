-----------/home/gpaiva/Documents

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.Packages_Util.all;

use std.textio.all;

entity ReadDataFromFile is
end ReadDataFromFile;

architecture ReadDataFromFile_rtl of ReadDataFromFile is
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
    
    
   constant C_FILE_NAME :string  := "/home/gpaiva/Documents/FFT_generalized_VHDL/VScode/output.dat";
   constant C_DATA1_W   :integer := 12;
   constant C_CLK       :time    := 10 ns;

   signal rst           :std_logic := '0';
   signal data1         :std_logic_vector(C_DATA1_W-1 downto 0);

   file fptr: text;

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
                     
                     
ClockGenerator: process
begin
   clk <= '0' after C_CLK, '1' after 2*C_CLK;
   wait for 2*C_CLK;
end process;

--rst <= '1', '0' after 100 ns;

GetData_proc: process

   variable fstatus       :file_open_status;
   
   variable file_line     :line;
   variable var_data1     :std_logic_vector(C_DATA1_W-1 downto 0);
   
begin

   data1     <= (others => '0');
   var_data1 := (others => '0');


   --wait until rst = '0';

   file_open(fstatus, fptr, C_FILE_NAME, read_mode);

   while (not endfile(fptr)) loop

      readline(fptr, file_line);
      hread(file_line, var_data1);
      data1      <= var_data1;
      NEW_VALUE      <= var_data1;

      if endfile(fptr) then
      
        file_close(fptr);
        file_open(fstatus, fptr, C_FILE_NAME, read_mode);

      
      end if;
      wait until clk = '1';
   end loop;
   
    data1      <= x"000";
    file_close(fptr);
   
   
end process;

end ReadDataFromFile_rtl;
