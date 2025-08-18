library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Core is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        instruction     : in std_logic_vector(31 downto 0)

    );
end entity Core;


architecture rtl of Core is
    
    component State_Fetch is
    port (
        clk                     : in std_logic;
        rst                     : in std_logic;
        stall                   : in std_logic;
        in_instruction          : in std_logic_vector(31 downto 0);
        in_instruction_addr     : in std_logic_vector(31 downto 0);
        out_instruction         : out std_logic_vector(31 downto 0);
        out_instruction_addr    : out std_logic_vector(31 downto 0)
    );
    end component;

    component Decoder_RV32I is
    port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        instruction         : in std_logic_vector(31 downto 0);
        funct_3             : out std_logic_vector(2 downto 0);
        funct_7             : out std_logic_vector(6 downto 0);
        rs1                 : out std_logic_vector(4 downto 0);
        rs2                 : out std_logic_vector(4 downto 0);
        rd                  : out std_logic_vector(4 downto 0);
        immediate           : out std_logic_vector(31 downto 0);
        rd_write_en         : out std_logic;
        sel_mux_exe         : out std_logic
    );
    end component;

    component Register_File is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        rd_write_en : in std_logic;
        rs1_addr    : in std_logic_vector(4 downto 0);
        rs2_addr    : in std_logic_vector(4 downto 0);
        rd_addr     : in std_logic_vector(4 downto 0);
        rd_data     : in std_logic_vector(31 downto 0);
        rs1_data    : out std_logic_vector(31 downto 0);
        rs2_data    : out std_logic_vector(31 downto 0)
    );
    end component;

    component State_Decode is
    port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        stall               : in std_logic;
        in_instruction      : in std_logic_vector(31 downto 0);
        in_funct_3          : in std_logic_vector(2 downto 0);
        in_funct_7          : in std_logic_vector(6 downto 0);
        in_immediate        : in std_logic_vector(31 downto 0);
        in_rs1_addr         : in std_logic_vector(4 downto 0);
        in_rs2_addr         : in std_logic_vector(4 downto 0);
        in_rd_addr          : in std_logic_vector(4 downto 0);
        in_rs1_data         : in std_logic_vector(31 downto 0);
        in_rs2_data         : in std_logic_vector(31 downto 0);
        in_rd_write_en      : in std_logic;
        in_sel_mux_exe      : in std_logic;
        out_instruction     : out std_logic_vector(31 downto 0);
        out_funct_3         : out std_logic_vector(2 downto 0);
        out_funct_7         : out std_logic_vector(6 downto 0);
        out_immediate       : out std_logic_vector(31 downto 0);
        out_rs1_addr        : out std_logic_vector(4 downto 0);
        out_rs2_addr        : out std_logic_vector(4 downto 0);
        out_rd_addr         : out std_logic_vector(4 downto 0);
        out_rs1_data        : out std_logic_vector(31 downto 0);
        out_rs2_data        : out std_logic_vector(31 downto 0);
        out_rd_write_en     : out std_logic;
        out_sel_mux_exe     : out std_logic
    );
    end component;

    component Mux_2to1 is
    port (
        sel_mux     : in std_logic;
        in_mux0     : in std_logic_vector(31 downto 0);
        in_mux1     : in std_logic_vector(31 downto 0);
        out_mux     : out std_logic_vector(31 downto 0)
    );
    end component;

    component Hazard_Unit is
    port (
        in_rs1_addr     : in std_logic_vector(4 downto 0);
        in_rs2_addr     : in std_logic_vector(4 downto 0);
        in_rd_addr      : in std_logic_vector(4 downto 0);
        wb              : in std_logic;
        stall           : out std_logic
    );
    end component;

    -- Stall Signal
    signal stall                            : std_logic; -- temp 0 for testing

    -- Fetch State
    -- Line State Fetch to Decoder
    signal instruction_StateFetch_decoder   : std_logic_vector(31 downto 0);

    -- Decode State
    -- Line Decoder to Register File
    signal rs1_addr         : std_logic_vector(4 downto 0);
    signal rs2_addr         : std_logic_vector(4 downto 0);


    -- Line Decoder & Register File to State Register
    signal funct_3_decoder_StateDecode      : std_logic_vector(2 downto 0);
    signal funct_7_decoder_StateDecode      : std_logic_vector(6 downto 0);
    signal immediate_decoder_StateDecode    : std_logic_vector(31 downto 0);
    signal rs1_data_regfile_StateDecode     : std_logic_vector(31 downto 0);
    signal rs2_data_regfile_StateDecode     : std_logic_vector(31 downto 0);
    signal rd_addr      : std_logic_vector(4 downto 0);
    signal rd_write_en_decoder_StateDecode  : std_logic;
    signal sel_mux_exe_decoder_StateDecode  : std_logic;


    -- Temp signal for debbugging/testing
    signal out_funct_3      : std_logic_vector(2 downto 0);
    signal out_funct_7      : std_logic_vector(6 downto 0);
    signal out_immediate    : std_logic_vector(31 downto 0);
    signal out_rs1_data     : std_logic_vector(31 downto 0);
    signal out_rs2_data     : std_logic_vector(31 downto 0);
    signal out_rd_addr      : std_logic_vector(4 downto 0);
    signal out_rd_write_en  : std_logic;
    -- signal instruction      : std_logic_vector(31 downto 0);

    -- Execute State
    -- Line to Hazard Unit
    signal rs1_addr_ID_EXE       : std_logic_vector(4 downto 0);
    signal rs2_addr_ID_EXE       : std_logic_vector(4 downto 0);
    signal rd_addr_ID_EXE        : std_logic_vector(4 downto 0);
    signal rs1_data_ID_EX        : std_logic_vector(31 downto 0);
    -- Line State Decode to Mux_2to1_exe
    signal rs2_data_ID_EXE       : std_logic_vector(31 downto 0);
    signal immediate_ID_EXE      : std_logic_vector(31 downto 0);
    signal sel_rs2_imm_ID_EXE    : std_logic;

    -- Line Mux_2to1_exe to ALU
    signal out_data_mux_2to1_exe_alu                : std_logic_vector(31 downto 0);
