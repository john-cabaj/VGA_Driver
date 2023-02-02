module t_display_plane();

  wire [23:0] pixel_in;
  reg  clk, rst, fifo_full;
  wire [23:0] pixel_out;
  wire [12:0] addr;
  wire fifo_write;

   
  display_plane dp(.pixel_out(pixel_out), .addr(addr), .fifo_write(fifo_write), .pixel_in(pixel_in), .clk(clk), .rst(rst), .fifo_full(fifo_full));
  rom_test rt(.pixel_out(pixel_in), .addr(addr), .clk(clk), .rst(rst));
   
  initial begin
    rst = 1'b1;
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  initial begin
    #1
    rst = 1'b0;
    fifo_full = 1'b0;
    #5000000
    fifo_full = 1'b1;
    #100
    fifo_full = 1'b0;
    #10
    fifo_full = 1'b1;
    #10
    fifo_full = 1'b0;
    #1010
    $finish;
  end
   
endmodule