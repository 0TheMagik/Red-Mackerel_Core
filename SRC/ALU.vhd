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
    
    signal result : std_logic_vector(32 downto 0);

begin
    logic: process(funct_3, funct_7)
    begin
        case funct_3 is
            when "000" =>
                if funct_7 = "0000000" then -- add
                    result <= std_logic_vector(signed(in_alu_0(31) & in_alu_0) + signed(in_alu_1 (31) & in_alu_1));

                elsif funct_7 = "0000001" then -- sub
                    result <= std_logic_vector(signed(in_alu_0(31) & in_alu_0) - signed(in_alu_1 (31) & in_alu_1));

                end if;

            when "001" => -- sll
                result <= std_logic_vector(shift_left(unsigned(in_alu_0), to_integer(unsigned(in_alu_1))))

            when "010" => -- slt
                if (signed(in_alu_0(31) & in_alu_0) < signed(in_alu_0(31) & in_alu_1)) then
                    result <= x"00000001";
                else
                    result <= x"00000000";
                end if;

            when "011" =>  -- sltu
                if (unsigned('0' & in_alu_0) < unsigned('0' & in_alu_1)) then
                    result <= x"00000001";
                else
                    result <= x"00000000";
                end if;

            when "100" => -- XOR
                result <= in_alu_0 

            when "101" => 
                if funct_7 = "0000000" then -- srl
                    result <= std_logic_vector(signed(in_alu_0(31) & in_alu_0) + signed(in_alu_1 (31) & in_alu_1));

                elsif funct_7 = "0000001" then -- sra
                    result <= std_logic_vector(signed(in_alu_0(31) & in_alu_0) - signed(in_alu_1 (31) & in_alu_1));

                end if;
            when "110" => -- or

            when "111" => -- and
        
            when others =>
                
        
        end case;
    end process logic;
    
    
end architecture rtl;