begin

    Register_State_Fetch: State_Fetch 
    port map(
        clk                     => clk,
        rst                     => rst,
        stall                   => stall,
        in_instruction          => instruction,
        in_instruction_addr     => x"00000000",
        out_instruction         => instruction_StateFetch_decoder,
        out_instruction_addr    => open
    );

    Decoder:  Decoder_RV32I
    port map (
        clk             => clk,
        rst             => rst,
        instruction     => instruction_StateFetch_decoder,
        funct_3         => funct_3_decoder_StateDecode,
        funct_7         => funct_7_decoder_StateDecode,
        rs1             => rs1_addr,
        rs2             => rs2_addr,
        rd              => rd_addr,
        immediate       => immediate_decoder_StateDecode,
        rd_write_en     => rd_write_en_decoder_StateDecode,
        sel_mux_exe     => sel_mux_exe_decoder_StateDecode
    );

    RegisterFile: Register_File
    port map(
        clk         => clk,
        rst         => rst,
        rd_write_en => '0',
        rs1_addr    => rs1_addr,
        rs2_addr    => rs2_addr,
        rd_addr     => "00000",
        rd_data     => x"00000000",
        rs1_data    => rs1_data_regfile_StateDecode,
        rs2_data    => rs2_data_regfile_StateDecode
    );

    Register_State_Decode : State_Decode
    port map(
        clk                 => clk,
        rst                 => rst,
        stall               => stall,
        in_instruction      => instruction_StateFetch_decoder, -- Tracking Purpose 
        in_funct_3          => funct_3_decoder_StateDecode,
        in_funct_7          => funct_7_decoder_StateDecode,
        in_immediate        => immediate_decoder_StateDecode,
        in_rs1_addr         => rs1_addr,
        in_rs2_addr         => rs2_addr,
        in_rd_addr          => rd_addr,
        in_rs1_data         => rs1_data_regfile_StateDecode,
        in_rs2_data         => rs2_data_regfile_StateDecode,
        in_rd_write_en      => rd_write_en_decoder_StateDecode,
        in_sel_mux_exe      => sel_mux_exe_decoder_StateDecode,
        out_instruction     => open,
        out_funct_3         => out_funct_3,
        out_funct_7         => out_funct_7,
        out_immediate       => immediate_ID_EXE,
        out_rs1_addr        => rs1_addr_ID_EXE,
        out_rs2_addr        => rs2_addr_ID_EXE,
        out_rd_addr         => rd_addr_ID_EXE,
        out_rs1_data        => out_rs1_data,
        out_rs2_data        => rs2_data_ID_EXE,
        out_rd_write_en     => out_rd_write_en,
        out_sel_mux_exe     => sel_rs2_imm_ID_EXE
    );

    Mux_RS2_IMM: Mux_2to1 
    port map(
        sel_mux     => sel_rs2_imm_ID_EXE,
        in_mux0     => rs2_data_ID_EXE,
        in_mux1     => immediate_ID_EXE,
        out_mux     => out_data_mux_2to1_exe_alu
    );

    Hazard_Unit_register_conflict: Hazard_Unit 
    port map(
        in_rs1_addr     => rs1_addr_ID_EXE,
        in_rs2_addr     => rs2_addr_ID_EXE,
        in_rd_addr      => rd_addr_ID_EXE,
        wb              => '0',
        stall           => stall
    );

end architecture rtl;