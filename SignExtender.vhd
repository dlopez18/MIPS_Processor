
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SignExtender is
    port( input  : in STD_LOGIC_VECTOR(15 DOWNTO 0);
        output : out STD_LOGIC_VECTOR(31 DOWNTO 0) );
end SignExtender;

architecture  Behavioral of SignExtender is

begin
output <= "0000000000000000" & input when (input(15) = '0') else
           "1111111111111111" & input;

end Behavioral;
