module gaussian_blur_256x256 (
    input wire clk,
    input wire rst,
    output reg [7:0] output_pixel,  // Single pixel output
    output reg [15:0] output_addr   // Address of the output pixel
);

    reg [7:0] image_data [0:65535];  // 256x256 input image, flattened array
    reg [7:0] blurred_pixel [0:65535];  // Flattened array for output

    integer i, j;

    initial begin
        // Initialize image_data with example values (replace with actual data)
        image_data[0] = 8'hFF;  // Example data
        // Initialize other pixels accordingly...
        image_data[65535] = 8'h00;
    end

    generate
        genvar x, y;
        for (x = 0; x < 254; x = x + 1) begin : gaussian_blur_x
            for (y = 0; y < 254; y = y + 1) begin : gaussian_blur_y
                wire [7:0] blurred_pixel_local;

                // Apply Gaussian blur using the 3x3 kernel for each pixel
                gaussian_blur_3x3 blur_inst (
                    .clk(clk),
                    .rst(rst),
                    .pixel_00(image_data[(x*256) + y]),
                    .pixel_01(image_data[(x*256) + y + 1]),
                    .pixel_02(image_data[(x*256) + y + 2]),
                    .pixel_10(image_data[((x+1)*256) + y]),
                    .pixel_11(image_data[((x+1)*256) + y + 1]),
                    .pixel_12(image_data[((x+1)*256) + y + 2]),
                    .pixel_20(image_data[((x+2)*256) + y]),
                    .pixel_21(image_data[((x+2)*256) + y + 1]),
                    .pixel_22(image_data[((x+2)*256) + y + 2]),
                    .blurred_pixel(blurred_pixel_local)
                );

                // Store the blurred pixel in the blurred_pixel array
                always @(posedge clk or posedge rst) begin
                    if (rst) begin
                        blurred_pixel[(x*256) + y + 1] <= 8'd0;
                    end else begin
                        blurred_pixel[(x*256) + y + 1] <= blurred_pixel_local;
                    end
                end
            end
        end
    endgenerate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            i <= 0;
            j <= 0;
            output_pixel <= 8'd0;
            output_addr <= 16'd0;
        end else begin
            // Output the blurred pixel and its address
            output_pixel <= blurred_pixel[(i*256) + j + 1];
            output_addr <= (i*256) + j + 1;

            // Move to the next pixel
            if (j < 253) begin
                j <= j + 1;
            end else begin
                j <= 0;
                if (i < 253) begin
                    i <= i + 1;
                end else begin
                    i <= 0;  // Reset to start processing from the top-left again
                end
            end
        end
    end
endmodule

module gaussian_blur_3x3 (
    input wire clk,
    input wire rst,
    input wire [7:0] pixel_00, pixel_01, pixel_02,
    input wire [7:0] pixel_10, pixel_11, pixel_12,
    input wire [7:0] pixel_20, pixel_21, pixel_22,
    output reg [7:0] blurred_pixel
);

    // Gaussian kernel weights (normalized to sum to 16)
    parameter [7:0] W00 = 8'd1,  W01 = 8'd2,  W02 = 8'd1;
    parameter [7:0] W10 = 8'd2,  W11 = 8'd4,  W12 = 8'd2;
    parameter [7:0] W20 = 8'd1,  W21 = 8'd2,  W22 = 8'd1;

    reg [15:0] sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            blurred_pixel <= 8'd0;
        end else begin
            // Calculating weighted sum
            sum = (pixel_00 * W00) + (pixel_01 * W01) + (pixel_02 * W02) +
                  (pixel_10 * W10) + (pixel_11 * W11) + (pixel_12 * W12) +
                  (pixel_20 * W20) + (pixel_21 * W21) + (pixel_22 * W22);

            blurred_pixel <= sum[11:4];
        end
    end
endmodule
