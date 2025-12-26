library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Core is
    port (
        clk     : in std_logic;
        rst     : in std_logic
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

    -- component Mux_2to1 is
    -- port (
    --     sel_mux     : in std_logic;
    --     in_mux0     : in std_logic_vector(31 downto 0);
    --     in_mux1     : in std_logic_vector(31 downto 0);
    --     out_mux     : out std_logic_vector(31 downto 0)
    -- );
    -- end component;

    component Hazard_Unit is
    port (
        in_rs1_addr_EX  : in std_logic_vector(4 downto 0);
        in_rs2_addr_EX  : in std_logic_vector(4 downto 0);
        in_rd_addr_EX   : in std_logic_vector(4 downto 0);
        in_rs1_addr_ID  : in std_logic_vector(4 downto 0);
        in_rs2_addr_ID  : in std_logic_vector(4 downto 0);
        in_rd_addr_ID   : in std_logic_vector(4 downto 0);
        wb              : in std_logic;
        stall           : out std_logic
    );
    end component;


    --signal
    signal stall            : std_logic;
    
    -- Instruction Fetch State
    signal instruction_IF       : std_logic_vector(31 downto 0);
    signal instruction_addr_IF  : std_logic_vector(31 downto 0);

    -- Instruction Decode State
    signal instruction_ID       : std_logic_vector(31 downto 0);
    signal instruction_addr_ID  : std_logic_vector(31 downto 0);
    signal funct_3_ID           : std_logic_vector(2 downto 0);
    signal funct_7_ID           : std_logic_vector(6 downto 0);
    signal rs1_ID               : std_logic_vector(4 downto 0);
    signal rs2_ID               : std_logic_vector(4 downto 0);
    signal rd_ID                : std_logic_vector(4 downto 0);
    signal immediate_ID         : std_logic_vector(31 downto 0);
    signal rd_write_en_ID       : std_logic;
    signal sel_mux_exe_ID       : std_logic;
    
    signal rs1_data_ID          : std_logic_vector(31 downto 0);
    signal rs2_data_ID          : std_logic_vector(31 downto 0);
    signal rd_data_ID           : std_logic_vector(31 downto 0);

    -- Execute State
    signal instruction_EX       : std_logic_vector(31 downto 0);
    signal instruction_addr_EX  : std_logic_vector(31 downto 0);
    signal funct_3_EX           : std_logic_vector(2 downto 0);
    signal funct_7_EX           : std_logic_vector(6 downto 0);
    signal rs1_EX               : std_logic_vector(4 downto 0);
    signal rs2_EX               : std_logic_vector(4 downto 0);
    signal rd_EX                : std_logic_vector(4 downto 0);
    signal immediate_EX         : std_logic_vector(31 downto 0);
    signal rd_write_en_EX       : std_logic;
    signal sel_mux_exe_EX       : std_logic;
    
    signal rs1_data_EX          : std_logic_vector(31 downto 0);
    signal rs2_data_EX          : std_logic_vector(31 downto 0);

    begin

        Fetch: State_Fetch
        port map(
            clk                     => clk,
            rst                     => rst,
            stall                   => stall,
            in_instruction          => instruction_IF,
            in_instruction_addr     => x"00000000",
            out_instruction         => instruction_ID,
            out_instruction_addr    => instruction_addr_ID
        );

        Decoder: Decoder_RV32I
        port map(
            clk                 => clk,
            rst                 => rst,
            instruction         => instruction_ID,
            funct_3             => funct_3_ID,
            funct_7             => funct_7_ID,
            rs1                 => rs1_ID,
            rs2                 => rs2_ID,
            rd                  => rd_ID,
            immediate           => immediate_ID,
            rd_write_en         => rd_write_en_ID,
            sel_mux_exe         => sel_mux_exe_ID
        );

        RF: Register_File 
        port map(
            clk         => clk,
            rst         => rst,
            rd_write_en => '0',
            rs1_addr    => rs1_ID,
            rs2_addr    => rs2_ID,
            rd_addr     => "00000",
            rd_data     => x"00000000",
            rs1_data    => rs1_data_ID,
            rs2_data    => rs2_data_ID
        );
        
        Decode: State_Decode 
        port map(
            clk                 => clk,
            rst                 => rst,
            stall               => stall,
            in_instruction      => instruction_ID,
            in_funct_3          => funct_3_ID,
            in_funct_7          => funct_7_ID,
            in_immediate        => immediate_ID,
            in_rs1_addr         => rs1_ID,
            in_rs2_addr         => rs2_ID,
            in_rd_addr          => rd_ID,
            in_rs1_data         => rs1_data_ID,
            in_rs2_data         => rs2_data_ID,
            in_rd_write_en      => rd_write_en_ID,
            in_sel_mux_exe      => sel_mux_exe_ID,
            out_instruction     => instruction_EX,
            out_funct_3         => funct_3_EX,
            out_funct_7         => funct_7_EX,
            out_immediate       => immediate_EX,
            out_rs1_addr        => rs1_EX,
            out_rs2_addr        => rs2_EX,
            out_rd_addr         => rd_EX,
            out_rs1_data        => rs1_data_EX,
            out_rs2_data        => rs2_data_EX,
            out_rd_write_en     => rd_write_en_EX,
            out_sel_mux_exe     => sel_mux_exe_EX
        );

        -- Hazard_Detection: Hazard_Unit
        -- port map(
        --     in_rs1_addr_EX      => rs1_EX,
        --     in_rs2_addr_EX      => rs2_EX,
        --     in_rd_addr_EX       => rd_EX,
        --     in_rs1_addr_ID      => rs1_ID,
        --     in_rs2_addr_ID      => rs2_ID,
        --     in_rd_addr_ID       => rd_ID,
        --     wb                  => '0',
        --     stall               => stall
        -- );

end architecture rtl;