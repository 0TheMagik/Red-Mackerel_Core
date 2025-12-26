library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity State_Execute is
    port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        stall               : in std_logic
        
        
    );
end entity State_Execute;

architecture rtl of State_Execute is
    
begin
    Execute_Register: process(clk, rst)
    begin
        if rst = '1' then
            
        elsif rising_edge(clk) and stall = '0' then
            
        end if;
    end process Execute_Register;
    
    
end architecture rtl;