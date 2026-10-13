`timescale 1ns/1ps

module motor_controller_tb;

    // Inputs used by the testbench.
	 
    reg clk;
    reg reset;
    reg [11:0] speed_cmd;
    reg enable;
    reg direction;

    // Outputs from the motor controller.
	 
    wire pwm;
    wire direction_out;

    // Count the checks that pass and fail.
	 
    integer pass_count;
    integer fail_count;

    // Connect the motor controller to the testbench.
	 
    motor_controller dut (
        .clk(clk),
        .reset(reset),
        .speed_cmd(speed_cmd),
        .enable(enable),
        .direction(direction),
        .pwm(pwm),
        .direction_out(direction_out)
    );

    // Generate a 50 MHz clock with a 20 ns period.
	 
    initial begin
        clk = 1'b0;
        forever #10 clk = ~clk;
    end

    // Test the PWM output, enable signal and direction for one speed command.
	 
    task run_speed_test;
        input [11:0] command;
        input integer expected_high;
        integer high_count;
        integer i;
        begin
            $display("");
            $display("------------------------------------------------");
            $display("TEST: speed_cmd=%0d, expected duty=%0d%%",
                     command, (expected_high * 100) / 2500);

            // Set the direction to 0 while the controller is disabled.
				
            enable = 1'b0;
            speed_cmd = 12'd0;
            direction = 1'b0;
            repeat (2) @(negedge clk);

            if (direction_out === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: Direction initialised while disabled.");
            end
            else begin
                fail_count = fail_count + 1;
                $display("FAIL: Direction did not initialise to 0.");
            end

            // Enable the controller and set the speed command for this test.
				
            enable = 1'b1;
            speed_cmd = command;
            repeat (2) @(negedge clk);

            // Request direction 1 while the controller is enabled.
				
            direction = 1'b1;
            repeat (2) @(negedge clk);

            if (command == 12'd0) begin
                if (direction_out === 1'b1) begin
                    pass_count = pass_count + 1;
                    $display("PASS: Direction changes at zero speed.");
                end
                else begin
                    fail_count = fail_count + 1;
                    $display("FAIL: Direction did not change at zero speed.");
                end
            end
            else begin
                if (direction_out === 1'b0) begin
                    pass_count = pass_count + 1;
                    $display("PASS: Direction held while enabled and running.");
                end
                else begin
                    fail_count = fail_count + 1;
                    $display("FAIL: Direction changed while enabled and running.");
                end
            end

            // Count the PWM HIGH samples over 2500 clock cycles.
				
            high_count = 0;
            for (i = 0; i < 2500; i = i + 1) begin
                @(negedge clk);
                if (pwm === 1'b1)
                    high_count = high_count + 1;
            end

            $display("PWM measurement: %0d HIGH cycles out of 2500",
                     high_count);

            if (high_count == expected_high) begin
                pass_count = pass_count + 1;
                $display("PASS: PWM duty cycle matches expectation.");
            end
            else begin
                fail_count = fail_count + 1;
                $display("FAIL: Expected %0d HIGH cycles; measured %0d.",
                         expected_high, high_count);
            end

            // Disable the controller and check that PWM goes LOW.
				
            enable = 1'b0;
            repeat (2) @(negedge clk);

            if (pwm === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: PWM is LOW while disabled.");
            end
            else begin
                fail_count = fail_count + 1;
                $display("FAIL: PWM was not LOW while disabled.");
            end

            // Check that the direction output follows the request while disabled.
				
            if (direction_out === direction) begin
                pass_count = pass_count + 1;
                $display("PASS: Direction follows request while disabled.");
            end
            else begin
                fail_count = fail_count + 1;
                $display("FAIL: Direction did not follow request while disabled.");
            end
        end
    endtask

    // Reset the controller, run the tests and print the final results.
	 
    initial begin
        pass_count = 0;
        fail_count = 0;

        reset = 1'b1;
        speed_cmd = 12'd0;
        enable = 1'b0;
        direction = 1'b0;

        $display("================================================");
        $display("FPGA MOTOR CONTROLLER - SELF CHECKING TESTBENCH");
        $display("Clock: 50 MHz | PWM target: 20 kHz");
        $display("Expected PWM period: 2500 clock cycles (50 us)");
        $display("================================================");

        repeat (5) @(negedge clk);
        reset = 1'b0;
        repeat (2) @(negedge clk);

        run_speed_test(12'd0,    0);
        run_speed_test(12'd625,  625);
        run_speed_test(12'd1250, 1250);
        run_speed_test(12'd1875, 1875);
        run_speed_test(12'd2500, 2500);

        $display("");
        $display("================================================");
        $display("VERIFICATION SUMMARY");
        $display("Passed checks: %0d", pass_count);
        $display("Failed checks: %0d", fail_count);

        if (fail_count == 0)
            $display("OVERALL RESULT: PASS");
        else
            $display("OVERALL RESULT: FAIL");

        $display("================================================");
        $finish;
    end

endmodule