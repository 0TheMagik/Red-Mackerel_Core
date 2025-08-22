library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        funct_3         : in std_logic_vector(2 downto 0);
        funct_7         : in std_logic_vector(6 downto 0);
        in_alu_0        : in std_logic_vector(31 downto 0);
        in_alu_1        : in std_logic_vector(31 downto 0);
        out_alu         : out std_logic_vector(31 downto 0)
    );
end entity ALU;

architecture rtl of ALU is
    
begin
    logic: process(funct_3, funct_7)
    begin
        case funct_3 is
            when choice =>
                
        
            when others =>
                
        
        end case;
    end process logic;
    
    
end architecture rtl;