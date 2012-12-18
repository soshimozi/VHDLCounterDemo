library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
	PORT (
		CLOCK_50 : in std_logic;
		LED : out std_logic_vector(7 downto 0);
		KEY				: in STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW					: in STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
end entity;
--
architecture rtl of top is

	component bcd_counter is
		port( 
		clk, reset, ena : in std_logic; 
		bcd1 : out std_logic_vector (3 downto 0);
		bcd2 : out std_logic_vector (3 downto 0));
	end component;
	
	component clk_50mhz_to_1hz is
		PORT (
			CLOCK_50MHZ : in std_logic;
			clk_divisor : in std_logic_vector(3 downto 0);
			CLOCK_1HZ : out std_logic
		);
	end component;

	component nanocounter is
		PORT( 
			clk : in std_logic;
			ena : in std_logic;
			Q : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component gc_cntr is
		PORT (
			reset : in  std_logic;    -- Async. active-high reset.
			clk   : in  std_logic;    -- Rising-edge-active clock.
			ena : in std_logic;
			q     : out std_logic_vector(7 downto 0) -- Counter output.
		);
	end component;	

	signal counterout : std_logic_vector(7 downto 0);
	signal gc_out : std_logic_vector(7 downto 0);
	signal led_out : std_logic_vector(7 downto 0);
	signal clock_enable : std_logic;
	signal rstn : std_logic;
	signal clock_divisor : std_logic_vector(3 downto 0);
	signal bcd_lownibble : std_logic_vector(3 downto 0);
	signal bcd_hinibble: std_logic_vector(3 downto 0);
	
	signal bcd_value : std_logic_vector(7 downto 0);
	alias bcd_hi : std_logic_vector(3 downto 0) is bcd_value(7 downto 4);
	alias bcd_low : std_logic_vector(3 downto 0) is bcd_value(3 downto 0);
	
begin

	rstn <= '0';
	clock_divisor <= SW;
	
	bcd_hi <= bcd_hinibble;
	bcd_low <= bcd_lownibble;

	process(CLOCK_50)
	variable last_counter : std_logic_vector(7 downto 0);
	begin
		if rising_edge(CLOCK_50) then
			case key is
				when "11" =>
					last_counter := counterout;
					led_out <= counterout;
				when "10" =>
					last_counter := gc_out;
					led_out <= gc_out;
				when "01" =>
					last_counter := bcd_value;
					led_out <= bcd_value;
				when others =>
					led_out <= last_counter;
			end case;
		end if;
				
	end process;
	
	u4 : bcd_counter 	port map ( 
		clk => CLOCK_50, reset => rstn,
		ena => clock_enable,
		bcd1 => bcd_lownibble,
		bcd2 => bcd_hinibble
		);

	u3: clk_50mhz_to_1hz PORT MAP (
		CLOCK_50MHZ => CLOCK_50,
		clk_divisor => clock_divisor,
		CLOCK_1HZ => clock_enable
		);
	
	u1 : nanocounter PORT MAP (
				clk => CLOCK_50,
				ena => clock_enable,
				Q => counterout
			);
			
	u2 : gc_cntr PORT MAP (
				reset => rstn,
				clk => CLOCK_50,
				ena => clock_enable,
				q   => gc_out 
			);			
	
		
	LED <= led_out;

end rtl;