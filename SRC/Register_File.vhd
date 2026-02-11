library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Register_File is
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        rd_write_en     : in std_logic;
        rs1_addr        : in std_logic_vector(4 downto 0);
        rs2_addr        : in std_logic_vector(4 downto 0);
        rd_addr         : in std_logic_vector(4 downto 0);
        rd_data         : in std_logic_vector(31 downto 0);
        rs1_data        : out std_logic_vector(31 downto 0);
        rs2_data        : out std_logic_vector(31 downto 0)
    );
end entity Register_File;

architecture rtl of Register_File is

    type register_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal x    : register_array := (others => (others => '0'));

begin
    
    reg: process(clk, rst, rd_write_en)
    begin
        if rst = '1' then
            x <=  (others => (others => '0'));
        elsif rising_edge(clk) then
            if rd_write_en = '1' and unsigned(rd_addr) /= 0 then
                x(to_integer(unsigned(rd_addr))) <= rd_data;
            
            else
                -- x(to_integer(unsigned(rs1_addr))) <= x(to_integer(unsigned(rs1_addr)));
                -- x(to_integer(unsigned(rs2_addr))) <= x(to_integer(unsigned(rs2_addr)));
            end if;
        end if;
        rs1_data <= x(to_integer(unsigned(rs1_addr)));
        rs2_data <= x(to_integer(unsigned(rs2_addr)));
    end process reg;
end architecture rtl;