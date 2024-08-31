module sobel_convolution_tb;

reg clk;
reg rst;
reg start;
reg [647:0] input_matrix;
wire [647:0] output_matrix;
wire done;

// Instantiate the Unit Under Test (UUT)
sobel_convolution uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .input_matrix(input_matrix),
    .output_matrix(output_matrix),
    .done(done)
);

// Clock generation
always begin
    #5 clk = ~clk;
end

integer i, j;

// Test procedure
initial begin
    // Initialize inputs
    clk = 0;
    rst = 1;
    start = 0;
    input_matrix = 0;
    
    // Initialize input matrix with test data
    for (i = 0; i < 9; i = i + 1) begin
        for (j = 0; j < 9; j = j + 1) begin
            input_matrix[(i*9+j)*8 +: 8] = i * 9 + j;
        end
    end

    // Release reset
    #100;
    rst = 0;
    
    // Start convolution
    #10;
    start = 1;
    #10;
    start = 0;

    // Wait for convolution to complete
    wait(done);
    
    // Display results
    $display("Sobel Convolution complete");
    $display("Input matrix:");
    for (i = 0; i < 9; i = i + 1) begin
        for (j = 0; j < 9; j = j + 1) begin
            $write("%3d ", input_matrix[(i*9+j)*8 +: 8]);
        end
        $write("\n");
    end
    
    $display("Output matrix:");
    for (i = 0; i < 9; i = i + 1) begin
        for (j = 0; j < 9; j = j + 1) begin
            $write("%3d ", output_matrix[(i*9+j)*8 +: 8]);
        end
        $write("\n");
    end
    
    // End simulation
    #100;
    $finish;
end

// Optional: Check for timeout
initial begin
    #1000000; // Adjust timeout value as needed
    $display("Simulation timeout");
    $finish;
end

endmodule

