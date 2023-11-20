

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ControlCode is
    GENERIC (n : integer := 32);
    Port( CLK, reset_neg : in std_logic );
end ControlCode;

architecture Behavioral of ControlCode is

component ControlUnit is
    port( -- input
        instruction : in std_logic_vector(31 downto 0);
        ZeroCarry   : in std_logic;
        
        -- output (control signals)
        RegDst      : out std_logic;
        Jump        : out std_logic;
        Branch      : out std_logic;
        MemRead     : out std_logic;
        MemToReg    : out std_logic;
        ALUOp       : out std_logic_vector (3 downto 0);  -- 9 operations
        MemWrite    : out std_logic;
        ALUSrc      : out std_logic;
        RegWrite    : out std_logic );
        end component;

component DataPath is
    port( -- inputs
        CLK, reset_neg    : in std_logic;
        instruction       : in std_logic_vector(31 downto 0);
        -- control signals
        RegDst            : in std_logic;
        Jump              : in std_logic;
        Branch            : in std_logic;
        MemRead           : in std_logic;
        MemToReg          : in std_logic;
        ALUOp             : in std_logic_vector(3 downto 0);
        MemWrite          : in std_logic;
        ALUSrc            : in std_logic;
        RegWrite          : in std_logic;
        
        -- outputs
        next_instruction  : out std_logic_vector(31 downto 0);
        ZeroCarry         : out std_logic );
    end component;


component InstructionMemory is
    port( -- input
        register_addr : in  std_logic_vector(31 downto 0);
        
        -- output
        instruction   : out std_logic_vector(31 downto 0) );
end component;

signal RegDst_TL, Jump_TL, Branch_TL, MemRead_TL, MemToReg_TL : std_logic;
signal MemWrite_TL, ALUSrc_TL, RegWrite_TL , ZeroCarry_TL : std_logic;
signal ALUOp_TL : std_logic_vector(3 downto 0);
signal NextInstruction, instr : std_logic_vector(31 downto 0);


begin
CU : ControlUnit  port map( instr,
ZeroCarry_TL,
RegDst_TL,
Jump_TL,
Branch_TL,
MemRead_TL,
MemToReg_TL,
ALUOp_TL,
MemWrite_TL,
ALUSrc_TL,
RegWrite_TL );

DP : DataPath     port map( CLK,
reset_neg,
instr,
RegDst_TL,
Jump_TL,
Branch_TL,
MemRead_TL,
MemToReg_TL,
ALUOp_TL,
MemWrite_TL,
ALUSrc_TL,
RegWrite_TL,
NextInstruction,
ZeroCarry_TL );


I  : InstructionMemory  port map( NextInstruction, instr );

end Behavioral;
