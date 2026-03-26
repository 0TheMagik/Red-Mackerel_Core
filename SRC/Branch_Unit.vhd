library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Branch_Unit is
    port (
        funct_3         : in std_logic_vector(2 downto 0);
        in_branchU_1    : in std_logic_vector(31 downto 0);
        in_branchU_2    : in std_logic_vector(31 downto 0);
        branch_flag     : in std_logic;
        out_branchU     : out std_logic_vector(31 downto 0)
    );
end entity Branch_Unit;

architecture rtl of Branch_Unit is
    branch_result   : std_logic := '0';

begin
    branch_logic: process(funct_3, in_branchU_1, in_branchU_2, branch_flag)
    begin
        if branch_flag = '1' then
            case funct_3 is
                when "000" => -- BEQ
                    if (signed(in_branchU_1) = signed(in_branchU_2)) then
                        branch_result <= '1';
                    else
                        branch_result <= '0';
                    end if;

                when "001" => -- BNE
                    if (signed(in_branchU_1) /= signed(in_branchU_2)) then
                        branch_result <= '1';
                    else
                        branch_result <= '0';
                    end if;

                when "100" => -- BLT
                    if (signed(in_branchU_1) < signed(in_branchU_2)) then
                        branch_result <= '1';
                    else
                        branch_result <= '0';
                    end if;

                when "101" => -- BGE
                    if (signed(in_branchU_1) >= signed(in_branchU_2)) then
                        branch_result <= '1';
                    else
                        branch_result <= '0';
                    end if;

                when "110" => -- BLTU
                    if (unsigned(in_branchU_1) < unsigned(in_branchU_2)) then
                        branch_result <= '1';
                    else
                        branch_result <= '0';
                    end if;

                when "111" => -- BGEU
                    if (unsigned(in_branchU_1) >= unsigned(in_branchU_2)) then
                        branch_result <= '1';
                    else
                        branch_result <= '0';
                    end if;

                when others =>
                    branch_result <= '0';
            
            end case;
        else
            branch_result <= '0';
        end if;
    end process branch_logic;
    
    out_branchU <= branch_result;    
end architecture rtl;