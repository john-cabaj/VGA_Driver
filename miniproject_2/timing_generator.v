`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	UW-Madison	
// Engineer: 	ECE 554, John Cabaj, Nate Williams, Paul McBride
// 
// Create Date:    September 19, 2013
// Design Name:    vga
// Module Name:    timing_generator
// Project Name:   Mini-Project 2 - VGA
// Target Devices:  Xilinx Vertex II FPGA
// Tool versions: 
// Description: 	Control timing of hsync, vsync, blank, and pixels for proper vga timing
//
// Dependencies: 
//
// Revision:  	1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module timing_generator(output [7:0] red, green, blue, output hsync, vsync, blank, comp_sync, input [23:0] pixel_in, input clk, rst, fifo_empty);
	 
	 //current pixel locations in timing
	 reg [9:0] pixel_x;
	 reg [9:0] pixel_y;
	 
	 // next pixel logic
	 wire [9:0] next_pixel_x;
	 wire [9:0] next_pixel_y;
	 
	 //update next line pixel or reset at end of line
	 assign next_pixel_x = (pixel_x == 10'd799)? 0 : pixel_x + 1;
	 //update next line when at the end of horizontal timing +1, or reset when full screen has been output
	 assign next_pixel_y = (pixel_x == 10'd799)? ((pixel_y == 10'd520) ? 0 : pixel_y + 1) : pixel_y;
	 
	 //assign 96 cycle hsync
	 assign hsync = (pixel_x < 10'd656) || (pixel_x > 10'd751); 
	 //assign 2 cycle vsync
	 assign vsync = (pixel_y < 10'd490) || (pixel_y > 10'd491);
	 //assign blank during pixel active fifo read time
	 assign blank = ~((pixel_x > 10'd639) | (pixel_y > 10'd479));
	 //not used
	 assign comp_sync = 1'b0;
		
	 //continuously assign rgb values when reading from fifo
	 assign red = (blank) ? pixel_in[23:16] : 8'hxx;
	 assign green = (blank) ? pixel_in[15:8] : 8'hxx;
	 assign blue = (blank) ? pixel_in[7:0] : 8'hxx;
	 
	 //sequential logic
	 always@(posedge clk, posedge rst)
	   if(rst) begin
		  pixel_x <= 10'h0;
		  pixel_y <= 10'h0;
		end else begin
			//if the fifo is empty, don't update pixel
		    if(!fifo_empty) begin
		        pixel_x <= next_pixel_x;
		        pixel_y <= next_pixel_y;
		    end
		end
		
endmodule
