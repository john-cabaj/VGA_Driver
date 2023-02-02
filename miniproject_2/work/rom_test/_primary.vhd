library verilog;
use verilog.vl_types.all;
entity rom_test is
    port(
        pixel_out       : out    vl_logic_vector(23 downto 0);
        addr            : in     vl_logic_vector(12 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end rom_test;
