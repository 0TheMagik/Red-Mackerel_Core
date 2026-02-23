library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Decoder_RV32I is
    port (
        clk                 : in std_logic;
        rst                 : in std_logic;
        instruction         : in std_logic_vector(31 downto 0);
        funct_3             : out std_logic_vector(2 downto 0);
        funct_7             : out std_logic_vector(6 downto 0);
        rs1                 : out std_logic_vector(4 downto 0);
        rs2                 : out std_logic_vector(4 downto 0);
        rd                  : out std_logic_vector(4 downto 0);
        immediate           : out std_logic_vector(31 downto 0);
        rd_write_en         : out std_logic;
        sel_mux_exe         : out std_logic;
        jump_branch_mux_sel : out std_logic
    );
end entity Decoder_RV32I;


architecture rtl of Decoder_RV32I is

    type opcode is (INVALID, LOAD, STORE, BRANCH, JALR, JAL, OP_IMM, OP, AUIPC, LUI);
    signal op_type      : opcode := INVALID;
    
    -- type instruction is ();

    signal internal_funct_3             : std_logic_vector(2 downto 0) := "000";
    signal internal_funct_7             : std_logic_vector(6 downto 0) := "0000000";
    signal internal_rs1                 : std_logic_vector(4 downto 0) := "00000";
    signal internal_rs2                 : std_logic_vector(4 downto 0) := "00000";
    signal internal_rd                  : std_logic_vector(4 downto 0) := "00000";
    signal internal_immediate           : std_logic_vector(31 downto 0):= x"00000000";
    signal internal_rd_write_en         : std_logic := '0';
    signal internal_sel_mux_exe         : std_logic := '0';
    signal internal_jump_branch_mux_sel : std_logic := '0';

begin
    
    Decoding: process(clk, rst, instruction)
    begin
        if rst = '1' then
            internal_funct_3        <= "000";
            internal_funct_7        <= "0000000";
            internal_rs1            <= "00000";
            internal_rs2            <= "00000";
            internal_rd             <= "00000";
            internal_immediate      <= x"00000000";
            internal_rd_write_en    <= '0';
            internal_sel_mux_exe    <= '0';

        else
            case instruction (6 downto 0) is
                when "0110111" => -- LUI
                    internal_funct_3            <= "000";
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= "00000";
                    internal_rs2                <= "00000";
                    internal_rd                 <= instruction(11 downto 7);
                    internal_immediate          <= x"000" & instruction(31 downto 12);
                    internal_rd_write_en        <= '1';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '0';

                when "0010111" => -- AUIPC
                    internal_funct_3            <= "000";
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= "00000";
                    internal_rs2                <= "00000";
                    internal_rd                 <= instruction(11 downto 7);
                    internal_immediate          <= instruction(31 downto 12) & x"000";
                    internal_rd_write_en        <= '1';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '0';

                when "1101111" => -- JAL
                    internal_funct_3            <= "000";
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= "00000";
                    internal_rs2                <= "00000";
                    internal_rd                 <= instruction(11 downto 7);
                    internal_immediate          <= "00000000000" & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';
                    internal_rd_write_en        <= '1';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '0';


                when "1100111" => -- JALR
                    internal_funct_3            <= instruction(14 downto 12);
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= instruction(19 downto 15);
                    internal_rs2                <= "00000";
                    internal_rd                 <= instruction(11 downto 7);
                    internal_immediate          <= "00000000000000000000" & instruction(31 downto 20);
                    internal_rd_write_en        <= '1';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '1';

                when "1100011" => -- BRANCH
                    internal_funct_3            <= instruction(14 downto 12);
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= instruction(19 downto 15);
                    internal_rs2                <= instruction(24 downto 20);
                    internal_rd                 <= "00000";
                    internal_immediate          <= "00000000000000000" & instruction(31) & instruction(7) & instruction(30 downto 25) &  instruction(11 downto 6) & '0';
                    internal_rd_write_en        <= '0';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '0';

                when "0000011" => -- LOAD
                    internal_funct_3            <= instruction(14 downto 12);
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= instruction(19 downto 15);
                    internal_rs2                <= "00000";
                    internal_rd                 <= instruction(11 downto 7);
                    internal_immediate          <= "00000000000000000000" & instruction(31 downto 20);
                    internal_rd_write_en        <= '1';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '0';


                when "0100011" => -- STORE
                    internal_funct_3            <= instruction(14 downto 12);
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= instruction(19 downto 15);
                    internal_rs2                <= instruction(24 downto 20);
                    internal_rd                 <= "00000";
                    internal_immediate          <= "00000000000000000" & instruction(31 downto 25) & instruction(11 downto 7);
                    internal_rd_write_en        <= '0';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '0';

                when "0010011" => -- OP-IMM
                    internal_funct_3            <= instruction(14 downto 12);
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= instruction(19 downto 15);
                    internal_rs2                <= "00000";
                    internal_rd                 <= instruction(11 downto 7);
                    internal_immediate          <= "00000000000000000000" & instruction(31 downto 20);
                    internal_rd_write_en        <= '1';
                    internal_sel_mux_exe        <= '1';
                    internal_jump_branch_mux_sel<= '0';

                when "0110011" => -- OP
                    internal_funct_3            <= instruction(14 downto 12);
                    internal_funct_7            <= instruction(31 downto 25);
                    internal_rs1                <= instruction(19 downto 15);
                    internal_rs2                <= instruction(24 downto 20);
                    internal_rd                 <= instruction(11 downto 7);
                    internal_immediate          <= x"00000000";                    
                    internal_rd_write_en        <= '1';
                    internal_sel_mux_exe        <= '0';
                    internal_jump_branch_mux_sel<= '0';

                when others =>
                    internal_funct_3            <= "000";
                    internal_funct_7            <= "0000000";
                    internal_rs1                <= "00000";
                    internal_rs2                <= "00000";
                    internal_rd                 <= "00000";
                    internal_immediate          <= x"00000000";
                    internal_rd_write_en        <= '0';
                    internal_sel_mux_exe        <= '0';
                    internal_jump_branch_mux_sel<= '0';

            end case;
        end if;
    end process Decoding;

    funct_3             <= internal_funct_3;
    funct_7             <= internal_funct_7;
    rs1                 <= internal_rs1;
    rs2                 <= internal_rs2;
    rd                  <= internal_rd;
    immediate           <= internal_immediate;
    rd_write_en         <= internal_rd_write_en;
    sel_mux_exe         <= internal_sel_mux_exe;

end architecture rtl;