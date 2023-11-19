

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Registers is
GENERIC(n : integer := 32);
  Port( CLK          : in STD_LOGIC;
        reset_neg    : in STD_LOGIC;
        address_in_1 : in STD_LOGIC_VECTOR(4 downto 0);
        address_in_2 : in STD_LOGIC_VECTOR(4 downto 0);
        address_out  : in STD_LOGIC_VECTOR(4 downto 0);
        write_data   : in STD_LOGIC_VECTOR(n-1 downto 0);
        RegWrite     : in STD_LOGIC;  

        register_1   : out STD_LOGIC_VECTOR(n-1 downto 0);
        register_2   : out STD_LOGIC_VECTOR(n-1 downto 0) );
end Registers;

architecture Behavioral of Registers is
    type   regg is array (0 to 31) of std_logic_vector(n - 1 downto 0);
    signal reg : regg := ((others => (others => '0')));
    
    
begin
    process(CLK)
      begin
        if reset_neg = '0' then -- reset
          reg(to_integer(unsigned(address_out))) <= (others => '0');
          else if rising_edge(CLK) and RegWrite = '1' then
            reg(to_integer(unsigned(address_out))) <= write_data;
          end if;
        end if;
    end process;

  register_1 <= reg(to_integer(unsigned(address_in_1)));  -- read in address 1
  register_2 <= reg(to_integer(unsigned(address_in_2)));  -- read in address 2

end Behavioral;
