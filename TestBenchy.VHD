

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestBenchy is
--  Port ( );
end TestBenchy;

architecture Behavioral of TestBenchy is
  
  constant CLK_low    : time := 12 ns;
  constant CLK_high   : time := 8 ns;
  constant CLK_period : time := CLK_low + CLK_high;
  constant ResetTime  : time := 10 ns;

  
  signal clock , reset : std_logic;
  signal count         : std_logic_vector(10 downto 0);
  
  
  
  component ControlCode is
  port( CLK, reset_neg  : in std_logic );
  end component;


    begin
  dut : ControlCode port map ( clock, reset );

  -- reset
  reset_process : process
  begin
    reset <= '0';
    wait for ResetTime;
    reset <= '1';
    wait;
  end process reset_process;

  clock_process : process
  begin
    if (clock = '0') then
      clock <= '1';
      wait for CLK_high;
    else
      clock <= '0';
      wait for CLK_low;
      count <= std_logic_vector(unsigned(count) + 1);
    end if;
  end process clock_process;


end Behavioral;
