module gaussian_blur_256x256 (
    input wire clk,
    input wire rst,
    input wire [7:0] input_pixel,
    input wire [15:0] input_addr,
    output wire [7:0] output_pixel,
    output wire [15:0] output_addr
);

    // Parameters
    localparam WIDTH = 256;
    localparam HEIGHT = 256;
    localparam KERNEL_SIZE = 3;
    localparam BUFFER_ROWS = KERNEL_SIZE - 1;

    // Line buffers
    reg [7:0] line_buffer [0:BUFFER_ROWS-1][0:WIDTH-1];
    
    // Pixel window
    wire [7:0] window [0:KERNEL_SIZE-1][0:KERNEL_SIZE-1];

    // Counters
    reg [7:0] x_count;
    reg [7:0] y_count;

    // Pipeline registers
    reg [15:0] addr_pipeline [0:KERNEL_SIZE-1];
    reg valid_pipeline [0:KERNEL_SIZE-1];

    integer i, j;

    // Line buffer and window management
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < BUFFER_ROWS; i = i + 1)
                for (j = 0; j < WIDTH; j = j + 1)
                    line_buffer[i][j] <= 8'd0;
            x_count <= 8'd0;
            y_count <= 8'd0;
        end else begin
            // Shift pixels in line buffers
            for (i = BUFFER_ROWS-1; i > 0; i = i - 1)
                line_buffer[i] <= line_buffer[i-1];
            
            // Input new pixel
            line_buffer[0][x_count] <= input_pixel;

            // Update counters
            if (x_count == WIDTH-1) begin
                x_count <= 8'd0;
                if (y_count == HEIGHT-1)
                    y_count <= 8'd0;
                else
                    y_count <= y_count + 8'd1;
            end else begin
                x_count <= x_count + 8'd1;
            end
        end
    end

    // Assign window values
    genvar row, col;
    generate
        for (row = 0; row < KERNEL_SIZE; row = row + 1) begin : window_row
            for (col = 0; col < KERNEL_SIZE; col = col + 1) begin : window_col
                if (row == KERNEL_SIZE-1)
                    assign window[row][col] = (col == KERNEL_SIZE-1) ? input_pixel : line_buffer[row-1][x_count+col+1];
                else
                    assign window[row][col] = line_buffer[row][x_count+col];
            end
        end
    endgenerate

    // Instantiate multiple parallel 3x3 Gaussian blur modules
    wire [7:0] blurred_pixels [0:WIDTH-KERNEL_SIZE];
    
    genvar k;
    generate
        for (k = 0; k < WIDTH-KERNEL_SIZE+1; k = k + 1) begin : blur_modules
            gaussian_blur_3x3 blur_inst (
                .clk(clk),
                .rst(rst),
                .pixel_00(window[0][k]), .pixel_01(window[0][k+1]), .pixel_02(window[0][k+2]),
                .pixel_10(window[1][k]), .pixel_11(window[1][k+1]), .pixel_12(window[1][k+2]),
                .pixel_20(window[2][k]), .pixel_21(window[2][k+1]), .pixel_22(window[2][k+2]),
                .blurred_pixel(blurred_pixels[k])
            );
        end
    endgenerate

    // Pipeline for address and valid signal
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < KERNEL_SIZE; i = i + 1) begin
                addr_pipeline[i] <= 16'd0;
                valid_pipeline[i] <= 1'b0;
            end
        end else begin
            addr_pipeline[0] <= input_addr;
            valid_pipeline[0] <= (y_count >= KERNEL_SIZE-1) && (x_count >= KERNEL_SIZE-1);
            
            for (i = 1; i < KERNEL_SIZE; i = i + 1) begin
                addr_pipeline[i] <= addr_pipeline[i-1];
                valid_pipeline[i] <= valid_pipeline[i-1];
            end
        end
    end

    // Output assignment
    assign output_pixel = blurred_pixels[0];
    assign output_addr = addr_pipeline[KERNEL_SIZE-1] - ((KERNEL_SIZE/2 * WIDTH) + KERNEL_SIZE/2);

endmodule

