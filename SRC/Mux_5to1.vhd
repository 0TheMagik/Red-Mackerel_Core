library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Mux_5to1 is
    port (
        sel_mux     : in std_logic_vector(2 downto 0);
        in_mux0     : in std_logic_vector(31 downto 0);
        in_mux1     : in std_logic_vector(31 downto 0);
        in_mux2     : in std_logic_vector(31 downto 0);
        in_mux3     : in std_logic_vector(31 downto 0);
        in_mux4     : in std_logic_vector(31 downto 0);
        out_mux     : out std_logic_vector(31 downto 0)
    );
end entity Mux_5to1;

architecture behavioral of Mux_5to1 is
    
begin
    with sel_mux select
        out_mux <= 
            in_mux0 when "000",
            in_mux1 when "001",
            in_mux2 when "010",
            in_mux3 when "011",
            in_mux4 when "100",
            x"00000000" when others;
            
end architecture behavioral;