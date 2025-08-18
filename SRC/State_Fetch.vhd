library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity State_Fetch is
    port (
        clk                     : in std_logic;
        rst                     : in std_logic;
        stall                   : in std_logic;
        in_instruction          : in std_logic_vector(31 downto 0);
        in_instruction_addr     : in std_logic_vector(31 downto 0);
        out_instruction         : out std_logic_vector(31 downto 0);
        out_instruction_addr    : out std_logic_vector(31 downto 0)
    );
end entity State_Fetch;

architecture rtl of State_Fetch is
    signal instruction          : std_logic_vector(31 downto 0) := x"00000000";
    signal instruction_addr     : std_logic_vector(31 downto 0) := x"00000000";

begin
    Fetch_Register: process(clk, rst, stall)
    begin
        if rst = '1' then
            instruction         <= x"00000000";
            instruction_addr    <= x"00000000";
        
        elsif rising_edge(clk) and stall = '0' then
            instruction             <= in_instruction;
            instruction_addr        <= in_instruction_addr;
            out_instruction         <= instruction;
            out_instruction_addr    <= instruction_addr;

        else
            instruction         <= instruction;
            instruction_addr    <= instruction_addr;

        end if;
    end process Fetch_Register;

end architecture rtl;