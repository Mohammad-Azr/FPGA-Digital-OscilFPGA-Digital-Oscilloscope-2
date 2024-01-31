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

reg [7:0] i;

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



// colors
always @(posedge clk_25MHz)
begin

  if(H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34)
  begin
    if(V_Count_Value > 268 && V_Count_Value<282)     // middle line of screen 
    begin
      Red = 4'h0;
      Green = 4'hF;
      Blue = 4'h0;
    end
  end
    
    else if(V_Count_Value < 269 && V_Count_Value>35) // top of screen
    begin
      if(mode==0 || mode==2)
      begin	
          if(signal_data[7:4] == 5)                  // 5 volt
          begin
            if(signal_data[3:0] <= 3 )                               // 0 ~ 0.3
            begin
					for(i=61 ; i < 74 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else if(signal_data[3:0] > 3 && signal_data[3:0] <= 6 )  // 0.3 ~ 0.6
            begin
					for(i=48 ; i < 61 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else                                                     // 0.6 ~ 1
            begin
					for(i=35 ; i < 48 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
          end
          
          else if(signal_data[7:4] == 4)             // 4 volt
          begin
            if(signal_data[3:0] <= 3 )                               // 0 ~ 0.3
            begin
					for(i=100 ; i < 113 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else if(signal_data[3:0] > 3 && signal_data[3:0] <= 6 )  // 0.3 ~ 0.6
            begin
					for(i=87 ; i < 100 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else                                                     // 0.6 ~ 1
            begin
					for(i=74 ; i < 87 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
          end
          
          else if(signal_data[7:4] == 3)             // 3 volt
          begin
            if(signal_data[3:0] <= 3 )                               // 0 ~ 0.3
            begin
            for(i=139 ; i < 152 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else if(signal_data[3:0] > 3 && signal_data[3:0] <= 6 )  // 0.3 ~ 0.6
            begin
            for(i=126 ; i < 139 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else                                                     // 0.6 ~ 1
            begin
            for(i=113 ; i <126 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
          end
          
          else if(signal_data[7:4] == 2)             // 2 volt
          begin
            if(signal_data[3:0] <= 3 )                               // 0 ~ 0.3
            begin
            for(i=178 ; i < 191 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else if(signal_data[3:0] > 3 && signal_data[3:0] <= 6 )  // 0.3 ~ 0.6
            begin
            for(i=165 ; i < 178 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else                                                     // 0.6 ~ 1
            begin
            for(i=152 ; i < 165 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
          end
          
          else if(signal_data[7:4] == 1)             // 1 volt
          begin
            if(signal_data[3:0] <= 3 )                               // 0 ~ 0.3
            begin
            for(i=217 ; i < 230 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else if(signal_data[3:0] > 3 && signal_data[3:0] <= 6 )  // 0.3 ~ 0.6
            begin
            for(i=204 ; i < 217 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else                                                     // 0.6 ~ 1
            begin
            for(i=131 ; i < 204 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
          end
          
          else                                         // 0 volt
          begin
            if(signal_data[3:0] <= 3 )                               // 0 ~ 0.3
            begin
            for(i=256 ; i < 269 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else if(signal_data[3:0] > 3 && signal_data[3:0] <= 6 )  // 0.3 ~ 0.6
            begin
            for(i=243 ; i < 256 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
            else                                                     // 0.6 ~ 1
            begin
            for(i=230 ; i < 243 ; i = i+1)
					begin
						new_col_data[i] <= 12'b000000010000;
					end
            end
         end
	end
	end
end

//assign Red = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
//assign Green = (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;
//assign Blue= (H_Count_Value < 784 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value>34) ? 4'hF:4'h0;


endmodule
