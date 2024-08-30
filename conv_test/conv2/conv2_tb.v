`timescale 1ns / 1ps

module tb_top_module;

    // Testbench parameters
    parameter MATRIX_SIZE = 256;
    parameter KERNEL_SIZE = 3;
    parameter OUTPUT_SIZE = MATRIX_SIZE - KERNEL_SIZE + 1;

    // Testbench signals
    reg clk;
    reg rst;
    reg [524287:0] input_matrix; // Flattened 1D vector for 256x256 input matrix
    wire [516127:0] output_matrix; // Flattened 1D vector for 254x254 output matrix

    // Instantiate the top module
    top_module uut (
        .clk(clk),
        .rst(rst),
        .input_matrix(input_matrix),
        .output_matrix(output_matrix)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz clock
    end

    // Testbench procedure
    initial begin
        // Initialize input_matrix with a simple pattern for testing
        integer i, j;
        for (i = 0; i < MATRIX_SIZE; i = i + 1) begin
            for (j = 0; j < MATRIX_SIZE; j = j + 1) begin
                input_matrix[(i * MATRIX_SIZE + j) * 8 +: 8] = (i + j) % 256; // Example pattern
            end
        end

        // Reset the system
        rst = 1;
        #10;
        rst = 0;

        // Wait for some time to simulate the processing
        #1000;

        // Display some of the output matrix values for verification
        for (i = 0; i < OUTPUT_SIZE; i = i + 1) begin
            for (j = 0; j < OUTPUT_SIZE; j = j + 1) begin
                $display("output_matrix[%d][%d] = %h", i, j, output_matrix[(i * OUTPUT_SIZE + j) * 8 +: 8]);
            end
        end

        // End the simulation
        $finish;
    end

endmodule

