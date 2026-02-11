library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder is
    port (
        in_0     : in std_logic_vector(31 downto 0);
        in_1     : in std_logic_vector(31 downto 0);
        out_sum  : out std_logic_vector(31 downto 0)
    );
end entity Adder;

architecture behavioral of Adder is
    
    signal temp_sum : std_logic_vector(31 downto 0) := (others => '0');

begin
    
    Adder : process (in_0, in_1, temp_sum)
    begin
        temp_sum <= std_logic_vector(unsigned(in_0) + unsigned(in_1));        
    end process Adder;
    
    out_sum <= temp_sum;
end architecture behavioral;