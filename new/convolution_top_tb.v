`timescale 1ns / 1ps

module convolution_top_tb();

    // Parameters
    parameter IMAGE_WIDTH = 256;
    parameter IMAGE_HEIGHT = 256;
    parameter CLK_PERIOD = 10;

    // Signals
    reg clk;
    reg rst;
    reg start;
    reg [7:0] pixel_in;
    reg [$clog2(IMAGE_WIDTH*IMAGE_HEIGHT)-1:0] pixel_addr;
    reg pixel_we;
    wire [7:0] pixel_out;
    wire [$clog2(IMAGE_WIDTH*IMAGE_HEIGHT)-1:0] output_addr;
    wire output_we;
    wire done;

    // Instantiate the Unit Under Test (UUT)
    convolution_top uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .pixel_in(pixel_in),
        .pixel_addr(pixel_addr),
        .pixel_we(pixel_we),
        .pixel_out(pixel_out),
        .output_addr(output_addr),
        .output_we(output_we),
        .done(done)
    );

    // Clock generation
    always begin
        #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test vectors
    reg [7:0] input_image [0:IMAGE_WIDTH*IMAGE_HEIGHT-1];
    reg [7:0] output_image [0:IMAGE_WIDTH*IMAGE_HEIGHT-1];

    integer i;
    integer output_file;

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        start = 0;
        pixel_in = 0;
        pixel_addr = 0;
        pixel_we = 0;

        // Load input image
        $readmemh("pixel_data.hex", input_image);

        // Reset
        #(CLK_PERIOD*10);
        rst = 0;

        // Load input image into the module
        for (i = 0; i < IMAGE_WIDTH*IMAGE_HEIGHT; i = i + 1) begin
            @(posedge clk);
            pixel_addr = i;
            pixel_in = input_image[i];
            pixel_we = 1;
        end

        // Start processing
        @(posedge clk);
        pixel_we = 0;
        start = 1;
        @(posedge clk);
        start = 0;

        // Wait for processing to complete
        wait(done);

        // Open output file
        output_file = $fopen("output_data.hex", "w");

        // Write output image to file
        for (i = 0; i < IMAGE_WIDTH*IMAGE_HEIGHT; i = i + 1) begin
            $fwrite(output_file, "%02h\n", output_image[i]);
        end

        $fclose(output_file);
        $finish;
    end

    // Capture output
    always @(posedge clk) begin
        if (output_we) begin
            output_image[output_addr] <= pixel_out;
        end
    end

endmodule
