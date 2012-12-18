library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd_counter is
		port( 
		clk, reset : in std_logic; 
		ena : std_logic;
		bcd1 : out std_logic_vector (3 downto 0);
		bcd2 : out std_logic_vector (3 downto 0));
end entity;

architecture Behavioral of bcd_counter is
	signal bcd1_int : std_logic_vector (3 downto 0) := "0000";
	signal bcd2_int : std_logic_vector (3 downto 0) := "0000";

	begin

	process (clk, reset) 
	begin -- process bcd_counting 
		if reset = '1' then -- asynchronous reset (active high) 
			bcd1_int <= ( others => '0'); 
			bcd2_int <= ( others => '0'); 
		elsif rising_edge(clk) then -- rising clock edge 

			if ena = '1' then
				if bcd1_int = "1001" then 
					bcd1_int <= "0000"; 
					
					if bcd2_int = "1001" then 
						bcd2_int <= "0000"; 
					else 
						bcd2_int <= bcd2_int + '1'; 
					end if; 
				else 
					bcd1_int <= bcd1_int + '1'; 
				end if; 
			end if;
			
		end if; 
	end process; 

	bcd1 <= bcd1_int;
	bcd2 <= bcd2_int;

end Behavioral;