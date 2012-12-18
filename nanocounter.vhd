library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nanocounter is

	PORT( 
	-- //////////// CLOCK //////////
	clk : in std_logic;
	ena : in std_logic;

	-- //////////// LED /////////
	Q : out std_logic_vector(7 downto 0)
);

end nanocounter;


architecture rtl of nanocounter is

signal d_out : unsigned(7 downto 0);

begin

		process(clk)
		begin
			if rising_edge(clk) then
				if ena = '1' then
					d_out <= d_out + 1;
				end if;
			end if;
		end process;

		Q <= std_logic_vector(d_out);
	
end architecture;