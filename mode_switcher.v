mescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:43:09 01/29/2024 
// Design Name: 
// Module Name:    mode_switcher 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mode_switcher(

		input clk,
		input [7:0] dipswitch,
		
		output reg [7:0] led,
		output reg [1:0] mode

    );

	
	reg [7:0] dipswitch_reg; 


	always @(posedge clk)
	begin
		
		dipswitch_reg <= dipswitch
	
	end
	

	
	always @(posedge clk)
	begin 
        led <= dipswitch_reg;
	end 


	always @(posedge clk)
	begin	
	case(dipswitch_reg[2:0])
		
		3'b111: mode = 2'b11;
        	3'b011: mode = 2'b10;
        	3'b001: mode = 2'b01;
	        default: output_value = 2'b11;
		endcase
		
	end


endmodule

