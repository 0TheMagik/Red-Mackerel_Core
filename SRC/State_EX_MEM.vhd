library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity State_EX_MEM is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        hazard          : in std_logic;

        jump_flag       : in std_logic;
        alu_branch_resp : in std_logic;
        alu_result      : in std_logic_vector(31 downto 0);
        fw_mux_2        : in std_logic_vector(31 downto 0);

        instr_addr_in   : in std_logic_vector(31 downto 0);

    );
end entity State_EX_MEM;

architecture rtl of State_EX_MEM is
    
begin
    
    
    
end architecture rtl;