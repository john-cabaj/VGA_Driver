library verilog;
use verilog.vl_types.all;
entity top_level is
    port(
        pixel_r         : out    vl_logic_vector(7 downto 0);
        pixel_g         : out    vl_logic_vector(7 downto 0);
        pixel_b         : out    vl_logic_vector(7 downto 0);
        vsync           : out    vl_logic;
        hsync           : out    vl_logic;
        blank           : out    vl_logic;
        comp_sync       : out    vl_logic;
        clk_25mhz       : out    vl_logic;
        LED_0           : out    vl_logic;
        LED_1           : out    vl_logic;
        LED_2           : out    vl_logic;
        LED_3           : out    vl_logic;
        clk_100mhz      : in     vl_logic;
        rst             : in     vl_logic
    );
end top_level;
