
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TwoShiftLeft is
port( 
        input  : in STD_LOGIC_VECTOR(31 DOWNTO 0);
        output : out STD_LOGIC_VECTOR(31 DOWNTO 0) );
end TwoShiftLeft;

architecture Behavioral of TwoShiftLeft is

begin
    output <= STD_LOGIC_VECTOR(UNSIGNED(input) sll 2);

end Behavioral;
