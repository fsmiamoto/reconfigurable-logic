library ieee;
use ieee.std_logic_1164.all;

entity Top is
  port (
    digit_enable : out std_logic_vector(3 downto 0);
    data         : out std_logic_vector(6 downto 0);
    clk          : in std_logic;
    clk_out      : out std_logic
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
    generic (
      modulus : integer := 10
    );
    port (
      clock : in std_logic;
      sclr  : in std_logic;
      q     : out std_logic_vector (4 downto 0)
    );
  end component;

  component ClockDivider is
    generic (
      divide_by : integer := 1E6
    );
    port (
      clk_in  : in std_logic;
      clk_out : out std_logic
    );
  end component;

  signal encoded : std_logic_vector (3 downto 0);
  signal decoded : std_logic_vector(6 downto 0);

  signal reset_counter : std_logic := '0';
  signal rom_out       : std_logic_vector(3 downto 0);
  signal counter_out   : std_logic_vector(4 downto 0);
  signal clock         : std_logic;
begin
  dec : Decoder port map(
    input  => rom_out,
    output => decoded
  );

  mem : ROM port map(
    address => counter_out,
    clock   => clock,
    q       => rom_out
  );

  cnt : Counter
  generic map(
    modulus => 11
  )
  port map(
    clock => clock,
    sclr  => reset_counter,
    q     => counter_out
  );

  div : ClockDivider generic map(
    divide_by => 25E6
  )
  port map(
    clk_in  => clk,
    clk_out => clock
  );

  clk_out      <= clock;
  data         <= decoded;
  digit_enable <= (3 => '0', others => '1');
end architecture;