`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:22:29 01/29/2024 
// Design Name: 
// Module Name:    top 
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
module top(
	
	input clk,
	
	output Hsynq,
	output Vsynq,
	
	output [1:0] Red,
	output [1:0] Green,
	output [1:0] Blue,
	
	
	output led_dcm_locked,
	
	
	//  --- LED ---
	output [7:0] LED,
	input  [7:0] DipSwitch,
	
	
	
	//-- Adc interfaces ---
	input  Adc2Fpga_data,
	output Fpga2Adc_data,
	output Fpga2Adc_Csn,
	output Fpga2Adc_sclk
	
	
    );


wire clk_25MHz;
wire clk_25MHz_noBuff;

wire [1:0] mode;    // mode 0: normal signal, mode 1: fft signal, mode 2: both

wire [3:0] integer_data; // integer data from the ADC
wire [3:0] float1_data; // first number after the decimal from ADC

wire [2:0] ADDR;       // ADC channel address
wire [11:0] ADC2Sseg; // ADC digital output

wire [11:0] fft_output; //fft output




wire locked_wire;   //clock wire

wire fft_done; //fft is done

assign led_dcm_locked = locked_wire;



//generate clock
clk_gen clk_generator
   (// Clock in ports
    .CLK_IN1(clk),      // IN
    // Clock out ports
    .CLK_OUT1(clk_25MHz),     // OUT
    .CLK_OUT2(clk_25MHz_noBuff),     // OUT
    // Status and control signals
    //.RESET(RESET),// IN
    .LOCKED(locked_wire));      // OUT




//select the mode from the dipswitches
mode_switcher mode_s(

		.clk(clk_25MHz),
		.dipswitch(DipSwitch),
		
		.led(LED),
		.mode(mode)

    );





//VGA controller
VGA vga(
		.clk_25MHz(clk_25MHz),		//input
		.signal_data({integer_data,float1_data}),  //input
		
		.FFT_data(fft_output), //input
		
		.mode(mode), //input
		
		.Hsynq(Hsynq), //output
		.Vsynq(Vsynq), //output
		
		.Red(Red),   //output
		.Green(Green), //output
		.Blue(Blue) //output

);


//SPI controller
SPI spi (
    .clk(clk_25MHz),               // IN
    .clk_noBuff(clk_25MHz_noBuff), // IN
	 .Resetn(1'b0),           // IN
	 .sclk(Fpga2Adc_sclk), 	    // OUT
    .din(Fpga2Adc_data),        // OUT
    .cs(Fpga2Adc_Csn),          // OUT
    .ADD(3'b000),                 // IN
    .ADC2SPI(Adc2Fpga_data),    // IN
	 .start(locked_wire),			//IN
    .ADC2Sseg(ADC2Sseg)         // OUT
    );



//voltage calculator from the ADC data
voltage_calculater voltage_cal(
	 .clk(clk_25MHz),						 // IN
	 .ADC_data(ADC2Sseg),	       // IN
	 .flag(1'b1),						 // IN
	 .integer_data(integer_data),	 // OUT
	 .float1_data(float1_data)	 // OUT

	 );
	 

//FFT calculator
FFT_Core your_instance_name (
  .clk(clk), // input clk
  .ce(locked_wire), // input ce
  .start(1'b1), // input start
  .xn_re(ADC2Sseg), // input [8 : 0] xn_re
  .xn_im(8'b0), // input [8 : 0] xn_im
  .fwd_inv(fwd_inv), // input fwd_inv
  .fwd_inv_we(fwd_inv_we), // input fwd_inv_we
  //.rfd(rfd), // output rfd
  //.xn_index(xn_index), // output [8 : 0] xn_index
  //.busy(busy), // output busy
  //.edone(edone), // output edone
  .done(fft_done), // output done
  //.dv(dv), // output dv
  //.xk_index(xk_index), // output [8 : 0] xk_index
  .xk_re(fft_output), // output [18 : 0] xk_re
  //.xk_im(xk_im) // output [18 : 0] xk_im
);




endmodule

