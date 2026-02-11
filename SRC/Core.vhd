library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ! Code Not tested yet
-- ! Test it first you fool

-- ! Temporaray Variables:
-- !    sel_mux in Mux_PC set to '0'
-- !    in_mux1 in Mux_PC set to (others => '0')
-- !    hazard signal set to '0'
-- !    rd_write_en in RF set to '0'
-- !    rd_addr and rd_data in RF set to (others => '0')

entity Core is
    port (
        clk             : in std_logic;
        rst             : in std_logic
    );
end entity Core;

architecture rtl of Core is
    
    component Mux_2to1 is
    port (
        sel_mux         : in std_logic;
        in_mux0         : in std_logic_vector(31 downto 0);
        in_mux1         : in std_logic_vector(31 downto 0);
        out_mux         : out std_logic_vector(31 downto 0)
    );
    end component;

    component PC is
    port (
        clk              : in std_logic;
        rst              : in std_logic;
        address_in       : in std_logic_vector(31 downto 0);
        address_out      : out std_logic_vector(31 downto 0)
    );
    end component;

    component Adder is
    port (
        in_0            : in std_logic_vector(31 downto 0);
        in_1            : in std_logic_vector(31 downto 0);
        out_sum         : out std_logic_vector(31 downto 0)
    );
    end component;

    component Progmem is
    port (
        rst             : in std_logic;
        address_in      : in std_logic_vector(31 downto 0);
        instr_out       : out std_logic_vector(31 downto 0)
    );
    end component;

    component State_IF_ID is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        hazard          : in std_logic;
        -- Input Fetch
        instr_in        : in std_logic_vector(31 downto 0);
        instr_addr_in   : in std_logic_vector(31 downto 0);

        -- output Decode
        instr_out       : out std_logic_vector(31 downto 0);
        instr_addr_out  : out std_logic_vector(31 downto 0)

    );
    end component;

    component Register_File is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        rd_write_en     : in std_logic;
        rs1_addr        : in std_logic_vector(4 downto 0);
        rs2_addr        : in std_logic_vector(4 downto 0);
        rd_addr         : in std_logic_vector(4 downto 0);
        rd_data         : in std_logic_vector(31 downto 0);
        rs1_data        : out std_logic_vector(31 downto 0);
        rs2_data        : out std_logic_vector(31 downto 0)
    );
    end component;

    component Decoder_RV32I is
    port (
        clk            : in std_logic;
        rst            : in std_logic;
        instruction    : in std_logic_vector(31 downto 0);
        -- funct_3        : out std_logic_vector(2 downto 0);
        -- funct_7        : out std_logic_vector(6 downto 0);
        rs1            : out std_logic_vector(4 downto 0);
        rs2            : out std_logic_vector(4 downto 0);
        rd             : out std_logic_vector(4 downto 0);
        immediate      : out std_logic_vector(31 downto 0);
        rd_write_en    : out std_logic;
        sel_mux_exe    : out std_logic
    );
    end component;

    component State_ID_EX is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        hazard          : in std_logic;

        rs1_data        : in std_logic_vector(31 downto 0);
        rs2_data        : in std_logic_vector(31 downto 0);
        rs1_addr        : in std_logic_vector(4 downto 0);
        rs2_addr        : in std_logic_vector(4 downto 0);
        rd_addr         : in std_logic_vector(4 downto 0);
        immediate       : in std_logic_vector(31 downto 0);
        rd_write_en     : in std_logic;
        sel_mux_exe     : in std_logic;
        instr_addr_in   : in std_logic_vector(31 downto 0);


        rs1_data_out    : out std_logic_vector(31 downto 0);
        rs2_data_out    : out std_logic_vector(31 downto 0);
        rs1_addr_out    : out std_logic_vector(4 downto 0);
        rs2_addr_out    : out std_logic_vector(4 downto 0);
        rd_addr_out     : out std_logic_vector(4 downto 0);
        immediate_out   : out std_logic_vector(31 downto 0);
        rd_write_en_out : out std_logic;
        sel_mux_exe_out : out std_logic;
        instr_addr_out  : out std_logic_vector(31 downto 0)
    );
    end component;

    -- General signals
    -- signal clk          : std_logic := '0'; -- Value temporary
    -- signal rst          : std_logic := '0'; -- Value temporary
    signal hazard       : std_logic := '0'; -- Value temporary

    --state IF_ID signals
    signal IF_ID_instr_out      : std_logic_vector(31 downto 0); -- To ID_EX
    signal IF_ID_instr_addr_out : std_logic_vector(31 downto 0); -- To ID_EX
    -- This signals used in PC Module
    signal pc_mux_out   : std_logic_vector(31 downto 0);
    signal pc_adder_out : std_logic_vector(31 downto 0);
    signal pc_out       : std_logic_vector(31 downto 0);
    signal pc_fetched   : std_logic_vector(31 downto 0);


    -- state ID_EX signals
    signal ID_EX_rs1_data       : std_logic_vector(31 downto 0);
    signal ID_EX_rs2_data       : std_logic_vector(31 downto 0);
    signal ID_EX_rs1_addr       : std_logic_vector(4 downto 0);
    signal ID_EX_rs2_addr       : std_logic_vector(4 downto 0);
    signal ID_EX_rd_addr        : std_logic_vector(4 downto 0);
    signal ID_EX_immediate      : std_logic_vector(31 downto 0);
    signal ID_EX_rd_write_en    : std_logic;
    signal ID_EX_sel_mux_exe    : std_logic;

    -- To EX_MEM
    signal ID_EX_rs1_data_out   : std_logic_vector(31 downto 0);
    signal ID_EX_rs2_data_out   : std_logic_vector(31 downto 0);
    signal ID_EX_rs1_addr_out   : std_logic_vector(4 downto 0);
    signal ID_EX_rs2_addr_out   : std_logic_vector(4 downto 0);
    signal ID_EX_rd_addr_out    : std_logic_vector(4 downto 0);
    signal ID_EX_immediate_out  : std_logic_vector(31 downto 0);
    signal ID_EX_rd_write_en_out: std_logic;
    signal ID_EX_sel_mux_exe_out: std_logic;
    signal ID_EX_instr_addr_out : std_logic_vector(31 downto 0);
