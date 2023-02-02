`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	UW-Madison	
// Engineer: 	John Cabaj, Nate Williams, Paul McBride
// 
// Create Date:    September 19, 2013
// Design Name:    vga
// Module Name:    display_plane
// Project Name:   Mini-Project 2 - VGA
// Target Devices:  Xilinx Vertex II FPGA
// Tool versions: 
// Description: 	Control rom accesses and fifo writes
//
// Dependencies: 
//
// Revision:  	1.0
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module display_plane(output [23:0] pixel_out, output reg [12:0] addr, output reg fifo_write, input [23:0] pixel_in, input clk, rst, fifo_full);
    
    reg [6:0] horiz_count;							//counting  the pixels per line
    reg [5:0] vert_count;							//counting the vertical lines
    wire [6:0] next_horiz_count;					//next pixel per line count
    wire [5:0] next_vert_count;						//next vertical lines count
    reg [2:0] state, next_state;					//state and next state instantiation
    reg [2:0] first_four, vert_stretch;    			//first four for fifo delay, vert stretch to stretch each 8 lines downward
    
	//state variables
    localparam IDLE = 3'd0, LAST = 3'd7;
    
	//increment the pixels on the line or reset when end of line reached
    assign next_horiz_count = (horiz_count == 7'd79) ? 7'd0 : horiz_count + 7'd1;
	//if we've output the horizontal line 8 times (80x60->640x480), then 
	//check if full screen is output to reset or simply increment, otherwise keep outputting on same line
    assign next_vert_count = ((vert_stretch == 3'd7) && (horiz_count == 7'd79)) ? ((vert_count == 6'd59) ? 6'd0 : vert_count + 6'd1) : vert_count;
    
	//pixel being written is pixel being read
    assign pixel_out = pixel_in;
    
	//sequential logic
    always@(posedge clk, posedge rst) begin
        if(rst) begin
           state <= IDLE;
           addr <= 13'd0;
           horiz_count <= 7'd0;
           vert_count <= 6'd0;
           first_four <= 3'd0;
			  vert_stretch <= 3'd0;
        end
        else begin
			//fifo initializing, don't do anything
            if(first_four != 3'd4) begin
               first_four <= first_four + 3'd1;
            end
			//if the fifo isn't full
            if(!fifo_full) begin
			   //update the horizontal and vertical pixel counts
               if(state == 3'd6) begin
                  horiz_count <= next_horiz_count;
                  vert_count <= next_vert_count;
						//if we reached the end of a horizontal line, increment our vertical stretch count
						if(next_horiz_count == 7'd0) begin
							vert_stretch <= vert_stretch + 3'd1;
						end
               end
			   //in last state, update the rom read address
               if(state == LAST) begin
                  addr <= vert_count * 80 + horiz_count;
               end
			   //update state
               state <= next_state;
            end
        end 
    end
    
	//combinational logic
    always@(state, first_four, fifo_full) begin
        fifo_write = 1'b0;		//default no write to fifo
        case(state)
            IDLE: begin
				//in idle and fifo is full or still initializing, stay idle
                if(fifo_full || (first_four < 3'd4)) begin
                  next_state = IDLE;  
                end
                else begin
				   //write to fifo, update state
                   fifo_write = 1'b1;
                   next_state = state + 3'd1; 
                end
            end
            default: begin
				//fifo not full, write to it
                if(!fifo_full) begin
                   fifo_write = 1'b1; 
                end
				//update state
                next_state = state + 3'd1;
            end
        endcase
    end
    
endmodule
