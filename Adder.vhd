
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Adder is
  GENERIC(n : integer := 32);
  Port( 
        oper1 : IN  std_logic_vector(n-1 downto 0);
        oper2 : IN  std_logic_vector(n-1 downto 0);
        result    : out std_logic_vector(n-1 downto 0) );
end Adder;

architecture Behavioral of Adder is
begin

  result <= std_logic_vector(unsigned(oper1) + unsigned(oper2));

end Behavioral;
