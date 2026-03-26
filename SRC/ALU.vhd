library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
    port (
        funct_3         : in std_logic_vector(2 downto 0);
        funct_7         : in std_logic_vector(6 downto 0);
        in_alu_1        : in std_logic_vector(31 downto 0);
        in_alu_2        : in std_logic_vector(31 downto 0);
        branch_flag     : in std_logic;
        imm_flag        : in std_logic;
        out_alu         : out std_logic_vector(31 downto 0)
    );
end entity ALU;

architecture rtl of ALU is
    
    signal result : std_logic_vector(32 downto 0);

begin
    logic: process(funct_3, funct_7, in_alu_1, in_alu_2, branch_flag, imm_flag)
    begin
        if branch_flag = '0' then
            case funct_3 is
                when "000" =>
                    if funct_7 = "0000000" or imm_flag = '1' then -- add & addi
                        result <= std_logic_vector(signed(in_alu_1(31) & in_alu_1) + signed(in_alu_2 (31) & in_alu_2));

                    elsif funct_7 = "0100000" and imm_flag = '0' then -- sub
                        result <= std_logic_vector(signed(in_alu_1(31) & in_alu_1) - signed(in_alu_2 (31) & in_alu_2));

                    end if;

                when "001" => -- sll & slli
                    result <= std_logic_vector(shift_left(unsigned(in_alu_1), to_integer(unsigned(in_alu_2))));

                when "010" => -- slt & slti
                    if (signed(in_alu_1(31) & in_alu_1) < signed(in_alu_1(31) & in_alu_2)) then
                        result <= x"00000001";
                    else
                        result <= x"00000000";
                    end if;

                when "011" =>  -- sltu & sltiu
                    if (unsigned('0' & in_alu_1) < unsigned('0' & in_alu_2)) then
                        result <= x"00000001";
                    else
                        result <= x"00000000";
                    end if;

                when "100" => -- XOR & XORI
                    result <= in_alu_1 XOR in_alu_2;

                when "101" => 
                    if funct_7 = "0000000" then -- srl & srli
                        result <= std_logic_vector(shift_right(unsigned(in_alu_1), to_integer(unsigned(in_alu_2))));

                    elsif funct_7 = "0000001" then -- sra & srai
                        result <= std_logic_vector(shift_right(signed(in_alu_1)), to_integer(unsigned(in_alu_2))));

                    end if;
                    
                when "110" => -- or & ori
                    result <= in_alu_1 or in_alu_2;

                when "111" => -- and & andi
                    result <= in_alu_1 and in_alu_2;

                when others =>
                    result <= (others => '0');
            
            end case;

        else
            result <= x"00000000";
            
        end if;
        
    end process logic;
    
    out_alu <= result(31 downto 0);
    
end architecture rtl;