library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity State_IF_ID is
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
end entity State_IF_ID;

architecture rtl of State_IF_ID is
    
    signal instr_reg       : std_logic_vector(31 downto 0);
    signal instr_addr_reg  : std_logic_vector(31 downto 0);

begin
    
    
    IF_ID: process(clk, rst)
    begin
        if rst = '1' then
            instr_reg       <= (others => '0');
            instr_addr_reg  <= (others => '0');

        elsif rising_edge(clk) then
            if hazard = '0' then
                instr_reg       <= instr_in;
                instr_addr_reg  <= instr_addr_in;
            else -- hold values
                instr_reg       <= instr_reg;
                instr_addr_reg  <= instr_addr_reg;
            end if;
        end if;
    end process IF_ID;

    instr_out       <= instr_reg;
    instr_addr_out  <= instr_addr_reg;
end architecture rtl;