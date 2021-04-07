library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is
	port (
		a    : in std_logic_vector(7 downto 0);
		b    : in std_logic_vector(7 downto 0);
		clk  : in std_logic;
		sel  : in std_logic_vector(2 downto 0);
		res  : out std_logic_vector(7 downto 0)
	);
end ALU;

architecture behavior of ALU is
	signal next_output : std_logic_vector(7 downto 0);
begin
	process (a, b, sel, clk)
	begin
		if (clk'EVENT and clk = '1') then
			case sel is
				when "000" => 
					next_output <= a + b;
				when "001" => 
					next_output <= a + (not b) + 1;
				when "010" => 
					next_output <= a and b;
				when "011" => 
					next_output <= a or b;
				when "100" => 
					next_output <= a - b;
				when "101" => 
					next_output <= not a;
				when "110" => 
					next_output <= not (a or b);
				when "111" => 
					next_output <= not (a and b);
			end case;
		end if;
	end process;
	res <= next_output;
end behavior;