library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PC is
    port (
        clk         : in std_logic;
        rst         : in std_logic;
        address_in  : in std_logic_vector(31 downto 0);
        address_out : out std_logic_vector(31 downto 0)
    );
end entity PC;

architecture rtl of PC is
    
    signal address_reg : std_logic_vector(31 downto 0) := (others => '0');

begin
    program_counter: process(clk, rst)
    begin
        if rst = '1' then
            address_reg <= (others => '0');
        elsif rising_edge(clk) then
            address_reg <= address_in;

        else
            -- Stayed the same 
        end if;
    end process program_counter;

    address_out <= address_reg;

end architecture rtl;