mescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:39:17 01/29/2024 
// Design Name: 
// Module Name:    horizontal_counter 
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
module horizontal_counter(

		input clk_25MHz,
		
		output reg enable_V_counter=0,
		output reg [15:0] H_count_Value = 0
    );

	
	always @(posedge clk_25MHz)
	begin
		
		if(H_count_Value <800)
		begin
			H_counter_Value <= H_counter_Value+1;
			enable_V_counter <= 0;
		end
		else
		begin
			H_counter_Value <= 0;
			enable_V_counter <= 1;
		end
	end

endmodule

