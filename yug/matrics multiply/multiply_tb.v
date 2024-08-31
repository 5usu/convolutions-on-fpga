module MatrixMultiplier_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg start;
    reg [7:0] matrix_a [0:2][0:2]; // 3x3 matrix of 8-bit elements
    reg [7:0] matrix_b [0:2][0:2]; // 3x3 matrix of 8-bit elements
    wire [15:0] result [0:2][0:2]; // 3x3 matrix of 16-bit elements

    // Instantiate the MatrixMultiplier module
    MatrixMultiplier uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .matrix_a(matrix_a),
        .matrix_b(matrix_b),
        .result(result)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Stimulus block
    initial begin
        $dumpfile("MatrixMultiplier_tb.vcd");
        $dumpvars(0, MatrixMultiplier_tb);

        // Initialize signals
        reset = 1;
        start = 0;
        #10 reset = 0; // Release reset after 10 time units

        // Provide first set of test inputs
        start = 1;
        matrix_a[0][0] = 8'd1; matrix_a[0][1] = 8'd2; matrix_a[0][2] = 8'd3;
        matrix_a[1][0] = 8'd4; matrix_a[1][1] = 8'd5; matrix_a[1][2] = 8'd6;
        matrix_a[2][0] = 8'd7; matrix_a[2][1] = 8'd8; matrix_a[2][2] = 8'd9;

        matrix_b[0][0] = 8'd9; matrix_b[0][1] = 8'd8; matrix_b[0][2] = 8'd7;
        matrix_b[1][0] = 8'd6; matrix_b[1][1] = 8'd5; matrix_b[1][2] = 8'd4;
        matrix_b[2][0] = 8'd3; matrix_b[2][1] = 8'd2; matrix_b[2][2] = 8'd1;

        #20; // Wait for result

        // Provide second set of test inputs
        start = 1;
        matrix_a[0][0] = 8'd1; matrix_a[0][1] = 8'd0; matrix_a[0][2] = 8'd0;
        matrix_a[1][0] = 8'd0; matrix_a[1][1] = 8'd1; matrix_a[1][2] = 8'd0;
        matrix_a[2][0] = 8'd0; matrix_a[2][1] = 8'd0; matrix_a[2][2] = 8'd1;

        matrix_b[0][0] = 8'd1; matrix_b[0][1] = 8'd2; matrix_b[0][2] = 8'd3;
        matrix_b[1][0] = 8'd4; matrix_b[1][1] = 8'd5; matrix_b[1][2] = 8'd6;
        matrix_b[2][0] = 8'd7; matrix_b[2][1] = 8'd8; matrix_b[2][2] = 8'd9;

        #20; // Wait for result

        // Provide third set of test inputs
        start = 1;
        matrix_a[0][0] = 8'd2; matrix_a[0][1] = 8'd0; matrix_a[0][2] = 8'd0;
        matrix_a[1][0] = 8'd0; matrix_a[1][1] = 8'd2; matrix_a[1][2] = 8'd0;
        matrix_a[2][0] = 8'd0; matrix_a[2][1] = 8'd0; matrix_a[2][2] = 8'd2;

        matrix_b[0][0] = 8'd1; matrix_b[0][1] = 8'd2; matrix_b[0][2] = 8'd3;
        matrix_b[1][0] = 8'd4; matrix_b[1][1] = 8'd5; matrix_b[1][2] = 8'd6;
        matrix_b[2][0] = 8'd7; matrix_b[2][1] = 8'd8; matrix_b[2][2] = 8'd9;

        #20; // Wait for result

        // Provide fourth set of test inputs
        start = 1;
        matrix_a[0][0] = 8'd1; matrix_a[0][1] = 8'd2; matrix_a[0][2] = 8'd3;
        matrix_a[1][0] = 8'd0; matrix_a[1][1] = 8'd1; matrix_a[1][2] = 8'd4;
        matrix_a[2][0] = 8'd0; matrix_a[2][1] = 8'd0; matrix_a[2][2] = 8'd1;

        matrix_b[0][0] = 8'd1; matrix_b[0][1] = 8'd0; matrix_b[0][2] = 8'd0;
        matrix_b[1][0] = 8'd2; matrix_b[1][1] = 8'd1; matrix_b[1][2] = 8'd0;
        matrix_b[2][0] = 8'd3; matrix_b[2][1] = 8'd4; matrix_b[2][2] = 8'd1;

        #20; // Wait for result

        // End the simulation
        $finish;
    end
endmodule

