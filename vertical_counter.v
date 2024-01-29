mescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:42:27 01/29/2024 
// Design Name: 
// Module Name:    vertical_counter 
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
module vertical_counter(

		input clk_25MHz,
		
		input reg enable_V_counter=0,
		output reg [15:0] V_count_Value=0

    );
	 
	 
	 always @(posedge clk_25MHz)
	 begin
	 if(enable_V_counter==1'b1)
		 begin
			if(V_count_Value < 524)
				V_count_Value <= V_count_Value+1;
		 
			else
				V_count_Value <= 0;
		 end
	 end
	 


endmodule

