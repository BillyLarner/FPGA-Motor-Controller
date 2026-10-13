// PWM calculation
// System clock = 50 MHz
// PWM frequency = 20 kHz
// Tpwm = 1 / 20000
// Tclk = 1 / 50000000
// Tpwm / Tclk = 50 us / 20 ns = 2500
// 2500 cycles per pwm period

module motor_controller ( 				// Declaring a piece of hardware.

	// Creates ports so that signals can be sent into the controller, speed cmd has a 12 bit value since it needs values up to 2500.
	
	input wire clk,
	input wire reset,
	input wire [11:0] speed_cmd,
	input wire enable,
	input wire direction,
	
	// Signals going out of the hardware
	
	output reg pwm,
	output reg direction_out
);

reg [11:0] counter;						// Creating a 12 bit register to count clock cycles within PWM periods.

	always@(posedge clk) begin			// When the clock is at a positive edge execute the logic.
	
		// When the reset is HIGH, counter and pwm and motor direction are set to 0.
		
		if(reset) begin
			counter <= 12'd0;				
			pwm <= 1'b0;	
			direction_out <= 1'b0;
		end
		
		else begin

			// If the function to reset the counter if it reaches 2499.
			
			if (counter == 12'd2499) begin		
				counter <= 12'd0;
			end
			
			// Adds one to the coutner when it is not equal to 2499.
			
			else begin
				counter <= counter + 12'd1;
			end
				
			// Direction logic.
			
			if (!enable || (speed_cmd == 12'd0)) begin	// If the enable is 0 OR speed is 0 direction can change.
				direction_out <= direction;
			end
				
			// PWM logic	
				
			if (!enable) begin
				pwm <= 1'd0;
			end
			
			else if (counter < speed_cmd) begin
				pwm <= 1'b1;				// If counter is less than the speed command the pwm is set to HIGH.
			end
			
			else begin
				pwm <= 1'b0;				// If counter is equal or greater than 1250 the pwm is set to LOW.
			end
	
		end
	
	end										// Ends the logic.
	
endmodule									// Ends hardware.