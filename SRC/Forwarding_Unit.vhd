library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Forwarding_Unit is
    port (
        -- Input From ID_EX
        rs1_addr            : in std_logic_vector(4 downto 0);
        rs2_addr            : in std_logic_vector(4 downto 0);
        -- Input From EX_MEM
        EX_MEM_rd_addr      : in std_logic_vector(4 downto 0);
        EX_MEM_rd_write_en  : in std_logic;
        EX_MEM_sel_mux_wb   : in std_logic_vector(1 downto 0);

        -- Input From MEM_WB
        MEM_WB_rd_addr      : in std_logic_vector(4 downto 0);
        MEM_WB_rd_write_en  : in std_logic;
        MEM_WB_sel_mux_wb   : in std_logic_vector(1 downto 0);

        -- Output To Forwarding Muxes
        sel_mux_fwd1        : out std_logic_vector(2 downto 0);
        sel_mux_fwd2        : out std_logic_vector(2 downto 0)
    );
end entity Forwarding_Unit;

architecture rtl of Forwarding_Unit is

    signal internal_sel_mux_fwd1    : std_logic_vector(2 downto 0) := "000";
    signal internal_sel_mux_fwd2    : std_logic_vector(2 downto 0) := "000";
    
begin
    fwd1: process(rs1_addr, EX_MEM_rd_addr, EX_MEM_rd_write_en, EX_MEM_sel_mux_wb, MEM_WB_rd_addr, MEM_WB_rd_write_en, MEM_WB_sel_mux_wb)
    begin
        if EX_MEM_rd_write_en = '1' and EX_MEM_sel_mux_wb = "00" and rs1_addr /= "00000" and rs1_addr = EX_MEM_rd_addr then
            internal_sel_mux_fwd1 <= "001";
        
        elsif EX_MEM_rd_write_en = '1' and EX_MEM_sel_mux_wb = "01" and rs1_addr /= "00000" and rs1_addr = MEM_WB_rd_addr then
            internal_sel_mux_fwd1 <= "010";

        elsif MEM_WB_rd_write_en = '1' and MEM_WB_sel_mux_wb = "00" and rs1_addr /= "00000" and rs1_addr = MEM_WB_rd_addr then
            internal_sel_mux_fwd1 <= "011";

        elsif MEM_WB_rd_write_en = '1' and MEM_WB_sel_mux_wb = "01" and rs1_addr /= "00000" and rs1_addr = MEM_WB_rd_addr then
            internal_sel_mux_fwd1 <= "100";

        else
            internal_sel_mux_fwd1 <= "000";
        end if;
        
    end process fwd1;

    fwd2: process(rs2_addr, EX_MEM_rd_addr, EX_MEM_rd_write_en, EX_MEM_sel_mux_wb, MEM_WB_rd_addr, MEM_WB_rd_write_en, MEM_WB_sel_mux_wb)
    begin
        if EX_MEM_rd_write_en = '1' and EX_MEM_sel_mux_wb = "00" and rs2_addr /= "00000" and rs2_addr = EX_MEM_rd_addr then
            internal_sel_mux_fwd2 <= "001";
        
        elsif EX_MEM_rd_write_en = '1' and EX_MEM_sel_mux_wb = "01" and rs2_addr /= "00000" and rs2_addr = MEM_WB_rd_addr then
            internal_sel_mux_fwd2 <= "010";

        elsif MEM_WB_rd_write_en = '1' and MEM_WB_sel_mux_wb = "00" and rs2_addr /= "00000" and rs2_addr = MEM_WB_rd_addr then
            internal_sel_mux_fwd2 <= "011";

        elsif MEM_WB_rd_write_en = '1' and MEM_WB_sel_mux_wb = "01" and rs2_addr /= "00000" and rs2_addr = MEM_WB_rd_addr then
            internal_sel_mux_fwd2 <= "100";

        else
            internal_sel_mux_fwd2 <= "000";
        end if;
        
    end process fwd2;
    
    sel_mux_fwd1 <= internal_sel_mux_fwd1;
    sel_mux_fwd2 <= internal_sel_mux_fwd2;
    
end architecture rtl;