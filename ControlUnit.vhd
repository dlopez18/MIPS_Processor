

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlUnit is
port(   instruction : in std_logic_vector(31 downto 0);
        ZeroCarry   : in std_logic;
        RegDst      : out std_logic;
        Jump        : out std_logic;
        Branch      : out std_logic;
        MemRead     : out std_logic;
        MemToReg    : out std_logic;
        ALUOp       : out std_logic_vector (3 downto 0);  
        MemWrite    : out std_logic;
        ALUSrc      : out std_logic;
        RegWrite    : out std_logic );
end ControlUnit;

architecture Behavioral of ControlUnit is
signal data : std_logic_vector(11 downto 0);  --CONTROL SIGNAL
begin

  -- ADD
  data <= "100000000001" when (instruction(31 downto 26) = "000000" and
                               instruction(10 downto 0)  = "00000100000") else
  -- SUB
  "100000001001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100010") else
  -- AND
  "100000010001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100100") else
  -- OR
  "100000011001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100101") else
  -- NOR
  "100000100001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000100111") else
  -- XOR
  "100000110001" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "100110") else
  -- SLL
  "100000111011" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "000000") else
  -- SRR
  "100001000011" when (instruction(31 downto 26) = "000000" and
                       instruction(5 downto 0)   = "000010") else
  -- SLT
  "100001001001" when (instruction(31 downto 26) = "000000" and
                       instruction(10 downto 0)  = "00000101010") else
  -- ADDI
  "000000000011" when instruction(31 downto 26) = "001000" else
  -- LW
  "000110000011" when instruction(31 downto 26) = "100011" else
  -- SW
  "000000000110" when instruction(31 downto 26) = "101011" else
  -- ANDI
  "000000010011" when instruction(31 downto 26) = "001100" else
  -- ORI
  "000000011011" when instruction(31 downto 26) = "001101" else
  -- BEQ
  "001000001000" when instruction(31 downto 26) = "000100" else
  -- BENQ
  "001000110010" when instruction(31 downto 26) = "000101" else
  -- SLTI
  "000001001011" when instruction(31 downto 26) = "001010" else
  -- JMP
  "010000000000" when instruction(31 downto 26) = "000010" else
  -- OTHER
  (others =>'0');

  RegDst   <= data(11);
  Jump     <= data(10);
  -- AND port included considering the LSB of beq and bne
  Branch   <= data(9) AND (ZeroCarry XOR instruction(26));
  MemRead  <= data(8);
  MemToReg <= data(7);
  ALUOp    <= data(6 downto 3);  -- 9 operations available
  MemWrite <= data(2);
  ALUSrc   <= data(1);
  RegWrite <= data(0);

end Behavioral;
