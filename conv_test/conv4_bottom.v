module gaussian_blur_3x3 (
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_00, pixel_01, pixel_02,
    input wire [7:0] pixel_10, pixel_11, pixel_12,
    input wire [7:0] pixel_20, pixel_21, pixel_22,
    output reg [7:0] blurred_pixel
);
    // Gaussian kernel weights (normalized to sum to 16)
    parameter [3:0] W00 = 4'd1, W01 = 4'd2, W02 = 4'd1;
    parameter [3:0] W10 = 4'd2, W11 = 4'd4, W12 = 4'd2;
    parameter [3:0] W20 = 4'd1, W21 = 4'd2, W22 = 4'd1;

    reg [11:0] sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            blurred_pixel <= 8'd0;
        end else begin
            // Calculating weighted sum
            sum = (pixel_00 * W00) + (pixel_01 * W01) + (pixel_02 * W02) +
                  (pixel_10 * W10) + (pixel_11 * W11) + (pixel_12 * W12) +
                  (pixel_20 * W20) + (pixel_21 * W21) + (pixel_22 * W22);
            
            // Divide by 16 (shift right by 4)
            blurred_pixel <= sum[11:4];
        end
    end
endmodule

