library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Hazard_Unit is
    port (
        in_rs1_addr_EX  : in std_logic_vector(4 downto 0);
        in_rs2_addr_EX  : in std_logic_vector(4 downto 0);
        in_rd_addr_EX   : in std_logic_vector(4 downto 0);
        in_rs1_addr_ID  : in std_logic_vector(4 downto 0);
        in_rs2_addr_ID  : in std_logic_vector(4 downto 0);
        in_rd_addr_ID   : in std_logic_vector(4 downto 0);
        wb              : in std_logic;
        stall           : out std_logic
    );
end entity Hazard_Unit;


architecture rtl of Hazard_Unit is

    signal internal_stall       : std_logic := '0';

begin
    Hazard : process(in_rs1_addr_EX, in_rs2_addr_EX, in_rd_addr_EX, wb)
    begin
        if in_rs1_addr_EX /= "00000" OR in_rs2_addr_EX /= "00000" then
            if in_rs1_addr_EX = in_rd_addr_ID OR in_rs2_addr_EX = in_rd_addr_ID then
                internal_stall <= '1';
            else
                internal_stall <= '0';
            end if;
        else
            internal_stall <= '0';
            -- in_rs1_addr_ID <= in_rs1_addr_EX;
            -- in_rs2_addr_ID <= in_rs2_addr_EX;
            -- in_rd_addr_ID  <= in_rd_addr_EX;
        end if;
        -- case wb  is
        --     when '0' =>
        --         internal_stall <= internal_stall;
        --     when '1' =>
        --         internal_stall <= '0';
        --     when others => 
        --         internal_stall <= '0';
        -- end case;
    end process; 
    stall <= internal_stall;   
end architecture rtl;