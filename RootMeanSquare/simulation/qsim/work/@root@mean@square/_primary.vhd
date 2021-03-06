library verilog;
use verilog.vl_types.all;
entity RootMeanSquare is
    port(
        squared         : out    vl_logic_vector(31 downto 0);
        clock           : in     vl_logic
    );
end RootMeanSquare;
