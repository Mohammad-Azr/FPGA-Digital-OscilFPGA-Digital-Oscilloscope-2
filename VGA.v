`timescale 1ns / 1ps
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
		
		input [2:0] signal_data,
		
		input [2:0] FFT_data,
		
		input [1:0] mode,
		
		output Hsynq,
		output Vsynq,
		
		output reg [3:0] Red,
		output reg [3:0] Green,
		output reg [3:0] Blue

    );
	 
	 
wire enable_V_Counter;
wire [15:0] H_Count_Value;
wire [15:0] V_Count_Value;


reg [15:0] x_init_counter=0;
reg [15:0] y_init_counter=0;

reg start_update=0;
reg update_col_counter=0;


horizontal_counter VGA_Horiz (clk_25MHz, enable_V_Counter, H_Count_Value);
vertical_counter VGA_Verti (clk_25MHz, enable_V_Counter, V_Count_Value);


//frame
reg [11:0] frame [479:0][639:0];

reg [11:0] new_col_data [479:0];


// outputs
assign Hsynq = (H_Count_Value < 96) ? 1'b1:1'b0;
assign Vsynq = (V_Count_Value < 2) ? 1'b1:1'b0;




always @(posedge clk_25MHz)
begin
	if(H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34)
	begin	
		Red <= frame[V_Count_Value-35][H_Count_Value-144][11:8];
		Green <= frame[V_Count_Value-35][H_Count_Value-144][7:4];
		Blue <= frame[V_Count_Value-35][H_Count_Value-144][3:0];
	end
	else
	begin 
		Red_out <= 0;
		Green_out <= 0;
		Red_out <= 0 ;
	end
end


always @(posedge clk_25MHz)
begin

		
	
		// initialize the monitor at first to all black
		if(start_update!=1)
		begin
			if(x_init_counter<481 && y_init_counter<641)
				frame[x_init_counter][y_init_counter] <= 0;
			else
				start_update<=1;
		end
		
		//update the new_col_data
		else
		begin
			//update the column when you reach the blank area
			if(V_Count_Value>=515)
			begin
	
				for(i=0;i<481;i=i+1)
				begin
					frame[i][update_col_counter] <= new_col_data[i];
				end
			end
			else
			begin
				frame[i][update_col_counter]<=frame[i][update_col_counter];
			end
		end
end

always @(posedge clk_25MHz)
begin
		
		if(update_col_counter<641)
			update_col_counter<=update_col_counter+1;
		else
			update_col_counter<=0;

end



//assign Red = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
//assign Green = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
//assign Blue= (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;


endmodule

