module convolution_top (
    input wire clk,
    input wire rst,
    input wire start,
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
    initial $readmemh("image_data.hex", input_bram);

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
    integer i, j;

    // Output file handle
    integer output_file;

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

    // Main processing logic
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (start) begin
                    output_file = $fopen("output_data.hex", "w");
                end
            end
            LOAD: begin
                x_count <= 0;
                y_count <= 0;
            end
            PROCESS: begin
                // Load the 3x3 window
                for (i = 0; i < KERNEL_SIZE; i = i + 1) begin
                    for (j = 0; j < KERNEL_SIZE; j = j + 1) begin
                        if (x_count + j - 1 < 0 || x_count + j - 1 >= IMAGE_WIDTH ||
                            y_count + i - 1 < 0 || y_count + i - 1 >= IMAGE_HEIGHT) begin
                            window[i*KERNEL_SIZE + j] = 0;  // Zero padding
                        end else begin
                            window[i*KERNEL_SIZE + j] = input_bram[(y_count + i - 1) * IMAGE_WIDTH + (x_count + j - 1)];
                        end
                    end
                end

                // Perform convolution
                conv_result = 0;
                for (i = 0; i < KERNEL_SIZE*KERNEL_SIZE; i = i + 1) begin
                    conv_result = conv_result + window[i] * kernel[i];
                end

                // Normalize and clip the result
                conv_output = (conv_result / 16 > 255) ? 255 : (conv_result / 16 < 0) ? 0 : conv_result / 16;

                // Store the result
                output_bram[y_count * IMAGE_WIDTH + x_count] <= conv_output;

                // Write to output file
                $fwrite(output_file, "%02h\n", conv_output);

                // Update counters
                if (x_count == IMAGE_WIDTH - 1) begin
                    x_count <= 0;
                    y_count <= y_count + 1;
                end else begin
                    x_count <= x_count + 1;
                end
            end
            STORE: begin
                if (last_pixel) begin
                    $fclose(output_file);
                end
            end
        endcase
    end

    assign done = (state == STORE) && last_pixel;

    // Debug logic
    `ifdef DEBUG
        always @(posedge clk) begin
            if (state == PROCESS) begin
                $display("Processing pixel (%d, %d)", x_count, y_count);
                $display("Convolution result: %d", conv_result);
            end
        end
    `endif

endmodule
