timescale 1ns / 1ps

module testbench;
    reg a;
    reg b;
    wire y;

    // Instantiate the XOR gate
    xor_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Create a VCD file for waveform dumping
    initial begin
        $dumpfile("xor_test.vcd");
        $dumpvars(0, testbench);

        // Apply test vectors
        $monitor("a = %b, b = %b, y = %b", a, b, y);

        // Test case 1
        a = 0; b = 0;
        #10;

        // Test case 2
        a = 0; b = 1;
        #10;

        // Test case 3
        a = 1; b = 0;
        #10;

        // Test case 4
        a = 1; b = 1;
        #10;

        // End simulation
        $finish;
    end
endmodule

