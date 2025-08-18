library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux_2to1 is
    port (
        sel_mux     : in std_logic;
        in_mux0     : in std_logic_vector(31 downto 0);
        in_mux1     : in std_logic_vector(31 downto 0);
        out_mux     : out std_logic_vector(31 downto 0)
    );
end entity Mux_2to1;


architecture rtl of Mux_2to1 is
    
begin
    with sel_mux select 
        out_mux <= 
            in_mux0 when '0',
            in_mux1 when '1',
            x"00000000" when others;
    
    
end architecture rtl;