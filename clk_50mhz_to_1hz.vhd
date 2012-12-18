library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clk_50mhz_to_1hz is
	PORT (
		CLOCK_50MHZ : in std_logic;
		clk_divisor : in std_logic_vector(3 downto 0);
		CLOCK_1HZ : out std_logic
	);
end entity;


-- divisor will set the upper range of the count value to 
-- to the base divisor value (50x10^6) divided by that value
-- so if you want a 2hz rate you would use 2 as a divisor
-- if you want a 10hz rate you would use 10 as a divisor

architecture rtl of clk_50mhz_to_1hz is

constant base_divisor : integer := 3333333;

signal clock_enabled : std_logic := '0';

begin

	process(CLOCK_50MHZ)
	variable divisor : integer range 1 to 31 := 1;
	variable count : integer range 0 to 50000000 := 50000000;
	variable upper_range : integer range 0 to 50000000;
	begin
		if rising_edge(CLOCK_50MHZ) then
			
			divisor := to_integer(unsigned(clk_divisor));
			
			upper_range := base_divisor * divisor;
			
			count := count - 1;
		
			if count = 0 then
				clock_enabled <= '1';
				count := upper_range;
			else
				clock_enabled <= '0';
			end if;
			
		end if;
		
	end process;
	
	
	CLOCK_1HZ <= clock_enabled;
	
end rtl;