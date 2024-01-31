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
		
		output reg [3:0] Red_out,
		output reg [3:0] Green_out,
		output reg [3:0] Blue_out
	

    );
	 
	 
wire enable_V_Counter;
wire [15:0] H_Count_Value;
wire [15:0] V_Count_Value;

reg [3:0] Red;
reg [3:0] Green;
reg [3:0] Blue;

reg [15:0] x_update_counter=0;
reg [15:0] y_update_counter=0;

reg [15:0] x_monitor_counter=0;
reg [15:0] y_monitor_counter=0;

reg start_update=0;


horizontal_counter VGA_Horiz (clk_25MHz, enable_V_Counter, H_Count_Value);
vertical_counter VGA_Verti (clk_25MHz, enable_V_Counter, V_Count_Value);


//frame
reg [11:0] frame [480][640];




// outputs
assign Hsynq = (H_Count_Value < 96) ? 1'b1:1'b0;
assign Vsynq = (V_Count_Value < 2) ? 1'b1:1'b0;



always @(posedge clk_25MHz)
begin
	frame[x_update_counter][y_update_counter] <= {Red,Green,Blue};
end


always @(posedge clk_25MHz)
begin
	if(H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34)
	begin
		//Red_out <= frame[x_monitor_counter][y_monitor_counter][11:8];
		//Green_out <= frame[x_monitor_counter][y_monitor_counter][7:4];
		//Blue_out <= frame[x_monitor_counter][y_monitor_counter][3:0];
		
		Red_out <= frame[V_Count_Value-35][H_Count_Value-144][11:8];
		Green_out <= frame[V_Count_Value-35][H_Count_Value-144][7:4];
		Blue_out <= frame[V_Count_Value-35][H_Count_Value-144][3:0];
	end
	else
	begin 
		Red_out <= 0;
		Green_out <= 0;
		Red_out <= 0 ;
	end
end

//assign Red = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;


always @(posedge clk_25MHz)
begin

	if(start_update==0)
	begin
		if(x<481 && y<641)
			frame[x][y] <= 0;
		else
			start_update<=1;
	end
	else
	begin
	
		if(mode==0)
		begin
			
			for
			
		
		
		end
	
		
	end



end


reg


// colors
always @(posedge clk_25MHz)
begin

	if(H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34)
	begin
		
		if(V_Count_Value > 268 && V_Count_Value<282)
		begin
			Red = 4'h0;
			Green = 4'hF;
			Blue = 4'h0;
		end
		
		
		else if(V_Count_Value < 269 && V_Count_Value>35)
		begin
			if(mode==0 || mode==2)
			begin
					
				
			






			end
		end
		else if(V_Count_Value > 281 && V_Count_Value < 516)
		begin
			
			if(mode==1 || mode==2)
			begin
				if(V_Count_Value<321)              // voltage 0
				begin
				
				end
				
				else if(V_Count_Value<360)        // voltage 1
				begin
				
				end
				
				else if(V_Count_Value<399)        // voltage 2
				begin
				
				end
				else if(V_Count_Value<438)        // voltage 3
				begin
				
				end
				
				else if(V_Count_Value<477)        // voltage 4
				begin
				
				end
				
				else        							// voltage 5
				begin
				
				end
			end
		end
		
	end
end




/*
always @(posedge clk_25MHz)
begin
	if(start_update)
	begin
		if(y_update_counter<640)
			y_update_counter <= y_update_counter+1;
	
		else
		begin
			if(x_update_counter == 480)
				x_update_counter<=0;
		
			else
			begin
				y_update_counter <= 0;
				x_update_counter <= x_update_counter + 1;
			end	
		end
	end
	else
	begin
		y_update_counter <= 0;
		x_update_counter <= 0;	
	end
	
end
*/

always @(posedge clk_25MHz)
begin
	
	if(y_monitor_counter>5 && x_monitor_counter==0)
		start_update<=1;
	else
		start_update<=0;
		
	
end

/*
always @(posedge clk_25MHz)
begin
	
	if(y_monitor_counter<640)
		y_monitor_counter <= y_monitor_counter+1;
		
	else
	begin
		if(x_monitor_counter == 480)
			x_monitor_counter<=0;
		else
		begin
			y_monitor_counter <= 0;
			x_monitor_counter <= x_monitor_counter + 1;
		end
		
	end
	
	
	if(y_monitor_counter>5 && x_monitor_counter==0)
		start_update<=1;
	else
		start_update<=0;
	

end

*/






//assign Red = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
//assign Green = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
//assign Blue= (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;


endmodule

