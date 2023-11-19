
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TwoToOneMux is
    GENERIC(n : integer := 32);
    Port(
        Val1    : in std_logic_vector(n - 1 downto 0);
        Val2    : in std_logic_vector(n - 1 downto 0);
        mux_selecty : in std_logic;
        output     : out std_logic_vector(n - 1 downto 0) );
end TwoToOneMux;

architecture Behavioral of TwoToOneMux is
begin
with mux_selecty select
  output <= Val1 when '0', Val2 when others;
end Behavioral;
