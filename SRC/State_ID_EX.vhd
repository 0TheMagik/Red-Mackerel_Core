library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity State_ID_EX is
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
end entity State_ID_EX;

architecture rtl of State_ID_EX is
    
    signal rs1_data_reg     : std_logic_vector(31 downto 0);
    signal rs2_data_reg     : std_logic_vector(31 downto 0);
    signal rs1_addr_reg     : std_logic_vector(4 downto 0);
    signal rs2_addr_reg     : std_logic_vector(4 downto 0);
    signal rd_addr_reg      : std_logic_vector(4 downto 0);
    signal immediate_reg    : std_logic_vector(31 downto 0);
    signal rd_write_en_reg  : std_logic;
    signal sel_mux_exe_reg  : std_logic;
    signal instr_addr_reg   : std_logic_vector(31 downto 0);
    
begin
    ID_EX: process(clk, rst)
    begin
        if rst = '1' then
            rs1_data_reg    <= (others => '0');
            rs2_data_reg    <= (others => '0');
            rs1_addr_reg    <= (others => '0');
            rs2_addr_reg    <= (others => '0');
            rd_addr_reg     <= (others => '0');
            immediate_reg   <= (others => '0');
            sel_mux_exe_reg <= '0';
            rd_write_en_reg <= '0';
            instr_addr_reg  <= (others => '0');

        elsif rising_edge(clk) then
            if hazard = '0' then
                rs1_data_reg    <= rs1_data;
                rs2_data_reg    <= rs2_data;
                rs1_addr_reg    <= rs1_addr;
                rs2_addr_reg    <= rs2_addr;
                rd_addr_reg     <= rd_addr;
                immediate_reg   <= immediate;
                sel_mux_exe_reg <= sel_mux_exe;
                rd_write_en_reg <= rd_write_en;
                instr_addr_reg  <= instr_addr_in;

            else -- hold values
                rs1_data_reg    <= rs1_data_reg;
                rs2_data_reg    <= rs2_data_reg;
                rs1_addr_reg    <= rs1_addr_reg;
                rs2_addr_reg    <= rs2_addr_reg;
                rd_addr_reg     <= rd_addr_reg;
                immediate_reg   <= immediate_reg;
                sel_mux_exe_reg <= sel_mux_exe_reg;
                rd_write_en_reg <= rd_write_en_reg;
                instr_addr_reg  <= instr_addr_reg;

            end if;

        else -- hold values
            rs1_data_reg    <= rs1_data_reg;
            rs2_data_reg    <= rs2_data_reg;
            rs1_addr_reg    <= rs1_addr_reg;
            rs2_addr_reg    <= rs2_addr_reg;
            rd_addr_reg     <= rd_addr_reg;
            immediate_reg   <= immediate_reg;
            sel_mux_exe_reg <= sel_mux_exe_reg;
            rd_write_en_reg <= rd_write_en_reg;
            instr_addr_reg  <= instr_addr_reg;
        end if;
    end process ID_EX;

    rs1_data_out    <= rs1_data_reg;
    rs2_data_out    <= rs2_data_reg;
    rs1_addr_out    <= rs1_addr_reg;
    rs2_addr_out    <= rs2_addr_reg;
    rd_addr_out     <= rd_addr_reg;
    immediate_out   <= immediate_reg;   
    sel_mux_exe_out <= sel_mux_exe_reg;
    rd_write_en_out <= rd_write_en_reg;
    instr_addr_out  <= instr_addr_reg;
end architecture rtl;