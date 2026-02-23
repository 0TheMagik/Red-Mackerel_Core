library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity State_EX_MEM is
    port (
        clk                     : in std_logic;
        rst                     : in std_logic;
        hazard                  : in std_logic;

        jump_flag_in            : in std_logic;
        alu_branch_resp_in      : in std_logic;
        alu_result              : in std_logic_vector(31 downto 0);
        fw_mux_2_output_in      : in std_logic_vector(31 downto 0);
        data_format_in          : in std_logic_vector(2 downto 0);
        data_mem_write_en_in    : in std_logic;
        write_back_sel_in       : in std_logic_vector(1 downto 0);
        rd_write_en_in          : in std_logic;
        rd_addr_in              : in std_logic_vector(4 downto 0);
        instr_addr_in           : in std_logic_vector(31 downto 0);

        jump_flag_out           : out std_logic;
        alu_branch_resp_out     : out std_logic;
        alu_result_out          : out std_logic_vector(31 downto 0);
        fw_mux_2_output_out     : out std_logic_vector(31 downto 0);
        data_format_out         : out std_logic_vector(2 downto 0);
        data_mem_write_en_out   : out std_logic;
        write_back_sel_out      : out std_logic_vector(1 downto 0);
        rd_write_en_out         : out std_logic;
        rd_addr_out             : out std_logic_vector(4 downto 0);
        instr_addr_out          : out std_logic_vector(31 downto 0)

    );
end entity State_EX_MEM;

architecture rtl of State_EX_MEM is

    signal internal_jump_flag           : std_logic;
    signal internal_alu_branch_resp     : std_logic;
    signal internal_alu_result          : std_logic_vector(31 downto 0);
    signal internal_fw_mux_2_output     : std_logic_vector(31 downto 0);
    signal internal_data_format         : std_logic_vector(2 downto 0);
    signal internal_data_mem_write_en   : std_logic;
    signal internal_write_back_sel      : std_logic_vector(1 downto 0);
    signal internal_rd_write_en         : std_logic;
    signal internal_rd_addr             : std_logic_vector(4 downto 0);
    signal internal_instr_addr          : std_logic_vector(31 downto 0);
    
begin
    EX_MEM: process(clk, rst)
    begin
        if rst = '1' then
            internal_jump_flag          <= '0';
            internal_alu_branch_resp    <= '0';
            internal_alu_result         <= (others => '0');
            internal_fw_mux_2_output    <= (others => '0');
            internal_data_format        <= (others => '0');
            internal_data_mem_write_en  <= '0';
            internal_write_back_sel     <= (others => '0');
            internal_rd_write_en        <= '0';
            internal_rd_addr            <= (others => '0');
            internal_instr_addr         <= (others => '0');

        elsif rising_edge(clk) then
            if hazard = '0' then
                internal_jump_flag          <= jump_flag_in;
                internal_alu_branch_resp    <= alu_branch_resp_in;
                internal_alu_result         <= alu_result;
                internal_fw_mux_2_output    <= fw_mux_2_output_in;
                internal_data_format        <= data_format_in;
                internal_data_mem_write_en  <= data_mem_write_en_in;
                internal_write_back_sel     <= write_back_sel_in;
                internal_rd_write_en        <= rd_write_en_in;
                internal_rd_addr            <= rd_addr_in;
                internal_instr_addr         <= instr_addr_in;

            else
                internal_jump_flag          <= internal_jump_flag;
                internal_alu_branch_resp    <= internal_alu_branch_resp;
                internal_alu_result         <= internal_alu_result;
                internal_fw_mux_2_output    <= internal_fw_mux_2_output;
                internal_data_format        <= internal_data_format;
                internal_data_mem_write_en  <= internal_data_mem_write_en;
                internal_write_back_sel     <= internal_write_back_sel;
                internal_rd_write_en        <= internal_rd_write_en;
                internal_rd_addr            <= internal_rd_addr;
                internal_instr_addr         <= internal_instr_addr;

            end if;

        else
            internal_jump_flag          <= internal_jump_flag;
            internal_alu_branch_resp    <= internal_alu_branch_resp;
            internal_alu_result         <= internal_alu_result;
            internal_fw_mux_2_output    <= internal_fw_mux_2_output;
            internal_data_format        <= internal_data_format;
            internal_data_mem_write_en  <= internal_data_mem_write_en;
            internal_write_back_sel     <= internal_write_back_sel;
            internal_rd_write_en        <= internal_rd_write_en;
            internal_rd_addr            <= internal_rd_addr;
            internal_instr_addr         <= internal_instr_addr;
        end if;
    end process EX_MEM;
    
     jump_flag_out          <= internal_jump_flag;
     alu_branch_resp_out    <= internal_alu_branch_resp;
     alu_result_out         <= internal_alu_result;
     fw_mux_2_output_out    <= internal_fw_mux_2_output;
     data_format_out        <= internal_data_format;
     data_mem_write_en_out  <= internal_data_mem_write_en;
     write_back_sel_out     <= internal_write_back_sel;
     rd_write_en_out        <= internal_rd_write_en;
     rd_addr_out            <= internal_rd_addr;
     instr_addr_out         <= internal_instr_addr;
     
end architecture rtl;