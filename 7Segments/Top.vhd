-- TODO: 
-- Refactor, it's a mess

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Top is
  port (
    digit_enable : out std_logic_vector(3 downto 0);
    data         : out std_logic_vector(6 downto 0);
    clk          : in std_logic;
    left_right   : in std_logic;
    fast_slow    : in std_logic;
    word_select  : in std_logic;
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
      modulus : integer
    );
    port (
      clock  : in std_logic;
      updown : in std_logic;
      q      : out std_logic_vector (4 downto 0)
    );
  end component;

  constant UP   : std_logic := '1';
  constant DOWN : std_logic := '0';

  component ClockDivider is
    generic (
      divide_by : integer := 1E6
    );
    port (
      clk_in  : in std_logic;
      clk_out : out std_logic
    );
  end component;

  signal encoded : std_logic_vector (15 downto 0) := "1010111011011010";

  signal decoded_0 : std_logic_vector(6 downto 0);
  signal decoded_1 : std_logic_vector(6 downto 0);
  signal decoded_2 : std_logic_vector(6 downto 0);
  signal decoded_3 : std_logic_vector(6 downto 0);

  signal active_display : integer range 0 to 3 := 0;

  signal rom_out  : std_logic_vector(3 downto 0);
  signal rom_addr : std_logic_vector(4 downto 0);

  signal counter_out    : std_logic_vector(4 downto 0);
  signal counter_updown : std_logic;

  signal shift_clk   : std_logic;
  signal shift_fast  : std_logic;
  signal shift_slow  : std_logic;
  signal display_clk : std_logic;
begin
  dec0 : Decoder port map(
    input  => encoded(3 downto 0),
    output => decoded_0
  );
  dec1 : Decoder port map(
    input  => encoded(7 downto 4),
    output => decoded_1
  );
  dec2 : Decoder port map(
    input  => encoded(11 downto 8),
    output => decoded_2
  );
  dec3 : Decoder port map(
    input  => encoded(15 downto 12),
    output => decoded_3
  );

  mem : ROM port map(
    address => rom_addr,
    clock   => shift_clk,
    q       => rom_out
  );

  cnt : Counter
  generic map(
    modulus => 12
  )
  port map(
    clock  => shift_clk,
    updown => counter_updown,
    q      => counter_out
  );

  div0 : ClockDivider generic map(
    divide_by => 10E6
  )
  port map(
    clk_in  => clk,
    clk_out => shift_slow
  );

  div1 : ClockDivider generic map(
    divide_by => 5E6
  )
  port map(
    clk_in  => clk,
    clk_out => shift_fast
  );

  div3 : ClockDivider generic map(
    divide_by => 25E2
  )
  port map(
    clk_in  => clk,
    clk_out => display_clk
  );

  clk_out        <= shift_clk;
  counter_updown <= not left_right;
  rom_addr       <= counter_out when word_select = '1' else std_logic_vector(unsigned(counter_out) + 12);
  shift_clk      <= shift_fast when fast_slow = '0' else shift_slow;

  process (display_clk)
  begin
    if (rising_edge(display_clk)) then
      if (active_display = 3) then
        active_display <= 0;
      else
        active_display <= active_display + 1;
      end if;
    end if;
  end process;

  process (shift_clk)
  begin
    if (rising_edge(shift_clk)) then
      if (counter_updown = UP) then
        encoded <= encoded(11 downto 0) & rom_out;
      else
        encoded <= rom_out & encoded(15 downto 4);
      end if;
    end if;
  end process;

  digit_enable <= "1110" when active_display = 0 else
    "1101" when active_display = 1 else
    "1011" when active_display = 2 else
    "0111" when active_display = 3 else
    "1111";

  data <= decoded_0 when active_display = 0 else
    decoded_1 when active_display = 1 else
    decoded_2 when active_display = 2 else
    decoded_3 when active_display = 3 else
    (others => '1');

end architecture;