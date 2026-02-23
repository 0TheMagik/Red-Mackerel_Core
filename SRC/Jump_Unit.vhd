library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- * jump_mux_sel = 0, addr + imm  ie. JAL
-- * jump_mux-sel = 1, rs1 + imm ie. JALR,
entity Jump_Unit is
    port (
        jump_mux_sel    : in std_logic;
        rs1_data        : in std_logic_vector(31 downto 0);
        instr_addr      : in std_logic_vector(31 downto 0);
        immediate       : in std_logic_vector(31 downto 0);
        jump_branch_dst : out std_logic_vector(31 downto 0)
    );
end entity Jump_Unit;

architecture structural of Jump_Unit is

    component Mux_2to1 is
    port (
        sel_mux         : in std_logic;
        in_mux0         : in std_logic_vector(31 downto 0);
        in_mux1         : in std_logic_vector(31 downto 0);
        out_mux         : out std_logic_vector(31 downto 0)
    );
    end component;

    component Adder is
    port (
        in_0            : in std_logic_vector(31 downto 0);
        in_1            : in std_logic_vector(31 downto 0);
        out_sum         : out std_logic_vector(31 downto 0)
    );
    end component;

    signal mux_out      : std_logic_vector(31 downto 0);

begin

    Jump_Mux: Mux_2to1 is
    port (
        sel_mux         => jump_mux_sel,
        in_mux0         => instr_addr,
        in_mux1         => rs1_data,
        out_mux         => mux_out
    );

    Jump_Adder: Adder is
    port (
        in_0            => mux_out,
        in_1            => immediate,
        out_sum         => jump_branch_dst
    );
    
end architecture structural;