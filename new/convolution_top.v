module convolution_top (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] pixel_in,
    input wire [$clog2(IMAGE_WIDTH*IMAGE_HEIGHT)-1:0] pixel_addr,
    input wire pixel_we,
    output reg [7:0] pixel_out,
    output reg [$clog2(IMAGE_WIDTH*IMAGE_HEIGHT)-1:0] output_addr,
    output reg output_we,
    output wire done
);

    // Parameters
    parameter IMAGE_WIDTH = 256;
    parameter IMAGE_HEIGHT = 256;
    parameter KERNEL_SIZE = 3;

    // FSM states
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam PROCESS = 2'b10;
    localparam STORE = 2'b11;

    reg [1:0] state, next_state;

    // BRAM for input image
    reg [7:0] input_bram [0:IMAGE_WIDTH*IMAGE_HEIGHT-1];

    // BRAM for output image
    reg [7:0] output_bram [0:IMAGE_WIDTH*IMAGE_HEIGHT-1];

    // Gaussian blur kernel (3x3)
    reg signed [3:0] kernel [0:KERNEL_SIZE*KERNEL_SIZE-1];
    initial begin
        kernel[0] = 1; kernel[1] = 2; kernel[2] = 1;
        kernel[3] = 2; kernel[4] = 4; kernel[5] = 2;
        kernel[6] = 1; kernel[7] = 2; kernel[8] = 1;
    end

    // Counters and control signals
    reg [$clog2(IMAGE_WIDTH)-1:0] x_count;
    reg [$clog2(IMAGE_HEIGHT)-1:0] y_count;
    wire last_pixel;

    assign last_pixel = (x_count == IMAGE_WIDTH-1) && (y_count == IMAGE_HEIGHT-1);

    // Convolution logic
    reg signed [15:0] conv_result;
    reg [7:0] conv_output;
    
    reg [7:0] window [0:KERNEL_SIZE*KERNEL_SIZE-1];

    // FSM logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = PROCESS;
            PROCESS: next_state = last_pixel ? STORE : PROCESS;
            STORE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Input loading logic
    always @(posedge clk) begin
        if (pixel_we) begin
            input_bram[pixel_addr] <= pixel_in;
        end
    end

    // Main processing logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                // Reset output signals
                output_we <= 0;
            end
            LOAD: begin
                x_count <= 0;
                y_count <= 0;
            end
            PROCESS: begin
                // Load the 3x3 window
                window[0] = (x_count == 0 || y_count == 0) ? 0 : input_bram[(y_count - 1) * IMAGE_WIDTH + (x_count - 1)];
                window[1] = (y_count == 0) ? 0 : input_bram[(y_count - 1) * IMAGE_WIDTH + x_count];
                window[2] = (x_count == IMAGE_WIDTH - 1 || y_count == 0) ? 0 : input_bram[(y_count - 1) * IMAGE_WIDTH + (x_count + 1)];
                window[3] = (x_count == 0) ? 0 : input_bram[y_count * IMAGE_WIDTH + (x_count - 1)];
                window[4] = input_bram[y_count * IMAGE_WIDTH + x_count];
                window[5] = (x_count == IMAGE_WIDTH - 1) ? 0 : input_bram[y_count * IMAGE_WIDTH + (x_count + 1)];
                window[6] = (x_count == 0 || y_count == IMAGE_HEIGHT - 1) ? 0 : input_bram[(y_count + 1) * IMAGE_WIDTH + (x_count - 1)];
                window[7] = (y_count == IMAGE_HEIGHT - 1) ? 0 : input_bram[(y_count + 1) * IMAGE_WIDTH + x_count];
                window[8] = (x_count == IMAGE_WIDTH - 1 || y_count == IMAGE_HEIGHT - 1) ? 0 : input_bram[(y_count + 1) * IMAGE_WIDTH + (x_count + 1)];

                // Perform convolution
                conv_result = 0;
                conv_result = conv_result + window[0] * kernel[0];
                conv_result = conv_result + window[1] * kernel[1];
                conv_result = conv_result + window[2] * kernel[2];
                conv_result = conv_result + window[3] * kernel[3];
                conv_result = conv_result + window[4] * kernel[4];
                conv_result = conv_result + window[5] * kernel[5];
                conv_result = conv_result + window[6] * kernel[6];
                conv_result = conv_result + window[7] * kernel[7];
                conv_result = conv_result + window[8] * kernel[8];

                // Normalize and clip the result
                conv_output = (conv_result / 16 > 255) ? 255 : (conv_result / 16 < 0) ? 0 : conv_result / 16;

                // Store the result
                output_bram[y_count * IMAGE_WIDTH + x_count] <= conv_output;

                // Set output signals
                pixel_out <= conv_output;
                output_addr <= y_count * IMAGE_WIDTH + x_count;
                output_we <= 1;

                // Update counters
                if (x_count == IMAGE_WIDTH - 1) begin
                    x_count <= 0;
                    y_count <= y_count + 1;
                end else begin
                    x_count <= x_count + 1;
                end
            end
            STORE: begin
                output_we <= 0;
            end
        endcase
    end

    assign done = (state == STORE) && last_pixel;

endmodule
