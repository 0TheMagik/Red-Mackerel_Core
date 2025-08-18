library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity State_Decode is
    port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        stall               : in std_logic;
        -- In Signal
        in_instruction      : in std_logic_vector(31 downto 0); -- Tracking Purpose
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
        -- Out Signal
        out_instruction     : out std_logic_vector(31 downto 0); -- Tracking Purpose
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
end entity State_Decode;


architecture rtl of State_Decode is
    signal  instruction     : std_logic_vector(31 downto 0) := x"00000000";
    signal  funct_3         : std_logic_vector(2 downto 0)  := "000";
    signal  funct_7         : std_logic_vector(6 downto 0)  := "0000000";
    signal  immediate       : std_logic_vector(31 downto 0) := x"00000000";
    signal  rs1_addr        : std_logic_vector(4 downto 0)  := "00000";
    signal  rs2_addr        : std_logic_vector(4 downto 0)  := "00000";
    signal  rd_addr         : std_logic_vector(4 downto 0)  := "00000";
    signal  rs1_data        : std_logic_vector(31 downto 0) := x"00000000";
    signal  rs2_data        : std_logic_vector(31 downto 0) := x"00000000";
    signal  rd_write_en     : std_logic := '0';
    signal  sel_mux_exe     : std_logic := '0';

begin

    Decode_Register: process(clk, rst)
    begin
        if rst = '1' then
            instruction     <= x"00000000";
            funct_3         <= "000";
            funct_7         <= "0000000";
            immediate       <= x"00000000";
            rs1_addr        <= "00000";
            rs2_addr        <= "00000";
            rd_addr         <= "00000";
            rs1_data        <= x"00000000";
            rs2_data        <= x"00000000";
            rd_write_en     <= '0';
            sel_mux_exe     <= '0';

        elsif rising_edge(clk) and stall = '0' then
            instruction     <= in_instruction;
            funct_3         <= in_funct_3;
            funct_7         <= in_funct_7;
            immediate       <= in_immediate;
            rs1_addr        <= in_rs1_addr;
            rs2_addr        <= in_rs2_addr;
            rd_addr         <= in_rd_addr;
            rs1_data        <= in_rs1_data;
            rs2_data        <= in_rs2_data;
            rd_write_en     <= in_rd_write_en;
            sel_mux_exe     <= in_sel_mux_exe;
   
            
        else
            instruction     <= instruction;
            funct_3         <= funct_3;
            funct_7         <= funct_7;
            immediate       <= immediate;
            rs1_addr        <= rs1_addr;
            rs2_addr        <= rs2_addr;
            rs1_data        <= rs1_data;
            rs2_data        <= rs2_data;
            rd_addr         <= rd_addr;
            rd_write_en     <= rd_write_en;
            sel_mux_exe     <= sel_mux_exe;
        end if;

    end process Decode_Register;
    
    out_instruction    <= instruction;
    out_funct_3        <= funct_3;
    out_funct_7        <= funct_7;
    out_immediate      <= immediate;
    out_rs1_addr       <= rs1_addr;
    out_rs2_addr       <= rs2_addr;
    out_rd_addr        <= rd_addr;
    out_rs1_data       <= rs1_data;
    out_rs2_data       <= rs2_data;
    out_rd_write_en    <= rd_write_en;
    out_sel_mux_exe    <= sel_mux_exe;
end architecture rtl;