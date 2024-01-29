mescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:50 01/29/2024 
// Design Name: 
// Module Name:    VGA 
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
module VGA(

		input clk,
		input clk_25MHz,
		
		output Hsynq,
		output Vsynq,
		output [3:0] Red,
		output [3:0] Green,
		output [3:0] Blue
	

    );
	 
	 
wire enable_V_Counter;
wire [15:0] H_Count_Value;
wire [15:0] V_Count_Value;

horizontal_counter VGA_Horiz (clk_25MHz, enable_V_Counter, H_Count_Value);
vertical_counter VGA_Verti (clk_25MHz, enable_V_Counter, V_Count_Value);

// outputs
assign Hsynq = (H_Count_Value < 96) ? 1'bl:1'b0;
assign Vsynq = (V_Count_Value < 2) ? l'bl:1'b0;
// colors
assign Red = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
assign Green = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
assign Blue= (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;


endmodule

