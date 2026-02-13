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
    
begin
    
    
    
end architecture rtl;