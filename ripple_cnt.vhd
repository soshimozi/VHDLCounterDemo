library ieee;
use ieee.std_logic_1164.all; use ieee.std_logic_unsigned.all;
-- ~ --
entity ripple_cnt is
  generic (
    n : natural := 8
  );
  port (
    clk   : in std_logic;
    clear : in std_logic;
	 ena : in std_logic;

    dout  : out std_logic_vector(n-1 downto 0)
  );
end ripple_cnt;
-- ~ --
architecture arch_rtl of ripple_cnt is
  -- signals declaration
  signal clk_i, q_i   : std_logic_vector(n-1 downto 0);

begin
  -- clocks
  clk_i(0)            <= clk;
  clk_i(n-1 downto 1) <= q_i(n-2 downto 0);

  -- flip-flops
  gen_cnt: for i in 0 to n-1 generate
    dff: process(clear, clk_i)
    begin
      if (clear = '1') then
        q_i(i) <= '1';
      elsif (clk_i(i)'event and clk_i(i) = '1') then
			if ena = '1' then
				q_i(i) <= not q_i(i);
			end if;
      end if;
    end process dff;
  end generate;
  
  -- output
  dout <= not q_i;
  -- ~ --
end arch_rtl;