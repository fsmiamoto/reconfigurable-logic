library ieee;
use ieee.std_logic_1164.all;

entity Top is
  port (
    digit_enable : out std_logic_vector(3 downto 0);
    data         : out std_logic_vector(6 downto 0);
    clk          : in std_logic
  );
end Top;

architecture rtl of Top is
  component Decoder is
    port (
      input  : in std_logic_vector (3 downto 0);
      output : out std_logic_vector (6 downto 0)
    );
  end component;

  component ROM is
    port (
      address : in std_logic_vector (4 downto 0);
      clock   : in std_logic := '1';
      q       : out std_logic_vector (3 downto 0)
    );
  end component;

  component Counter is
    port (
      clock : in std_logic;
      sclr  : in std_logic;
      q     : out std_logic_vector (4 downto 0)
    );
  end component;

  signal encoded : std_logic_vector (3 downto 0);
  signal decoded : std_logic_vector(6 downto 0);

  signal rom_out     : std_logic_vector(3 downto 0);
  signal counter_out : std_logic_vector(4 downto 0);
begin
  dec : Decoder port map(
    input  => rom_out,
    output => decoded
  );

  mem : ROM port map(
    address => counter_out,
    clock   => clk,
    q       => rom_out
  );

  cnt : Counter port map(
    clock => clk,
    sclr  => '0',
    q     => counter_out
  );

  data         <= decoded;
  digit_enable <= (3 => '0', others => '1');
  encoded      <= "1101";

end architecture;