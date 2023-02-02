`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	 UW-Madison
// Engineer: 	 John Cabaj, Nate Williams, Paul McBride
// 
// Create Date:    9-18-2013
// Design Name:    VGA
// Module Name:    top_level 
// Project Name:   Mini-Project 2 - VGA Driver
// Target Devices:  Xilinx Vertex II FPGA
// Tool versions: 
// Description: 	Instantiate and encorporate all sub-modules
//
// Dependencies: 
//
// Revision:   1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top_level(output [7:0] pixel_r, pixel_g, pixel_b, 
					  output vsync, hsync, blank, comp_sync, clk_25mhz, LED_0, LED_1, LED_2, LED_3, 
					  input clk_100mhz, rst);

	//wires for sub-module interconnects					
	wire [23:0] pixel_in_dp, din_fifo, pixel_in_tg;
	wire [12:0] addr;
	wire wr_en, fifo_full, fifo_empty;
	wire vga_clk, clkin_ibufg_out, clk_100mhz_buf, locked_dcm;
	
	//assign LEDs
	assign LED_0 = ~clk_100mhz_buf;
	assign LED_1 = ~clk_25mhz;
	assign LED_2 = ~fifo_full;
	assign LED_3 = ~fifo_empty;

	//alias clk_25mhz output
	assign vga_clk = clk_25mhz;
	
	//vga clk at 100 mhz clock generator
	vgaclk vga_clk_gen1(.CLKIN_IN(clk_100mhz), 
								.RST_IN(rst), 
								.CLKFX_OUT(clk_25mhz), 
								.CLKIN_IBUFG_OUT(clkin_ibufg_out), 
								.CLK0_OUT(clk_100mhz_buf), 
								.LOCKED_OUT(locked_dcm)
								);
	//ROM							
	ROM r(.douta(pixel_in_dp), 
			.addra(addr), 
			.clka(clk_100mhz_buf)
			);
			
	//display plane module for ROM -> FIFO and image enlargement
	display_plane dp(.pixel_out(din_fifo), 
						  .addr(addr), 
						  .fifo_write(wr_en), 
						  .pixel_in(pixel_in_dp), 
						  .clk(clk_100mhz_buf), 
						  .rst(rst), 
						  .fifo_full(fifo_full)
						  );
						  
	//fifo					  
	xclk_fifo f(.dout(pixel_in_tg), 
					.full(fifo_full), 
					.empty(fifo_empty), 
					.din(din_fifo), 
					.rd_clk(vga_clk), 
					.rd_en(blank), 
					.wr_clk(clk_100mhz_buf), 
					.wr_en(wr_en), 
					.rst(rst)
					);
							
	//timing generator to generate monitor signals							
	timing_generator tg(.clk(vga_clk),
					 .rst(rst),
					 .fifo_empty(fifo_empty),
					 .blank(blank),
					 .pixel_in(pixel_in_tg),
					 .comp_sync(comp_sync),
					 .hsync(hsync),
					 .vsync(vsync),
					 .red(pixel_r),
					 .green(pixel_g),
					 .blue(pixel_b)
					 );

endmodule

