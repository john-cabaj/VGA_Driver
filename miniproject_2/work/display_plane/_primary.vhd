library verilog;
use verilog.vl_types.all;
entity display_plane is
    port(
        pixel_out       : out    vl_logic_vector(23 downto 0);
        addr            : out    vl_logic_vector(12 downto 0);
        fifo_write      : out    vl_logic;
        pixel_in        : in     vl_logic_vector(23 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        fifo_full       : in     vl_logic
    );
end display_plane;
