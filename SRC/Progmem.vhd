library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Progmem is
    port (
        rst             : in std_logic;
        address_in      : in std_logic_vector(31 downto 0);
        instr_out       : out std_logic_vector(31 downto 0)
    );
end entity Progmem;

architecture rtl of Progmem is
    type progmem is array (0 to 1023) of std_logic_vector(31 downto 0);
    signal program_memory : progmem := (others => (others => '0'));

begin

    progmem_process: process(rst)
    begin
        if rst = '1' then
            program_memory <= (others => (others => '0'));
        else
            instr_out <= program_memory(to_integer(unsigned(address_in)));
        end if;
    end process progmem_process;
end architecture rtl;