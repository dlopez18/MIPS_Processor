

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ProgCounter is
Port( 
      CLK        : IN  STD_LOGIC;
      reset_neg  : IN  STD_LOGIC;
      input      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
      output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
end ProgCounter;

architecture Behavioral of ProgCounter is
begin
PROCESS(CLK)
  BEGIN
    IF reset_neg = '0' THEN
      output <= (OTHERS => '0' );
    ELSIF RISING_EDGE(CLK) then
      output <= input;
    END IF;
  END PROCESS;

end Behavioral;
