`timescale 1ns/1ns

module traffic_tb; 
    reg clk; 
    reg reset; 
    wire [1:0] light; 

traffic_control uut (
    .clk(clk),
    .reset(reset),
    .light(light)
);

initial begin 
    clk = 0;
    forever #5 clk = ~clk; 
end 

initial begin 
    $dumpfile("traffic_control.vcd");
    $dumpvars(0, traffic_tb);

    reset = 1;
    #10 reset = 0;

    #1000; 

    $finish; 
end

always @(posedge clk) begin 
    $display("Time=%0t, Light=%b", $time, light); 
end
endmodule 
