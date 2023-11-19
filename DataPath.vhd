library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DataPath is
  GENERIC(n : integer := 32);
  port( 
        --IPNUTS
        CLK, reset_neg    : in std_logic;
        instruction       : in std_logic_vector(31 downto 0);
        RegDst            : in std_logic;
        Jump              : in std_logic;
        Branch            : in std_logic;
        MemRead           : in std_logic;
        MemToReg          : in std_logic;
        ALUOp             : in std_logic_vector(3 downto 0);
        MemWrite          : in std_logic;
        ALUSrc            : in std_logic;
        RegWrite          : in std_logic;


        next_instruction  : out std_logic_vector(31 downto 0);
        ZeroCarry         : out std_logic );
end DataPath;


architecture Behavioral of DataPath is




component TwoShiftLeft is
  port( 
        input : in std_logic_vector(31 downto 0);
        
        output: out std_logic_vector(31 downto 0) );
end component;







component SignExtender is
  port( 
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0) );
end component;






component TwoToOneMux is
  generic(n: integer);
  port( 
        input_1    : in std_logic_vector(n-1 downto 0);
        input_2    : in std_logic_vector(n-1 downto 0);
        mux_select : in std_logic;
        output     : out std_logic_vector(n-1 downto 0) );
end component;






component DataMem is
  port( 
        CLK            : in std_logic;
        reset_neg      : in std_logic;
        memory_address : in std_logic_vector(n-1 downto 0);
        MemWrite       : in std_logic;
        MemRead        : in std_logic;
        data_in        : in std_logic_vector(n-1 downto 0);

        data_out       : out std_logic_vector(n-1 downto 0) );
end component;






component Registers is
  port( 
        CLK          : in std_logic;
        reset_neg    : in std_logic;
        address_in_1 : in std_logic_vector(4 downto 0);
        address_in_2 : in std_logic_vector(4 downto 0);
        address_out  : in std_logic_vector(4 downto 0);
        write_data   : in std_logic_vector(n-1 downto 0);
        RegWrite     : in std_logic;  

        register_1   : out std_logic_vector(n-1 downto 0);
        register_2   : out std_logic_vector(n-1 downto 0) );
end component;





component ProgCounter is
port( 
      CLK        : in  std_logic;
      reset_neg  : in  std_logic;
      input      : in  std_logic_vector(31 downto 0);
      output     : out std_logic_vector(31 downto 0) );
end component;




component Adder is
  port( 
        oper1 : in  std_logic_vector(n-1 downto 0);
        oper2 : in  std_logic_vector(n-1 downto 0);
        result    : out std_logic_vector(n-1 downto 0) );
end component;




component ALU is
  port( 
        oper1   : in std_logic_vector(n-1 downto 0);
        oper2   : in std_logic_vector(n-1 downto 0);
        ALU_control : in std_logic_vector(3 downto 0);
        result      : out std_logic_vector(n-1 downto 0);
        zero        : out std_logic );
end component;


  constant PC_increment     : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
  signal PC_out             : std_logic_vector(31 downto 0);
  signal MuxToWriteRegister : std_logic_vector(4 downto 0);
  signal SignExtendToSLL    : std_logic_vector(31 downto 0);
  signal SLLToAdder         : std_logic_vector(31 downto 0);
  signal ReadData1ToALU     : std_logic_vector(n-1 downto 0);
  signal ReadData2ToMux     : std_logic_vector(n-1 downto 0);
  signal MuxToALU           : std_logic_vector(n-1 downto 0);
  signal ALUToDataMemory    : std_logic_vector(n-1 downto 0);
  signal DataMemoryToMux    : std_logic_vector(n-1 downto 0);
  signal MuxToWriteData     : std_logic_vector(n-1 downto 0);
  signal AdderToMux         : std_logic_vector(31 downto 0);
  signal MuxToMux           : std_logic_vector(31 downto 0);
  signal MuxToPC            : std_logic_vector(31 downto 0);
  signal Adder1ToMux        : std_logic_vector(31 downto 0);
  signal SLLToMux           : std_logic_vector(31 downto 0);
  signal SLLOut             : std_logic_vector(31 downto 0);
  signal ShiftJump          : std_logic_vector(31 downto 0);

begin

  SLLToMux  <= Adder1ToMux(31 downto 28) & SLLOut(27 downto 0);
  ShiftJump <= "000000" & instruction(25 downto 0);

  Memory        : DataMem     port map(CLK, reset_neg, ALUToDataMemory, MemWrite, MemRead, ReadData2ToMux, DataMemoryToMux);
  ALogicUnit    : ALU            port map(ReadData1ToALU, MuxToALU, ALUOp, ALUToDataMemory, ZeroCarry);

  MuxAlu        : TwoToOneMux            generic map(32) port map(ReadData2ToMux, SignExtendToSLL, ALUSrc, MuxToALU);
  MuxReg        : TwoToOneMux            generic map(5)  port map(instruction(20 downto 16), instruction(15 downto 11), RegDst, MuxToWriteRegister);
  MuxMem        : TwoToOneMux            generic map(32) port map(ALUToDataMemory, DataMemoryToMux, MemToReg, MuxToWriteData);
  MuxBranch     : TwoToOneMux            generic map(32) port map(Adder1ToMux, AdderToMux, Branch, MuxToMux);
  MuxJump       : TwoToOneMux            generic map(32) port map(MuxToMux, SLLToMux, Jump, MuxToPC);
  AdderPC       : Adder          port map(PC_out, PC_increment, Adder1ToMux);
  AdderBranch   : Adder          port map(Adder1ToMux, SLLToAdder, AdderToMux);
  ShifterJump   : TwoShiftLeft     port map(ShiftJump, SLLOut);
  ShifterBranch : TwoShiftLeft     port map(SignExtendToSLL, SLLToAdder);
  ShiftExtend   : SignExtender     port map(instruction(15 downto 0), SignExtendToSLL);
  PC            : ProgCounter port map(CLK, reset_neg, MuxToPC, PC_out);
  Registers1    : Registers      port map(CLK, reset_neg, instruction(25 downto 21), instruction(20 downto 16), MuxToWriteRegister, MuxToWriteData, RegWrite, ReadData1ToALU, ReadData2ToMux);

  next_instruction <= PC_out;
end Behavioral;
