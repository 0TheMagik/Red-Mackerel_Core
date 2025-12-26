-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"
-- CREATED		"Thu Dec 25 23:02:28 2025"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Core IS 
	PORT
	(

	);
END Core;

ARCHITECTURE bdf_type OF Core IS 

COMPONENT decoder_rv32i
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rd_write_en : OUT STD_LOGIC;
		 sel_mux_exe : OUT STD_LOGIC;
		 funct_3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 funct_7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rd : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rs1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rs2 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_file
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 rd_write_en : IN STD_LOGIC;
		 rd_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rd_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rs1_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rs2_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rs1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 rs2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT state_fetch
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 in_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 in_instruction_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 out_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 out_instruction_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT state_decode
	PORT(clk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 in_rd_write_en : IN STD_LOGIC;
		 in_sel_mux_exe : IN STD_LOGIC;
		 in_funct_3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 in_funct_7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 in_immediate : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 in_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 in_rd_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 in_rs1_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 in_rs1_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 in_rs2_addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 in_rs2_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 out_rd_write_en : OUT STD_LOGIC;
		 out_sel_mux_exe : OUT STD_LOGIC;
		 out_funct_3 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 out_funct_7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 out_immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 out_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 out_rd_addr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 out_rs1_addr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 out_rs1_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 out_rs2_addr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 out_rs2_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 



b2v_inst : decoder_rv32i
PORT MAP(instruction => SYNTHESIZED_WIRE_14,
		 rd_write_en => SYNTHESIZED_WIRE_3,
		 sel_mux_exe => SYNTHESIZED_WIRE_4,
		 funct_3 => SYNTHESIZED_WIRE_5,
		 funct_7 => SYNTHESIZED_WIRE_6,
		 immediate => SYNTHESIZED_WIRE_7,
		 rd => SYNTHESIZED_WIRE_9,
		 rs1 => SYNTHESIZED_WIRE_15,
		 rs2 => SYNTHESIZED_WIRE_16);


b2v_inst2 : register_file
PORT MAP(rs1_addr => SYNTHESIZED_WIRE_15,
		 rs2_addr => SYNTHESIZED_WIRE_16,
		 rs1_data => SYNTHESIZED_WIRE_11,
		 rs2_data => SYNTHESIZED_WIRE_13);


b2v_inst3 : state_fetch
PORT MAP(		 out_instruction => SYNTHESIZED_WIRE_14);


b2v_inst4 : state_decode
PORT MAP(in_rd_write_en => SYNTHESIZED_WIRE_3,
		 in_sel_mux_exe => SYNTHESIZED_WIRE_4,
		 in_funct_3 => SYNTHESIZED_WIRE_5,
		 in_funct_7 => SYNTHESIZED_WIRE_6,
		 in_immediate => SYNTHESIZED_WIRE_7,
		 in_instruction => SYNTHESIZED_WIRE_14,
		 in_rd_addr => SYNTHESIZED_WIRE_9,
		 in_rs1_addr => SYNTHESIZED_WIRE_15,
		 in_rs1_data => SYNTHESIZED_WIRE_11,
		 in_rs2_addr => SYNTHESIZED_WIRE_16,
		 in_rs2_data => SYNTHESIZED_WIRE_13);


END bdf_type;