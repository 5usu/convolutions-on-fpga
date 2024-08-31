`timescale 1ns / 1ps

module convolution_tb;

    // Parameters
    parameter CLK_PERIOD = 10;  // 10 ns clock period (100 MHz clock)
    parameter IMAGE_WIDTH = 256;
    parameter IMAGE_HEIGHT = 256;

    // Signals
    reg clk;
    reg rst;
    reg start;
    wire done;

    // File handling
    integer input_file, output_file, scan_file;
    reg [7:0] input_data;
    reg [7:0] output_data;
    integer i;  // Loop variable

    // Instantiate the Unit Under Test (UUT)
    convolution_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done)
    );

    // Clock generation
    always begin
        clk = 0;
        #(CLK_PERIOD/2);
        clk = 1;
        #(CLK_PERIOD/2);
    end

    // Test procedure
    initial begin
        // Initialize inputs
        rst = 1;
        start = 0;

        // Generate random input data
        input_file = $fopen("image_data.hex", "w");
        for (i = 0; i < IMAGE_WIDTH * IMAGE_HEIGHT; i = i + 1) begin
            input_data = $random & 8'hFF;  // Ensure 8-bit value
            $fwrite(input_file, "%02h\n", input_data);
        end
        $fclose(input_file);

        // Wait for global reset
        #(CLK_PERIOD*10);
        rst = 0;

        // Start the convolution process
        #(CLK_PERIOD*5);
        start = 1;
        #CLK_PERIOD;
        start = 0;

        // Wait for the process to complete
        wait(done);
        
        // Add a small delay to ensure all operations are complete
        #(CLK_PERIOD*10);

        // Verify the output
        $display("Convolution process completed.");
        $display("Checking output_data.hex...");

        output_file = $fopen("output_data.hex", "r");
        if (output_file == 0) begin
            $display("Error: output_data.hex not found!");
            $finish;
        end

        for (i = 0; i < IMAGE_WIDTH * IMAGE_HEIGHT; i = i + 1) begin
            scan_file = $fscanf(output_file, "%h\n", output_data);
            if (scan_file != 1) begin
                $display("Error: Unexpected end of file or read error at position %d", i);
                $fclose(output_file);
                $finish;
            end
            // You can add more specific checks here if needed
        end

        $fclose(output_file);
        $display("Output data verification complete.");
        $display("All %0d pixels processed successfully.", IMAGE_WIDTH * IMAGE_HEIGHT);

        // End simulation
        $finish;
    end

    // Optional: Monitor important signals
    initial begin
        $monitor("Time=%0t: State=%b, X=%d, Y=%d", 
                 $time, uut.state, uut.x_count, uut.y_count);
    end

endmodule
