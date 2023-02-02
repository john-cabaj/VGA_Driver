library verilog;
use verilog.vl_types.all;
entity timing_generator is
    port(
        red             : out    vl_logic_vector(7 downto 0);
        green           : out    vl_logic_vector(7 downto 0);
        blue            : out    vl_logic_vector(7 downto 0);
        hsync           : out    vl_logic;
        vsync           : out    vl_logic;
        blank           : out    vl_logic;
        comp_sync       : out    vl_logic;
        pixel_in        : in     vl_logic_vector(23 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        fifo_empty      : in     vl_logic
    );
end timing_generator;
