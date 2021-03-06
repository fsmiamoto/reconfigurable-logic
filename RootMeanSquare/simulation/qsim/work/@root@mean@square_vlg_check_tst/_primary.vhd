library verilog;
use verilog.vl_types.all;
entity RootMeanSquare_vlg_check_tst is
    port(
        squared         : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end RootMeanSquare_vlg_check_tst;
