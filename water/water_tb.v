`timescale 1ns / 1ps

module water_reservoir_controller_tb;

    reg S1, S2, S3;
    reg clk, reset;

    wire FR1, FR2, FR3, AFR;

    water_reservoir_controller uut (
        .S1(S1), .S2(S2), .S3(S3),
        .FR1(FR1), .FR2(FR2), .FR3(FR3), .AFR(AFR),
        .clk(clk), .reset(reset)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    initial begin
        $dumpfile("water_sim.vcd");
        $dumpvars(0, water_reservoir_controller_tb);
    end

    initial begin
        S1 = 1; S2 = 1; S3 = 1;
        reset = 1;
        #10 reset = 0;

        #20 $display("Test case 1: Above S3");
        #10 if (FR1 == 0 && FR2 == 0 && FR3 == 0 && AFR == 0)
            $display("Test case 1 passed");
        else
            $display("Test case 1 failed");

        #20 $display("Test case 2: Between S3 and S2");
        S3 = 0;
        #10 if (FR1 == 1 && FR2 == 0 && FR3 == 0 && AFR == 0)
            $display("Test case 2 passed");
        else
            $display("Test case 2 failed");

        #20 $display("Test case 3: Between S2 and S1");
        S2 = 0;
        #10 if (FR1 == 1 && FR2 == 1 && FR3 == 0 && AFR == 0)
            $display("Test case 3 passed");
        else
            $display("Test case 3 failed");

        #20 $display("Test case 4: Below S1");
        S1 = 0;
        #10 if (FR1 == 1 && FR2 == 1 && FR3 == 1 && AFR == 1)
            $display("Test case 4 passed");
        else
            $display("Test case 4 failed");

        #20 $display("Test case 5: Back to Between S2 and S1");
        S1 = 1;
        #10 if (FR1 == 1 && FR2 == 1 && FR3 == 0 && AFR == 0)
            $display("Test case 5 passed");
        else
            $display("Test case 5 failed");

        #20 $finish;
    end

endmodule
