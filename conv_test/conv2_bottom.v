module convolution(
    input wire clk,
    input wire rst,
    input wire [71:0] input_window, // Flattened 3x3 window (9*8=72 bits)
    output reg [7:0] output_pixel
);

    // Gaussian kernel (example values)
    parameter signed [15:0] KERNEL_0 = 16'h01; parameter signed [15:0] KERNEL_1 = 16'h02; parameter signed [15:0] KERNEL_2 = 16'h01;
    parameter signed [15:0] KERNEL_3 = 16'h02; parameter signed [15:0] KERNEL_4 = 16'h04; parameter signed [15:0] KERNEL_5 = 16'h02;
    parameter signed [15:0] KERNEL_6 = 16'h01; parameter signed [15:0] KERNEL_7 = 16'h02; parameter signed [15:0] KERNEL_8 = 16'h01;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_pixel <= 8'b0;
        end else begin
            // Convolution operation using individual bits of the input_window
            output_pixel <= (
                             input_window[7:0]   * KERNEL_0 + input_window[15:8]  * KERNEL_1 + input_window[23:16] * KERNEL_2 +
                             input_window[31:24] * KERNEL_3 + input_window[39:32] * KERNEL_4 + input_window[47:40] * KERNEL_5 +
                             input_window[55:48] * KERNEL_6 + input_window[63:56] * KERNEL_7 + input_window[71:64] * KERNEL_8
                             ) >> 4; // Normalize the result by dividing by 16 (shifting right by 4 bits)
        end
    end

endmodule
