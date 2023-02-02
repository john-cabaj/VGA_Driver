module t_timing_generator();
  
  
  wire [7:0] red, blue, green;
  wire hsync, vsync, blank, comp_sync;
  reg [23:0] pixel_in;
  reg clk, rst, fifo_empty;
  
  //timing_generator tg(.red(red), .blue(blue), .green(green), .hsync(hsync), .vsync(vsync), .blank(blank), .pixel_in(pixel_in), .clk(clk), .rst(rst), .fifo_empty(fifo_empty));
  vga_logic v(.clk(clk), .rst(rst), .fifo_empty(fifo_empty), .pixel_in(pixel_in), .blank(blank), .comp_sync(comp_sync), .hsync(hsync), .vsync(vsync), .red(red), .green(green), .blue(blue));
  
  initial begin
    rst = 1'b1;
    clk = 1'b0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    #1
    rst = 1'b0;
    #1004
    fifo_empty = 1'b1;
    #40
    fifo_empty = 1'b0;
    pixel_in = 24'hffffff;
    #24000
    $finish;
  end
  
endmodule
