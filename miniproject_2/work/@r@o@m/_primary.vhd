library verilog;
use verilog.vl_types.all;
entity ROM is
    port(
        clka            : in     vl_logic;
        addra           : in     vl_logic_vector(12 downto 0);
        douta           : out    vl_logic_vector(23 downto 0)
    );
end ROM;
