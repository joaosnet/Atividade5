library ieee;
use ieee.std_logic_1164.all;

entity top_level is
	port (
		 clk : in std_logic;
		 reset : in std_logic
	);
end top_level;

architecture str of top_level is
	component nios_cpu_subsystem is
	  port (
			clk_clk       : in std_logic := 'X'; -- clk
			reset_reset_n : in std_logic := 'X'  -- reset_n
	  );
	end component nios_cpu_subsystem;
begin
	u0 : component nios_cpu_subsystem
	port map (
		clk_clk       => clk,       --   clk.clk
		reset_reset_n => reset -- reset.reset_n
	);
end str;