begin
    
    
    Mux_PC : Mux_2to1
    port map (
        sel_mux         => '0', -- Temp
        in_mux0         => pc_adder_out,
        in_mux1         => (others => '0'), -- Temp
        out_mux         => pc_mux_out
    );

    Program_Counter : PC
    port map (
        clk             => clk,
        rst             => rst,
        address_in      => pc_mux_out,
        address_out     => pc_out
    );

    Adder_PC : Adder
    port map (
        in_0            => x"00000004",
        in_1            => pc_out,
        out_sum         => pc_adder_out
    );

    Program_Memory : Progmem
    port map (
        rst             => rst,
        address_in      => pc_out,
        instr_out       => pc_fetched
    );

    State_Fetch_Decode : State_IF_ID
    port map (
        clk             => clk,
        rst             => rst,
        hazard          => hazard,
        -- Input Fetch
        instr_in        => pc_fetched,
        instr_addr_in   => pc_out,

        -- output Decode
        instr_out       => IF_ID_instr_out,
        instr_addr_out  => IF_ID_instr_addr_out     -- Instruction Address to ID_EX
    );

    RF:  Register_File
    port map (
        clk             => clk,
        rst             => rst,
        rd_write_en     => '0', -- Temp
        rs1_addr        => ID_EX_rs1_addr,
        rs2_addr        => ID_EX_rs2_addr,
        rd_addr         => (others => '0'), -- Temp
        rd_data         => (others => '0'), -- Temp
        rs1_data        => ID_EX_rs1_data,
        rs2_data        => ID_EX_rs2_data
    );

    Decoder: Decoder_RV32I
    port map (
        clk            => clk,
        rst            => rst, 
        instruction    => IF_ID_instr_out,
        -- funct_3        : out std_logic_vector(2 downto 0);
        -- funct_7        : out std_logic_vector(6 downto 0);
        rs1            => ID_EX_rs1_addr,
        rs2            => ID_EX_rs2_addr,
        rd             => ID_EX_rd_addr,
        immediate      => ID_EX_immediate,
        rd_write_en    => ID_EX_rd_write_en,
        sel_mux_exe    => ID_EX_sel_mux_exe
    );

    State_Decode_Execute: State_ID_EX
    port map (
        clk             => clk,
        rst             => rst,
        hazard          => hazard,

        rs1_data        => ID_EX_rs1_data,
        rs2_data        => ID_EX_rs2_data,
        rs1_addr        => ID_EX_rs1_addr,
        rs2_addr        => ID_EX_rs2_addr,
        rd_addr         => ID_EX_rd_addr,
        immediate       => ID_EX_immediate,
        rd_write_en     => ID_EX_rd_write_en,
        sel_mux_exe     => ID_EX_sel_mux_exe,
        instr_addr_in   => IF_ID_instr_addr_out,    -- Instruction addres from IF_ID


        rs1_data_out    => ID_EX_rs1_data_out,
        rs2_data_out    => ID_EX_rs2_data_out,
        rs1_addr_out    => ID_EX_rs1_addr_out,
        rs2_addr_out    => ID_EX_rs2_addr_out,
        rd_addr_out     => ID_EX_rd_addr_out,
        immediate_out   => ID_EX_immediate_out,
        rd_write_en_out => ID_EX_rd_write_en_out,
        sel_mux_exe_out => ID_EX_sel_mux_exe_out,
        instr_addr_out  => ID_EX_instr_addr_out     -- Instruction Address to EX_MEM
    );


end architecture rtl;