--ARETHMIC LOGIC UNIT

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity ALU is
   
  GENERIC(n : integer := 32);
  Port( 
        oper1   : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        oper2   : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        ALU_control : IN STD_LOGIC_VECTOR(3 DOWNTO 0); 

        result      : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
        zero        : OUT STD_LOGIC );
end ALU;

architecture Behavioral of ALU is
  signal temp : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
begin

    --CONTROL FOR THE ALU
    --ADD, SUB, AND, OR, NOR, NAND, XOR, SLL, SRL
  temp <=
    -- ADD CONTROL
    STD_LOGIC_VECTOR(UNSIGNED(oper1) + UNSIGNED(oper2)) after 1 ns when ALU_control = "0000" else
    -- SUBTRACT CONTROL
    STD_LOGIC_VECTOR(UNSIGNED(oper1) - UNSIGNED(oper2)) after 1 ns when ALU_control = "0001" else
    -- AND GATE
    oper1 AND  oper2 after 1 ns when ALU_control = "0010" else
    -- OR GATE
    oper1 OR   oper2 after 1 ns when ALU_control = "0011" else
    -- NOR GATE
    oper1 NOR  oper2 after 1 ns when ALU_control = "0100" else
    -- NAND GATE
    oper1 NAND oper2 after 1 ns when ALU_control = "0101" else
    -- XOR GATE
    oper1 XOR  oper2 after 1 ns when ALU_control = "0110" else
    -- SLL
    STD_LOGIC_VECTOR(shift_left(UNSIGNED(oper1), to_integer(UNSIGNED(oper2(10 DOWNTO 6))))) after 1 ns when ALU_control = "0111" else
    -- SRL
    STD_LOGIC_VECTOR(shift_right(UNSIGNED(oper1), to_integer(UNSIGNED(oper2(10 DOWNTO 6))))) after 1 ns when ALU_control = "1000" else
    (others => '0');

  zero <= '1' when (temp <= "00000000000000000000000000000000") else '0';
  result <= temp;

end Behavioral;
